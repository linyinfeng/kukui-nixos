# solve infinite recursion caused by mkKernelConfigModule
{ selfLib }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.kukui;
  linux = pkgs.kukui.linux-mt81xx.override cfg.kernel.overrides;
in
{
  options.kukui = {
    kernel = {
      overrides = {
        enableCommonConfig = lib.mkEnableOption "kernel common config from nixos";
        autoModules = lib.mkEnableOption "kernel auto modules";
        ignoreConfigErrors = lib.mkEnableOption "ignore kernel config errors";
      };
    };
  };
  config = {
    nixpkgs.hostPlatform = "aarch64-linux";
    boot.kernelPackages = pkgs.linuxPackagesFor linux;
    hardware.deviceTree.filter = "mt81*.dtb";
    boot.initrd = {
      includeDefaultModules = false;
      availableKernelModules = [
        # only include available modules with `enableCommonConfig = false`
        # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/kernel.nix
        # SATE
        "ahci"
        "nvme"
        # EMMC
        "mmc_block"
        # USB Keyboard
        # "uhci_hcd"
        "ehci_hcd"
        "ehci_pci"
        "ohci_hcd"
        "ohci_pci"
        "xhci_hcd"
        "xhci_pci"
        "usbhid"
        "hid_generic"
        # "hid_lenovo"
        "hid_apple"
        # "hid_roccat"
        # "hid_logitech_hidpp"
        # "hid_logitech_dj"
        "hid_microsoft"
        "hid_cherry"
        # "hid_corsair"
      ];
    };
  };
}
