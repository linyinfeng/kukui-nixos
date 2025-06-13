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
  "USB_SERIAL" = yes;
  "USB_SERIAL_CH341" = yes;
  "USB_SERIAL_PL2303" = yes;
  "USB_SERIAL_CONSOLE" = yes;
}
