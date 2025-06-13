{ lib }:
{
  listPatches = import ./list-patches.nix { inherit lib; };
  adjustStandaloneConfig = import ./adjust-standalone-config.nix { inherit lib; };
  mkKernelConfigModule = import ./mk-kernel-config-module.nix;
  gptTypes = import ./gpt-types.nix;
  bootspecNamespace = import ./bootspec-namespace.nix;
}
