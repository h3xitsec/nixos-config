{
  ...
}: {

  # Copy custom scripts to profile
  home.file."Wallpapers" = {
    source = ../assets/wallpapers;
    recursive = true;
  };
}