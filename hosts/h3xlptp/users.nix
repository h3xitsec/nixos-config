{
  pkgs,
  lib,
  config,
  username,
  ...
}: let
  # Import the shared user creation function
  mkUser = import ../../lib/shared/users.nix {inherit pkgs lib username;};

  # Use shared user creation function with XPS15-specific groups
  userConfig = mkUser {
    username = username;
    description = username;
    uid = 1000;
    extraGroups = [
      "docker" # Docker support
      "power" # Power management
    ];
    isNixOS = true;
  };
in {
  # Define option to enable sudo NOPASSWD (default: false for security)
  options.security.sudoNoPasswd = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable NOPASSWD for wheel group (less secure, but convenient)";
  };

  config = lib.mkMerge [
    {
      users.mutableUsers = true;
    }
    userConfig
    {
      # Sudo configuration - NOPASSWD optional for security
      security.sudo.extraConfig = ''
        # Extended timeout for convenience
        Defaults timestamp_timeout=30
        # Allow wheel group full access (NOPASSWD only if enabled)
        ${lib.optionalString config.security.sudoNoPasswd "%wheel ALL=(ALL:ALL) NOPASSWD: ALL"}
        Defaults !requiretty
        # Preserve environment variables for development tools
        Defaults env_keep += "CURSOR_* ELECTRON_* VSCODE_* DISPLAY XAUTHORITY"
      '';

      # Container-specific security settings
      security.unprivilegedUsernsClone = true;
      security.allowUserNamespaces = true;
      boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
      boot.kernel.sysctl."kernel.yama.ptrace_scope" = 0;
      boot.kernelParams = ["systemd.unified_cgroup_hierarchy=1" "cgroup_no_v1=all"];
    }
  ];
}
