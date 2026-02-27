# nix-darwin Configuration

This directory contains the nix-darwin configuration for managing macOS system settings.

## Available Profiles

| Profile | File | Purpose |
|---------|------|---------|
| `#personal` | personal.nix | Full personal setup (imports shared.nix) |
| `#mini` | mini.nix | Mac mini server (imports shared.nix) |
| `#chasehost` | chasehost.nix | Chase work host machine |
| `#air` | air.nix | MacBook Air portable setup |
| `#chasevm` | chasevm.nix | Chase virtual machines |

### Personal Profile
Full app suite for personal machine including:
- **Window Manager:** AeroSpace (auto-starts via launchd)
- **Development:** Ghostty, Cursor, Visual Studio Code, **OrbStack** (lightweight Docker alternative)
- **Productivity:** Alfred, Raycast, 1Password, Obsidian, Things
- **Media:** Plex, Plexamp, IINA, ScreenFlow
- **Communication:** Slack, Discord, Telegram, Signal
- **Utilities:** Hammerspoon, Hazel, Keyboard Maestro, CleanShot, Espanso (text expander, auto-starts via launchd)
- Plus many specialized tools and Mac App Store apps

### Mini Profile
Minimal server/utility setup for Mac mini including:
- **Window Manager:** AeroSpace (auto-starts via launchd)
- **Core Apps:** Ghostty, 1Password
- **CLI Tools:** gh, mas
- **Remote Access:** Tailscale (Mac App Store)
- **Dock:** Ghostty only

### Chase Host Profile
Work machine with productivity apps for the Chase host macOS.

### Air Profile
Minimal portable setup for MacBook Air.

### Chase VM Profile
Minimal work-focused setup for Chase virtual machines:
- **Window Manager:** AeroSpace (auto-starts via launchd)
- **Core Apps:** Ghostty, Visual Studio Code, Slack, Google Chrome
- **Tools:** 1Password, Syncthing
- **Dock:** Ghostty, Slack, Chrome

## Quick Reference

### Apply Configuration Changes

Use `darwin-switch` function to interactively select and apply a profile, or run directly:

```bash
# Personal machine
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#personal

# Mac mini
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#mini

# Chase host
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#chasehost

# MacBook Air
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#air

# Chase VM
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#chasevm
```

### View Changes Without Applying
```bash
sudo darwin-rebuild build --flake ~/dev/shedali/nix-darwin#personal
```

### Check Configuration
```bash
nix flake check ~/dev/shedali/nix-darwin
```

## Initial Setup (New System)

### Option 1: Bootstrap Script (Recommended)
One command that automatically handles everything:
- Installs Determinate Nix (if not already installed)
- Backs up existing shell configs
- Installs nix-darwin with chosen profile

```bash
# Personal machine
curl -fsSL https://raw.githubusercontent.com/shedali/nix-darwin/main/bootstrap.sh | bash -s -- personal

# Chase VM
curl -fsSL https://raw.githubusercontent.com/shedali/nix-darwin/main/bootstrap.sh | bash -s -- chasevm

# Mac mini
curl -fsSL https://raw.githubusercontent.com/shedali/nix-darwin/main/bootstrap.sh | bash -s -- mini
```

### Option 2: Manual Install
```bash
# Backup existing shell configs (if they exist) - ONLY NEEDED ONCE
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin 2>/dev/null || true
sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin 2>/dev/null || true
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin 2>/dev/null || true

# Bootstrap nix-darwin and apply config from GitHub
sudo nix run nix-darwin -- switch --flake github:shedali/nix-darwin#personal
```

### Option 3: Local Install (For Customization)
```bash
# Clone the repository
git clone https://github.com/shedali/nix-darwin.git ~/dev/shedali/nix-darwin

# Backup existing shell configs (if they exist)
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin 2>/dev/null || true
sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin 2>/dev/null || true
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin 2>/dev/null || true

# Bootstrap nix-darwin and apply config
sudo nix run nix-darwin -- switch --flake ~/dev/shedali/nix-darwin#personal
```

## Important Configuration Details

### Determinate Nix
This system uses Determinate Nix, which has its own daemon. Therefore:
- `nix.enable = false;` is set in the configuration
- Nix settings managed by Determinate, not nix-darwin
- Cannot use `nix.*` options in the configuration

### Primary User
- Set to `franz` in `system.primaryUser`
- Required for user-specific settings (dock, finder, screenshots, etc.)

### Homebrew Management
- Managed via `nix-homebrew` module
- Configured per profile in `*.nix` files
- `onActivation.cleanup = "zap"` removes unlisted apps
  - **Important:** Apps removed from config will be automatically uninstalled
  - This includes both casks and Mac App Store apps
  - Zap also removes associated preference files and caches

### Integration with home-manager
- **nix-darwin**: System-level config, app installation, system settings
- **home-manager**: User-level config, dotfiles, application configs
- **AeroSpace config**: `.aerospace.toml` is symlinked by home-manager
- **Avoid duplication**: Don't install same app in both systems
  - Example: Install AeroSpace via nix-darwin cask, not home-manager package
  - Exception: Config files belong in home-manager even if app is in nix-darwin

### Current Settings
- **Dock**: autohide disabled, profile-specific persistent apps
- **Finder**: path bar and status bar enabled
- **Screenshots**: saved to `~/Pictures/Screenshots`

### AeroSpace Window Manager
All profiles include AeroSpace (i3-like tiling window manager):
- **Installation**: Via Homebrew cask from `nikitabobko/tap`
- **Auto-start**: Configured via launchd agent (launches on login)
- **Configuration**: `.aerospace.toml` managed by home-manager
- **Logs**:
  - `/tmp/aerospace.out.log` (standard output)
  - `/tmp/aerospace.err.log` (error output)

To restart AeroSpace after config changes:
```bash
# Kill current instance (will auto-restart via launchd)
killall AeroSpace
```

## File Structure

```
~/dev/shedali/nix-darwin/
├── flake.nix          # Main configuration file
├── flake.lock         # Locked dependency versions
├── bootstrap.sh       # Automated installation script
├── shared.nix         # Shared configuration (imported by personal, mini)
├── personal.nix       # Personal profile configuration
├── mini.nix           # Mac mini profile configuration
├── chasehost.nix      # Chase host profile configuration
├── air.nix            # MacBook Air profile configuration
├── chasevm.nix        # Chase VM profile configuration
└── CLAUDE.md          # This file
```

## Common Tasks

### Restart Dock (to see changes immediately)
```bash
killall Dock
```

### Test Screenshot Location
Take a screenshot with `Cmd+Shift+3` or `Cmd+Shift+4`

### Update Dependencies
```bash
nix flake update ~/dev/shedali/nix-darwin
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#personal
```

### View Available Options
Search for nix-darwin options:
```bash
darwin-option -l
```

Check specific option value:
```bash
darwin-option system.defaults.dock.autohide
```

## Troubleshooting

### "Unexpected files in /etc" Error
Backup existing files by adding `.before-nix-darwin` suffix:
```bash
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin
```

### "file 'darwin' was not found" Error
Use the system-installed `darwin-rebuild` instead of `nix run`:
```bash
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin
```

### Changes Not Taking Effect
Some settings require:
- Opening a new Finder window (finder settings)
- Restarting Dock: `killall Dock` (dock settings)
- Logging out/in or restarting (rare, but sometimes needed)

## Resources

- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/index.html)
- [nix-darwin Options Search](https://daiderd.com/nix-darwin/manual/index.html#sec-options)
- [nix-darwin GitHub](https://github.com/LnL7/nix-darwin)
