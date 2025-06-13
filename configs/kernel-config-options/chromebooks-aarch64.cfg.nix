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
  "TOUCHSCREEN_ATMEL_MXT_T37" = yes;
  "PM_DEVFREQ" = yes;
  "ARM_RK3399_DMC_DEVFREQ" = module;
  "PM_DEVFREQ_EVENT" = yes;
  "DEVFREQ_EVENT_ROCKCHIP_DFI" = module;
  "PHY_ROCKCHIP_USB" = yes;
  "INPUT_UINPUT" = module;
  "CROS_EC_RPMSG" = yes;
  "CHARGER_CROS_USBPD" = module;
  "DEVFREQ_GOV_PERFORMANCE" = module;
  "DEVFREQ_GOV_USERSPACE" = module;
  "USB_RTL8152" = module;
  "DRM_PANEL_KINGDISPLAY_KD097D04" = module;
  "DRM_PANEL_INNOLUX_P079ZCA" = module;
  "TOUCHSCREEN_ELAN" = module;
}
