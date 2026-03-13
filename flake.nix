{
  description = "nix-darwin system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/75690239f08f885ca9b0267580101f60d10fbe62";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = { self, nix-darwin, nixpkgs, nix-homebrew }: {
    # Personal configuration - full app suite
    darwinConfigurations."personal" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./personal.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "franz";
            autoMigrate = true;
          };
        }
      ];
    };

    # Mac Mini configuration - minimal server/utility setup
    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./mini.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "franz";
            autoMigrate = true;
          };
        }
      ];
    };

    # Chase host configuration - work machine with productivity apps
    darwinConfigurations."chasehost" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./chasehost.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "franz";
            autoMigrate = true;
          };
        }
      ];
    };

    # MacBook Air configuration - minimal portable setup
    darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./air.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "franz";
            autoMigrate = true;
          };
        }
      ];
    };

    # Chase VM configuration - for Chase virtual machines
    darwinConfigurations."chasevm" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./chasevm.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "franz";
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
