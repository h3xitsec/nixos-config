{
  pkgs,
  config,
  ...
}: {
  stylix = {
    enable = true;

    # Wallpaper image - colors will be generated from this
    # Change this path to use a different wallpaper
    # image = ../../home/common/files/wallpapers/2.jpeg;

    # Use dark theme (options: "dark", "light", "either")
    polarity = "dark";

    # OPTION: Use a predefined base16 scheme instead of wallpaper-generated colors
    # Uncomment the line below and comment out `image` above to use a specific scheme
    # Popular schemes: "gruvbox-dark-medium", "nord", "tokyo-night-dark",
    #                  "catppuccin-mocha", "dracula", "one-dark"
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    # OR: Keep the wallpaper but override colors with a specific scheme
    # (uncomment this while keeping `image` above for wallpaper + custom colors)
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

    # Font configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 12;
      };
    };

    # Cursor theme
    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
    };

    # Opacity settings (0.0 to 1.0)
    opacity = {
      terminal = 0.95;
      popups = 0.95;
      desktop = 1.0;
      applications = 1.0;
    };
  };
}
