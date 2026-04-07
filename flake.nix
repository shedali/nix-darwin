{
  description = "nix-darwin system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/75690239f08f885ca9b0267580101f60d10fbe62";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Homebrew tap sources (needed for chasevm/chasehost which bootstrap on fresh machines)
    atlassian-acli-tap = {
      url = "github:atlassian/homebrew-acli";
      flake = false;
    };
    nikitabobko-tap = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    manaflow-cmux-tap = {
      url = "github:manaflow-ai/homebrew-cmux";
      flake = false;
    };
  };

  outputs = { self, nix-darwin, nixpkgs, nix-homebrew, atlassian-acli-tap, nikitabobko-tap, manaflow-cmux-tap, ... }: {
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
            taps = {
              "atlassian/homebrew-acli" = atlassian-acli-tap;
              "manaflow-ai/cmux" = manaflow-cmux-tap;
            };
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
            mutableTaps = false;
            taps = {
              "atlassian/homebrew-acli" = atlassian-acli-tap;
              "nikitabobko/tap" = nikitabobko-tap;
            };
          };
        }
      ];
    };
  };
}
