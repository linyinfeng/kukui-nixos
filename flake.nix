{
  description = "NixOS form Chromebook Kukui";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    conf2nix = {
      url = "github:linyinfeng/conf2nix";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.crane.follows = "crane";
      inputs.flake-compat.follows = "flake-compat";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane.url = "github:ipetkov/crane";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

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
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        self,
        inputs,
        lib,
        ...
      }:
      {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        imports = [
          inputs.flake-parts.flakeModules.easyOverlay
          inputs.treefmt-nix.flakeModule
        ];
        flake = {
          lib = import ./lib { inherit (inputs.nixpkgs) lib; } // {
            sources = {
              inherit (inputs) kernel-config-options mt81xx-kernel kernel-extra-patches;
            };
          };
          nixosModules =
            let
              modules = import ./modules { selfLib = self.lib; };
            in
            modules
            // {
              default = {
                imports = lib.attrValues modules;
              };
            };
          nixosConfigurations.test = inputs.nixpkgs.lib.nixosSystem {
            modules = [
              self.nixosModules.default
              inputs.disko.nixosModules.disko
              ./profiles/disko.nix
              (
                { ... }:
                {
                  kukui.disko = {
                    device = "/tmp/test.img";
                    partitions = {
                      root = {
                        priority = 3;
                        size = "100%";
                        content = {
                          type = "filesystem";
                          format = "ext4";
                          mountpoint = "/";
                        };
                      };
                    };
                  };
                  nixpkgs.overlays = [ self.overlays.default ];
                  system.stateVersion = "25.05";
                }
              )
            ];
          };
        };
        perSystem =
          {
            config,
            inputs',
            pkgs,
            self',
            system,
            ...
          }:
          {
            legacyPackages = pkgs.callPackage ./packages {
              inherit inputs inputs';
              selfLib = self.lib;
            };
            overlayAttrs.kukui = config.legacyPackages;
            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                nixfmt.enable = true;
              };
            };
            devShells.default = pkgs.mkShell {
              inputsFrom = lib.attrValues self'.checks;
            };
            checks =
              let
                testSystem = self.nixosConfigurations.test.extendModules {
                  modules = [
                    { nixpkgs.buildPlatform = system; }
                  ];
                };
                # TODO working in progress
                systemCommonConfig = testSystem.extendModules {
                  modules = [
                    {
                      kukui.kernel.overrides = {
                        enableCommonConfig = true;
                        # TOD fix errors
                        ignoreConfigErrors = true;
                      };
                    }
                  ];
                };
              in
              {
                nixos-test-kernel = testSystem.config.boot.kernelPackages.kernel;
                nixos-test-configfile = testSystem.config.boot.kernelPackages.kernel.configfile;
                nixos-test-toplevel = testSystem.config.system.build.toplevel;
                nixos-test-disko = testSystem.config.system.build.destroyScript;

                # nixos-test-common-kernel = systemCommonConfig.config.boot.kernelPackages.kernel;
                # nixos-test-common-toplevel = systemCommonConfig.config.system.build.toplevel;
              };
          };
      }
    );
}
