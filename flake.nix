{
  description = "Basic flake for devShell";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    mt81xx-kernel = {
      url = "github:hexdump0815/linux-mainline-mediatek-mt81xx-kernel";
      flake = false;
    };
    kernel-config-options = {
      url = "github:hexdump0815/kernel-config-options";
      flake = false;
    };
    kernel-extra-patches = {
      url = "github:hexdump0815/kernel-extra-patches";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      mt81xx-kernel,
      kernel-config-options,
      kernel-extra-patches,
    }:
    let
      pkgs = import nixpkgs {
        system = "aarch64-linux";
      };
      lib = pkgs.lib;
      listPatches =
        path:
        builtins.map
          (_p: {
            name = lib.strings.removeSuffix ".patch" _p;
            patch = path + "/${_p}";
          })
          (
            builtins.attrNames (
              lib.attrsets.filterAttrs (path: type: type == "regular" && lib.strings.hasSuffix ".patch" path) (
                builtins.readDir path
              )
            )
          );
      mergeConfig =
        {
          kernelSrc,
          arch,
          extraConfigs,
        }:
        let
          drv = pkgs.stdenvNoCC.mkDerivation {
            name = "merged-config";
            src = kernelSrc;
            dontConfigure = true;
            buildPhase = ''
              export ARCH=${arch}
              scripts/kconfig/merge_config.sh -m arch/${arch}/configs/defconfig ${pkgs.lib.strings.concatStringsSep " " extraConfigs}
            '';
            installPhase = ''
              mkdir $out
              cp .config $out
            '';
          };
        in
        "${drv}/.config";
      kernelVer = "6.12.28";
      kernelSrc = pkgs.fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${kernelVer}.tar.xz";
        hash = "sha256-6KCZGCVirs/3gd5yznaUYecG2Xr0LXQN/yDrRQ3Vdx4=";
      };
    in
    {
      packages.aarch64-linux = {
        kukui-kernel = pkgs.linuxManualConfig {
          version = kernelVer;
          modDirVersion = "${kernelVer}-stb-cbm";
          src = kernelSrc;
          allowImportFromDerivation = true;
          configfile = mergeConfig {
            inherit kernelSrc;
            arch = "arm64";
            extraConfigs = [
              "${kernel-config-options}/chromebooks-aarch64.cfg"
              "${kernel-config-options}/mediatek.cfg"
              "${kernel-config-options}/docker-options.cfg"
              "${kernel-config-options}/options-to-remove-generic.cfg"
              "${mt81xx-kernel}/misc.cbm/options/options-to-remove-special.cfg"
              "${kernel-config-options}/additional-options-generic.cfg"
              "${kernel-config-options}/additional-options-aarch64.cfg"
              "${mt81xx-kernel}/misc.cbm/options/additional-options-special.cfg"
            ];
          };
          kernelPatches = (listPatches "${mt81xx-kernel}/misc.cbm/patches/v6.12") ++ [
            {
              name = "remove-panfrost-purge-log-spam";
              patch = "${kernel-extra-patches}/remove-panfrost-purge-log-spam/v6.12.12.patch";
            }
            {
              name = "fix-kernel-version";
              patch = "${kernel-extra-patches}/fix-kernel-version/v6.12.5.patch";
            }
          ];
        };
        kukui-kpart = pkgs.callPackage ./kpart.nix {
          kernel = self.packages.aarch64-linux.kukui-kernel;
          cmdline = "${mt81xx-kernel}/misc.cbm/misc/cmdline";
          dtbFilter = [
            "/dtbs/mediatek/mt8173-elm-*.dtb"
            "/dtbs/mediatek/mt8183-kukui-*.dtb"
            "/dtbs/mediatek/mt8186-corsola-*.dtb"
            "/dtbs/mediatek/mt8192-asurada-*.dtb"
            "/dtbs/mediatek/mt8195-cherry-*.dtb"
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            git
          ];
        };
      }
    );
}
