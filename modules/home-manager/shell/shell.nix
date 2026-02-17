{
  config,
  pkgs,
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
  ];

  programs = {
    # Direnv for development environments
    direnv = {
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
      '';
    };
  };
}
