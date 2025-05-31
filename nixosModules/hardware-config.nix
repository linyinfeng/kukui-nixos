{
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "usbhid"
    "usb_storage"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.kernelParams = [
    "console=tty1"
    "rootwait"
    "ro"
    "fsck.fix=yes"
    "fsck.repair=yes"
    "net.ifnames=0"
    "ipv6.disable=1"
    "noresume"
    "apparmor=0"
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
