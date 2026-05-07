{
  pkgs,
  ...
}: let
  # Workaround for nixpkgs PR #510748 (caido-desktop: fix exec in desktop file).
  # Remove once the PR is merged and nixpkgs input is updated.
  #
  # appimageTools.wrapType2 uses a custom buildCommand; postFixup is not run, so
  # patch like nixpkgs PR #510748 by appending after the inlined install commands.
  caido-desktop = pkgs.caido-desktop.overrideAttrs (old: {
    buildCommand =
      old.buildCommand
      + ''
        substituteInPlace $out/share/applications/caido.desktop \
          --replace-fail "Exec=AppRun --no-sandbox %U" "Exec=caido-desktop %U"
      '';
  });
in {
  home.packages = [caido-desktop];
}
