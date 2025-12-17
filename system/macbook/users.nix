{
  pkgs,
  ...
}: {
  users = {
    mutableUsers = true;
    users = {
      "h3x" = {
        isNormalUser = true;
        description = "h3x";
      };
    };
  };
}
