# XPS15-specific session variables (Wayland/NVIDIA)
{config, ...}: {
  # Session variables for Wayland/NVIDIA on XPS15
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_RECONNECT = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    WLR_DRM_NO_ATOMIC = "1";
  };
}
