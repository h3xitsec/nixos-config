{...}: {
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
}
