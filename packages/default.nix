{
  inputs,
  inputs',
  newScope,
  lib,
  selfLib,
  pkgs,
}:
lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    linux-mt81xx = import ./linux-mt81xx.nix {
      inherit
        inputs
        pkgs
        selfLib
        ;
    };
    convert-options = callPackage ./convert-options.nix {
      inherit (self) linux-mt81xx;
      conf2nixLib = inputs.conf2nix.lib;
      fullConfigFile = pkgs.runCommand "patched-full-config" { } ''
        touch "$out"
        cp "${inputs.pmaports}/device/community/linux-postmarketos-mediatek-mt8183/config-postmarketos-mediatek-mt8183.aarch64" "$out"
        echo >>"$out"
        # echo "CONFIG_RUST=y" >>"$out"
      '';
    };
    make-kpart = callPackage ./make-kpart.nix { };
  }
)
