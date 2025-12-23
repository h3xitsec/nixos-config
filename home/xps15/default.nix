{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}: 
let 
	headlampApp = import ./apps/headlamp.nix { inherit pkgs; };
in {
  imports = [
    ./shell.nix
    ./apps/terminal.nix
    ./theme.nix
    ./niri.nix
    ./apps/browsers.nix
    ./apps/editors.nix
    ./apps/tmux.nix
    ./apps/misc.nix
    ./apps/caido.nix
    ./apps/fhs-env.nix
    ./session-variables.nix
    ../common/apps/vscode.nix
    ../common/apps/git.nix
    ../common/wallpapers.nix
    ../common/session-variables.nix
  ];

  # Copy custom scripts to profile
  xdg.configFile."scripts" = {
    source = ./files/scripts;
    recursive = true;
  };

  # Copy custom icons to profile
  xdg.dataFile."icons" = {
    source = ./files/icons;
    recursive = true;
  };

  # XDG user directories pointing to /mnt/data
  xdg.userDirs = {
    enable = true;
    desktop = "/mnt/data/user-dirs/Desktop";
    documents = "/mnt/data/user-dirs/Documents";
    download = "/mnt/data/user-dirs/Downloads";
    music = "/mnt/data/user-dirs/Music";
    pictures = "/mnt/data/user-dirs/Pictures";
    videos = "/mnt/data/user-dirs/Videos";
    templates = "/mnt/data/user-dirs/Templates";
    publicShare = "/mnt/data/user-dirs/Public";
  };

  # GTK bookmarks
  gtk.gtk3.bookmarks = let
    home = config.home.homeDirectory;
  in [
    "file:///mnt/data/user-dirs/Documents"
    "file:///mnt/data/user-dirs/Pictures"
    "file:///mnt/data/user-dirs/Downloads"
    "file:///mnt/data/projects Projects"
    "file://${home}/data Data"
    "file://${home}/.config Config"
    "file:///mnt/data/projects/nix NixConfig"
  ];

  home = {
    stateVersion = "25.11";
    username = "h3x";

    # Additional packages (FHS env is in ./apps/fhs-env.nix)
    packages = with pkgs; [
      headlampApp
    ];

    # Symlinks to /mnt/data
    file."data".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data";
    file."Documents".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Documents";
    file."Pictures".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Pictures";
    file."Music".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Music";
    file."Templates".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Templates";
    file."Videos".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Videos";
    file."Downloads".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Downloads";

    # Session variables are now in ./session-variables.nix and ../common/session-variables.nix
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nix index for command-not-found
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
