{
  config,
  pkgs,
  ...
}: {
  
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


    # Bash configuration
    bash = {
      enable = true;
      initExtra = ''
        SHELL=${pkgs.bash}/bin/bash
      '';
    };

  };
}
