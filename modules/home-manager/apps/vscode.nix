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
    .${
      vscodePname
    };
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
in {
  # Mutability module is imported in flake.nix (./modules/home-manager/mutability.nix)

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
      # Use mkForce to override Stylix's font settings with our custom font stack
      "editor.fontFamily" = lib.mkForce "'M+1Code Nerd Font','Droid Sans Mono', 'monospace', monospace, 'JetBrainsMono Nerd Font'";
      "terminal.integrated.fontFamily" = lib.mkForce "'JetBrainsMono Nerd Font'";
      "explorer.confirmDelete" = false;
      "window.titleBarStyle" = "custom";
      "window.commandCenter" = true;
      "window.autoDetectColorScheme" = true;
      "editor.renderLineHighlight" = "none";
      "workbench.iconTheme" = null;
      "workbench.tree.indent" = 12;
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "terminal.integrated.defaultProfile.linux" = "zsh";
    };
    profiles.default.keybindings = [
      {
        key = "f8";
        command = "workbench.action.terminal.runSelectedText";
      }
    ];
  };
}
