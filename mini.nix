{ pkgs, ... }: {
  imports = [ ./shared.nix ];

  # Mac Mini Homebrew configuration - minimal server/utility setup
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    brews = [
      "gh"
      "mas"
    ];

    casks = [
      "1password"
      "ghostty"
      "raycast"
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
