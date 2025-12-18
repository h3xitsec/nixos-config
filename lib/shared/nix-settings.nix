# Shared nix configuration settings for both NixOS and Darwin systems
{ pkgs, ... }:
{
  nix = {
    # Build optimization - use all available cores
    settings = {
      cores = 0; # Use all cores
      max-jobs = "auto";

      # Store optimization
      auto-optimise-store = true;
      min-free = 536870912; # 512MB
      max-free = 1073741824; # 1GB

      # Trusted users for nix operations
      trusted-users = ["root" "@wheel"];

      # Binary cache configuration
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://niri.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];

      # Enable experimental features
      experimental-features = ["nix-command" "flakes"];
      
      # Disable dirty tree warnings
      warn-dirty = false;
    };

    # Use stable nix package
    package = pkgs.nixVersions.stable;

    # Garbage collection configuration
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Common nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    # NVIDIA license acceptance (NixOS specific, harmless on Darwin)
    nvidia.acceptLicense = true;
  };
}