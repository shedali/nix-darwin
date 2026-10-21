{ pkgs, ... }: {
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  # Set primary user for user-specific settings
  system.primaryUser = "franz";

  # System defaults - common across all profiles
  system.defaults = {
    dock.autohide = false;
    dock.persistent-apps = [];
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;
    screencapture.location = "~/Pictures/Screenshots";
  };

  # Common packages
  environment.systemPackages = [ pkgs.vim pkgs.neovim ];

  # Set Git commit hash for darwin-version
  system.configurationRevision = null;

  # Used for backwards compatibility
  system.stateVersion = 6;

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";

  # AeroSpace is not launched automatically; start it by hand.

  # Post-activation script
  system.activationScripts.postActivation.text = ''
    echo ""
    echo "=================================================="
    echo "IMPORTANT: Manual steps required for AeroSpace:"
    echo "1. Open System Settings > Privacy & Security > Accessibility"
    echo "2. Click the lock to make changes"
    echo "3. Add and enable AeroSpace.app"
    echo "=================================================="
    echo ""
  '';
}
