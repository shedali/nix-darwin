{ ... }: {
  # Chase VM profile - for Chase virtual machines (standalone, does not import shared.nix)
  imports = [ ./base.nix ];

  # Work Homebrew configuration - minimal set for work
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    taps = [];

    brews = [
      "acli"
      "gh"
      "git-lfs"
      "llmfit"
      "mas"
    ];

    casks = [
      "1password"
      "aerospace"
      "ghostty"
      "google-chrome"
      "slack"
      "warp"
    ];

    masApps = {};
  };

  system.defaults.dock.persistent-apps = [
    "/Applications/Ghostty.app"
    "/Applications/Slack.app"
    "/Applications/Google Chrome.app"
  ];
}
