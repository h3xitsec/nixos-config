{
  config,
  lib,
  ...
}: {
  # Symlink the Stylix VSCode extension to Cursor's extensions directory
  # This reuses the same themed extension that Stylix generates for VSCode
  home.file.".cursor/extensions/stylix.stylix" = lib.mkIf config.stylix.targets.vscode.enable {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.vscode/extensions/stylix.stylix";
  };
}
