{
  pkgs,
  inputs,
  config,
  ...
}: {
  home = {
    stateVersion = "25.11";
    username = "h3x";

    # Modern CLI tools (shared with XPS15)
    packages = with pkgs; [
      bat
      eza
      ripgrep
      ncdu
      duf
      fd
      httpie
      fzf
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
