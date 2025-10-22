#!/bin/bash
set -e

echo "==================================================================="
echo "Darwin Rebuild - Fixing Homebrew for Apple Silicon"
echo "==================================================================="
echo ""
echo "This script will rebuild your nix-darwin configuration with the"
echo "correct Apple Silicon settings for Homebrew."
echo ""

cd ~/dev/shedali/nix-darwin

echo "Step 1: Running darwin-rebuild switch..."
echo ""

sudo darwin-rebuild switch --flake ~/dev/shedali/nix-darwin#personal

echo ""
echo "==================================================================="
echo "Rebuild complete!"
echo "==================================================================="
echo ""
echo "Now testing Homebrew installation..."
echo ""

# Use the ARM Homebrew directly
export PATH="/opt/homebrew/bin:$PATH"

echo "Step 2: Installing Atlassian CLI..."
brew install acli

echo ""
echo "==================================================================="
echo "Success! Homebrew is now properly configured for Apple Silicon."
echo "==================================================================="
echo ""
echo "The 'acli' command should now be available:"
which acli
echo ""
