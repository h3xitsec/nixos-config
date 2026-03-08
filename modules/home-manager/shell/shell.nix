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
    inputs.devenv.packages.${pkgs.system}.devenv
    # (import (fetchTarball {
    #   url = "https://install.devenv.sh/latest";
    #   sha256 = "1i0b5k8cxw12cwjy77w52jadah00f9ihzn9h21kyf40zh0p2piyz";
    # })).devenv
  ];

  programs = {
    # Direnv for development environments
    # direnv = {
    #   enable = true;
    #   nix-direnv.enable = true;
    # };

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
