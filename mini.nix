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

  # Mac Mini Homebrew configuration - minimal server/utility setup
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    taps = [
      "nikitabobko/tap"
    ];

    brews = [
      "gh"
      "mas"
    ];

    casks = [
      "1password"
      "nikitabobko/tap/aerospace"
      "ghostty"
      "utm"
    ];

    masApps = {
      "Tailscale" = 1475387142;
    };
  };

  # Mac Mini dock settings - minimal
  system.defaults.dock.persistent-apps = [
    "/Applications/Ghostty.app"
  ];
}
