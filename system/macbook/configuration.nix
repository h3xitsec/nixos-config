{ pkgs, ... }:
{
      environment.systemPackages  = with pkgs; [
            vim
            vscode
            discord
      ];
      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = "nix-command flakes";
      nix.settings.substituters = [ "https://cache.nixos.org" ];
      nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      #system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
}
