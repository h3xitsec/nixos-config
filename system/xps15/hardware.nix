{
  config,
  lib,
  pkgs,
  ...
}: {
  # Boot and kernel configuration
  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = ["vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = ["i915" "vfat" "nls_cp437" "nls_iso8859-1"];
  boot.initrd.compressor = "zstd";
  boot.initrd.compressorArgs = ["-19" "-T0"];

  boot.kernelModules = ["kvm-intel" "coretemp" "nct6775"];
  boot.kernelParams = [
    "acpi_osi=linux"
    "intel_pstate=active"
    "acpi_rev_override=1"
    "mem_sleep_default=s2idle"
    "pcie_aspm=off"
    "quiet"
    "splash"
    "nowatchdog"
    "mitigations=off"
  ];

  boot.extraModulePackages = [];
  boot.extraModprobeConfig = ''
    blacklist nouveau
    blacklist spd5118
    options nouveau modeset=0
    options iwlwifi power_save=1 disable_11ax=0 swcrypto=0 bt_coex_active=1
    options iwlmvm power_scheme=3
  '';

  boot.blacklistedKernelModules = ["spd5118" "nouveau"];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Graphics hardware
  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    graphics.extraPackages = with pkgs; [
      intel-media-driver # VAAPI for new Intel GPUs
      #intel-vaapi-driver # VAAPI for older Intel GPUs
      libva-vdpau-driver
      libvdpau-va-gl
      intel-compute-runtime # OpenCL
    ];
    enableRedistributableFirmware = true;
  };

  # Filesystem mounts
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/98d96009-0c5b-49bd-9047-c444ccff6c82";
    fsType = "btrfs";
    options = ["subvol=@" "ssd" "noatime" "space_cache=v2" "compress=zstd:3" "discard=async" "commit=120"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/98d96009-0c5b-49bd-9047-c444ccff6c82";
    fsType = "btrfs";
    options = ["subvol=@home" "ssd" "noatime" "space_cache=v2" "compress=zstd:3" "discard=async" "commit=128"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D1E4-3175";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/81e2a0f2-84ca-48bc-941f-d26e5ed73b5a";
    fsType = "ext4";
  };

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  # Thermal management
  services.thermald.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Thunderbolt
  services.hardware.bolt.enable = true;

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
