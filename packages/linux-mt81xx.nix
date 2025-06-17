{
  inputs,
  pkgs,
  selfLib,
}:
let
  inherit (pkgs) pkgsCross hostPlatform lib;
  kukuiPkgs = if hostPlatform.isAarch64 then pkgs else pkgsCross.aarch64-multiplatform;
  inherit (lib.kernel) yes module;
in
kukuiPkgs.linux_6_12.override (old: {
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
    (old.kernelPatches or [ ])
    ++ (selfLib.listPatches "${inputs.pmaports}/device/community/linux-postmarketos-mediatek-mt8183")
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
})
