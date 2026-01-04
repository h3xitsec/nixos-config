# Shared session variables for home manager
{config, ...}: {
  # Common session variables used across systems
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    NIXPKGS_ALLOW_INSECURE = "1";
    GOPATH = "${config.home.homeDirectory}/.local/share/go";
    GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
  };

  # Common session PATH additions
  home.sessionPath = [
    "$HOME/.local/share/go/bin"
    "$HOME/.pdtm/go/bin"
  ];
}
