{ lib }:
let
  inherit (lib.kernel)
    yes
    no
    module
    freeform
    ;
in
{
  "LOCALVERSION_AUTO" = no;
  "I2C_MT65XX" = yes;
  "SPI_MT65XX" = yes;
  "MFD_MT6397" = yes;
  "REGULATOR_DA9211" = yes;
  "REGULATOR_MT6358" = yes;
  "REGULATOR_MT6397" = yes;
  "DRM" = yes;
  "DRM_PANEL_SIMPLE" = yes;
  "DRM_GENERIC_GPIO_MUX" = yes;
  "DRM_ANALOGIX_ANX7688" = yes;
  "DRM_PARADE_PS8640" = yes;
  "DRM_MEDIATEK" = yes;
  "DRM_MEDIATEK_HDMI" = yes;
  "SND_SOC_MT8173" = module;
  "SND_SOC_MT8173_RT5650" = module;
  "SND_SOC_MT8173_RT5650_RT5514" = module;
  "SND_SOC_MT8173_RT5650_RT5676" = module;
  "USB_XHCI_PLATFORM" = yes;
  "USB_MTU3" = yes;
  "MMC_MTK" = yes;
  "MTK_CQDMA" = yes;
  "COMMON_CLK_MT6779" = no;
  "COMMON_CLK_MT6797_MMSYS" = yes;
  "COMMON_CLK_MT6797_IMGSYS" = yes;
  "COMMON_CLK_MT6797_VDECSYS" = yes;
  "COMMON_CLK_MT6797_VENCSYS" = yes;
  "COMMON_CLK_MT8183" = yes;
  "COMMON_CLK_MT8183_AUDIOSYS" = yes;
  "COMMON_CLK_MT8183_CAMSYS" = yes;
  "COMMON_CLK_MT8183_IMGSYS" = yes;
  "COMMON_CLK_MT8183_IPU_CORE0" = yes;
  "COMMON_CLK_MT8183_IPU_CORE1" = yes;
  "COMMON_CLK_MT8183_IPU_ADL" = yes;
  "COMMON_CLK_MT8183_IPU_CONN" = yes;
  "COMMON_CLK_MT8183_MFGCFG" = yes;
  "COMMON_CLK_MT8183_MMSYS" = yes;
  "COMMON_CLK_MT8183_VDECSYS" = yes;
  "COMMON_CLK_MT8183_VENCSYS" = yes;
  "MTK_IOMMU" = yes;
  "MTK_CMDQ" = yes;
  "MTK_PMIC_WRAP" = yes;
  "PWM_MTK_DISP" = yes;
  "PWM_MEDIATEK" = yes;
  "PHY_MTK_TPHY" = yes;
  "VIDEO_MEDIATEK_MDP" = module;
  "BT_MRVL" = module;
  "BT_MRVL_SDIO" = module;
  "MWIFIEX_SDIO" = module;
  "MOUSE_ELAN_I2C" = module;
  "MOUSE_ELAN_I2C_I2C" = yes;
  "TOUCHSCREEN_ELAN" = module;
  "MTK_EFUSE" = yes;
  "MTK_THERMAL" = yes;
}
