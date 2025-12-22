{
  pkgs,
  username,
  ...
}: {
  users = {
    #defaultUserShell = pkgs.zsh;
    mutableUsers = true;
    groups = {
      h3x = {};
    };
    users = {
      "h3x" = {
        uid = 1000;
        createHome = true;
        isNormalUser = true;
        description = "h3x";
        group = "h3x";
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
          "docker"
          "input"
          "plugdev"
          "power"
        ];
      };
    };
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=30
    # Allow Cursor to run sudo commands without password
    %wheel ALL=(ALL:ALL) NOPASSWD: ALL
    Defaults !requiretty
    Defaults env_keep += "CURSOR_* ELECTRON_* VSCODE_* DISPLAY XAUTHORITY"
  '';

  # Add container-specific security settings
  security.unprivilegedUsernsClone = true;
  security.allowUserNamespaces = true;
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 0;
  boot.kernelParams = ["systemd.unified_cgroup_hierarchy=1" "cgroup_no_v1=all"];
}
