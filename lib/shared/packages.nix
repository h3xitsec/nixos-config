# Shared package definitions for cross-platform use
{ pkgs, ... }:
{
  # Core development tools available on all systems
  core-dev = with pkgs; [
    vim
    git
    curl
    wget
    jq
    unzip
    cachix
  ];

  # System utilities available on all platforms
  system-utils = with pkgs; [
    btop
    # Platform-specific utilities can be conditionally included
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    iotop
    powertop
    lm_sensors
    acpi
    usbutils
    pciutils
  ];

  # Networking tools
  networking = with pkgs; [
    dnsutils
    netcat-gnu
  ];

  # Development languages and tools
  development = with pkgs; [
    python312
    python312Packages.pip
    pipx
    gnumake
    cacert
  ];

  # Shell and terminal utilities
  shell = with pkgs; [
    tmux
    zsh
  ];
}