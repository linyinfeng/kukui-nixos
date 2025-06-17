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
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
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
    pmaports = {
      url = "gitlab:postmarketOS/pmaports?host=gitlab.postmarketos.org";
      flake = false;
    };
    # TODO wait for https://nixpkgs-tracker.ocfox.me/?pr=414818
    nixpkgs-alsa-ucm-conf.url = "github:nixos/nixpkgs/pull/414818/head";
  };

  outputs =
    {
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
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
              inherit (inputs) pmaports;
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
          nixosConfigurations = {
            installer = inputs.nixpkgs.lib.nixosSystem {
              modules = [
                self.nixosModules.default
                inputs.disko.nixosModules.disko
                ./profiles/disko.nix
                (
                  { pkgs, ... }:
                  {
                    kukui.disko = {
                      diskName = "installer";
                      device = "/dev/sda";
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
                    services.getty.autologinUser = "root";
                    users.users.root.initialHashedPassword = "";
                    environment.systemPackages = with pkgs; [
                      vboot_reference # for cgpt
                    ];
                    nixpkgs.hostPlatform = "aarch64-linux";
                    nixpkgs.overlays = [ self.overlays.default ];
                    system.stateVersion = "25.05";
                  }
                )
              ];
            };
            installer-cross = config.flake.nixosConfigurations.installer.extendModules {
              modules = [
                { nixpkgs.buildPlatform = "x86_64-linux"; }
              ];
            };
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
                testSystem = self.nixosConfigurations.installer.extendModules {
                  modules = [
                    { nixpkgs.buildPlatform = system; }
                  ];
                };
              in
              {
                installer-kernel = testSystem.config.boot.kernelPackages.kernel;
                installer-configfile = testSystem.config.boot.kernelPackages.kernel.configfile;
                installer-toplevel = testSystem.config.system.build.toplevel;
              };
          };
      }
    );
}
