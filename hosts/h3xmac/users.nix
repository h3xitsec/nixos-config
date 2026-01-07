{
  pkgs,
  lib,
  username,
  ...
}: let
  # Import the shared user creation function
  mkUser = import ../../lib/shared/users.nix {inherit pkgs lib username;};

  # Use shared user creation function for Darwin
  userConfig = mkUser {
    username = username;
    description = username;
    isNixOS = false;
  };
in
  userConfig
