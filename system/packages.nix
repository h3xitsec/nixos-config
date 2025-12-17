{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Development
    python312
    python312Packages.pip
    pipx
    git
    gnumake
    vim
    cacert

    # System utilities
    btop
    iotop
    powertop
    lm_sensors
    acpi
    cachix

    # Networking
    dnsutils
    wget
    curl
    netcat-gnu

    # File utilities
    unzip

    # Hardware
    usbutils
    tpm2-tss
    pciutils

    # Shell
    tmux
    jq
  ];
}
