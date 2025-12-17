{
  config,
  pkgs,
  ...
}: let
  shellAliases = {
    vim = "nvim";
    s = "kitten ssh";
    ape = "source venv/bin/activate";
    kalict = "incus exec kalict -- su --login h3x";
    df = "duf";
  };
  starshipCmd = "${pkgs.starship}/bin/starship";
  lang = icon: color: {
    symbol = icon;
    format = "[$symbol ](${color})";
  };
  os = icon: fg: "[${icon} ](fg:${fg})";
  pad = {
    left = "";
    right = "";
  };
in {
  # Modern CLI tools
  home.packages = with pkgs; [
    bat
    eza
    ripgrep
    ncdu
    duf
    fd
    httpie
    fzf
  ];

  programs = {
    # Direnv for development environments
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Zsh configuration
    zsh = {
      inherit shellAliases;
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
        {
        name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
        name = "powerlevel10k-config";
          src = ./files/p10k;
          file = "p10k.zsh";
        }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "history"];
        theme = "robbyrussell";
      };
      initContent = ''
        SHELL=${pkgs.zsh}/bin/zsh
        zstyle ':completion:*' menu select
        bindkey  "^[[H"   beginning-of-line
        bindkey  "^[[F"   end-of-line
        bindkey  "^[[3~"  delete-char
        unsetopt BEEP
        # eval "$(${starshipCmd} init zsh)"
      '';
    };

    # Bash configuration
    bash = {
      inherit shellAliases;
      enable = true;
      initExtra = ''
        SHELL=${pkgs.bash}/bin/bash
        #eval "$(${starshipCmd} init bash)"
      '';
    };

    # # Starship prompt
    # starship = {
    #   enable = true;
    #   settings = {
    #     add_newline = true;
    #     format = builtins.concatStringsSep "" [
    #       "$username"
    #       "$os"
    #       "$hostname"
    #       "$directory"
    #       "$python"
    #       "$nodejs"
    #       "$lua"
    #       "$rust"
    #       "$java"
    #       "$c"
    #       "$golang"
    #       "$git_status"
    #       "$git_branch $git_status"
    #       "$time"
    #       "$cmd_duration"
    #       "$status"
    #       "$line_break"
    #       "$nix_shell"
    #       "$character"
    #     ];
    #     continuation_prompt = "∙  ┆ ";
    #     line_break = {disabled = false;};
    #     status = {
    #       symbol = "";
    #       not_found_symbol = "󰍉 Not Found";
    #       not_executable_symbol = " Can't Execute E";
    #       sigint_symbol = "󰂭 ";
    #       signal_symbol = "󱑽 ";
    #       success_symbol = "";
    #       format = "[$symbol](fg:red)";
    #       map_symbol = true;
    #       disabled = false;
    #     };
    #     username = {
    #       format = "[$user]($style) on ";
    #       show_always = true;
    #       style_root = "bold red";
    #     };
    #     hostname = {
    #       disabled = false;
    #       format = "[$hostname]($style) in ";
    #       ssh_only = false;
    #       trim_at = "-";
    #     };
    #     cmd_duration = {
    #       min_time = 1000;
    #       format = "[$duration ](fg:yellow)";
    #     };
    #     nix_shell = {
    #       disabled = false;
    #       format = "[${pad.left}](fg:white)[ ](bg:white fg:black)[${pad.right}](fg:white) ";
    #     };
    #     container = {
    #       symbol = " 󰏖";
    #       format = "[$symbol ](yellow dimmed)";
    #     };
    #     directory = {
    #       truncate_to_repo = true;
    #       truncation_length = 0;
    #       truncation_symbol = "repo: ";
    #     };
    #     git_branch = {
    #       symbol = "";
    #       format = "[ $symbol $branch](fg:purple)(:$remote_branch)";
    #     };
    #     git_status = {
    #       ahead = "⇡$count";
    #       behind = "⇣$count";
    #       deleted = "x";
    #       diverged = "⇕⇡$ahead_count⇣$behind_count";
    #     };
    #     time = {
    #       disabled = true;
    #       format = " 🕙 $time($style)\n";
    #       style = "bright-white";
    #       time_format = "%T";
    #     };
    #     os = {
    #       disabled = false;
    #       format = "$symbol";
    #     };
    #     os.symbols = {
    #       Arch = os "" "bright-blue";
    #       Debian = os "" "red)";
    #       EndeavourOS = os "" "purple";
    #       Fedora = os "" "blue";
    #       NixOS = os "" "blue";
    #       openSUSE = os "" "green";
    #       SUSE = os "" "green";
    #       Ubuntu = os "" "bright-purple";
    #       Macos = os "" "white";
    #     };
    #     python = {
    #       symbol = "";
    #       format = "[ $symbol $version env:($virtualenv) ](fg:yellow)";
    #       style = "bold yellow";
    #       disabled = false;
    #     };
    #     nodejs = lang " " "yellow";
    #     lua = lang "󰢱" "blue";
    #     rust = lang "" "red";
    #     java = lang "" "red";
    #     c = lang "" "blue";
    #     golang = lang "" "blue";
    #   };
    # };
  };
}
