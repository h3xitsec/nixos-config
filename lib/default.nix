# Library entry point for shared modules and functions
{inputs}: let
  lib = inputs.nixpkgs.lib;
in {
  # Import all shared modules
  shared = {
    nix-settings = import ./shared/nix-settings.nix;
    packages = import ./shared/packages.nix;
    users = import ./shared/users.nix;
  };

  # Import builder functions
  builders = {
    nixos = import ./builders/nixos.nix {inherit inputs lib;};
    darwin = import ./builders/darwin.nix {inherit inputs lib;};
  };
}
