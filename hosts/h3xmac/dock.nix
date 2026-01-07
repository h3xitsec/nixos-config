{
  pkgs,
  username,
  ...
}: {
  system.defaults.dock = {
    autohide = false;
    orientation = "bottom";
    show-process-indicators = false;
    show-recents = false;
    persistent-apps = [
      "/System/Applications/System Settings.app"
      "/System/Cryptexes/App/System/Applications/Safari.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Facetime.app"
      "/System/Applications/Messages.app"
      "/Users/${username}/Applications/Home Manager Apps/Discord.app"
      "/System/Applications/Music.app"
      "/System/Applications/TV.app"
      "/Applications/Nix Apps/iTerm2.app"
      "/Users/${username}/Applications/Home Manager Apps/Visual Studio Code.app"
      "/Applications/BambuStudio.app"
      "/Applications/Caido.app"
      "/Applications/1Password.app"
      "/Users/${username}/Applications/Autodesk Fusion.app"
    ];
  };
}
