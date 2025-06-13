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
  "DRM_PANFROST" = module;
  "USB_RTL8152" = module;
}
