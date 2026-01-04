{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [inputs.niri.nixosModules.niri];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;
  # greetd display manager with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${pkgs.niri-unstable}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };
  # greetd systemd service configuration
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Disable niri-flake's polkit service
  systemd.user.services.niri-flake-polkit.enable = false;

  # Use GNOME's polkit agent instead
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "PolicyKit Authentication Agent (GNOME)";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  programs.xwayland.enable = true;
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.devmon.enable = true;
  services.accounts-daemon.enable = true;

  # XServer configuration (for XKB settings and X11 compatibility)
  services.xserver = {
    enable = true;
    videoDrivers = ["modesetting"];
    xkb = {
      layout = "ca";
      options = "ctrl:nocaps";
      variant = "";
    };
    displayManager.startx.enable = true;
  };

  # libinput for input device handling
  services.libinput.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    nerd-fonts.jetbrains-mono
  ];
  services.xserver.updateDbusEnvironment = true;
  # Wayland environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    GDK_BACKEND = "wayland";
  };
}
