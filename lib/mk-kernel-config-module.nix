{
  path,
  priority ? 100,
  optional ? false,
}:
{ lib, ... }:
let
  inherit (lib.kernel) option;
in
{
  config = {
    boot.kernelPatches = [
      {
        name = baseNameOf path;
        patch = null;
        extraStructuredConfig = lib.mapAttrs (
          _: value: lib.mkOverride priority (if optional then option value else value)
        ) (import path { inherit lib; });
      }
    ];
  };
}
