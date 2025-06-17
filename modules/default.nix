{ selfLib }:
{
  mt81xx = import ./mt81xx.nix { inherit selfLib; };
  kukui-lib = import ./kukui-lib.nix { inherit selfLib; };
  kpart = import ./kpart.nix;
  boot = import ./boot.nix;
  audio = import ./audio.nix;
}
