{
  lib,
  stdenvNoCC,

  arch,
  kernelSrc,
  extraConfigs,
}:
stdenvNoCC.mkDerivation {
  name = "merged-config";
  src = kernelSrc;
  dontConfigure = true;
  buildPhase = ''
    export ARCH=${arch}
    scripts/kconfig/merge_config.sh -m arch/${arch}/configs/defconfig ${lib.strings.concatStringsSep " " extraConfigs}
  '';
  installPhase = ''
    cp .config $out
  '';
}
