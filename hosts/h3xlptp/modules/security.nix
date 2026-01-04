{...}: {
  security.rtkit.enable = true;

  # Polkit
  security.polkit.enable = true;

  # Sudo configuration
  security.sudo.wheelNeedsPassword = false;

  # Kernel security
  security.protectKernelImage = true;
  security.allowSimultaneousMultithreading = true;

  # AppArmor (disabled)
  security.apparmor.enable = false;
}
