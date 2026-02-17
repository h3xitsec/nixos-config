{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    settings = {
      background = "#282a36";
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      font_family = "JetBrainsMono Nerd Font";
      font_size = 13;
      cursor_shape = "Underline";
      cursor_underline_thickness = 1;
      window_padding_width = 10;
      url_style = "curly";
      confirm_os_window_close = "0";
      remember_window_size = "no";
      disable_ligatures = "never";
      shell = "${pkgs.fish}/bin/fish";
      initial_window_width = 1200;
      initial_window_height = 600;
      map = let
        mappings = [];
      in (builtins.concatStringsSep "\nmap " mappings);
    };
  };
}
