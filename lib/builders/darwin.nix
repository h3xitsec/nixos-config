# Darwin system builder with shared configuration
{ inputs, lib }:
{ system ? "aarch64-darwin", hostname, modules ? [], specialArgs ? {}, ... }:

inputs.darwin.lib.darwinSystem {
  inherit system;
  
  specialArgs = {
    inherit inputs;
    inherit (inputs.self) outputs;
  } // specialArgs;

  modules = [
    # Apply shared configuration
    ../shared/nix-settings.nix
    
    # Home Manager integration
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = specialArgs;
      };
    }
  ] ++ modules;
}