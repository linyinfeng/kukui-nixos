{
  writeShellApplication,
  coreutils,
  jq,
  lz4,
  vboot_reference,
  ubootTools,
  findutils,
  lib,

  verbose ? false,
  kukuiNamespace ? import ../lib/bootspec-namespace.nix,
}:
writeShellApplication {
  name = "make-kpart";
  runtimeInputs = [
    coreutils
    jq
    lz4
    vboot_reference
    ubootTools
    findutils
  ];
  text = ''
    ${lib.optionalString verbose ''
      set -x
    ''}

    boot_json="$1"

    init="$(jq --raw-output '."org.nixos.bootspec.v1".init' "$boot_json")"
    jq --raw-output '["'"init=$init"'"] + ."org.nixos.bootspec.v1".kernelParams | join(" ")' "$boot_json" >cmdline
    initrd="$(jq --raw-output '."org.nixos.bootspec.v1".initrd' "$boot_json")"
    kernel="$(jq --raw-output '."org.nixos.bootspec.v1".kernel' "$boot_json")"
    dtbs="$(jq --raw-output '."${kukuiNamespace}".dtbs' "$boot_json")"
    dtb_args=()
    while read -r dtb; do
      dtb_args+=('--device-tree' "$dtb")
    done < <(find "$dtbs" -type f -name "*.dtb")

    mkimage \
      --dtcopts "-I dts -O dtb -p 2048" \
      --fit auto \
      --architecture arm64 \
      --os linux \
      --type kernel \
      --compression none \
      --load-address 0 \
      --image "$kernel" \
      --initramfs "$initrd" \
      kernel.itb \
      "''${dtb_args[@]}"

    dd if=/dev/zero of=bootloader.bin bs=512 count=1
    vbutil_kernel \
      --pack vmlinux.kpart \
      --keyblock ${vboot_reference}/share/vboot/devkeys/kernel.keyblock \
      --signprivate ${vboot_reference}/share/vboot/devkeys/kernel_data_key.vbprivk \
      --version 1 \
      --config cmdline \
      --bootloader bootloader.bin \
      --vmlinuz kernel.itb \
      --arch arm
    rm bootloader.bin
  '';
}
