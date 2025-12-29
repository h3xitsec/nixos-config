
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obsidian
  ];


  fileSystems."/home/h3x/Obsidian" = {
    device = "/mnt/data/user-dirs/Documents/obsidian";
    options = [ "bind" ];
  };

}