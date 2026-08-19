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
  #
  # Runs lishid's `obsidian-headless` (bin: `ob`) via bunx — no global install needed,
  # bunx resolves from its own cache and works with no network (verified), so this is
  # safe at RunAtLoad before the network is up.
  #
  # Version is pinned deliberately: this is 0.0.x software, and an unattended upgrade
  # that broke the CLI would silently stop syncing. Bump it consciously.
  #
  # Requires a one-time interactive setup (cannot be automated — needs account creds):
  #   bunx obsidian-headless login
  #   bunx obsidian-headless sync-setup --path /Users/franz/dev/shedali/knowledge
  # Check with: bunx obsidian-headless sync-status --path /Users/franz/dev/shedali/knowledge
  launchd.user.agents.obsidian-sync = {
    path = [ "/Users/franz/.nix-profile/bin" "/opt/homebrew/bin" "/usr/local/bin" "/usr/bin" "/bin" ];
    serviceConfig = {
      ProgramArguments = [ "/Users/franz/.nix-profile/bin/bunx" "obsidian-headless@0.0.14" "sync" "--path" "/Users/franz/dev/shedali/knowledge" "--continuous" ];
      KeepAlive = true;
      RunAtLoad = true;
      EnvironmentVariables = { HOME = "/Users/franz"; };
      StandardErrorPath = "/tmp/obsidian-sync.err.log";
      StandardOutPath = "/tmp/obsidian-sync.out.log";
    };
  };

  # Brew reads this file before every invocation. Prevents brew from auto-updating
  # during darwin-rebuild activation, which breaks mas's package_manager_installed? check.
  environment.etc."homebrew/brew.env".text = "HOMEBREW_NO_AUTO_UPDATE=1\n";

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
