{
  pkgs,
  ...
}:
{
  # NIXVIM
  programs.nixvim = {
    enable = true;

    colorschemes.dracula.enable = true;
    plugins.lualine.enable = true;
    opts = {
      number = true;         # Show line numbers
      shiftwidth = 2;        # Tab width should be 2
    };
  };
  programs.zsh.shellAliases = {
      vim = "nvim";
    };
}