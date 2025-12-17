{pkgs, ...}: {
  home.sessionVariables.BROWSER = "firefox";

  programs.chromium = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = with builtins; let
        extension = shortId: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
      in
        listToAttrs [
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "pwnfox" "PwnFox@bi.tk")
          (extension "1password-x-password-manager" "{d634138d-c276-4fc8-924b-40a0ea21d284}")
        ];
    };
  };
}
