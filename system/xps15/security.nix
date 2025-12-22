{
  pkgs,
  lib,
  ...
}: {
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

  # udev rules for hardware devices
  # services.udev.extraRules = ''
  #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", ATTRS{idProduct}=="7321", GROUP="plugdev"
  # '';
}
