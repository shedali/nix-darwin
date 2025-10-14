{ pkgs, ... }: {
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  # Set primary user for user-specific settings
  system.primaryUser = "franz";

  # System defaults - common across all profiles
  system.defaults = {
    dock.autohide = false;
    dock.persistent-apps = [ "/Applications/Terminal.app" ];
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;
    screencapture.location = "~/Pictures/Screenshots";
  };

  # Common packages
  environment.systemPackages = [ pkgs.vim ];

  # Set Git commit hash for darwin-version
  system.configurationRevision = null;

  # Used for backwards compatibility
  system.stateVersion = 6;

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
