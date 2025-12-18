{ pkgs, ... }:
{
  imports = [
    ./users.nix
    # Import shared nix settings
    ../../lib/shared/nix-settings.nix
  ];
  system.primaryUser = "h3x";
  system.defaults = {
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    finder = {
      AppleShowAllFiles = true; # hidden files
      AppleShowAllExtensions = true; # file extensions
      _FXShowPosixPathInTitle = true; # title bar full path
      ShowPathbar = true; # breadcrumb nav at bottom
      ShowStatusBar = true; # file count & disk space
    };

    NSGlobalDomain = {
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
    };
  };
  environment.systemPackages  = with pkgs; [
        vim
        discord
  ];
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [];
    brews = [];
    casks = [];
  };
  # Nix settings now handled by shared module ../../lib/shared/nix-settings.nix
  # nixpkgs.config.allowUnfree and nix.settings are set there
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Sudo fingerprint
  security.pam.services.sudo_local.touchIdAuth = true;
}
