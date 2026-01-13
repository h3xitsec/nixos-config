{
  description = "h3xit's simplified NixOS configuration with Niri";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

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

    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nix-index.url = "github:Mic92/nix-index-database";
    nix-index.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-homebrew,
    homebrew-cask,
    homebrew-core,
    darwin,
    nixos-hardware,
    nixvim,
    home-manager,
    alejandra,
    dgop,
    dankMaterialShell,
    ...
  }: let
    username = "h3x";
    darwinSystems = ["aarch64-darwin" "x86_64-darwin"];
    # Import our library functions
    lib = import ./lib {inherit inputs;};
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
        specialArgs = {inherit username;};
        modules = [
          # Dell XPS 15-9520 hardware support
          nixos-hardware.nixosModules.dell-xps-15-9520
          inputs.stylix.nixosModules.stylix
          ./lib/shared/nix-settings.nix

          ./hosts/h3xlptp/configuration.nix
          ./hosts/h3xlptp/hardware.nix
          ./hosts/h3xlptp/users.nix

          ./modules/nixos/hardware/nvidia.nix

          ./modules/nixos/de/niri.nix
          ./modules/nixos/de/stylix.nix

          ./modules/nixos/apps/1password.nix
          ./modules/nixos/apps/docker.nix
          ./modules/nixos/apps/libvirtd-virtmanager.nix
          ./modules/nixos/apps/obsidian.nix

          # Alejandra formatter
          {environment.systemPackages = [alejandra.defaultPackage."x86_64-linux"];}

          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "bak";
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit username;};
              users.h3x.imports = [
                inputs.nixvim.homeModules.nixvim
                inputs.nix-index.homeModules.nix-index
                inputs.dankMaterialShell.homeModules.dank-material-shell
                inputs.dankMaterialShell.homeModules.niri
                inputs.nixcord.homeModules.nixcord

                ./hosts/h3xlptp/home.nix

                ./modules/home-manager/de/niri.nix
                ./modules/home-manager/de/theme.nix
                ./modules/home-manager/de/dankmaterialshell.nix
                ./modules/home-manager/de/wallpapers.nix

                ./modules/home-manager/shell/shell.nix
                ./modules/home-manager/shell/common-session-variables.nix
                ./modules/home-manager/shell/session-variables.nix
                ./modules/home-manager/shell/tmux.nix
                ./modules/home-manager/shell/pentest-shell.nix
                ./modules/home-manager/shell/git.nix
                ./modules/home-manager/shell/nixvim.nix
                ./modules/home-manager/shell/zsh.nix

                ./modules/home-manager/apps/browsers.nix
                ./modules/home-manager/apps/caido.nix
                ./modules/home-manager/apps/headlamp.nix
                ./modules/home-manager/apps/misc.nix
                ./modules/home-manager/apps/terminal.nix
                ./modules/home-manager/apps/obsidian.nix
                ./modules/home-manager/apps/vscode.nix
                ./modules/home-manager/apps/cursor.nix
                ./modules/home-manager/apps/nixcord.nix
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
      specialArgs = {inherit username;};
      modules = [
        ./hosts/h3xmac/configuration.nix
        ./hosts/h3xmac/dock.nix
        ./hosts/h3xmac/homebrew.nix
        ./hosts/h3xmac/users.nix
        ./lib/shared/nix-settings.nix
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
            extraSpecialArgs = {inherit username;};
            users.h3x.imports = [
              inputs.nixvim.homeModules.nixvim
              inputs.nix-index.homeModules.nix-index
              inputs.nixcord.homeModules.nixcord
              ./hosts/h3xmac/home.nix
              ./modules/home-manager/apps/vscode.nix
              ./modules/home-manager/shell/git.nix
              ./modules/home-manager/shell/zsh.nix
              ./modules/home-manager/de/wallpapers.nix
              ./modules/home-manager/shell/common-session-variables.nix
              ./modules/home-manager/shell/nixvim.nix
              ./modules/home-manager/apps/nixcord.nix
            ];
          };
        }
      ];
    };
  };
}
