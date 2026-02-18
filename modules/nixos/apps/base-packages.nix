{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      git
      curl
      wget
      jq
      unzip
      cachix
      btop
      dnsutils
      netcat-gnu
      net-tools
      python312
      python312Packages.pip
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
