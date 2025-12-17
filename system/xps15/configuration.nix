{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware.nix
    ./boot.nix
    ./networking.nix
    ./nvidia.nix
    ./power.nix
    ./audio.nix
    ./security.nix
    ./users.nix
    ./niri.nix
    ./packages.nix
    ./1password.nix
  ];
  programs.dconf.enable = true;
  # Nix settings
  nix = {
    settings = {
      # Build optimization
      cores = 0; # Use all cores
      max-jobs = "auto";

      # Store optimization (single place, no systemd service)
      auto-optimise-store = true;
      min-free = 536870912; # 512MB
      max-free = 1073741824; # 1GB

      # Trusted users
      trusted-users = ["root" "@wheel"];

      # Cache settings
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
    };

    package = pkgs.nixVersions.stable;

    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Locale settings
  time.timeZone = "America/Montreal";
  i18n.defaultLocale = "en_CA.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_CA.UTF-8";
    LC_IDENTIFICATION = "en_CA.UTF-8";
    LC_MEASUREMENT = "en_CA.UTF-8";
    LC_MONETARY = "en_CA.UTF-8";
    LC_NAME = "en_CA.UTF-8";
    LC_NUMERIC = "en_CA.UTF-8";
    LC_PAPER = "en_CA.UTF-8";
    LC_TELEPHONE = "en_CA.UTF-8";
    LC_TIME = "en_CA.UTF-8";
  };

  # Console configuration
  console.useXkbConfig = true;

  # Package manager settings
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  
  # System packages list for reference
  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;

  # Make /etc/hosts root writable
  environment.etc.hosts.mode = "0644";

  # Add ~/.local/bin to sessions path
  environment.localBinInPath = true;

  # Smart card support
  services.pcscd.enable = true;

  # Enable AppImage support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  #zsh
  programs.zsh.enable = true;

  # nix-ld for running non-NixOS binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libfprint-2-tod1-goodix
  ];
  
  # Fix for hanging reboot
  systemd.user.extraConfig = "DefaultTimeoutStopSec=10s";

  # State version
  system.stateVersion = "25.11";
}
