{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}: {
  imports = [
    ./shell.nix
    ./apps/terminal.nix
    ./apps/git.nix
    ./theme.nix
    ./niri.nix
    ./apps/browsers.nix
    ./apps/editors.nix
    ./apps/tmux.nix
    ./apps/misc.nix
    ./apps/caido.nix
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

    # Generic FHS environment
    packages = with pkgs; [
      (pkgs.buildFHSEnv {
        name = "fhs";
        targetPkgs = pkgs:
          with pkgs; [
            curl
            dbus
            expat
            file
            fontconfig
            freetype
            libdrm
            libva
            fuse
            glib
            gtk3
            libGL
            libnotify
            libxml2
            libxslt
            netcat
            nspr
            nss
            openjdk8
            openssl.dev
            pango
            pkg-config
            strace
            udev
            vulkan-loader
            watch
            wget
            which
            xorg.libX11
            xorg.libxcb
            xorg.libXcomposite
            xorg.libXcursor
            xorg.libXdamage
            xorg.libXext
            xorg.libXfixes
            xorg.libXi
            xorg.libXrandr
            xorg.libXrender
            xorg.libXScrnSaver
            xorg.libxshmfence
            xorg.libXtst
            xorg.xcbutilkeysyms
            zlib
            fontconfig.lib
            xorg.libXinerama
            gst_all_1.gstreamer
            xorg.libXft
            libpng
            gst_all_1.gst-plugins-base
          ];
        profile = ''export FHS=1'';
        runScript = "bash";
      })
    ];

    # Symlinks to /mnt/data
    file."data".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data";
    file."Documents".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Documents";
    file."Pictures".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Pictures";
    file."Music".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Music";
    file."Templates".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Templates";
    file."Videos".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Videos";
    file."Downloads".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/user-dirs/Downloads";

    # Session variables for Wayland/NVIDIA
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_RECONNECT = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "0";
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      WLR_DRM_NO_ATOMIC = "1";
    };

    # Session PATH additions
    sessionPath = [
      "$HOME/.local/share/go/bin"
      "$HOME/.pdtm/go/bin"
    ];
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nix index for command-not-found
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
