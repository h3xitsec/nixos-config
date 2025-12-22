{pkgs, lib, ...}:
let
  # Import shared packages
  sharedPackages = import ../../lib/shared/packages.nix { inherit pkgs; };
in
{
  environment.systemPackages = 
    # Use all shared packages
    sharedPackages.all
    # Add XPS15-specific hardware packages
    ++ (with pkgs; [
      tpm2-tss  # TPM2 support for hardware security
    ]);
}
