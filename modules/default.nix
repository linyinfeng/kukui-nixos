{ selfLib }:
{
  mt81xx = import ./mt81xx.nix { inherit selfLib; };
  kukui-lib = import ./kukui-lib.nix { inherit selfLib; };
  kpart = ./kpart.nix;
  boot = ./boot.nix;
  audio = ./audio.nix;
}
