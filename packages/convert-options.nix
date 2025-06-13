{
  lib,
  writeShellApplication,
  fd,
  nconf2nix,
  nconf2nixPathPatterns,
  conf2nixLib,
  linux-mt81xx,
  fullConfigFile,
}:
let
  convertOne =
    {
      extraArgs ? [ ],
    }:
    writeShellApplication {
      name = "nconf2nix-convert-one";
      runtimeInputs = [
        nconf2nix
      ];
      text = ''
        source="$1"
        target_dir="$2"
        target_file="$target_dir/$source.nix"
        mkdir --parents "$(dirname "$target_file")"
        nconf2nix --config "$source" --output "$target_file" ${lib.escapeShellArgs extraArgs}
      '';
    };

  fullConfigNix = conf2nixLib.conf2nix {
    configFile = fullConfigFile;
    kernel = linux-mt81xx;
    preset = "standalone";
  };
in
writeShellApplication {
  name = "convert-options";
  runtimeInputs = [
    fd
    (convertOne { })
  ];
  passthru = {
    inherit fullConfigNix;
  };
  text = ''
    cp "${fullConfigNix}" "configs/config.nix"
    chmod u+w "configs/config.nix"

    ${lib.concatMapStringsSep "\n" (
      {
        directory,
        pattern,
        targetDirectory,
      }:
      ''
        fd '${pattern}' --base-directory '${directory}' \
          --exec nconf2nix-convert-one '{}' "$PWD"'/configs/${targetDirectory}'
      ''
    ) nconf2nixPathPatterns}
  '';
}
