{
  pkgs,
  config,
  ...
}: {
  imports = [];
  # Enable DankMaterialShell
  programs.dank-material-shell = {
    enable = true;
    enableDynamicTheming = true;
    default.settings = {
      theme = "dark";
      dynamicTheming = true;
    };
    niri = {
      enableKeybinds = false;   # Automatic keybinding configuration
      enableSpawn = true;      # Auto-start DMS with niri
    };
  };

  ## Niri Settings
  programs.niri.settings.prefer-no-csd = true;
  # Outputs
  programs.niri.settings.outputs."eDP-1" = {
    scale = 1.5;
  };
  # Inputs
  programs.niri.settings.input = {
    focus-follows-mouse.enable = true;
    focus-follows-mouse.max-scroll-amount = "5%";
    touchpad = {
      dwt = true;
      tap = true;
      natural-scroll = true;
    };
  };
  # Cursors - theme is managed by Stylix
  # programs.niri.settings.cursor = {
  #   theme = "capitaine-cursors";
  # };
  # Window Rules
  programs.niri.settings.window-rules = [
    {
      geometry-corner-radius = {
        top-left = 12.0;
        top-right = 12.0;
        bottom-left = 12.0;
        bottom-right = 12.0;
      };
      clip-to-geometry = true;
    }
  ];
  # Layout
  programs.niri.settings.layout = {
    gaps = 10;
    background-color = "transparent";
    always-center-single-column = true;
    center-focused-column = "never";
    default-column-width = { proportion = 1. / 2.; };
    preset-column-widths = [
      { proportion = 1. / 3.; }
      { proportion = 1. / 2.; }
      { proportion = 2. / 3.; }
    ];
    preset-window-heights = [
      { proportion = 1. / 3.; }
      { proportion = 1. / 2.; }
      { proportion = 2. / 3.; }
      { proportion = 1. / 1.; }
    ];
    # Focus ring and border colors are now managed by Stylix
    # Uncomment below to override Stylix colors with custom values
    focus-ring = {
      width = 2;
      # active.color = "#7fc8ff";
      # inactive.color = "#505050";
    };
    border = {
      width = 3;
      # active.color = "#d8dee9";
      # inactive.color = "#434c5e";
      # urgent.color = "#bf616a";
    };
  };
  # Hotkey overlay
  programs.niri.settings.hotkey-overlay = {
    hide-not-bound = true;
    skip-at-startup = true;
  };
  # Debug
  programs.niri.settings.debug = {
    render-drm-device = "/dev/dri/renderD128";
  };
  # Bindings
  programs.niri.settings.binds = with config.lib.niri.actions; {
    # App
    "Mod+D".action.spawn = [ "dms" "ipc" "call" "spotlight" "toggle" ];
    "Mod+D".hotkey-overlay.title = "Open App Launcher";
    "Mod+T".action.spawn = "kitty";
    "Mod+T".hotkey-overlay.title = "Open Terminal";
    "Mod+F1".action.spawn = "firefox";
    "Mod+F1".hotkey-overlay.title = "Open Browser";
    "Mod+F2".action.spawn = "nautilus";
    "Mod+F2".hotkey-overlay.title = "Open File Manager";
    # Workspace focus
    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+4".action.focus-workspace = 4;
    # Move window to workspace
    "Mod+Shift+1".action.move-window-to-workspace = 1;
    "Mod+Shift+2".action.move-window-to-workspace = 2;
    "Mod+Shift+3".action.move-window-to-workspace = 3;
    "Mod+Shift+4".action.move-window-to-workspace = 4;
    # Column and window focus
    "Mod+Left".action = focus-column-left;
    "Mod+WheelScrollDown".action = focus-column-left;
    "Mod+Right".action = focus-column-right;
    "Mod+WheelScrollUp".action = focus-column-right;
    "Mod+Up".action = focus-window-up;
    "Mod+Down".action = focus-window-down;
    # Column placement
    "Mod+Shift+Left".action = move-column-left;
    "Mod+Shift+Right".action = move-column-right;
    # Expel
    "Mod+Period".action = consume-or-expel-window-left;
    "Mod+Comma".action = consume-or-expel-window-right;
    "Mod+Ctrl+Left".action = consume-window-into-column;
    "Mod+Ctrl+Right".action = expel-window-from-column;
    # Column and window sizing
    "Mod+F".action = maximize-column;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+Alt+Left".action.set-column-width = "-5%";
    "Mod+Alt+Right".action.set-column-width = "+5%";
    "Mod+Alt+Up".action.set-window-height = "+5%";
    "Mod+Alt+Down".action.set-window-height = "-5%";
    "Mod+R".action = switch-preset-column-width;
    "Mod+Shift+R".action = switch-preset-window-height;
    # Misc
    "Mod+Shift+O".action = show-hotkey-overlay;
    "Mod+Q".action = close-window;
    "Mod+Shift+Q".action.spawn = [ "dms" "ipc" "call" "powermenu" "toggle" ];
    "Mod+Shift+Q".hotkey-overlay.title = "Open Powermenu";
    "Mod+Tab".action = toggle-overview;
    "Mod+Tab".repeat = false;
    "Mod+L".action.spawn = [ "dms" "ipc" "call" "lock" "lock" ];
    "Mod+L".hotkey-overlay.title = "Lock session";
    "Mod+Shift+S".action.spawn = [ "~/.config/scripts/screenshot.sh" ];
    "Mod+Shift+S".hotkey-overlay.title = "Screenshot: screen region";
    # Multimedia using DMS IPC calls
    "XF86AudioRaiseVolume".action.spawn = [ "dms" "ipc" "call" "audio" "increment" "3" ];
    "XF86AudioLowerVolume".action.spawn = [ "dms" "ipc" "call" "audio" "decrement" "3" ];
    "XF86AudioMute".action.spawn = [ "dms" "ipc" "call" "audio" "mute" ];
    "XF86MonBrightnessUp".action.spawn = [ "dms" "ipc" "call" "brightness" "increment" "5" "backlight:intel_backlight" ];
    "XF86MonBrightnessDown".action.spawn = [ "dms" "ipc" "call" "brightness" "decrement" "5" "backlight:intel_backlight" ];

  };
  # Environment
  programs.niri.settings.environment = {
    XDG_CURRENT_DESKTOP = "niri";
    QT_QPA_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
  };
  home.packages = with pkgs; [
    nautilus
    wl-clipboard
    grim
    slurp
    satty
    wlr-randr
    networkmanagerapplet
    capitaine-cursors
  ];
  
}
