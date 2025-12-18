# Shared user management patterns and templates
{ pkgs, lib, ... }:
{
  # Common user template function
  mkUser = {
    username ? "h3x",
    description ? "h3x", 
    uid ? null,
    extraGroups ? [],
    isNixOS ? true,
    ...
  }: 
  let
    # Base groups that should be available on most systems
    baseGroups = if isNixOS then [
      "wheel"
      "networkmanager"
    ] else [];
    
    # Additional groups for development and system access
    devGroups = if isNixOS then [
      "video"
      "input"
      "plugdev"
    ] else [];
    
    allGroups = baseGroups ++ devGroups ++ extraGroups;
  in
  {
    users.users.${username} = lib.mkMerge [
      # Common configuration for all platforms
      {
        inherit description;
        createHome = true;
        extraGroups = allGroups;
      }
      
      # NixOS-specific configuration
      (lib.mkIf isNixOS {
        isNormalUser = true;
        group = username;
        uid = lib.mkIf (uid != null) uid;
      })
      
      # Darwin-specific configuration  
      (lib.mkIf (!isNixOS) {
        home = "/Users/${username}";
      })
    ];
    
    # Create user group on NixOS
    users.groups = lib.mkIf isNixOS {
      ${username} = {};
    };
  };

  # Common sudo configuration for development
  sudoConfig = {
    security.sudo.extraConfig = ''
      # Extended timeout for convenience
      Defaults timestamp_timeout=30
      # Allow wheel group full access
      %wheel ALL=(ALL:ALL) NOPASSWD: ALL
      Defaults !requiretty
      # Preserve environment variables for development tools
      Defaults env_keep += "CURSOR_* ELECTRON_* VSCODE_* DISPLAY XAUTHORITY"
    '';
  };
}