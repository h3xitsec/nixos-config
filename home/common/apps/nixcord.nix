{ pkgs, ... }: {
  programs.nixcord = {
    enable = true;          # Enable Nixcord (It also installs Discord)
    discord = {
      vencord.enable = true;  # Use Vencord (default)
    };
    vesktop.enable = false;  # Vesktop
    equibop.enable = false;  # Equibop
    dorion.enable = false;   # Dorion
    config = {
      useQuickCss = true;   # use out quickCSS
      frameless = true;                   # Set some Vencord/Equicord options
      plugins = {};
    };
  };
}