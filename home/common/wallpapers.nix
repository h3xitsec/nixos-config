{
  ...
}: {

  # Copy custom scripts to profile
  xdg.configFile."wallpapers" = {
    source = ./files/wallpapers;
    recursive = true;
  };
}