{
  config,
  pkgs,
  lib,
  ...
}: let
  cursorConfigDir = ".config/Cursor";
  cursorUserDir = "${cursorConfigDir}/User";
  emptyJson = "{}";
in {

  # NIXVIM
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };

  # CURSOR IDE

  home.activation.createCursorDirs = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    if [ -L "$HOME/${cursorConfigDir}" ]; then
      $DRY_RUN_CMD rm $VERBOSE_ARG "$HOME/${cursorConfigDir}"
    fi
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$HOME/${cursorUserDir}/snippets"
    $DRY_RUN_CMD chmod 700 $VERBOSE_ARG "$HOME/${cursorConfigDir}"
    $DRY_RUN_CMD find "$HOME/${cursorConfigDir}" -type d -exec $DRY_RUN_CMD chmod 700 $VERBOSE_ARG {} \;
    for file in "settings.json" "tasks.json" "keybindings.json" "snippets/global.code-snippets"; do
      target="$HOME/${cursorUserDir}/$file"
      if [ ! -e "$target" ]; then
        $DRY_RUN_CMD touch $VERBOSE_ARG "$target"
        $DRY_RUN_CMD chmod 600 $VERBOSE_ARG "$target"
      fi
    done
  '';

  home.file."${cursorUserDir}/settings.json" = {
    text = ''
      {
        "editor.fontFamily": "'M+1Code Nerd Font','Droid Sans Mono', 'monospace', monospace, 'JetBrainsMono Nerd Font'",
        "editor.renderLineHighlight": "none",
        "explorer.confirmDelete": false,
        "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font'",
        "window.autoDetectColorScheme": true,
        "window.commandCenter": true,
        "window.titleBarStyle": "custom",
        "workbench.iconTheme": null,
        "workbench.productIconTheme": "adwaita",
        "workbench.tree.indent": 12,
        "git.enableSmartCommit": true,
        "git.confirmSync": false,
        "explorer.confirmDragAndDrop": false,
        "cursor.composer.collapsePaneInputBoxPills": true,
        "cursor.chat.showSuggestedFiles": true,
        "cursor.composer.renderPillsInsteadOfBlocks": true,
        "cursor.general.gitGraphIndexing": "enabled",
        "cursor.cmdk.useThemedDiffBackground": true,
        "terminal.integrated.enableMultiLinePasteWarning": false,
        "files.watcherExclude": {
          "**/.git/objects/**": true,
          "**/.git/subtree-cache/**": true,
          "**/node_modules/*/**": true,
          "**/.hg/store/**": true,
          "**/target/**": true,
          "**/.direnv/**": true
        },
        "search.exclude": {
          "**/node_modules": true,
          "**/bower_components": true,
          "**/.git": true,
          "**/.direnv": true,
          "**/target": true
        },
        "files.exclude": {
          "**/.direnv": true,
          "**/result": true,
          "**/result-*": true
        },
        "typescript.disableAutomaticTypeAcquisition": true,
        "extensions.autoUpdate": false,
        "telemetry.telemetryLevel": "off"
      }
    '';
    force = true;
    mutable = true;
  };

  home.file."${cursorUserDir}/tasks.json" = {
    text = emptyJson;
    force = true;
    mutable = true;
  };

  home.file."${cursorUserDir}/keybindings.json" = {
    text = emptyJson;
    force = true;
    mutable = true;
  };

  home.file."${cursorUserDir}/snippets/global.code-snippets" = {
    text = emptyJson;
    force = true;
    mutable = true;
  };
}
