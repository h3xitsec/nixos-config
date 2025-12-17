{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/apps/git.nix
  ];
  home = {
    stateVersion = "25.11";
  };
}