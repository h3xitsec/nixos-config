{ pkgs, ... }:
{
  imports = [
    ./users.nix
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
    # onActivation.cleanup = "uninstall";

    taps = [];
    brews = [];
    casks = [
      "unnaturalscrollwheels"
    ];
  };
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.substituters = [ "https://cache.nixos.org" ];
  nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Sudo fingerprint
  security.pam.services.sudo_local.touchIdAuth = true;
}
