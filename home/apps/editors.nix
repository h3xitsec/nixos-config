{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.vscode;
  vscodePname = cfg.package.pname;
  configDir =
    {
      "vscode" = "Code";
      "vscode-insiders" = "Code - Insiders";
      "vscodium" = "VSCodium";
    }
    .${vscodePname};
  userDir = "${config.xdg.configHome}/${configDir}/User";
  configFilePath = "${userDir}/settings.json";
  tasksFilePath = "${userDir}/tasks.json";
  keybindingsFilePath = "${userDir}/keybindings.json";
  snippetDir = "${userDir}/snippets";
  pathsToMakeWritable = lib.flatten [
    (lib.optional (cfg.profiles.default.userTasks != {}) tasksFilePath)
    (lib.optional (cfg.profiles.default.userSettings != {}) configFilePath)
    (lib.optional (cfg.profiles.default.keybindings != []) keybindingsFilePath)
    (lib.optional (cfg.profiles.default.globalSnippets != {})
      "${snippetDir}/global.code-snippets")
    (lib.mapAttrsToList (language: _: "${snippetDir}/${language}.json")
      cfg.profiles.default.languageSnippets)
  ];
  cursorConfigDir = ".config/Cursor";
  cursorUserDir = "${cursorConfigDir}/User";
  emptyJson = "{}";
in {
  imports = [
    (import (builtins.fetchurl {
      url = "https://gist.githubusercontent.com/h3xitsec/b5922a7c727e0bfd74c56a35b379f837/raw/03301ebc807b2fd20cd8aeaabd9b2c7847fc9132/mutability.nix";
      sha256 = "1lfqs0ccqmqq2kikpn2wwi5gn6vryk15jscq5dm9f91h6x1yi83l";
    }) {inherit config lib;})
  ];

  # NIXVIM
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };

  # VSCODE
  programs.vscode = {
    enable = true;
    profiles.default.enableUpdateCheck = true;
    package = pkgs.vscode;
    profiles.default.enableExtensionUpdateCheck = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      mads-hartmann.bash-ide-vscode
      oderwat.indent-rainbow
      ms-vscode-remote.remote-ssh
      ms-azuretools.vscode-docker
      hashicorp.terraform
    ];
    profiles.default.userSettings = {
      "editor.fontFamily" = "'M+1Code Nerd Font','Droid Sans Mono', 'monospace', monospace, 'JetBrainsMono Nerd Font'";
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
      "explorer.confirmDelete" = false;
      "window.titleBarStyle" = "custom";
      "window.commandCenter" = true;
      "window.autoDetectColorScheme" = true;
      "editor.renderLineHighlight" = "none";
      "workbench.iconTheme" = null;
      "workbench.tree.indent" = 12;
      "git.enableSmartCommit" = true;
    };
    profiles.default.keybindings = [
      {
        key = "f8";
        command = "workbench.action.terminal.runSelectedText";
      }
    ];
  };

  # CURSOR IDE
  home.packages = [];

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
