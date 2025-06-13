{ lib }:
let
  inherit (lib.kernel)
    yes
    no
    module
    freeform
    ;
in
{
  "PCI_ECAM" = yes;
  "PCI_HOST_COMMON" = yes;
  "PCI_HOST_GENERIC" = yes;
  "VIRTIO_BLK" = yes;
  "SERIAL_AMBA_PL010" = yes;
  "SERIAL_AMBA_PL010_CONSOLE" = yes;
  "DRM_VIRTIO_GPU" = module;
  "VIRTIO_PCI_LIB" = yes;
  "VIRTIO_PCI_LIB_LEGACY" = yes;
  "VIRTIO_MENU" = yes;
  "VIRTIO_PCI" = yes;
  "VIRTIO_PCI_LEGACY" = yes;
  "VIRTIO_INPUT" = module;
  "VIRTIO_MMIO" = yes;
  "VIRTIO_MMIO_CMDLINE_DEVICES" = yes;
  "VIRTIO_FS" = module;
  "SND_VIRTIO" = module;
  "WQ_POWER_EFFICIENT_DEFAULT" = yes;
}
