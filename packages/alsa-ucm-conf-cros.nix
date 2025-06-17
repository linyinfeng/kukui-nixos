{ source, runCommandNoCC }:
runCommandNoCC "alsa-ucm-conf-cros" { } ''
  mkdir --parents "$out/share/alsa"
  cp --recursive "${source}/ucm2" "$out/share/alsa/"
''
