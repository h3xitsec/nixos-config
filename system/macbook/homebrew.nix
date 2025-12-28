{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    taps = [];
    brews = [];
    casks = [
      "caffeine"
      "caido"
      "1password"
      "logi-options+"
      "autodesk-fusion"
      "parsec"
      "bambu-studio"
      "github"
    ];
  };
}