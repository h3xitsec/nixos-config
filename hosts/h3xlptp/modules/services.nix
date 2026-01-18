{
  pkgs,
  lib,
  ...
}: {
  # Smart card support
  services.pcscd.enable = true;

  # DNS-over-TLS configuration
  services.resolved = {
    enable = true;
  };

  # Tailscale VPN
  services.tailscale.enable = true;

  ## Audio Services
  services.pulseaudio.enable = lib.mkForce false;
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
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave"; # Keep powersave - HWP does the real work

      # EPP: This is the key setting for Alder Lake responsiveness
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance"; # Was balance_power, now snappier

      # Turbo boost - keep it, EPP will limit when idle anyway
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      # HWP dynamic boost - allow burst performance on battery
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1; # Changed: allows short performance bursts

      # ----- Platform Profile -----
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced"; # Keep balanced (not low-power)

      # ----- Disk (aggressive APM causes micro-stutters) -----
      DISK_DEVICES = "nvme0n1";
      DISK_APM_LEVEL_ON_AC = "254";
      DISK_APM_LEVEL_ON_BAT = "192"; # Was 128, less aggressive now

      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";

      # ----- PCIe ASPM (latency vs power tradeoff) -----
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "default"; # Was powersupersave, now let kernel decide

      # ----- Runtime PM -----
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # ----- WiFi (keep responsive) -----
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off"; # Changed: WiFi power save adds latency

      # ----- USB -----
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;
      USB_EXCLUDE_PHONE = 1;

      # ----- Audio -----
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 0; # Changed: avoids audio latency/pops

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

  # Fingerprint reader
  services.fprintd.enable = true;

  # Keyring
  services.gnome.gnome-keyring.enable = true;

  # Thermal management
  services.thermald.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Thunderbolt
  services.hardware.bolt.enable = true;
}
