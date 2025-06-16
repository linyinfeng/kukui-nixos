{ config, lib, ... }:
let
  cfg = config.kukui.disko;
  gptTypes = import ../lib/gpt-types.nix; # infinite loop when using config.lib.kukui.gptTypes
in
{
  options.kukui.disko = {
    device = lib.mkOption {
      type = lib.types.str;
    };
    diskName = lib.mkOption {
      type = lib.types.str;
      default = "kukui";
    };
    kernelPartitionSize = lib.mkOption {
      type = lib.types.str;
      default = "128M"; # set relatively large partitions for nixos
    };
    partitions = lib.mkOption {
      type = lib.types.anything;
      default = { };
    };
  };
  config = {
    disko.devices = {
      disk.${cfg.diskName} = {
        type = "disk";
        inherit (cfg) device;
        content = {
          type = "gpt";
          partitions = {
            # https://www.chromium.org/chromium-os/developer-library/reference/device/disk-format
            kernelA = {
              priority = 0;
              start = "2M";
              size = cfg.kernelPartitionSize;
              type = gptTypes.crosKernel;
            };
            kernelB = {
              priority = 1;
              size = cfg.kernelPartitionSize;
              type = gptTypes.crosKernel;
            };
          } // cfg.partitions;
        };
      };
    };
    kukui.boot.kernelDevice = "/dev/disk/by-partlabel/disk-${cfg.diskName}-kernelA";
  };
}
