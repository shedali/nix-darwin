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

### Profiles

Each machine has its own profile. The flake attribute is the profile name, not
the hostname:

| Profile | Machine |
|---|---|
| `personal` | Primary personal Mac |
| `air` | MacBook Air |
| `mini` | Mac mini server |
| `chasehost` | Chase work host |
| `chasevm` | Chase VM (standalone -- does not import `shared.nix`) |

Apply a profile straight from GitHub, no clone needed:

```bash
sudo darwin-rebuild switch --flake github:shedali/nix-darwin#air --refresh
```

`--refresh` is not optional when pulling from GitHub: without it Nix can serve a
cached copy of the flake and silently apply an older revision than the one you
just pushed.

If `darwin-rebuild` is not on PATH yet (nix-darwin has never been applied on
that machine), bootstrap it instead:

```bash
sudo /nix/var/nix/profiles/default/bin/nix run nix-darwin -- \
  switch --flake github:shedali/nix-darwin#air --refresh
```

With a local clone, pull first, then point the flake at the working copy:

```bash
git -C ~/dev/shedali/nix-darwin pull
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#air
```

#### When a switch exits 1 after apparently succeeding

nix-darwin runs `brew bundle --cleanup`, which *reports* removals rather than
performing them and then exits 1. So after a brew or cask is dropped from the
config, the next switch ends with `Would uninstall formulae: ...` or
`Would untap: ...` and a non-zero exit, even though everything else applied.
Clear the leftovers by hand and the switch goes green again:

```bash
brew uninstall <formula> && brew untap <tap>
```

Relatedly, every tap a brew or cask comes from must be listed in `taps`. Brew
will still resolve the package through an already-installed tap, so the build
succeeds -- and then cleanup reports `Would untap` and fails the activation.

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
