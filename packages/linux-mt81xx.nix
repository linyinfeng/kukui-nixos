{
  inputs,
  pkgs,
  selfLib,
}:
let
  inherit (pkgs) pkgsCross hostPlatform lib;
  kukuiPkgs = if hostPlatform.isAarch64 then pkgs else pkgsCross.aarch64-multiplatform;
in
kukuiPkgs.linux_6_12.override (old: {
  enableCommonConfig = false;
  autoModules = false;
  structuredExtraConfig =
    (selfLib.adjustStandaloneConfig (import ../configs/config.nix { inherit lib; }))
    // {
      # simply turn off LOCALVERSION so that we can ignore modDirVersion
      LOCALVERSION = lib.kernel.unset;

      # the options can be selected by common config, just unset
      IPV6_TUNNEL = lib.kernel.unset;
      CRYPTO_CURVE25519 = lib.kernel.unset;
      NET_FOU = lib.kernel.unset;
    };
  kernelPatches =
    (old.kernelPatches or [ ])
    ++ (selfLib.listPatches "${inputs.mt81xx-kernel}/misc.cbm/patches/v6.12")
    ++ [
      {
        name = "remove-panfrost-purge-log-spam";
        patch = "${inputs.kernel-extra-patches}/remove-panfrost-purge-log-spam/v6.12.12.patch";
      }
      {
        name = "fix-kernel-version";
        patch = "${inputs.kernel-extra-patches}/fix-kernel-version/v6.12.5.patch";
      }
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
