{lib, ...}: {
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
      trustedInterfaces = [
        "wlp0s20f3"
        "incusbr*"
        "virbr*"
        "vboxnet1"
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
}
