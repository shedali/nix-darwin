{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Disable nix-darwin's Nix management (using Determinate Nix)
      nix.enable = false;

      # Set primary user for user-specific settings
      system.primaryUser = "franz";

      # System defaults
      system.defaults = {
        dock.autohide = false;
        dock.persistent-apps = [ "/Applications/Terminal.app" ];
        finder.ShowPathbar = true;
        finder.ShowStatusBar = true;
        screencapture.location = "~/Pictures/Screenshots";
      };

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#personal
    darwinConfigurations."personal" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
