# FHS (Filesystem Hierarchy Standard) environment for running non-NixOS binaries
{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
}

