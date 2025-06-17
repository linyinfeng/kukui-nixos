# TODO wait for https://nixpkgs-tracker.ocfox.me/?pr=414818
{ config, pkgs, ... }:
let
  ucm2Env = config.environment.variables.ALSA_CONFIG_UCM2;
in
{
  environment.systemPackages = [
    pkgs.kukui.alsa-ucm-conf
  ];

  # https://github.com/mobile-nixos/mobile-nixos/blob/development/modules/quirks/audio.nix
  environment.pathsToLink = [ "/share/alsa/ucm2" ];
  environment.variables.ALSA_CONFIG_UCM2 = "/run/current-system/sw/share/alsa/ucm2";
  systemd.user.services.pulseaudio.environment.ALSA_CONFIG_UCM2 = ucm2Env;
  systemd.services.pulseaudio.environment.ALSA_CONFIG_UCM2 = ucm2Env;
  systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM2 = ucm2Env;
  systemd.user.services.pipewire-pulse.environment.ALSA_CONFIG_UCM2 = ucm2Env;
  systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM2 = ucm2Env;
  systemd.services.pipewire.environment.ALSA_CONFIG_UCM2 = ucm2Env;
  systemd.services.pipewire-pulse.environment.ALSA_CONFIG_UCM2 = ucm2Env;
  systemd.services.wireplumber.environment.ALSA_CONFIG_UCM2 = ucm2Env;
}
