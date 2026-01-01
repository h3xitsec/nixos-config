{
  pkgs,
  ...
}: {
  programs.dconf.enable = true;

  # Enable AppImage support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  #zsh
  programs.zsh.enable = true;

  # nix-ld for running non-NixOS binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libfprint-2-tod1-goodix
  ];
}