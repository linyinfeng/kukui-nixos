{
  inputs,
  pkgs,
  selfLib,
}:
let
  inherit (pkgs) pkgsCross lib;
  kukuiPkgs = if pkgs.stdenv.hostPlatform.isAarch64 then pkgs else pkgsCross.aarch64-multiplatform;
  inherit (lib.kernel) yes;
  inherit (kukuiPkgs) fetchurl;
  version = "6.12.57";
  src = pkgs.stdenv.mkDerivation {
    name = "linux-mt81-src";
    inherit version;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
      hash = "sha256-Flyhw3xGB7kOcxmWt8HjMRKFFn0T3u7fCPPx8LnSVBo=";
    };
    postPatch = ''
      cp "${inputs.pmaports}/device/community/linux-postmarketos-mediatek-mt81/config-postmarketos-mediatek-mt81.aarch64" arch/arm64/configs/mt81_defconfig
    '';
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir --parents $out
      cp --recursive . "$out"
      runHook postInstall
    '';
  };
  pmPatch =
    {
      file,
      name ? file,
    }:
    {
      inherit name;
      patch = "${inputs.pmaports}/device/community/linux-postmarketos-mediatek-mt81/${file}";
    };
in
kukuiPkgs.buildLinux {
  inherit src version;
  modDirVersion = "${version}-mt81";
  autoModules = false;
  structuredExtraConfig = {
    # tweaks for nixos
    EROFS_FS = yes; # for envfs support
  };
  kernelPatches = (kukuiPkgs.linux_6_12.kernelPatches or [ ]) ++ [
    # order matters for some patches
    (pmPatch { file = "arm64-dts-mt8183-Add-kukui-jacuzzi-cerise-board.patch"; })
    (pmPatch { file = "arm64-dts-mediatek-Add-dts-for-hayato-rev5-sku0.patch"; })
    (pmPatch { file = "mt8183-fix-bluetooth.patch"; })
    (pmPatch { file = "mt8183-kukui-add-it6505-and-enable-dpi.patch"; })
    (pmPatch { file = "mt8183-kukui-jacuzzi-fix-display-resume.patch"; })
    (pmPatch { file = "mt8183-kukui-jacuzzi-hack-dpms-resume.patch"; })
    (pmPatch { file = "mt8183-kukui-jacuzzi-fennel14-rt1015p-sound.patch"; })
    (pmPatch { file = "wifi-rtw88-Fix-the-random-error-beacon-valid-message.patch"; })
    (pmPatch { file = "HACK-MTK-Disable-AFBC-support.patch"; })
    (pmPatch { file = "platform-chrome-cros_ec_typec-Purge-blocking-switch-devlinks.patch"; })
    (pmPatch { file = "drm-Display-Add-Type-C-switch-helpers.patch"; })
    (pmPatch { file = "drm-bridge-anx7625-Register-Type-C-mode-switches.patch"; })
    (pmPatch { file = "drm-bridge-anx7625-Check-for-Type-C-during-panel-registration.patch"; })
    (pmPatch { file = "STOPSHIP-arm64-dts-mediatek-asurada-Add-DP.patch"; })
    (pmPatch { file = "STOPSHIP-arm64-dts-mediatek-asurada-Enable-HDMI-audio.patch"; })
    (pmPatch { file = "mt8186-enable-dpi.patch"; })
    (pmPatch { file = "mt8186-add-extcon-to-dp-bridge.patch"; })
    (pmPatch { file = "mt8186-ASoC-hdmi-codec-Add-event-handler-for-hdmi-TX.patch"; })
    (pmPatch { file = "mt8186-SoC-mediatek-mt8186-correct-the-HDMI-widgets.patch"; })
    (pmPatch { file = "mt8186-drm-bridge-it6505-Add-audio-support.patch"; })
    (pmPatch { file = "mt8186-ASoC-mediatek-mt8186-make-FE-nonatomic-and-no_pcm.patch"; })
    (pmPatch { file = "mt8195-adsp.patch"; })
    (pmPatch { file = "mt8195-dvfsrc.patch"; })
  ];
  defconfig = "mt81_defconfig";
}
