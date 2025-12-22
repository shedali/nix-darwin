#!/bin/bash
set -e

# Bootstrap script for nix-darwin installation
# Usage: curl -fsSL https://raw.githubusercontent.com/shedali/nix-darwin/main/bootstrap.sh | bash -s -- <profile>

VALID_PROFILES="personal work mini air"
PROFILE="${1:-personal}"

# Validate profile
if ! echo "$VALID_PROFILES" | grep -qw "$PROFILE"; then
    echo "Error: Invalid profile '$PROFILE'"
    echo "Valid profiles: $VALID_PROFILES"
    exit 1
fi

echo "Installing nix-darwin with profile: $PROFILE"

# Backup existing shell configs (if they exist)
echo "Backing up existing shell configs..."
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin 2>/dev/null && echo "  ✓ Backed up /etc/zshrc" || echo "  - No /etc/zshrc to backup"
sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin 2>/dev/null && echo "  ✓ Backed up /etc/zprofile" || echo "  - No /etc/zprofile to backup"
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin 2>/dev/null && echo "  ✓ Backed up /etc/bashrc" || echo "  - No /etc/bashrc to backup"

# Check if Nix is installed, install if not
if ! command -v nix &> /dev/null; then
    echo "Nix not found. Installing Determinate Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

    # Source nix for current shell
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
else
    echo "✓ Nix already installed"
fi

# Bootstrap nix-darwin
echo "Bootstrapping nix-darwin..."
sudo nix run nix-darwin -- switch --flake "github:shedali/nix-darwin#${PROFILE}"

echo ""
echo "✓ nix-darwin installed successfully with profile: $PROFILE"
echo ""
echo "Future updates can be done with:"
echo "  sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#${PROFILE}"
