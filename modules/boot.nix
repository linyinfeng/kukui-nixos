{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.kukui.boot;
  inherit (config.lib.kukui) bootspecNamespace;
in
{
  options.kukui.boot = {
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
      installHook = pkgs.writeShellApplication {
        name = "kpart-install";
        runtimeInputs = with pkgs; [
          kukui.make-kpart
        ];
        text = ''
          working_dir="$(mktemp --directory -t kpart-install.XXXXXX)"
          pushd "$working_dir" >/dev/null

          make-kpart /nix/var/nix/profiles/system/boot.json
          dd if=vmlinux.kpart of="${cfg.kernelDevice}"

          popd >/dev/null
          rm --recursive "$working_dir"
        '';
      };
    };
  };
}
