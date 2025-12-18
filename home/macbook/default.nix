{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/apps/vscode.nix
    ../common/apps/git.nix
  ];
  home = {
    stateVersion = "25.11";
  };
  
}