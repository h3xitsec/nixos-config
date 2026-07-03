{
  pkgs,
  username,
  ...
}: {
  home = {
    stateVersion = "26.05";
    username = username;

    packages = with pkgs; [
      code-cursor
      # caffeine
      # telegram-desktop
      wireshark
      unrar
      protonmail-desktop
      nil
    ];
  };

  programs = {
    # Nix index for command-not-found
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };
}
