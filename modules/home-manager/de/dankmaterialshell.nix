{
  config,
  lib,
  pkgs,
  ...
}: {
  # Define custom options to expose DMS commands for use in other modules
  options.programs.dank-material-shell.commands = {
    launcher = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["dms" "ipc" "call" "spotlight" "toggle"];
      description = "Command to open the launcher";
    };
    lock = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["dms" "ipc" "call" "lock" "lock"];
      description = "Command to lock the session";
    };
    powerMenu = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["dms" "ipc" "call" "powermenu" "toggle"];
      description = "Command to open power menu";
    };
    audio = {
      raise = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["dms" "ipc" "call" "audio" "increment" "3"];
        description = "Command to raise audio volume";
      };
      lower = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["dms" "ipc" "call" "audio" "decrement" "3"];
        description = "Command to lower audio volume";
      };
      mute = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["dms" "ipc" "call" "audio" "mute"];
        description = "Command to mute audio";
      };
    };
    brightness = {
      raise = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["dms" "ipc" "call" "brightness" "increment" "5" "backlight:intel_backlight"];
        description = "Command to raise brightness";
      };
      lower = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["dms" "ipc" "call" "brightness" "decrement" "5" "backlight:intel_backlight"];
        description = "Command to lower brightness";
      };
    };
  };

  config = let
    # Import Stylix colors - these are the base16 colors from your palette
    # Catppuccin Mocha palette mapping
    colors = config.lib.stylix.colors;

    # Create DMS custom theme JSON from Stylix palette
    dmsTheme = builtins.toJSON {
      dark = {
        name = "Stylix Catppuccin";

        # Primary colors - using base0D (blue)
        primary = "#${colors.base0D}";
        primaryText = "#${colors.base00}";
        primaryContainer = "#${colors.base02}";
        primaryContainerText = "#${colors.base0D}";

        # Secondary colors - using base0E (purple/mauve)
        secondary = "#${colors.base0E}";
        secondaryText = "#${colors.base00}";
        secondaryContainer = "#${colors.base02}";
        secondaryContainerText = "#${colors.base0E}";

        # Tertiary colors - using base0C (teal)
        tertiary = "#${colors.base0C}";
        tertiaryText = "#${colors.base00}";
        tertiaryContainer = "#${colors.base02}";
        tertiaryContainerText = "#${colors.base0C}";

        # Surface colors
        surface = "#${colors.base00}";
        surfaceText = "#${colors.base05}";
        surfaceVariant = "#${colors.base01}";
        surfaceVariantText = "#${colors.base04}";
        surfaceTint = "#${colors.base0D}";
        surfaceContainer = "#${colors.base01}";
        surfaceContainerLow = "#${colors.base00}";
        surfaceContainerLowest = "#${colors.base00}";
        surfaceContainerHigh = "#${colors.base02}";
        surfaceContainerHighest = "#${colors.base03}";

        # Background
        background = "#${colors.base00}";
        backgroundText = "#${colors.base05}";

        # Outline/borders
        outline = "#${colors.base03}";
        outlineVariant = "#${colors.base02}";

        # Status colors
        error = "#${colors.base08}";
        errorText = "#${colors.base00}";
        errorContainer = "#${colors.base01}";
        errorContainerText = "#${colors.base08}";

        warning = "#${colors.base09}";
        warningText = "#${colors.base00}";
        warningContainer = "#${colors.base01}";
        warningContainerText = "#${colors.base09}";

        info = "#${colors.base0A}";
        infoText = "#${colors.base00}";
        infoContainer = "#${colors.base01}";
        infoContainerText = "#${colors.base0A}";

        success = "#${colors.base0B}";
        successText = "#${colors.base00}";
        successContainer = "#${colors.base01}";
        successContainerText = "#${colors.base0B}";

        # Inverse colors
        inverseSurface = "#${colors.base05}";
        inverseSurfaceText = "#${colors.base00}";
        inversePrimary = "#${colors.base0D}";

        # Shadow and scrim
        shadow = "#000000";
        scrim = "#000000";

        # Matugen type for dynamic color generation
        matugen_type = "scheme-fidelity";
      };

      # Light variant (optional - maps inverted colors)
      light = {
        name = "Stylix Catppuccin Light";

        # Primary colors
        primary = "#${colors.base0D}";
        primaryText = "#${colors.base07}";
        primaryContainer = "#${colors.base0D}";
        primaryContainerText = "#${colors.base00}";

        # Secondary colors
        secondary = "#${colors.base0E}";
        secondaryText = "#${colors.base07}";
        secondaryContainer = "#${colors.base0E}";
        secondaryContainerText = "#${colors.base00}";

        # Tertiary colors
        tertiary = "#${colors.base0C}";
        tertiaryText = "#${colors.base07}";
        tertiaryContainer = "#${colors.base0C}";
        tertiaryContainerText = "#${colors.base00}";

        # Surface colors (inverted for light mode)
        surface = "#${colors.base06}";
        surfaceText = "#${colors.base00}";
        surfaceVariant = "#${colors.base05}";
        surfaceVariantText = "#${colors.base02}";
        surfaceTint = "#${colors.base0D}";
        surfaceContainer = "#${colors.base05}";
        surfaceContainerLow = "#${colors.base06}";
        surfaceContainerLowest = "#${colors.base07}";
        surfaceContainerHigh = "#${colors.base04}";
        surfaceContainerHighest = "#${colors.base03}";

        # Background
        background = "#${colors.base06}";
        backgroundText = "#${colors.base00}";

        # Outline/borders
        outline = "#${colors.base03}";
        outlineVariant = "#${colors.base04}";

        # Status colors
        error = "#${colors.base08}";
        errorText = "#${colors.base07}";
        errorContainer = "#${colors.base08}";
        errorContainerText = "#${colors.base00}";

        warning = "#${colors.base09}";
        warningText = "#${colors.base07}";
        warningContainer = "#${colors.base09}";
        warningContainerText = "#${colors.base00}";

        info = "#${colors.base0A}";
        infoText = "#${colors.base00}";
        infoContainer = "#${colors.base0A}";
        infoContainerText = "#${colors.base00}";

        success = "#${colors.base0B}";
        successText = "#${colors.base07}";
        successContainer = "#${colors.base0B}";
        successContainerText = "#${colors.base00}";

        # Inverse colors
        inverseSurface = "#${colors.base01}";
        inverseSurfaceText = "#${colors.base05}";
        inversePrimary = "#${colors.base0D}";

        # Shadow and scrim
        shadow = "#000000";
        scrim = "#000000";

        matugen_type = "scheme-fidelity";
      };
    };

    # dank16 ANSI color palette for terminals - mapped from Stylix
    dank16Palette = builtins.toJSON {
      color0 = "#${colors.base00}"; # black (background)
      color1 = "#${colors.base08}"; # red
      color2 = "#${colors.base0B}"; # green
      color3 = "#${colors.base0A}"; # yellow
      color4 = "#${colors.base0D}"; # blue
      color5 = "#${colors.base0E}"; # magenta/purple
      color6 = "#${colors.base0C}"; # cyan
      color7 = "#${colors.base05}"; # white (foreground)
      color8 = "#${colors.base03}"; # bright black
      color9 = "#${colors.base08}"; # bright red
      color10 = "#${colors.base0B}"; # bright green
      color11 = "#${colors.base0A}"; # bright yellow
      color12 = "#${colors.base0D}"; # bright blue
      color13 = "#${colors.base0E}"; # bright magenta
      color14 = "#${colors.base0C}"; # bright cyan
      color15 = "#${colors.base07}"; # bright white
    };
  in {
    programs.dank-material-shell = {
      enable = true;
      enableDynamicTheming = true;
      niri = {
        enableKeybinds = false; # Automatic keybinding configuration
        enableSpawn = true; # Auto-start DMS with niri
      };
    };
    # Place custom DMS theme in config directory
    xdg.configFile."DankMaterialShell/themes/stylix.json" = {
      text = dmsTheme;
    };

    # Override dank16 palette with Stylix colors (optional - for terminal theming)
    xdg.configFile."DankMaterialShell/dank16-override.json" = {
      text = dank16Palette;
    };
  };
}
