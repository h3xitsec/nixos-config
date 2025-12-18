{
  ...
}: {

  # Copy custom scripts to profile
  home.file."Wallpapers" = {
    source = ./files/wallpapers;
    recursive = true;
  };
}