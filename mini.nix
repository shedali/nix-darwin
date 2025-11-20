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

  # Configure CUPS for printer sharing without authentication
  system.activationScripts.cups.text = ''
    echo "Configuring CUPS for shared printers..."

    # Enable printer sharing and remote access
    /usr/sbin/cupsctl --share-printers --remote-any

    # Disable authentication for the Munbyn printer (if it exists)
    if /usr/bin/lpstat -p Munbyn_ITPP941 >/dev/null 2>&1; then
      /usr/sbin/lpadmin -p Munbyn_ITPP941 -o auth-info-required=none
      echo "✓ Munbyn printer configured for guest access"
    fi

    # Restart CUPS to apply changes
    /bin/launchctl stop org.cups.cupsd 2>/dev/null || true
    /bin/launchctl start org.cups.cupsd
  '';

  # Mac Mini Homebrew configuration - minimal server/utility setup
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
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
      "aerospace"
      "ghostty"
      "google-chrome"
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
