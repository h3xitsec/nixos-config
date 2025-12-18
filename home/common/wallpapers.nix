{
  ...
}: {

  # Copy custom scripts to profile
  home.file."Pictures/Wallpapers" = {
    source = ./files/wallpapers;
    recursive = true;
  };
}