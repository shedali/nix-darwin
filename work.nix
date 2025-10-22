{ pkgs, ... }: {
  imports = [ ./shared.nix ];

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

  # Work Homebrew configuration - minimal set for work
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    taps = [
      "atlassian/homebrew-acli"
      "nikitabobko/tap"
    ];

    brews = [
      "acli"
    ];

    casks = [
      "1password"
      "nikitabobko/tap/aerospace"
      "docker"
      "ghostty"
      "google-chrome"
      "obsidian"
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
