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
      code-cursor
      caffeine
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
