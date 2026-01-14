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
      "syncthing"
    ];

    casks = [
      "1password"
      "aerospace"
      "ghostty"
      "github"
      "google-chrome"
      "obsidian"
      "raycast"
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
