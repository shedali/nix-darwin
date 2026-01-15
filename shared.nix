{ pkgs, ... }: {
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  # Set primary user for user-specific settings
  system.primaryUser = "franz";

  # System defaults - common across all profiles
  system.defaults = {
    dock.autohide = false;
    dock.persistent-apps = [ "/Applications/Terminal.app" ];
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;
    screencapture.location = "~/Pictures/Screenshots";
  };

  # Common packages
  environment.systemPackages = [ pkgs.vim pkgs.neovim ];

  # Shared Homebrew apps across all profiles
  homebrew = {
    taps = [
      "nikitabobko/tap"
    ];
    brews = [
      "gh"
      "git-lfs"
      "mas"
    ];
    casks = [
      "1password"
      "aerospace"
      "ghostty"
      "google-chrome"
      "obsidian"
      "raycast"
    ];
    masApps = {
      "Drafts" = 1435957248;
      "Spark" = 6445813049;
      "Things" = 904280696;
    };
  };

  # Set Git commit hash for darwin-version
  system.configurationRevision = null;

  # Used for backwards compatibility
  system.stateVersion = 6;

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";

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
