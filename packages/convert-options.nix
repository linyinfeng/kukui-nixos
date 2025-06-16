{
  writeShellApplication,
  conf2nixLib,
  linux-mt81xx,
  fullConfigFile,
}:
let
  fullConfigNix = conf2nixLib.conf2nix {
    configFile = fullConfigFile;
    kernel = linux-mt81xx;
    preset = "standalone";
  };
in
writeShellApplication {
  name = "convert-options";
  passthru = {
    inherit fullConfigNix;
  };
  text = ''
    cp "${fullConfigNix}" "configs/config.nix"
    chmod u+w "configs/config.nix"
  '';
}
