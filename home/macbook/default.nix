{
  pkgs,
  ...
}: {
  imports = [
    ../common/apps/vscode.nix
    ../common/apps/git.nix
  ];
}