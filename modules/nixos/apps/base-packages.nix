{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      (python3.withPackages (ps:
        with ps; [
          requests
        ]))
      curl
      wget
      jq
      gitFull
      unzip
      cachix
      btop
      dnsutils
      netcat-gnu
      net-tools
      python3
      python3Packages.pip
      pipx
      gnumake
      cacert
    ]
    # Add linux-specific packages
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      iotop
      powertop
      lm_sensors
      acpi
      usbutils
      pciutils
    ];
}
