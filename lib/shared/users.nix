# Shared user management patterns and templates
# This file exports mkUser as a function that can be imported
{
  pkgs,
  lib,
  username,
}: let
  # Helper function to create a user configuration
  mkUser = {
    username ? username,
    description ? username,
    uid ? null,
    extraGroups ? [],
    isNixOS ? true,
    ...
  }: let
    # Base groups that should be available on most systems
    baseGroups =
      if isNixOS
      then [
        "wheel"
        "networkmanager"
      ]
      else [];

    # Additional groups for development and system access
    devGroups =
      if isNixOS
      then [
        "video"
        "input"
        "plugdev"
      ]
      else [];

    allGroups = baseGroups ++ devGroups ++ extraGroups;

    # Build user config conditionally
    userAttrs =
      if isNixOS
      then
        {
          inherit description;
          shell = "${pkgs.fish}/bin/fish";
          createHome = true;
          extraGroups = allGroups;
          isNormalUser = true;
          group = username;
        }
        // (
          if uid != null
          then {inherit uid;}
          else {}
        )
      else {
        inherit description;
        shell = "${pkgs.fish}";
        home = "/Users/${username}";
      };

    # Build groups conditionally
    groupsAttrs =
      if isNixOS
      then {
        ${username} = {};
      }
      else {};
  in {
    users.users.${username} = userAttrs;
    users.groups = groupsAttrs;
  };
in
  mkUser
