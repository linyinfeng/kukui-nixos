{
  description = "Basic flake for devShell";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    mt81xx-kernel = {
      url = "github:hexdump0815/linux-mainline-mediatek-mt81xx-kernel";
      flake = false;
    };
    kernel-config-options = {
      url = "github:hexdump0815/kernel-config-options";
      flake = false;
    };
    kernel-extra-patches = {
      url = "github:hexdump0815/kernel-extra-patches";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    {
      nixosConfigurations.kukui = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          inherit (self) overlays;
        };
        modules = [
          ./nixosModules/cros-sd-image.nix
          ./nixosModules/hardware-config.nix
          ./nixosConfigurations/kukui.nix
        ];
      };
      overlays = {
        allow-missing-kmodules = import ./overlays/allow-missing-kmodules.nix;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            git
          ];
        };
      }
    );
}
