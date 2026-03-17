{
  pkgs,
  config,
  ...
}: {
  programs.openclaw = {
    # Don't use `enable = true` — it creates a fallback default instance
    # that's missing appDefaults.nixMode. Use explicit instances instead.
    documents = ./documents;
    

    # Explicit instance — goes through the submodule type system
    # and gets all defaults (including appDefaults.nixMode)
    instances.default = {
      enable = true;
      package = pkgs.openclaw; # batteries-included
      stateDir = "~/.openclaw";
      workspaceDir = "~/.openclaw/workspace";
      launchd.enable = true;
      gatewayPort = 18789;
      config = {
        gateway = {
          mode = "local";
          auth = {
            mode = "none"; # Local only, no auth needed
          };
        };
        channels.telegram = {
          tokenFile = "~/.secrets/telegram-bot-token";
          allowFrom = [
            7122874379         # you (DM)
          ];
          groups = {

          };
        };

        # Configure Ollama as the LLM provider
        models = {
          providers = {
            ollama = {
              api = "ollama";
              baseUrl = "http://localhost:11434";
              apiKey = "ollama-local";
              models = [
                {
                  id = "llama3.2:3b"; # Change to your preferred model
                  name = "Llama3.2 3B";
                  contextWindow = 131072;
                }
              ];
            };
          };
        };
        # Set the default model to your Ollama model
        agents = {
          defaults = {
            model = "ollama/llama3.2:3b"; # Format: provider/model
          };
        };
      };
      # Plugins (prod: pinned GitHub). Built-ins are via nix-steipete-tools.
      # MVP target: repo pointers resolve to tools + skills automatically.
      plugins = [];
    };

    # Disable launchd service if you want to start manually
    # launchd.enable = false;
  };
}
