{ pkgs, ... }: {
  imports = [ ./base.nix ];

  # Override tdarr-node to match server version (avoids auto-update loop on read-only nix store)
  nixpkgs.overlays = [
    (final: prev: {
      tdarr-node = prev.tdarr-node.overrideAttrs (_finalAttrs: _oldAttrs: {
        version = "2.62.01";
        src = prev.fetchzip {
          url = "https://storage.tdarr.io/versions/2.62.01/darwin_arm64/Tdarr_Node.zip";
          hash = "sha256-i7GS+Y9P+q/kdg37Qq6KuKGQz4Cv9F/VDAVTZy/DIuA=";
          stripRoot = false;
        };
      });
    })
  ];

  # Keyboard shortcuts
  # Modifiers: @ = Cmd, $ = Shift, ~ = Option, ^ = Control
  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # Cmd+` for "Move focus to next window"
        "27" = {
          enabled = true;
          value = {
            parameters = [ 96 50 1048576 ];
            type = "standard";
          };
        };
        # Disable Spotlight search (Cmd+Space)
        "64" = {
          enabled = false;
          value = {
            parameters = [ 32 49 1048576 ];
            type = "standard";
          };
        };
        # Disable Finder search window (Cmd+Option+Space)
        "65" = {
          enabled = false;
          value = {
            parameters = [ 32 49 1572864 ];
            type = "standard";
          };
        };
      };
    };

    # App-specific keyboard shortcuts
    "com.omnigroup.OmniFocus4" = {
      NSUserKeyEquivalents = {
        "Move Up" = "^@k";
        "Move Down" = "^@j";
      };
    };
    "com.agiletortoise.Drafts-OSX" = {
      NSUserKeyEquivalents = {
        "Link Mode" = "@l";
      };
    };
    "com.culturedcode.ThingsMac" = {
      NSUserKeyEquivalents = {
        "Convert to Project..." = "~@p";
      };
    };
  };

  # Obsidian headless sync (continuous background sync for CLI/nvim editing)
  launchd.user.agents.obsidian-sync = {
    path = [ "/opt/homebrew/bin" "/usr/local/bin" "/usr/bin" "/bin" ];
    serviceConfig = {
      ProgramArguments = [ "/opt/homebrew/bin/ob" "sync" "--path" "/Users/franz/dev/shedali/knowledge" "--continuous" ];
      KeepAlive = true;
      RunAtLoad = true;
      EnvironmentVariables = { HOME = "/Users/franz"; };
      StandardErrorPath = "/tmp/obsidian-sync.err.log";
      StandardOutPath = "/tmp/obsidian-sync.out.log";
    };
  };

  # Shared Homebrew apps across all profiles
  homebrew = {
    taps = [
      "alexanderwillner/tap"
      "nikitabobko/tap"
    ];
    brews = [
      "flock"
      "gh"
      "git-delta"
      "git-lfs"
      "llmfit"
      "mas"
      "rtk"
      "worktrunk"
      "alexanderwillner/tap/things.sh"
    ];
    casks = [
      "1password"
      "aerospace"
      "ghostty"
      "google-chrome"
      "obsidian"
      "quicklook-video"
      "raycast"
    ];
    masApps = {
      "Drafts" = 1435957248;
      "Tailscale" = 1475387142;
      "Things" = 904280696;
    };
  };
}
