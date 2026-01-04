{
  lib,
  config,
  pkgs,
  ...
}: {
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
      availableKernelModules = ["vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = ["i915" "vfat" "nls_cp437" "nls_iso8859-1"];
      compressor = "zstd";
      compressorArgs = ["-19" "-T0"];
    };

    kernelModules = ["kvm-intel" "coretemp" "nct6775"];

    kernelParams =
      [
        "acpi_osi=linux"
        "intel_pstate=active"
        "acpi_rev_override=1"
        "mem_sleep_default=s2idle"
        "pcie_aspm=off"
        "quiet"
        "splash"
        "nowatchdog"
      ]
      ++ lib.optionals config.hardware.disableMitigations [
        "mitigations=off" # WARNING: Disables CPU security mitigations - performance only
      ];

    extraModulePackages = with config.boot.kernelPackages; [
      #rtl8188eus-aircrack
    ];
    extraModprobeConfig = ''
      blacklist nouveau
      blacklist spd5118
      options nouveau modeset=0
      options iwlwifi power_save=1 disable_11ax=0 swcrypto=0 bt_coex_active=1
      options iwlmvm power_scheme=3
    '';

    blacklistedKernelModules = ["spd5118" "nouveau"];
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
