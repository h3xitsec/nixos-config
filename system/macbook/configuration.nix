{ pkgs, ... }:
{
  imports = [
    ./users.nix
    # Import shared modules
    ../../lib/shared/nix-settings.nix
  ];
  system.primaryUser = "h3x";
  system.defaults = {
    dock = {
      autohide = false;
      orientation = "bottom";
      show-process-indicators = false;
      show-recents = false;
      persistent-apps = [
        "/System/Cryptexes/App/System/Applications/Safari.app"
        "/System/Applications/Mail.app"
        "/System/Applications/Messages.app"
        "/System/Applications/Music.app"
        "/System/Applications/TV.app"
        "/Applications/Nix Apps/iTerm2.app"
        "/Users/h3x/Applications/Home Manager Apps/Visual Studio Code.app"
        "/Applications/BambuStudio.app"
        "/Applications/Caido.app"
        "/Applications/1Password.app"
        "/Users/h3x/Applications/Autodesk Fusion.app"
      ];
    };
    # Other system settings...
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
    iterm2
  ];
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    taps = [];
    brews = [];
    casks = [
      "caffeine"
      "caido"
      "1password"
      "logi-options+"
      "autodesk-fusion"
    ];
  };
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Sudo fingerprint
  security.pam.services.sudo_local.touchIdAuth = true;
}
