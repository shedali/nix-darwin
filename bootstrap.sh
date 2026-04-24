#!/bin/bash
set -e

# Bootstrap script for nix-darwin installation
# Usage: curl -fsSL https://raw.githubusercontent.com/shedali/nix-darwin/main/bootstrap.sh | bash -s -- <profile>
#
# Profiles: personal | work | mini | air | chasevm | chasehost

VALID_PROFILES="personal work mini air chasevm chasehost"
PROFILE="${1:-personal}"

# Validate profile
if ! echo "$VALID_PROFILES" | grep -qw "$PROFILE"; then
    echo "Error: Invalid profile '$PROFILE'"
    echo "Valid profiles: $VALID_PROFILES"
    exit 1
fi

echo "Bootstrapping nix-darwin with profile: $PROFILE"

# Backup existing shell configs (nix-darwin requires these to not exist)
echo "Backing up shell configs..."
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin 2>/dev/null && echo "  ✓ Backed up /etc/zshrc" || echo "  - No /etc/zshrc to backup"
sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin 2>/dev/null && echo "  ✓ Backed up /etc/zprofile" || echo "  - No /etc/zprofile to backup"
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin 2>/dev/null && echo "  ✓ Backed up /etc/bashrc" || echo "  - No /etc/bashrc to backup"

# Install Nix only if not already installed
NIX_DAEMON="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
NIX_BIN="/nix/var/nix/profiles/default/bin/nix"

if command -v nix &>/dev/null; then
    echo "✓ Nix already installed, skipping"
elif [ -f "$NIX_BIN" ]; then
    echo "✓ Nix installed but not in PATH, sourcing daemon..."
    # shellcheck disable=SC1090
    [ -f "$NIX_DAEMON" ] && . "$NIX_DAEMON"
else
    echo "Installing Nix via Determinate Systems..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    [ -f "$NIX_DAEMON" ] && . "$NIX_DAEMON"
fi

# Resolve nix binary — sudo has a restricted PATH so use full path
NIX=$(command -v nix 2>/dev/null || echo "$NIX_BIN")

if [ ! -x "$NIX" ]; then
    echo "Error: nix binary not found at $NIX"
    exit 1
fi

echo "✓ Using nix at: $NIX"

# Always apply nix-darwin config (blats existing state)
echo "Applying nix-darwin config: $PROFILE..."
sudo "$NIX" run nix-darwin -- switch --flake "github:shedali/nix-darwin#${PROFILE}"

echo ""
echo "✓ nix-darwin applied successfully: $PROFILE"
echo ""
echo "To re-apply later:"
echo "  darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#${PROFILE}"
