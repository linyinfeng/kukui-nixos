{
  pkgs,
  inputs,
  overlays,
  ...
}:
let
  inherit (inputs) kernel-config-options mt81xx-kernel kernel-extra-patches;
  kernelVer = "6.12.28";
  kernelSrc = pkgs.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${kernelVer}.tar.xz";
    hash = "sha256-6KCZGCVirs/3gd5yznaUYecG2Xr0LXQN/yDrRQ3Vdx4=";
  };
  listPatches = pkgs.callPackage ../packages/list-patches.nix { };
  kukui-kernel = pkgs.linuxManualConfig {
    version = kernelVer;
    modDirVersion = "${kernelVer}-stb-cbm";
    src = kernelSrc;
    allowImportFromDerivation = true;
    configfile = pkgs.callPackage ../packages/merge-config.nix {
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
        ../make-nixos-happy.cfg
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
in
{
  boot.kernelPackages = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor kukui-kernel);

  system.stateVersion = "25.05";

  nixpkgs.overlays = builtins.attrValues overlays;
}
