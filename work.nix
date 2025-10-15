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
      "1password"
      "docker"
      "ghostty"
      "google-chrome"
      "slack"
      "visual-studio-code"
    ];

    masApps = {
      "Slack" = 803453959;
    };
  };
}
