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

    # Keyboard shortcuts
    # Enable Cmd+` for "Move focus to next window" (key 27)
    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "27" = {
            enabled = true;
            value = {
              parameters = [ 96 50 1048576 ];
              type = "standard";
            };
          };
        };
      };

      # App-specific keyboard shortcuts
      # Modifiers: @ = Cmd, $ = Shift, ~ = Option, ^ = Control
      "com.omnigroup.OmniFocus4" = {
        NSUserKeyEquivalents = {
          "Move Up" = "^@k";
          "Move Down" = "^@j";
        };
      };
      "com.agiletortoise.Drafts-OSX" = {
        NSUserKeyEquivalents = {
          "Link Mode" = "@l";
        };
      };
      "com.culturedcode.ThingsMac" = {
        NSUserKeyEquivalents = {
          "Convert to Project..." = "~@p";
        };
      };
    };
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
      "readdle-spark"
    ];
    masApps = {
      "Drafts" = 1435957248;
      "Tailscale" = 1475387142;
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
