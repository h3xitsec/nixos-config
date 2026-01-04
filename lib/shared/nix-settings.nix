# Shared nix configuration settings for both NixOS and Darwin systems
{pkgs, ...}: {
  nix = {
    # Build optimization - use all available cores
    settings = {
      cores = 0; # Use all cores
      max-jobs = "auto";

      # Store optimization
      min-free = 536870912; # 512MB
      max-free = 1073741824; # 1GB

      # Trusted users for nix operations
      trusted-users = ["root" "@wheel"];

      # Binary cache configuration - multiple caches for faster builds
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://niri.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];

      # Enable experimental features
      experimental-features = ["nix-command" "flakes"];

      # Disable dirty tree warnings
      warn-dirty = false;

      # Build sandboxing for security and reproducibility
      sandbox = true;
    };

    # Use stable nix package
    package = pkgs.nixVersions.stable;

    # Garbage collection configuration - more aggressive for space savings
    gc =
      {
        automatic = true;
        # More aggressive GC: delete older than 14 days and free up to 10GB
        options = "--delete-older-than 14d --max-freed $((10 * 1024 * 1024 * 1024))";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        interval = {
          Weekday = 0;
          Hour = 0;
          Minute = 0;
        };
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        dates = "weekly";
      };
    optimise.automatic = true;
  };

  # Common nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    # NVIDIA license acceptance (NixOS specific, harmless on Darwin)
    nvidia.acceptLicense = true;
  };
}
