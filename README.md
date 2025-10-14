# nix-darwin Configuration

My personal [nix-darwin](https://github.com/LnL7/nix-darwin) configuration for managing macOS system settings declaratively.

## Quick Start

### One-Liner Remote Install (No Clone Required)

If you want to use the configuration as-is with my username/hostname:

```bash
# Backup existing shell configs (if they exist)
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin 2>/dev/null || true
sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin 2>/dev/null || true
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin 2>/dev/null || true

# First time install (bootstraps nix-darwin and applies config)
sudo nix run nix-darwin -- switch --flake github:shedali/nix-darwin#personal

# Subsequent updates
sudo darwin-rebuild switch --flake github:shedali/nix-darwin#personal
```

### Local Install (With Customization)

If you want to customize the configuration:

```bash
# Clone the repository
git clone https://github.com/shedali/nix-darwin.git ~/.config/nix-darwin

# Edit the configuration to match your system
cd ~/.config/nix-darwin
# Update flake.nix: change "franz" to your username (line 23)
# Update flake.nix: change "personal" to your hostname (line 51)

# Backup existing shell configs (if they exist)
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin 2>/dev/null || true
sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin 2>/dev/null || true
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin 2>/dev/null || true

# First time install
sudo nix run nix-darwin -- switch --flake ~/.config/nix-darwin

# Subsequent updates
sudo darwin-rebuild switch --flake ~/.config/nix-darwin
```

### Find Your Hostname
```bash
scutil --get LocalHostName
```

## What This Configures

- **Dock**: Auto-hide disabled, Terminal.app in persistent apps
- **Finder**: Path bar and status bar enabled
- **Screenshots**: Saved to `~/Pictures/Screenshots`

## Making Changes

1. Edit `flake.nix`
2. Apply changes: `sudo darwin-rebuild switch --flake ~/.config/nix-darwin`
3. Commit and push: `git commit -am "description" && git push`

## Documentation

See [CLAUDE.md](./CLAUDE.md) for detailed documentation, troubleshooting, and common tasks.

## Resources

- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/index.html)
- [nix-darwin Options](https://daiderd.com/nix-darwin/manual/index.html#sec-options)
- [Determinate Nix Installer](https://determinate.systems/posts/determinate-nix-installer)
