# NixOS Configuration

This repository contains a NixOS configuration for:
- **Dell XPS 15 Laptop** (h3xlptp) - Linux/NixOS
- **MacBook Air M4** (h3xmac) - macOS/nix-darwin

## Structure

```
.
├── flake.nix                 # Main flake entry point
├── overlays.nix              # Package overlays
├── lib/                      # Shared library modules
│   ├── builders/            # System builders (NixOS/Darwin)
│   └── shared/              # Shared configuration modules
│       ├── nix-settings.nix    # Nix settings (caches, GC, etc.)
│       ├── packages.nix         # Shared package definitions
│       └── users.nix            # Shared user management
├── system/                   # System-specific configurations
│   ├── xps15/               # Dell XPS 15 configuration
│   │   ├── configuration.nix   # Main system config
│   │   ├── hardware.nix        # Hardware-specific settings
│   │   ├── boot.nix            # Boot configuration
│   │   ├── networking.nix      # Network & firewall
│   │   ├── nvidia.nix          # NVIDIA GPU configuration
│   │   ├── power.nix           # Power management (TLP)
│   │   ├── audio.nix           # Audio configuration
│   │   ├── security.nix        # Security settings
│   │   ├── users.nix           # User accounts
│   │   ├── packages.nix        # System packages
│   │   └── ...
│   └── macbook/             # MacBook Air M4 configuration
│       ├── configuration.nix   # Main system config
│       └── users.nix           # User accounts
└── home/                     # Home Manager configurations
    ├── common/              # Shared home manager modules
    │   ├── apps/            # Common applications
    │   │   ├── git.nix
    │   │   ├── vscode.nix
    │   │   └── zsh.nix
    │   ├── session-variables.nix  # Shared environment variables
    │   └── wallpapers.nix
    ├── xps15/               # XPS15-specific home config
    │   ├── default.nix
    │   ├── shell.nix
    │   ├── session-variables.nix  # Wayland/NVIDIA variables
    │   └── apps/            # XPS15-specific apps
    └── macbook/             # MacBook-specific home config
        └── default.nix
```

## Key Features

### Shared Configuration
- **Packages**: Centralized package definitions in `lib/shared/packages.nix`
- **Users**: Shared user management patterns in `lib/shared/users.nix`
- **Nix Settings**: Optimized binary caches, GC, and build settings

### XPS15-Specific
- NVIDIA GPU with PRIME offload
- TLP power management
- Wayland/NVIDIA session variables
- FHS environment for non-NixOS binaries
- Hardware-specific kernel parameters

### MacBook-Specific
- Homebrew integration via nix-homebrew
- macOS system defaults
- Touch ID for sudo

## System-Specific Values

### XPS15 Hardware Configuration
The following values in `system/xps15/hardware.nix` are system-specific and should be updated for your installation:

- **Disk UUIDs**: Update the UUIDs in `fileSystems` sections:
  - Root filesystem UUID
  - Boot partition UUID
  - Data partition UUID

- **Network Interface**: Update `networking.nix` with your actual network interface name if different from `wlp0s20f3`

### Security Options

#### CPU Mitigations
By default, CPU security mitigations are **enabled** for security. To disable them for performance (SECURITY RISK), set in `system/xps15/hardware.nix`:
```nix
hardware.disableMitigations = true;
```

#### Sudo NOPASSWD
By default, sudo requires a password. To enable NOPASSWD for convenience (less secure), set in `system/xps15/users.nix`:
```nix
security.sudoNoPasswd = true;
```

## Building

### XPS15 (NixOS)
```bash
sudo nixos-rebuild switch --flake .#h3xlptp
```

### MacBook (nix-darwin)
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

## License

This configuration is for personal use. Individual packages may have their own licenses.

