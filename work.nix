{ pkgs, ... }: {
  imports = [ ./shared.nix ];

  # Work Homebrew configuration - minimal set for work
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    brews = [
    ];

    casks = [
      "docker"
      "ghostty"
      "google-chrome"
      "slack"
      "visual-studio-code"
    ];

    masApps = {
    };
  };

  # Override dock settings for work - use Ghostty instead of Terminal
  system.defaults.dock.persistent-apps = [
    "/Applications/Ghostty.app"
    "/Applications/Slack.app"
    "/Applications/Google Chrome.app"
  ];
}
