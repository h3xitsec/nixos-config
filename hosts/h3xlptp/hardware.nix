{
  config,
  lib,
  pkgs,
  ...
}: {
  # Define option to disable CPU mitigations for performance (SECURITY RISK)
  options.hardware.disableMitigations = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Disable CPU security mitigations for performance (SECURITY RISK - only for testing)";
  };

  config = {
    # Graphics hardware
    hardware = {
      graphics.enable = true;
      graphics.enable32Bit = true;
      graphics.extraPackages = with pkgs; [
        intel-media-driver # VAAPI for new Intel GPUs
        libva-vdpau-driver
        libvdpau-va-gl
        intel-compute-runtime # OpenCL
      ];
      enableRedistributableFirmware = true;
    };

    # Root filesystem (BTRFS with subvolumes)
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/98d96009-0c5b-49bd-9047-c444ccff6c82"; # UPDATE THIS UUID
      fsType = "btrfs";
      # BTRFS options:
      # - subvol=@: root subvolume
      # - ssd: optimize for SSD
      # - noatime: don't update access times (performance)
      # - space_cache=v2: use v2 space cache (better performance)
      # - compress=zstd:3: zstd compression level 3 (good balance)
      # - discard=async: async TRIM for SSDs
      # - commit=120: commit transaction every 120 seconds
      options = ["subvol=@" "ssd" "noatime" "space_cache=v2" "compress=zstd:3" "discard=async" "commit=120"];
    };

    # Home filesystem (separate BTRFS subvolume)
    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/98d96009-0c5b-49bd-9047-c444ccff6c82"; # Same device, different subvolume
      fsType = "btrfs";
      # Similar options to root, but longer commit interval for user data
      options = ["subvol=@home" "ssd" "noatime" "space_cache=v2" "compress=zstd:3" "discard=async" "commit=128"];
    };

    # Boot partition (EFI system partition)
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/D1E4-3175"; # UPDATE THIS UUID
      fsType = "vfat";
      # Standard EFI partition mount options
      options = ["fmask=0022" "dmask=0022"];
    };

    # Data partition (separate drive/partition for user data)
    fileSystems."/mnt/data" = {
      device = "/dev/disk/by-uuid/81e2a0f2-84ca-48bc-941f-d26e5ed73b5a"; # UPDATE THIS UUID
      fsType = "ext4";
    };

    fileSystems."/mnt/priv" = {
      device = "192.168.0.12:/mnt/pool01/subvol-priv";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
    };

    # Power management
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "ondemand";
    };

    # Platform
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
