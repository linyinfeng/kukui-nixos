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
        cp "${inputs.mt81xx-kernel}/config.cbm" "$out"
        echo >>"$out"
        echo "CONFIG_RUST=y" >>"$out"
      '';

      # nconf2nix
      inherit (inputs'.conf2nix.packages) nconf2nix;
      nconf2nixPathPatterns = [
        {
          directory = "${inputs.kernel-config-options}";
          pattern = ".*\.cfg";
          targetDirectory = "kernel-config-options";
        }
        {
          directory = "${inputs.mt81xx-kernel}";
          pattern = ".*\.cfg";
          targetDirectory = "mt81xx-kernel";
        }
      ];
    };
    make-kpart = callPackage ./make-kpart.nix { };
  }
)
