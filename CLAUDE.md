# nix-darwin Configuration

This directory contains the nix-darwin configuration for managing macOS system settings.

## Quick Reference

### Apply Configuration Changes
```bash
sudo darwin-rebuild switch --flake ~/.config/nix-darwin
```

### View Changes Without Applying
```bash
sudo darwin-rebuild build --flake ~/.config/nix-darwin
```

### Check Configuration
```bash
nix flake check ~/.config/nix-darwin
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
~/.config/nix-darwin/
├── flake.nix          # Main configuration file
├── flake.lock         # Locked dependency versions
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
nix flake update ~/.config/nix-darwin
sudo darwin-rebuild switch --flake ~/.config/nix-darwin
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
sudo darwin-rebuild switch --flake ~/.config/nix-darwin
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
