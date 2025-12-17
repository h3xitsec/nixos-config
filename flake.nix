{
  description = "h3xit's simplified NixOS configuration with Niri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
    nixos-hardware,
    nixvim,
    home-manager,
    alejandra,
    ...
  }: {
    formatter = {
      x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    };

    overlays = import ./overlays.nix {inherit inputs;};

    nixosConfigurations = {
      h3xlptp = nixpkgs.lib.nixosSystem rec {
        specialArgs = {
          inherit self inputs;
          inherit (self) outputs;
        };

        modules = [
          # Dell XPS 15-9520 hardware support
          nixos-hardware.nixosModules.dell-xps-15-9520

          # System configuration
          ./system/configuration.nix

          # Alejandra formatter
          {environment.systemPackages = [alejandra.defaultPackage."x86_64-linux"];}          

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "bak";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.h3x.imports = [
                inputs.nixvim.homeModules.nixvim
                inputs.nix-index.homeModules.nix-index
                inputs.dankMaterialShell.homeModules.dankMaterialShell.default
                inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
                ./home
              ];
            };
          }

          # Apply overlays
          {
            nixpkgs.overlays = [
              inputs.niri.overlays.niri
              (import ./overlays.nix {inherit inputs;}).fixups
              (import ./overlays.nix {inherit inputs;}).unstable-packages
            ];
          }
        ];
      };
    };
  };
}
