{
  config,
  pkgs,
  ...
}: {
  # Modern CLI tools
  programs.yazi = {
    enable = true;
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
  };
}
