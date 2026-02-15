# Shared shell aliases for zsh and bash.
# In shell.nix:  programs.bash.shellAliases = import ./aliases.nix;
# In zsh.nix:    programs.zsh.shellAliases = import ./aliases.nix;
{
  ls = "eza";
  df = "duf";
  du = "ncdu";
  vim = "nvim";
  # lt = "eza --tree";
  # g = "git";
}
