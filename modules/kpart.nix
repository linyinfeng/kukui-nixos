{ pkgs, config, ... }:
{
  system.build.kpartImage = pkgs.callPackage ../packages/kpart.nix {
    kernelParams = config.boot.kernelParams ++ [ "init=${config.system.build.toplevel}/init" ];
    inherit (config.boot.kernelPackages) kernel;
    dtbFilter = [
      "/dtbs/mediatek/mt8173-elm-*.dtb"
      "/dtbs/mediatek/mt8183-kukui-*.dtb"
      "/dtbs/mediatek/mt8186-corsola-*.dtb"
      "/dtbs/mediatek/mt8192-asurada-*.dtb"
      "/dtbs/mediatek/mt8195-cherry-*.dtb"
    ];
    initrd = "${config.system.build.initialRamdisk}/initrd";
  };
}
