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
  "CRYPTO_AES_ARM64_NEON_BLK" = yes;
  "CRYPTO_CHACHA20_NEON" = yes;
  "CRYPTO_NHPOLY1305_NEON" = yes;
  "CRYPTO_AES_ARM64_BS" = yes;
  "DT_IDLE_STATES" = yes;
  "ARM_CPUIDLE" = yes;
  "ARM_PSCI_CPUIDLE" = yes;
  "ARM_PSCI_CPUIDLE_DOMAIN" = yes;
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
