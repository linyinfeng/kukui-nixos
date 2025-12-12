{
  inputs,
  pkgs,
  selfLib,
}:
let
  inherit (pkgs) pkgsCross lib;
  kukuiPkgs = if pkgs.stdenv.hostPlatform.isAarch64 then pkgs else pkgsCross.aarch64-multiplatform;
  inherit (lib.kernel) yes module;
  inherit (kukuiPkgs) fetchurl;
  version = "6.12.36";
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
    hash = "sha256-ShaK7S3lqBqt2QuisVOGCpjZm/w0ZRk24X8Y5U8Buow=";
  };
in
kukuiPkgs.buildLinux {
  inherit src version;
  enableCommonConfig = false;
  autoModules = false;
  structuredExtraConfig =
    (selfLib.adjustStandaloneConfig (import ../configs/config.nix { inherit lib; }))
    // {
      # simply turn off LOCALVERSION so that we can ignore modDirVersion
      LOCALVERSION = lib.kernel.unset;

      # extra fixes due to defconfig mismatch
      MHI_BUS = module;
      STM = module;

      # tweaks for nixos
      EROFS_FS = yes; # for envfs support
    };
  kernelPatches =
    (kukuiPkgs.linux_6_12.kernelPatches or [ ])
    ++ (lib.filter (patch: lib.match "mt8133.*" patch.name != null) (
      selfLib.listPatches "${inputs.pmaports}/device/community/linux-postmarketos-mediatek-mt81"
    ))
    ++ [
      {
        name = "kukui-extra-defconfig";
        patch = ./linux-mt81xx/kukui-defconfig.patch;
      }
    ];
  # ../configs/config.nix should fully explained the platform
  # clear hostPlatform.linux-kernel.extraConfig
  stdenv =
    let
      originalPlatform = kukuiPkgs.stdenv.hostPlatform;
      hostPlatform =
        assert kukuiPkgs.stdenv.hostPlatform.isAarch64;
        originalPlatform
        // {
          linux-kernel = originalPlatform.linux-kernel // {
            extraConfig = "";
          };
        };
    in
    kukuiPkgs.stdenv // { inherit hostPlatform; };
}
