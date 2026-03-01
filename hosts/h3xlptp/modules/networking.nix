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
    '';

    nftables.enable = true;
    firewall = {
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
