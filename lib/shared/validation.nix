# Configuration validation and assertions
{ lib, config, ... }:
{
  # Validate that essential nix settings are properly configured
  assertions = [
    {
      assertion = config.nix.settings.experimental-features != null;
      message = "Nix experimental features must be enabled for flakes support";
    }
    {
      assertion = config.nix.settings.auto-optimise-store == true;
      message = "Auto store optimization should be enabled for better disk usage";
    }
    {
      assertion = lib.length config.nix.settings.substituters > 0;
      message = "At least one binary cache substituter should be configured";
    }
    {
      assertion = config.nixpkgs.config.allowUnfree == true;
      message = "allowUnfree should be enabled for proprietary software support";
    }
  ];

  # Warnings for suboptimal configurations
  warnings = lib.optionals (config.nix.settings.cores == 0) [
    "Using all CPU cores for Nix builds may impact system responsiveness"
  ] ++ lib.optionals (config.nix.gc.automatic == false) [
    "Automatic garbage collection is disabled - consider enabling for disk space management"
  ];
}