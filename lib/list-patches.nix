{ lib }:
path:
builtins.map
  (_p: {
    name = lib.strings.removeSuffix ".patch" _p;
    patch = path + "/${_p}";
  })
  (
    builtins.attrNames (
      lib.attrsets.filterAttrs (path: type: type == "regular" && lib.strings.hasSuffix ".patch" path) (
        builtins.readDir path
      )
    )
  )
