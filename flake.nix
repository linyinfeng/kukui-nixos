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
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      mt81xx-kernel,
      kernel-config-options,
    }:
    let
      pkgs = import nixpkgs {
        system = "aarch64-linux";
      };
      mergeConfig =
        {
          kernelSrc,
          arch,
          extraConfigs,
        }:
        pkgs.stdenv.mkDerivation {
          pname = "merged-config";
          version = "1.0.0";
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
      kernelVer = "6.12.28";
      kernelSrc = pkgs.fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${kernelVer}.tar.xz";
        hash = "sha256-6KCZGCVirs/3gd5yznaUYecG2Xr0LXQN/yDrRQ3Vdx4=";
      };
      config = mergeConfig {
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
    in
    {
      packages.aarch64-linux.kukui-kernel = pkgs.linuxPackages_custom {
        version = kernelVer;
        modDirVersion = "${kernelVer}-stb-cbm";
        src = kernelSrc;
        configfile = "${config}/.config";
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
