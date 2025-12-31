{ lib, ...}: {
  # Disable TLP and enable power-profiles-daemon for full noctalia support
  services.tlp = {
    enable = lib.mkForce false;
  };
  services.power-profiles-daemon.enable = lib.mkForce true;
}
