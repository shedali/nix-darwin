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

if command -v nix &>/dev/null || [ -f "$NIX_BIN" ] || [ -d "/nix/store" ]; then
    echo "  ✓ Nix already installed, skipping"
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
# 4. Authenticate GitHub and clone/update home-manager config (via HTTPS token)
# ---------------------------------------------------------------------------
# home-manager is a PRIVATE repo, and the SSH signing/auth keys are deployed *by*
# home-manager — so we can't depend on an SSH key here (chicken-and-egg). Instead
# pull in gh via nix, authenticate, and clone over HTTPS with the token.
echo ""
echo "==> Setting up home-manager config..."
HM_DIR="$HOME/.config/home-manager"
GH_TOKEN=""

# gh isn't installed yet on a fresh machine; run it from nixpkgs. Progress goes to
# stderr so the captured stdout is just the token. gh auth login reads from the
# terminal (/dev/tty) since this script may be piped via curl | bash.
GH_TOKEN=$("$NIX" shell nixpkgs#gh nixpkgs#git --command bash -c '
    set -e
    HM_DIR="'"$HM_DIR"'"
    if ! gh auth status &>/dev/null; then
        echo "  Authenticating with GitHub..." >&2
        gh auth login </dev/tty >&2
    fi
    TOKEN=$(gh auth token 2>/dev/null)
    [ -z "$TOKEN" ] && { echo "  ⚠ no gh token" >&2; exit 1; }
    AUTH_HEADER="AUTHORIZATION: bearer $TOKEN"
    if [ -d "$HM_DIR/.git" ]; then
        echo "  Updating existing home-manager repo..." >&2
        git -C "$HM_DIR" remote set-url origin https://github.com/shedali/home-manager.git
        git -C "$HM_DIR" -c "http.https://github.com/.extraheader=$AUTH_HEADER" pull --ff-only >&2 \
            || echo "  ⚠ Could not pull latest" >&2
    else
        echo "  Cloning home-manager repo..." >&2
        gh repo clone shedali/home-manager "$HM_DIR" >&2 \
            && echo "  ✓ Cloned home-manager" >&2 \
            || echo "  ⚠ Could not clone" >&2
    fi
    echo "$TOKEN"
') || true

# If the clone/pull failed, fall back to fetching the flake directly. This needs
# the token too, because an anonymous github: fetch of a private repo 404s.
if [ ! -d "$HM_DIR/.git" ]; then
    echo "  ⚠ Falling back to remote flake"
    HM_DIR="github:shedali/home-manager"
fi

# ---------------------------------------------------------------------------
# 5. Apply home-manager config
# ---------------------------------------------------------------------------
echo ""
echo "==> Applying home-manager config..."
# Use profile-specific home-manager config if available
HM_PROFILE="franz"
if [ "$PROFILE" = "chasevm" ] || [ "$PROFILE" = "chasehost" ]; then
    HM_PROFILE="franz-${PROFILE}"
fi

# When applying from the remote (private) flake, pass the token so nix can fetch it.
HM_FLAGS=()
if [ "$HM_DIR" = "github:shedali/home-manager" ] && [ -n "$GH_TOKEN" ]; then
    HM_FLAGS=(--option access-tokens "github.com=$GH_TOKEN")
fi

if command -v home-manager &>/dev/null; then
    home-manager switch --flake "$HM_DIR#$HM_PROFILE" "${HM_FLAGS[@]}"
else
    "$NIX" run home-manager -- switch --flake "$HM_DIR#$HM_PROFILE" "${HM_FLAGS[@]}"
fi
echo "  ✓ home-manager applied"

echo ""
echo "✓ Bootstrap complete: $PROFILE"
echo ""
echo "To re-apply later:"
echo "  darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#${PROFILE}"
echo "  home-manager switch --flake ~/.config/home-manager"
