# https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
final: super: {
  makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
}
