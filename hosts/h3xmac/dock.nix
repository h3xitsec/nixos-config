{username, ...}: {
  system.defaults.dock = {
    autohide = false;
    orientation = "bottom";
    tilesize = 36;
    show-process-indicators = false;
    largesize = 48;
    magnification = true;
    show-recents = false;
    persistent-apps = [
      "/System/Applications/System Settings.app"
      "/System/Cryptexes/App/System/Applications/Safari.app"
      "/System/Applications/Mail.app"
      "/Users/${username}/Applications/Home Manager Apps/Proton Mail.app"
      "/Applications/Claude.app"
      "/System/Applications/Facetime.app"
      "/System/Applications/Messages.app"
      #"/Users/${username}/Applications/Home Manager Apps/Discord.app"
      "/System/Applications/Music.app"
      "/System/Applications/TV.app"
      "/Applications/Ghostty.app"
      "/Users/${username}/Applications/Home Manager Apps/Visual Studio Code.app"
      "/Users/${username}/Applications/Home Manager Apps/Cursor.app"
      "/Users/${username}/Applications/Home Manager Apps/Headlamp.app"
      "/Applications/BambuStudio.app"
      "/Applications/Caido.app"
      "/Applications/1Password.app"
      "/Users/${username}/Applications/Autodesk Fusion.app"
      "/Applications/Blender.app"
      "/System/Applications/Notes.app"
      "/Applications/Obsidian.app"
      "/Applications/GitHub Desktop.app"
    ];
  };
}
