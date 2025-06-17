{pkgs, ...}:
{
  environment.systemPackages = with pkgs.kukui; [
    alsa-ucm-conf-cros
  ];
}
