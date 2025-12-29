# NixOS system builder with shared configuration
{ inputs, lib }:
{ system ? "x86_64-linux", hostname, modules ? [], specialArgs ? {}, ... }:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  
  specialArgs = {
    inherit inputs ;
    inherit (inputs.self) outputs;
  } // specialArgs;

  modules = [
    # Apply shared configuration
    ../shared/nix-settings.nix
    ../shared/validation.nix 
    
    # Default overlays
    {
      nixpkgs.overlays = [
        inputs.niri.overlays.niri
        (import ../../overlays.nix {inherit inputs;}).fixups
        (import ../../overlays.nix {inherit inputs;}).unstable-packages
      ];
    }
  ] ++ modules;
}