{pkgs, ...}: {
  # Stylix now handles GTK, Qt, cursor, and color themes automatically
  # This file contains only settings that Stylix doesn't manage

  # Stylix targets - enable/disable theming for specific applications
  # See: https://stylix.danth.me/options/hm.html for all available targets
  stylix.targets = {
    nixvim.enable = true;
    kitty.enable = true; # Terminal
    tmux = {
      enable = true;
      colors.enable = true;
    };
    nixcord.enable = true; # Nixcord
    nixcord.fonts.enable = true;
    firefox = {
      enable = true;
      profileNames = ["h3xit"];
      colorTheme.enable = true;
    };
    vscode.enable = true; # VSCode
    gtk.enable = true; # Already enabled by default
    qt.enable = true; # Qt
    obsidian = {
      enable = true;
      vaultNames = ["obsidian"];
    };
    gnome.enable = true; # Gnome
    yazi.enable = true; # Yazi file manager
    k9s = {
      enable = true; # K9s Kubernetes dashboard
      colors.enable = true;
    };
    dank-material-shell.enable = false;
    # niri.enable = true;        # Automatically imported by niri-flake
  };

  # Use dconf to set color scheme for libadwaita/GTK4 apps
  # (Stylix sets this, but we keep it for explicit dark mode preference)
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Icon theme (Stylix doesn't manage icons)
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Force overwrite existing GTK config files that Stylix now manages
  # xdg.configFile."gtk-3.0/gtk.css".force = true;
  # xdg.configFile."gtk-4.0/gtk.css".force = true;

  # Qt theming is fully managed by Stylix (uses qtct)
}
