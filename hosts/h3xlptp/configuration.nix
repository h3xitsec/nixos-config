{
  pkgs,
  config,
  lib,
  ...
}: let
  # Import shared packages
  sharedPackages = import ../../lib/shared/packages.nix { inherit pkgs; };
in {
  environment.systemPackages = 
    # Use all shared packages
    sharedPackages.all
    # Add XPS15-specific hardware packages
    ++ (with pkgs; [
      tpm2-tss  # TPM2 support for hardware security
    ]);
  ## Boot Settings
  boot = {
    supportedFilesystems = ["ntfs"];

    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      grub.enable = false;
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "auto";
    };

    initrd = {
      systemd.enable = true;
    };
  };

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

  ## Network Services
  networking = {
    hostName = "h3xlptp";
    useDHCP = lib.mkDefault true;

    networkmanager = {
      enable = true;
    };

    # Extra hosts
    extraHosts = ''
      127.0.0.1 dev.h3x.recon
    '';

    # Firewall with nftables
    nftables.enable = true;
    firewall = {
      enable = true;  # Explicitly enable firewall
      trustedInterfaces = [
        "wlp0s20f3"
        "incusbr*"
        "virbr*"
        "vboxnet1"
      ];
      # Allow common services
      allowedTCPPorts = [
        # Add any required TCP ports here
      ];
      allowedUDPPorts = [
        # Add any required UDP ports here
      ];
    };
  };

  # DNS-over-TLS configuration
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=1.1.1.1 8.8.8.8
      FallbackDNS=1.0.0.1 8.8.4.4
      DNSOverTLS=yes
      Cache=yes
      DNSStubListener=yes
      Domains=~.
    '';
  };

  # Tailscale VPN
  services.tailscale.enable = true;


  ## Audio Services
  services.pulseaudio.enable = lib.mkForce false;

  # Enable PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.enable = true;
    wireplumber.configPackages = [];

    # Low latency configuration
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };

    extraConfig.pipewire-pulse."92-low-latency" = {
      pulse.properties = {
        pulse.min.req = "32/48000";
        pulse.default.req = "32/48000";
        pulse.max.req = "32/48000";
        pulse.min.quantum = "32/48000";
        pulse.max.quantum = "32/48000";
      };
      stream.properties = {
        node.latency = "32/48000";
        resample.quality = 1;
      };
    };
  };

  # Bluetooth audio modules
  services.pulseaudio.extraModules = [pkgs.pulseaudio-modules-bt];

  ## Power Management
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      # ----- CPU (main culprit for "slow" feeling) -----
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";  # Keep powersave - HWP does the real work

      # EPP: This is the key setting for Alder Lake responsiveness
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";  # Was balance_power, now snappier

      # Turbo boost - keep it, EPP will limit when idle anyway
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      # HWP dynamic boost - allow burst performance on battery
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;  # Changed: allows short performance bursts

      # ----- Platform Profile -----
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";  # Keep balanced (not low-power)

      # ----- Disk (aggressive APM causes micro-stutters) -----
      DISK_DEVICES = "nvme0n1";
      DISK_APM_LEVEL_ON_AC = "254";
      DISK_APM_LEVEL_ON_BAT = "192";  # Was 128, less aggressive now

      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";

      # ----- PCIe ASPM (latency vs power tradeoff) -----
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "default";  # Was powersupersave, now let kernel decide

      # ----- Runtime PM -----
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # ----- WiFi (keep responsive) -----
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";  # Changed: WiFi power save adds latency

      # ----- USB -----
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;
      USB_EXCLUDE_PHONE = 1;

      # ----- Audio -----
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 0;  # Changed: avoids audio latency/pops

      # ----- Battery thresholds -----
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # ----- Misc -----
      NMI_WATCHDOG = 0;
      WOL_DISABLE = "Y";
    };
  };
  services.logind.settings.Login = {
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitch = "suspend";
  };

  ## Security Settings
  # Fingerprint reader
  services.fprintd.enable = true;
  
  # Keyring
  services.gnome.gnome-keyring.enable = true;
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  # PAM configuration with reduced fail delay
  environment.etc."login.defs".text = lib.mkForce ''
    DEFAULT_HOME yes
    ENCRYPT_METHOD YESCRYPT
    GID_MAX 29999
    GID_MIN 1000
    SYS_GID_MAX 999
    SYS_GID_MIN 400
    SYS_UID_MAX 999
    SYS_UID_MIN 400
    TTYGROUP tty
    TTYPERM 0620
    UID_MAX 29999
    UID_MIN 1000
    UMASK 077
    FAIL_DELAY 1
  '';

  # Polkit
  security.polkit.enable = true;

  # Sudo configuration
  security.sudo.wheelNeedsPassword = false;

  # Kernel security
  security.protectKernelImage = true;
  security.allowSimultaneousMultithreading = true;

  # AppArmor (disabled)
  security.apparmor.enable = false;  
}
