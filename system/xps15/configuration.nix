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
    ./docker.nix
    ./libvirtd-virtmanager.nix
    ./stylix.nix
    ../../home/xps15/apps/obsidian/enable-obsidian.nix
    # Import shared modules
    ../../lib/shared/nix-settings.nix
  ];
  programs.dconf.enable = true;

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

  # Package manager settings - now handled by shared nix-settings.nix
  # nixpkgs.config is set in ../../lib/shared/nix-settings.nix
  
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
  
  # State version
  system.stateVersion = "25.11";
}
