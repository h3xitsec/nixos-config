# NixOS Configuration

This repository contains a NixOS configuration for:
- **Dell XPS 15 Laptop** (h3xlptp) - Linux/NixOS with Niri compositor
- **MacBook Air M4** (h3xmac) - macOS/nix-darwin

## Structure

```
.
├── flake.nix                    # Main flake entry point
├── flake.lock                   # Locked flake inputs
├── overlays.nix                 # Package overlays
├── lib/                         # Library functions and shared modules
│   ├── default.nix             # Library entry point
│   ├── builders/               # System builders
│   │   ├── darwin.nix         # Darwin/macOS builder
│   │   └── nixos.nix          # NixOS builder
│   └── shared/                 # Shared configuration
│       ├── nix-settings.nix   # Nix settings (caches, GC, etc.)
│       ├── packages.nix       # Shared package definitions
│       ├── users.nix          # User management
│       └── validation.nix     # Validation utilities
├── hosts/                       # Host-specific configurations
│   ├── h3xlptp/               # Dell XPS 15 (NixOS)
│   │   ├── configuration.nix  # Main system config
│   │   ├── hardware.nix       # Hardware settings
│   │   ├── home.nix           # Home-manager config
│   │   ├── users.nix          # User accounts
│   │   └── modules/           # Host-specific NixOS modules
│   │       ├── boot.nix       # Boot configuration
│   │       ├── environment.nix
│   │       ├── networking.nix # Network & firewall
│   │       ├── programs.nix
│   │       ├── security.nix   # Security settings
│   │       └── services.nix
│   └── h3xmac/                # MacBook Air M4 (nix-darwin)
│       ├── configuration.nix  # Main system config
│       ├── dock.nix           # Dock configuration
│       ├── home.nix           # Home-manager config
│       ├── homebrew.nix       # Homebrew packages
│       └── users.nix          # User accounts
└── modules/                     # Reusable modules
    ├── home-manager/           # Home-manager modules
    │   ├── apps/              # Application configurations
    │   │   ├── browsers.nix   # Firefox, Chromium, etc.
    │   │   ├── caido.nix      # Caido web security tool
    │   │   ├── headlamp.nix   # Kubernetes dashboard
    │   │   ├── misc.nix       # Miscellaneous apps
    │   │   ├── nixcord.nix    # Discord via Nixcord
    │   │   ├── obsidian.nix   # Obsidian notes
    │   │   ├── terminal.nix   # Terminal emulators
    │   │   └── vscode.nix     # VS Code configuration
    │   ├── assets/            # Static assets
    │   │   ├── icons/         # Custom application icons
    │   │   ├── p10k/          # Powerlevel10k config
    │   │   ├── scripts/       # Custom scripts
    │   │   └── wallpapers/    # Desktop wallpapers
    │   ├── de/                # Desktop environment
    │   │   ├── niri.nix       # Niri compositor config
    │   │   ├── noctalia.nix   # Noctalia theme
    │   │   ├── theme.nix      # GTK/Qt theming
    │   │   └── wallpapers.nix # Wallpaper management
    │   └── shell/             # Shell configuration
    │       ├── common-session-variables.nix
    │       ├── fhs-env.nix    # FHS environment for binaries
    │       ├── git.nix        # Git configuration
    │       ├── nixvim.nix     # Neovim via Nixvim
    │       ├── session-variables.nix
    │       ├── shell.nix      # General shell settings
    │       ├── tmux.nix       # Tmux configuration
    │       └── zsh.nix        # Zsh configuration
    └── nixos/                  # NixOS-specific modules
        ├── apps/              # System applications
        │   ├── 1password.nix  # 1Password integration
        │   ├── docker.nix     # Docker configuration
        │   ├── libvirtd-virtmanager.nix  # Virtualization
        │   └── obsidian.nix   # Obsidian (system-level)
        ├── de/                # Desktop environment
        │   ├── niri.nix       # Niri system configuration
        │   └── stylix.nix     # Stylix theming
        └── hardware/          # Hardware configuration
            └── nvidia.nix     # NVIDIA GPU settings
```

## Key Features

### Shared Configuration
- **Library Functions**: Centralized builders and shared modules in `lib/`
- **Packages**: Shared package definitions in `lib/shared/packages.nix`
- **Nix Settings**: Optimized binary caches, GC, and build settings in `lib/shared/nix-settings.nix`
- **Reusable Modules**: Common home-manager modules shared across hosts

### h3xlptp (Dell XPS 15)
- **Niri Compositor**: Scrollable tiling Wayland compositor
- **NVIDIA GPU**: Hybrid graphics with PRIME offload
- **Stylix Theming**: System-wide consistent theming
- **Wayland/NVIDIA**: Proper session variables for NVIDIA on Wayland
- **FHS Environment**: For running non-NixOS binaries
- **Docker & Virtualization**: Docker and libvirtd/virt-manager
- **Hardware-specific**: Dell XPS 15-9520 support via nixos-hardware
- **XDG Directories**: User directories mapped to `/mnt/data`

### h3xmac (MacBook Air M4)
- **Homebrew Integration**: Fully declarative via nix-homebrew
- **macOS Defaults**: Finder, login window, and system preferences
- **Dock Configuration**: Declarative dock management
- **Touch ID**: Touch ID for sudo authentication
- **Rosetta 2**: Intel binary support via Rosetta

## System-Specific Values

### h3xlptp Hardware Configuration
The following values in `hosts/h3xlptp/hardware.nix` are system-specific and should be updated for your installation:

- **Disk UUIDs**: Update the UUIDs in `fileSystems` sections:
  - Root filesystem UUID (BTRFS with `@` subvolume)
  - Home filesystem UUID (BTRFS with `@home` subvolume)
  - Boot partition UUID (EFI)
  - Data partition UUID (`/mnt/data`)

- **Network Interface**: Update `hosts/h3xlptp/modules/networking.nix` with your actual network interface name if different

### Security Options

#### CPU Mitigations
By default, CPU security mitigations are **enabled** for security. To disable them for performance (SECURITY RISK), set in `hosts/h3xlptp/hardware.nix`:
```nix
hardware.disableMitigations = true;
```

## Building

### h3xlptp (NixOS)
```bash
sudo nixos-rebuild switch --flake .#h3xlptp
```

### h3xmac (nix-darwin)
```bash
darwin-rebuild switch --flake .#h3xmac
```

## Updating

Update all flake inputs:
```bash
nix flake update
```

Update specific input:
```bash
nix flake update nixpkgs
```

## Binary Caches

The configuration uses multiple binary caches for faster builds:
- `cache.nixos.org` - Official NixOS cache
- `nix-community.cachix.org` - Community cache
- `niri.cachix.org` - Niri compositor cache
- `nixpkgs-wayland.cachix.org` - Wayland packages cache

## Garbage Collection

Automatic GC runs weekly and deletes packages older than 14 days, freeing up to 10GB of space.

## Flake Inputs

Key flake inputs used in this configuration:
- **nixpkgs** - NixOS unstable
- **home-manager** - User environment management
- **nix-darwin** - macOS system configuration
- **nix-homebrew** - Declarative Homebrew management
- **nixos-hardware** - Hardware-specific optimizations
- **niri** - Niri compositor flake
- **stylix** - System-wide theming
- **nixvim** - Neovim configuration
- **nixcord** - Discord client

## License

This configuration is for personal use. Individual packages may have their own licenses.
