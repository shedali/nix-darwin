#!/bin/bash
set -e

echo "==================================================================="
echo "Applying Work Configuration (chase machine)"
echo "==================================================================="
echo ""
echo "Current hostname: $(scutil --get LocalHostName)"
echo "Applying configuration: work"
echo "Docker solution: Docker Desktop (docker cask)"
echo ""

# Temporarily remove OrbStack symlinks if they exist from previous misconfigurations
if [ -L "/usr/local/bin/docker" ] && [ "$(readlink /usr/local/bin/docker)" = "/Applications/OrbStack.app/Contents/MacOS/xbin/docker" ]; then
  echo "Removing old OrbStack symlinks from previous misconfiguration..."
  sudo rm -f /usr/local/bin/docker
  sudo rm -f /usr/local/bin/docker-compose
  sudo rm -f /usr/local/bin/docker-credential-osxkeychain
  echo "✓ OrbStack symlinks removed"
  echo ""
fi

cd ~/dev/shedali/nix-darwin

echo "Running darwin-rebuild with work profile..."
echo ""
sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#work

echo ""
echo "==================================================================="
echo "Success! Work configuration applied"
echo "==================================================================="
echo ""
echo "Docker Desktop will be installed (not OrbStack)"
echo "The brew wrapper now uses /opt/homebrew (ARM)"
echo "Open a new shell and 'acli' should be available"
echo ""
