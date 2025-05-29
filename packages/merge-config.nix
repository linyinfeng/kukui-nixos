{
  lib,
  stdenv,
  flex,
  bison,

  arch,
  kernelSrc,
  extraConfigs,
}:
stdenv.mkDerivation {
  name = "merged-config";
  src = kernelSrc;
  nativeBuildInputs = [
    flex
    bison
  ];
  dontConfigure = true;
  buildPhase = ''
    export ARCH=${arch}
    scripts/kconfig/merge_config.sh -m arch/${arch}/configs/defconfig ${lib.strings.concatStringsSep " " extraConfigs}
    make olddefconfig
  '';
  installPhase = ''
    cp .config $out
  '';
}
