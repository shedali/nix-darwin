#!/bin/bash
set -e

echo "==================================================================="
echo "Fixing Docker/OrbStack Conflict for darwin-rebuild"
echo "==================================================================="
echo ""

# Backup OrbStack symlinks
echo "Step 1: Backing up OrbStack symlinks..."
sudo mv /usr/local/bin/docker /usr/local/bin/docker.orbstack.bak 2>/dev/null || true
sudo mv /usr/local/bin/docker-compose /usr/local/bin/docker-compose.orbstack.bak 2>/dev/null || true
sudo mv /usr/local/bin/docker-credential-osxkeychain /usr/local/bin/docker-credential-osxkeychain.orbstack.bak 2>/dev/null || true
echo "✓ OrbStack symlinks backed up"
echo ""

# Run darwin-rebuild
echo "Step 2: Running darwin-rebuild switch..."
cd ~/dev/shedali/nix-darwin
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#personal

echo ""
echo "Step 3: Restoring OrbStack symlinks..."
sudo mv /usr/local/bin/docker.orbstack.bak /usr/local/bin/docker 2>/dev/null || true
sudo mv /usr/local/bin/docker-compose.orbstack.bak /usr/local/bin/docker-compose 2>/dev/null || true
sudo mv /usr/local/bin/docker-credential-osxkeychain.orbstack.bak /usr/local/bin/docker-credential-osxkeychain 2>/dev/null || true
echo "✓ OrbStack symlinks restored"
echo ""

echo "==================================================================="
echo "Success! darwin-rebuild completed"
echo "==================================================================="
echo ""
echo "Now the brew wrapper should use /opt/homebrew (ARM) instead of /usr/local (Intel)"
echo "Opening a new shell should give you access to 'acli' automatically."
echo ""
