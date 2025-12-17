{ pkgs, config, ... }:

let
  # Create the desktop item
  caidoDesktopItem = pkgs.makeDesktopItem {
    name = "caido"; # Internal Nix name for the derivation
    desktopName = "Caido"; # Name displayed in the application menu
    exec = "${pkgs.caido}/bin/caido"; # Command to execute the application
    comment = "Lightweight web security auditing toolkit";
    # You can specify an icon, e.g., icon = "${pkgs.gnome.adwaita-icon-theme}/share/icons/gnome/scalable/apps/custom-app.svg";
    icon = "${config.xdg.dataHome}/icons/caido.png";
    terminal = false; 
    categories = [ "Utility" "Application" ]; 
  };

in {
  home.packages = with pkgs; [ caido caidoDesktopItem ];
}