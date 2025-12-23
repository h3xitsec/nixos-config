{
  description = "h3xit's simplified NixOS configuration with Niri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # nix-darwin stuff
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Flake utilities for better system handling
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
    };
    
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nix-index.url = "github:Mic92/nix-index-database";
    nix-index.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    
    #apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-darwin,
    nix-homebrew,
    homebrew-cask,
    homebrew-core,
    darwin,
    nixos-hardware,
    nixvim,
    home-manager,
    alejandra,
    flake-utils-plus,
    ...
  }:
  let
    darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
    # Import our library functions
    lib = import ./lib { inherit inputs; };
  in {
    formatter = {
      x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    };

    overlays = import ./overlays.nix {inherit inputs;};

    # XPS15
    nixosConfigurations = {
      h3xlptp = lib.builders.nixos {
        hostname = "h3xlptp";
        system = "x86_64-linux";
        modules = [
          # Dell XPS 15-9520 hardware support
          nixos-hardware.nixosModules.dell-xps-15-9520

          # System configuration
          ./system/xps15/configuration.nix

          # Alejandra formatter
          {environment.systemPackages = [alejandra.defaultPackage."x86_64-linux"];}

          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "bak";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.h3x.imports = [
                inputs.nixvim.homeModules.nixvim
                inputs.nix-index.homeModules.nix-index
                inputs.dankMaterialShell.homeModules.dank-material-shell
                inputs.dankMaterialShell.homeModules.niri
                ./home/xps15
              ];
            };
          }
        ];
      };
    };
    
    # Macbook
    darwinConfigurations."h3xmac" = lib.builders.darwin {
      hostname = "h3xmac";
      system = "aarch64-darwin";
      modules = [
        ./system/macbook/configuration.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "h3x";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
        # Optional: Align homebrew taps config with nix-homebrew
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
        # Home Manager integration
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            users.h3x.imports = [
              inputs.nix-index.homeModules.nix-index
              ./home/macbook
            ];
          };
        }
      ];
    };
  };
}
