{
  pkgs,
  inputs,
  config,
  username,
  ...
}: {
  home = {
    stateVersion = "25.11";
    username = username;

    packages = with pkgs; [
      bat
      eza
      ripgrep
      ncdu
      duf
      fd
      httpie
      fzf
      caido
      code-cursor
    ];
  };

  programs = {
    # Direnv for development environments
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Nix index for command-not-found
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };
}
