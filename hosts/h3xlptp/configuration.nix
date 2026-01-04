{
  ...
}: {
  imports = [
    ./modules/environment.nix
    ./modules/programs.nix
    ./modules/services.nix
    ./modules/security.nix
    ./modules/boot.nix
    ./modules/networking.nix
  ];
  
  # State version
  system.stateVersion = "25.11";
  
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

  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };
}
