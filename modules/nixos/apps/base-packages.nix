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
      gnumake
      cacert
    ]
    # Add linux-specific packages
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      (pipx.overridePythonAttrs (old: {
        disabledTests =
          (old.disabledTests or [])
          ++ [
            "test_fix_package_name"
            "test_parse_specifier_for_metadata"
          ];
      }))
      iotop
      powertop
      lm_sensors
      acpi
      usbutils
      pciutils
    ];
}
