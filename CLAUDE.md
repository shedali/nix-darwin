# nix-darwin Configuration

This directory contains the nix-darwin configuration for managing macOS system settings.

## Available Profiles

### Personal Profile
Full app suite for personal machine including:
- **Window Manager:** AeroSpace (auto-starts via launchd)
- **Development:** Ghostty, Cursor, Visual Studio Code, **OrbStack** (lightweight Docker alternative)
- **Productivity:** Alfred, Raycast, 1Password, Obsidian, Things
- **Media:** Plex, Plexamp, IINA, ScreenFlow
- **Communication:** Slack, Discord, Telegram, Signal
- **Utilities:** Hammerspoon, Hazel, Keyboard Maestro, CleanShot
- Plus many specialized tools and Mac App Store apps

### Work Profile
Minimal work-focused setup including:
- **Window Manager:** AeroSpace (auto-starts via launchd)
- **Core Apps:** Ghostty, Visual Studio Code, Slack, Google Chrome
- **Tools:** 1Password, **Docker Desktop** (docker cask)
- **Dock:** Ghostty, Slack, Chrome
- **Note:** Uses Docker Desktop (not OrbStack) for work compatibility

### Mini Profile
Minimal server/utility setup for Mac mini including:
- **Window Manager:** AeroSpace (auto-starts via launchd)
- **Core Apps:** Ghostty, 1Password
- **CLI Tools:** gh, mas
- **Remote Access:** Tailscale (Mac App Store)
- **Dock:** Ghostty only

## Which Profile Should I Use?

Choose based on your machine's hostname (check with `scutil --get LocalHostName`):
- **Hostname: `personal`** → Use `#personal` profile
- **Hostname: `chase`** → Use `#work` profile
- **Hostname: `mini`** → Use `#mini` profile

**Important:** Each profile has a different Docker solution:
- **Personal**: OrbStack (lightweight, fast)
- **Work**: Docker Desktop (standard, enterprise-compatible)
- **Mini**: No Docker

## Initial Setup (New System)

### Option 1: Bootstrap Script (Recommended)
One command that automatically handles everything:
- Installs Determinate Nix (if not already installed)
- Backs up existing shell configs
- Installs nix-darwin with chosen profile

```bash
# Personal machine
curl -fsSL https://raw.githubusercontent.com/shedali/nix-darwin/main/bootstrap.sh | bash -s -- personal

# Work machine
curl -fsSL https://raw.githubusercontent.com/shedali/nix-darwin/main/bootstrap.sh | bash -s -- work

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

# Update the configuration with your username and hostname
cd ~/dev/shedali/nix-darwin
# Edit flake.nix: change "franz" to your username
# Edit flake.nix: change "personal" to your hostname

# Backup existing shell configs (if they exist)
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin 2>/dev/null || true
sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin 2>/dev/null || true
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin 2>/dev/null || true

# Bootstrap nix-darwin and apply config
sudo nix run nix-darwin -- switch --flake ~/dev/shedali/nix-darwin
```

### Get Your Current Hostname
```bash
scutil --get LocalHostName
```

## Quick Reference

### Apply Configuration Changes
**IMPORTANT:** Use the correct profile for your machine!

```bash
# For personal machine (hostname: personal)
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#personal

# For work machine (hostname: chase)
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#work

# For Mac mini (hostname: mini)
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#mini
```

### View Changes Without Applying
```bash
# Replace #work with #personal or #mini as appropriate
sudo darwin-rebuild build --flake ~/dev/shedali/nix-darwin#work
```

### Check Configuration
```bash
nix flake check ~/dev/shedali/nix-darwin
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
├── personal.nix       # Personal profile configuration
├── work.nix           # Work profile configuration
├── mini.nix           # Mac mini profile configuration
├── shared.nix         # Shared configuration across all profiles
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
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin
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

## Hostname
System hostname (LocalHostName): `personal`
This must match the configuration name in `flake.nix`: `darwinConfigurations."personal"`

## Recent Changes

### 2025-10-21
- Added **AeroSpace** window manager to all three profiles (personal, work, mini)
  - Installed via Homebrew cask with auto-start via launchd
  - Configuration managed by home-manager
- Removed many apps from personal profile (cleanup of unused apps)
- Created minimal **mini profile** for Mac mini
  - Only: 1Password, Ghostty, AeroSpace, Tailscale, gh, mas
- Removed Raycast from mini profile (not needed for headless use)
- Created **bootstrap script** for automated setup
- Updated documentation with current profile states

## Mac Mini Setup

One-command setup for Mac mini with the `mini` profile:

```bash
curl -fsSL https://raw.githubusercontent.com/shedali/nix-darwin/main/bootstrap.sh | bash -s -- mini
```

This single command automatically:
- Installs Determinate Nix (if not already installed)
- Backs up existing shell configs
- Installs and configures nix-darwin with the mini profile

The mini profile includes:
- **Window Manager:** AeroSpace (with auto-start)
- **GUI Apps:** 1Password, Ghostty
- **CLI Tools:** gh (GitHub CLI), mas (Mac App Store CLI)
- **Remote Access:** Tailscale (Mac App Store)
- **Dock:** Only Ghostty
