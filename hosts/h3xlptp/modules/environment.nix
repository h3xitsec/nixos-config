{
  pkgs,
  lib,
  config,
  ...
}: let
  # Import shared packages
  sharedPackages = import ../../../lib/shared/packages.nix { inherit pkgs; };
in {
  environment = {
    systemPackages = 
      # Use all shared packages
      sharedPackages.all
      # Add XPS15-specific hardware packages
      ++ (with pkgs; [
        tpm2-tss  # TPM2 support for hardware security
      ]);
    # System packages list for reference
    etc."current-system-packages".text = let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
      formatted;

    # Make /etc/hosts root writable
    etc.hosts.mode = "0644";

    # Add ~/.local/bin to sessions path
    localBinInPath = true;

    # PAM configuration with reduced fail delay
    etc."login.defs".text = lib.mkForce ''
      DEFAULT_HOME yes
      ENCRYPT_METHOD YESCRYPT
      GID_MAX 29999
      GID_MIN 1000
      SYS_GID_MAX 999
      SYS_GID_MIN 400
      SYS_UID_MAX 999
      SYS_UID_MIN 400
      TTYGROUP tty
      TTYPERM 0620
      UID_MAX 29999
      UID_MIN 1000
      UMASK 077
      FAIL_DELAY 1
    '';
  };
}