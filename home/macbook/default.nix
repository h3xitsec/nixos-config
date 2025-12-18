{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/apps/vscode.nix
    ../common/apps/git.nix
    ../common/apps/zsh.nix
    ../common/wallpapers.nix
  ];
  home = {
    stateVersion = "25.11";
  };
  
}