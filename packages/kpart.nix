{
  stdenvNoCC,
  lz4,
  vboot_reference,
  ubootTools,
  lib,
  writeTextFile,

  kernel,
  kernelParams,
  initrd,
  dtbFilter ? [ "/dtbs/**/*.dtb" ],
}:
let
  cmdline = writeTextFile {
    name = "cmdline";
    text = lib.strings.concatStringsSep " " kernelParams;
  };
in
stdenvNoCC.mkDerivation {
  name = "kpart";
  src = kernel;

  nativeBuildInputs = [
    lz4
    vboot_reference
    ubootTools
  ];

  dontConfigure = true;

  buildPhase = ''
    lz4 -f Image Image.lz4
    dd if=/dev/zero of=bootloader.bin bs=512 count=1
    ls ${
      lib.strings.concatStringsSep " " (builtins.map (filterPath: "${kernel}${filterPath}") dtbFilter)
    } | xargs printf " -b %s" | xargs mkimage -D "-I dts -O dtb -p 2048" -f auto -A arm64 -O linux -T kernel -C lz4 -a 0 -d Image.lz4 -i ${initrd} kernel.itb
    vbutil_kernel --pack vmlinux.kpart --keyblock ${vboot_reference}/share/vboot/devkeys/kernel.keyblock --signprivate ${vboot_reference}/share/vboot/devkeys/kernel_data_key.vbprivk --version 1 --config ${cmdline} --bootloader bootloader.bin --vmlinuz kernel.itb --arch arm
  '';

  installPhase = ''
    cp vmlinux.kpart $out
  '';
}
