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
  "ACPI" = no;
  "ARCH_HAS_ACPI_TABLE_UPGRADE" = no;
  "EFI" = no;
  "ARCH_APPLE" = no;
  "ARCH_EXYNOS" = no;
  "ARCH_BCM2835" = no;
  "ARCH_BCM_IPROC" = no;
  "ARCH_SUNXI" = no;
  "ARCH_MESON" = no;
  "ARCH_QCOM" = no;
  "ARCH_ROCKCHIP" = no;
  "ARCH_TEGRA_132_SOC" = no;
  "ARCH_TEGRA_186_SOC" = no;
  "ARCH_TEGRA_194_SOC" = no;
  "ARCH_TEGRA_210_SOC" = no;
  "ARCH_TEGRA_234_SOC" = no;
  "ARCH_TEGRA" = no;
  "ARCH_BCM" = no;
  "ARCH_BCMBCA" = no;
  "NET_VENDOR_ALLWINNER" = no;
  "NET_VENDOR_NVIDIA" = no;
  "NET_VENDOR_SAMSUNG" = no;
  "NET_VENDOR_SYNOPSYS" = no;
  "NET_VENDOR_STMICRO" = no;
  "DRM_RADEON" = no;
  "DRM_AMDGPU" = no;
  "DRM_I915" = no;
  "DRM_TEGRA" = no;
  "DRM_NOUVEAU" = no;
  "DRM_ETNAVIV" = no;
  "DRM_LIMA" = no;
  "DRM_EXYNOS" = no;
  "DRM_SUN4I" = no;
  "DRM_MSM" = no;
  "DRM_V3D" = no;
  "DRM_VC4" = no;
  "DRM_IMX" = no;
  "DRM_STI" = no;
  "DRM_VMWGFX" = no;
  "DRM_OMAPDRM" = no;
  "DRM_VIRTIO_GPU" = no;
  "DRM_HISI_HIBMC" = no;
  "DRM_HISI_KIRIN" = no;
  "DRM_PL111" = no;
  "DRM_TIDSS" = no;
  "DRM_MALI_DISPLAY" = no;
  "DRM_PANTHOR" = no;
}
