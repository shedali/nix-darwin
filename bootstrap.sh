#!/bin/bash
set -e

# Bootstrap script for nix-darwin + home-manager installation
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

echo "Bootstrapping nix-darwin + home-manager with profile: $PROFILE"

# ---------------------------------------------------------------------------
# 1. Backup existing shell configs (nix-darwin requires these to not exist)
# ---------------------------------------------------------------------------
echo ""
echo "==> Backing up shell configs..."
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin 2>/dev/null && echo "  ✓ Backed up /etc/zshrc" || echo "  - No /etc/zshrc to backup"
sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin 2>/dev/null && echo "  ✓ Backed up /etc/zprofile" || echo "  - No /etc/zprofile to backup"
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin 2>/dev/null && echo "  ✓ Backed up /etc/bashrc" || echo "  - No /etc/bashrc to backup"

# ---------------------------------------------------------------------------
# 2. Install Nix only if not already installed
# ---------------------------------------------------------------------------
echo ""
echo "==> Checking Nix..."
NIX_DAEMON="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
NIX_BIN="/nix/var/nix/profiles/default/bin/nix"

if command -v nix &>/dev/null; then
    echo "  ✓ Nix already installed, skipping"
elif [ -f "$NIX_BIN" ]; then
    echo "  ✓ Nix installed but not in PATH, sourcing daemon..."
    # shellcheck disable=SC1090
    [ -f "$NIX_DAEMON" ] && . "$NIX_DAEMON"
else
    echo "  Installing Nix via Determinate Systems..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    [ -f "$NIX_DAEMON" ] && . "$NIX_DAEMON"
fi

# Resolve nix binary — sudo has a restricted PATH so use full path
NIX=$(command -v nix 2>/dev/null || echo "$NIX_BIN")
if [ ! -x "$NIX" ]; then
    echo "Error: nix binary not found at $NIX"
    exit 1
fi
echo "  ✓ Using nix: $NIX"

# ---------------------------------------------------------------------------
# 3. Apply nix-darwin config (always, blats existing state)
# ---------------------------------------------------------------------------
echo ""
echo "==> Applying nix-darwin config: $PROFILE..."
sudo "$NIX" run nix-darwin -- switch --flake "github:shedali/nix-darwin#${PROFILE}"
echo "  ✓ nix-darwin applied"

# ---------------------------------------------------------------------------
# 4. Clone or update home-manager config (via SSH)
# ---------------------------------------------------------------------------
echo ""
echo "==> Setting up home-manager config..."
HM_DIR="$HOME/.config/home-manager"

if [ -d "$HM_DIR/.git" ]; then
    echo "  Updating existing home-manager repo..."
    git -C "$HM_DIR" remote set-url origin git@github.com:shedali/home-manager.git
    git -C "$HM_DIR" pull --ff-only || echo "  ⚠ Could not pull latest (SSH key not set up?), using existing"
else
    echo "  Cloning home-manager repo..."
    if git clone git@github.com:shedali/home-manager.git "$HM_DIR" 2>/dev/null; then
        echo "  ✓ Cloned home-manager"
    else
        echo ""
        echo "  ⚠ Could not clone via SSH. Set up SSH key (e.g. via 1Password agent) then run:"
        echo "    git clone git@github.com:shedali/home-manager.git ~/.config/home-manager"
        echo "    home-manager switch --flake ~/.config/home-manager"
        echo ""
        echo "  Skipping home-manager step."
        exit 0
    fi
fi

# ---------------------------------------------------------------------------
# 5. Apply home-manager config
# ---------------------------------------------------------------------------
echo ""
echo "==> Applying home-manager config..."
if command -v home-manager &>/dev/null; then
    home-manager switch --flake "$HM_DIR"
else
    "$NIX" run home-manager -- switch --flake "$HM_DIR"
fi
echo "  ✓ home-manager applied"

echo ""
echo "✓ Bootstrap complete: $PROFILE"
echo ""
echo "To re-apply later:"
echo "  darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#${PROFILE}"
echo "  home-manager switch --flake ~/.config/home-manager"
