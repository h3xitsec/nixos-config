{ pkgs, ... }:

{
  home.packages = with pkgs; [
    sbarlua
    lua
    sketchybar
  ];
  home.file."./.config/sketchybar/" = {
    source = ./config;
    recursive = true;
  };
}
