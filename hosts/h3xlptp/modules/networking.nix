{
  lib,
  config,
  ...
}: {
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
      enable = true; # Explicitly enable firewall
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
}
