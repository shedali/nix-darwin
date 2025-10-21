# nix-darwin Configuration

This directory contains the nix-darwin configuration for managing macOS system settings.

## Available Profiles

- **personal** - Full app suite for personal machine
- **work** - Minimal work-focused apps
- **mini** - Minimal server/utility setup for Mac mini

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
```bash
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin
```

### View Changes Without Applying
```bash
sudo darwin-rebuild build --flake ~/dev/shedali/nix-darwin
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

### Current Settings
- **Dock**: autohide disabled, Terminal.app in persistent apps
- **Finder**: path bar and status bar enabled
- **Screenshots**: saved to `~/Pictures/Screenshots`

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
- **Casks:** 1Password, Ghostty, Raycast
- **Brews:** gh, mas
- **Mac App Store:** Tailscale
