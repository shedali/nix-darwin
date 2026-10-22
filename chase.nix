{ pkgs, lib, ... }: {
  imports = [ ./shared.nix ./modules/plezy.nix ];

  # Chase Homebrew configuration
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
      "tinymist"
      "typst"
    ];

    # Chase-specific casks (shared.nix provides: 1password, aerospace, ghostty, google-chrome, obsidian, raycast)
    casks = [
      "betterdisplay"
      "cleanshot"
      "hammerspoon"
      "orbstack"
      "parallels"
      "slack"
      "visual-studio-code"
      "losslesscut"
      "zoom"
    ];

    # Mac App Store installs do not work on the managed Chase machine. shared.nix
    # declares some, so force the set empty (mkForce) to drop them for Chase only.
    masApps = lib.mkForce {};
  };

  # Chase dock settings
  system.defaults.dock.persistent-apps = [
    "/Applications/Ghostty.app"
    "/Applications/Google Chrome.app"
  ];
}
