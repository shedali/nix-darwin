{ pkgs, ... }: {
  # Chase VM profile - for Chase virtual machines (standalone, does not import shared.nix)

  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  # Set primary user for user-specific settings
  system.primaryUser = "franz";

  # System defaults
  system.defaults = {
    dock.autohide = false;
    dock.persistent-apps = [
      "/Applications/Ghostty.app"
      "/Applications/Slack.app"
      "/Applications/Google Chrome.app"
    ];
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

  # Launch AeroSpace automatically
  launchd.user.agents.aerospace = {
    path = [ "/usr/bin" "/usr/local/bin" ];
    serviceConfig = {
      ProgramArguments = [ "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/aerospace.err.log";
      StandardOutPath = "/tmp/aerospace.out.log";
    };
  };

  # Launch Syncthing automatically
  launchd.user.agents.syncthing = {
    path = [ "/opt/homebrew/bin" ];
    serviceConfig = {
      ProgramArguments = [ "/opt/homebrew/bin/syncthing" "serve" ];
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Background";
      StandardErrorPath = "/tmp/syncthing.err.log";
      StandardOutPath = "/tmp/syncthing.out.log";
    };
  };

  # Work Homebrew configuration - minimal set for work
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    taps = [
      "atlassian/homebrew-acli"
      "nikitabobko/tap"
    ];

    brews = [
      "acli"
      "gh"
      "git-lfs"
      "mas"
      "syncthing"
    ];

    casks = [
      "1password"
      "aerospace"
      "ghostty"
      "google-chrome"
      "slack"
      "visual-studio-code"
    ];

    masApps = {
    };
  };

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
