{pkgs, ...}: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    taps = [];
    brews = [];
    casks = [
      "caido"
      "1password"
      "logi-options+"
      "autodesk-fusion"
      "parsec"
      "bambu-studio"
      "github"
      "microsoft-office"
    ];
  };
}
