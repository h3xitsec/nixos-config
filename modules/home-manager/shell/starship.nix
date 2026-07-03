{pkgs, ...}: let
  starshipCmd = "${pkgs.starship}/bin/starship";
  lang = icon: color: {
    symbol = icon;
    format = "[$symbol ](${color})";
  };
  os = icon: fg: "[${icon} ](fg:${fg})";
  pad = {
    left = "";
    right = "";
  };
in {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = builtins.concatStringsSep "" [
        "$username"
        "$os"
        "$hostname"
        "$directory"
        "$python"
        "$nodejs"
        "$lua"
        "$rust"
        "$java"
        "$c"
        "$golang"
        "$git_status"
        "$git_branch $git_status"
        "$time"
        "$cmd_duration"
        "$status"
        "$line_break"
        "$nix_shell"
        "$character"
        #''''${custom.space}''
      ];
      custom.space = {
        when = ''! test $env'';
        format = " ";
      };
      continuation_prompt = "∙  ┆ ";
      line_break = {disabled = false;};
      status = {
        symbol = "";
        not_found_symbol = "󰍉 Not Found";
        not_executable_symbol = " Can't Execute E";
        sigint_symbol = "󰂭 ";
        signal_symbol = "󱑽 ";
        success_symbol = "";
        format = "[$symbol](fg:red)";
        map_symbol = true;
        disabled = false;
      };
      username = {
        format = "[$user]($style) on ";
        show_always = true;
        style_root = "bold red";
      };
      hostname = {
        disabled = false;
        format = "[$hostname]($style) in ";
        ssh_only = false;
        trim_at = "-";
      };
      cmd_duration = {
        min_time = 1000;
        format = "[$duration ](fg:yellow)";
      };
      nix_shell = {
        disabled = false;
        format = "[${pad.left}](fg:white)[ ](bg:white fg:black)[${pad.right}](fg:white) ";
      };
      container = {
        symbol = " 󰏖";
        format = "[$symbol ](yellow dimmed)";
      };
      directory = {
        truncate_to_repo = true;
        truncation_length = 0;
        truncation_symbol = "repo: ";
      };
      git_branch = {
        symbol = "";
        format = "[ $symbol $branch](fg:purple)(:$remote_branch)";
      };
      git_status = {
        ahead = "⇡$count";
        behind = "⇣$count";
        deleted = "x";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
      };
      time = {
        disabled = true;
        format = " 🕙 $time($style)\n";
        style = "bright-white";
        time_format = "%T";
      };
      # character = {
      #   error_symbol = "[❱](bold red)";
      #   success_symbol = "[❱](#${config.theme.colorScheme.palette.base0A})";
      # };
      os = {
        disabled = false;
        format = "$symbol";
      };
      os.symbols = {
        Arch = os "" "bright-blue";
        Debian = os "" "red)";
        EndeavourOS = os "" "purple";
        Fedora = os "" "blue";
        NixOS = os "" "blue";
        openSUSE = os "" "green";
        SUSE = os "" "green";
        Ubuntu = os "" "bright-purple";
        Macos = os "" "white";
      };
      python = {
        symbol = "";
        format = "[ $symbol $version env:($virtualenv) ](fg:yellow)";
        style = "bold yellow";
        disabled = false;
      };
      nodejs = lang " " "yellow";
      lua = lang "󰢱" "blue";
      rust = lang "" "red";
      java = lang "" "red";
      c = lang "" "blue";
      golang = lang "" "blue";
    };
  };
  programs.bash.initExtra = ''
    eval "$(${starshipCmd} init bash)"
  '';
  programs.zsh.initContent = ''
    eval "$(${starshipCmd} init zsh)"
  '';
  programs.fish.interactiveShellInit = ''
    eval "$(${starshipCmd} init fish)"
  '';
}
