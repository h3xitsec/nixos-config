{pkgs, inputs, ...}: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    masApps = {
      "Locally AI - Local AI Chat" = 6741426692;
      "Tailscale" = 1475387142;
      "1Password for Safari" = 1569813296;
      "Pages" = 409201541;
    };
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
      "obsidian"
      "ollama-app"
      "docker-desktop"
      "google-earth-pro"
      "macshot"
    ];
  };
}
