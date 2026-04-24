{ pkgs, ... }: {
  imports = [ ./shared.nix ];

  # MacBook Air Homebrew configuration - minimal portable setup
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    # Air-specific casks (shared.nix provides: 1password, aerospace, ghostty, google-chrome, obsidian, raycast)
    # masApps from shared.nix: Drafts, Spark, Things
    casks = [
    ];

    masApps = {
      "Screens 5" = 1663047912;
    };
  };

  # MacBook Air dock settings - minimal
  system.defaults.dock.persistent-apps = [
    "/Applications/Ghostty.app"
    "/Applications/Google Chrome.app"
  ];
}
