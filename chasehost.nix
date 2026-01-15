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

  # Chase Host Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    taps = [
      "atlassian/homebrew-acli"
    ];

    brews = [
      "acli"
      "syncthing"
    ];

    # Chasehost-specific casks (shared.nix provides: 1password, aerospace, ghostty, google-chrome, obsidian, raycast)
    # masApps from shared.nix: Drafts, Spark, Things
    casks = [
      "chatgpt"
      "cleanshot"
      "claude"
      "devonthink"
      "dropbox"
      "parallels"
      "slack"
      "telegram"
    ];

    masApps = {
      "Actions For Obsidian" = 1659667937;
      "DaisyDisk" = 411643860;
      "Due" = 524373870;
      "MindNode Next" = 6446116532;
      "OmniFocus" = 1542143627;
      "Screens 5" = 1663047912;
      "Tailscale" = 1475387142;
      "Xcode" = 497799835;
      "Yoink" = 457622435;
    };
  };

  # Chase host dock settings
  system.defaults.dock.persistent-apps = [
    "/Applications/Ghostty.app"
    "/Applications/Slack.app"
    "/Applications/Google Chrome.app"
  ];
}
