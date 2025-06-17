{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.kukui.boot;
  inherit (config.lib.kukui) bootspecNamespace;
  makeKpart = pkgs.kukui.make-kpart.override {
    inherit (cfg) verbose;
  };
  kpartInstall = pkgs.writeShellApplication {
    name = "kpart-install";
    runtimeInputs = [
      makeKpart
      pkgs.coreutils
    ];
    text = ''
      ${lib.optionalString cfg.verbose ''
        set -x
      ''}

        working_dir="$(mktemp --directory -t kpart-install.XXXXXX)"
        pushd "$working_dir" >/dev/null

        echo 'making kpart image...' >&2
        make-kpart /nix/var/nix/profiles/system/boot.json ${
          lib.optionalString (!cfg.verbose) "2>/dev/null"
        } >&2
        echo 'flashing kpart image to ${cfg.kernelDevice}...' >&2
        dd if=vmlinux.kpart of="${cfg.kernelDevice}" ${
          lib.optionalString (!cfg.verbose) "2>/dev/null"
        } >&2

        popd >/dev/null
        rm --recursive "$working_dir"
    '';
  };
in
{
  options.kukui.boot = {
    verbose = lib.mkEnableOption "verbose installer log";
    kernelDevice = lib.mkOption {
      type = lib.types.str;
      description = ''
        Path to the block device of Kernel A.
      '';
    };
  };
  config = {
    boot.bootspec = {
      enable = true;
      extensions.${bootspecNamespace} = {
        dtbs = config.hardware.deviceTree.package;
      };
    };
    boot.loader.external = {
      enable = true;
      installHook = lib.getExe kpartInstall;
    };
  };
}
