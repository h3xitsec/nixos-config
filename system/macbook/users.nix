{
  pkgs,
  lib,
  ...
}: 
let
  # Import the shared user creation function
  mkUser = import ../../lib/shared/users.nix { inherit pkgs lib; };
  
  # Use shared user creation function for Darwin
  userConfig = mkUser {
    username = "h3x";
    description = "h3x";
    isNixOS = false;
  };
in
{
  users = userConfig;
}
