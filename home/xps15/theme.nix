{pkgs, ...}: {
  # Use dconf to set color scheme for libadwaita/GTK4 apps
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Install theme packages (GTK3 needs gnome-themes-extra for Adwaita-dark)
  home.packages = [ pkgs.gnome-themes-extra ];

  gtk = {
    enable = true;
    # Don't set gtk.theme - it writes to both GTK3 and GTK4 configs,
    # but gnome-themes-extra has no GTK4 themes (GTK4 uses built-in Adwaita)
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    # GTK3: set theme and dark preference
    gtk3.extraConfig = {
      gtk-theme-name = "Adwaita-dark";
      gtk-application-prefer-dark-theme = true;
    };
    # GTK4: uses built-in Adwaita + color-scheme from dconf for dark mode
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
