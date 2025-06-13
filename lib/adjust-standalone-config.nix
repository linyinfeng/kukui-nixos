{ lib }:
config:
lib.mapAttrs (
  _: value:
  if (value.tristate or null) == "y" then lib.mkOverride 90 value else lib.mkOverride 110 value
) config
