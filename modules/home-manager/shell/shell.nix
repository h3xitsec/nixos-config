{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Modern CLI tools
  programs.yazi = {
    enable = true;
  };
  programs.fd = {
    enable = true;
    hidden = true; # Search hidden files/directories
    ignores = [".git/" "*.bak"]; # Add default ignore patterns
  };
  home.packages = with pkgs; [
    eza
    ncdu
    duf
    grc
    fzf
    devenv
    # (devenv.overrideAttrs (prev: rec {
    #   version = "2.0.4";
    #   src = pkgs.fetchFromGitHub {
    #     inherit (prev.src) owner repo;
    #     tag = "v2.0.4";
    #     hash = "sha256-1DpF5F7zgOZ7QrRjz23315pUoF532dHnsU/V4UQithk=";
    #   };
    # }))
    #inputs.devenv.packages.${pkgs.system}.devenv
  ];

  programs = {
    # Direnv for development environments
    # Enable direnv only on Linux
    direnv = pkgs.lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      nix-direnv.enable = true;
    };

    # Bash configuration
    bash = {
      enable = true;
      shellAliases = import ./aliases.nix;
      initExtra = ''
        SHELL=${pkgs.bash}/bin/bash
      '';
    };
    fish = {
      enable = true;
      shellAliases = import ./aliases.nix;
      interactiveShellInit = ''
        set SHELL ${pkgs.fish}/bin/fish
        set -g fish_greeting # Disable greeting
      '';
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "fish-fzf";
          src = pkgs.fishPlugins.fzf.src;
        }
      ];
    };
  };
}
