{ pkgs, ... }: {
  imports = [ ./shared.nix ];

  # Work Homebrew configuration - minimal set for work
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    brews = [
      "gh"
      "httpie"
      "mas"
      "neovim"
    ];

    casks = [
      "1password"
      "docker"
      "figma"
      "ghostty"
      "google-chrome"
      "notion"
      "slack"
      "visual-studio-code"
      "zoom"
    ];

    masApps = {
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Slack" = 803453959;
    };
  };
}
