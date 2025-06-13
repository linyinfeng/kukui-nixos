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
  "HIBERNATE_CALLBACKS" = yes;
  "HIBERNATION" = yes;
  "PM_STD_PARTITION" = freeform "";
}
