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

    extraHosts = ''
      127.0.0.1 dev.h3x.recon
      127.0.0.1 nats
      127.0.0.1 api
      127.0.0.1 postgresql
      127.0.0.1 redis
      127.0.0.1 ct-monitor
    '';

    nftables.enable = true;
    firewall = {
      checkReversePath = "loose";
      enable = true;
      trustedInterfaces = [
        "wlp0s20f3"
        "incusbr*"
        "virbr*"
        "vboxnet1"
        "br-*"
      ];
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };
}
