{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}: {
  programs.obsidian = {
    enable = true;

    vaults = {
      obsidian = {
        enable = true;
        target = "Obsidian";
      };
    };
  };
}
