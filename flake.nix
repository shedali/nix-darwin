{
  description = "nix-darwin system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs }: {
    # Personal configuration - full app suite
    darwinConfigurations."personal" = nix-darwin.lib.darwinSystem {
      modules = [ ./personal.nix ];
    };

    # Work configuration - minimal work-focused apps
    darwinConfigurations."work" = nix-darwin.lib.darwinSystem {
      modules = [ ./work.nix ];
    };
  };
}
