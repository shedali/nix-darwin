{ pkgs, ... }: {
  imports = [ ./shared.nix ];

  # Install uptime-kuma v1.23.16 via git clone into a persistent directory.
  # Uses node@20 (node@22+ drops APIs uptime-kuma v1 depends on).
  # npm registry only has broken v2-dev; nixpkgs version is marked broken.
  # Also installs provision script dependencies.
  system.activationScripts.uptimeKumaInstall.text = ''
    INSTALL_DIR="/Users/franz/.local/share/uptime-kuma-app"
    PROVISION_DIR="/Users/franz/dev/shedali/nix-darwin/uptime-kuma"
    NODE="/opt/homebrew/opt/node@20/bin/node"
    NPM="/opt/homebrew/opt/node@20/bin/npm"
    GIT="/usr/bin/git"
    export PATH="/opt/homebrew/opt/node@20/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

    if [ ! -f "$INSTALL_DIR/server/server.js" ]; then
      echo "Cloning uptime-kuma v1.23.16..."
      rm -rf "$INSTALL_DIR"
      $GIT clone --depth 1 --branch 1.23.16 https://github.com/louislam/uptime-kuma.git "$INSTALL_DIR" 2>&1 || echo "WARNING: git clone had errors"
      echo "Installing uptime-kuma dependencies..."
      cd "$INSTALL_DIR"
      $NPM install --production 2>&1 || echo "WARNING: npm install had errors"
      echo "Downloading pre-built frontend..."
      $NODE extra/download-dist.js 2>&1 || echo "WARNING: download-dist had errors"
    fi

    if [ ! -d "$PROVISION_DIR/node_modules/socket.io-client" ]; then
      echo "Installing provision script dependencies..."
      cd "$PROVISION_DIR"
      $NPM install 2>&1 || echo "WARNING: provision deps install had errors"
    fi
  '';

  # Uptime Kuma monitoring (independent of NAS — alerts still work during NAS rebuilds)
  # Runs via git-cloned v1.23.16 with node@20 (required for compatibility).
  launchd.user.agents.uptime-kuma = {
    serviceConfig = {
      ProgramArguments = [
        "/opt/homebrew/opt/node@20/bin/node"
        "server/server.js"
      ];
      WorkingDirectory = "/Users/franz/.local/share/uptime-kuma-app";
      EnvironmentVariables = {
        DATA_DIR = "/Users/franz/.local/share/uptime-kuma";
        UPTIME_KUMA_HOST = "0.0.0.0";
        UPTIME_KUMA_PORT = "3001";
        HOME = "/Users/franz";
      };
      KeepAlive = true;
      RunAtLoad = true;
      ThrottleInterval = 30;
      StandardErrorPath = "/tmp/uptime-kuma.err.log";
      StandardOutPath = "/tmp/uptime-kuma.out.log";
    };
  };

  # Provision monitors declaratively from nix-darwin/uptime-kuma/monitors.json.
  # Runs at boot, waits for the service to be ready, then syncs any missing monitors.
  # Credentials: op item "Uptime Kuma" in agents vault (username + password fields).
  launchd.user.agents.uptime-kuma-provision = {
    serviceConfig = {
      ProgramArguments = [
        "/opt/homebrew/bin/node"
        "/Users/franz/dev/shedali/nix-darwin/uptime-kuma/provision.mjs"
      ];
      EnvironmentVariables = {
        HOME = "/Users/franz";
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin";
      };
      RunAtLoad = true;
      KeepAlive = false;
      ThrottleInterval = 3600;
      StandardErrorPath = "/tmp/uptime-kuma-provision.err.log";
      StandardOutPath = "/tmp/uptime-kuma-provision.out.log";
    };
  };

  # Launch NullClaw gateway (disabled — re-enable when needed)
  # launchd.user.agents.nullclaw = {
  #   path = [ "/opt/homebrew/bin" "/opt/homebrew/sbin" "/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin" ];
  #   serviceConfig = {
  #     ProgramArguments = [ "/opt/homebrew/bin/nullclaw" "gateway" ];
  #     KeepAlive = true;
  #     RunAtLoad = true;
  #     EnvironmentVariables = {
  #       HOME = "/Users/franz";
  #     };
  #     StandardErrorPath = "/Users/franz/.nullclaw/logs/daemon.stderr.log";
  #     StandardOutPath = "/Users/franz/.nullclaw/logs/daemon.stdout.log";
  #   };
  # };

  # Claude Code Telegram bot
  launchd.user.agents.claude-telegram = {
    path = [ "/opt/homebrew/bin" "/usr/local/bin" "/usr/bin" "/bin" "/Users/franz/.local/bin" "/Users/franz/.nix-profile/bin" ];
    serviceConfig = {
      ProgramArguments = [ "/Users/franz/.local/bin/claude-telegram-bot" ];
      KeepAlive = true;
      RunAtLoad = true;
      WorkingDirectory = "/Users/franz/.claude-telegram";
      EnvironmentVariables = {
        HOME = "/Users/franz";
      };
      StandardErrorPath = "/Users/franz/.claude-telegram/stderr.log";
      StandardOutPath = "/Users/franz/.claude-telegram/stdout.log";
    };
  };


  # Tdarr distributed transcoding worker node (native binary for VideoToolbox GPU acceleration)
  launchd.user.agents.tdarr-node = {
    serviceConfig = {
      ProgramArguments = [ "${pkgs.tdarr-node}/bin/tdarr-node" ];
      WorkingDirectory = "/Users/franz/.local/share/tdarr/node";
      EnvironmentVariables = {
        serverIP = "192.168.0.72";
        serverPort = "8266";
        nodeName = "mac-mini";
        ffmpegPath = "${pkgs.ffmpeg}/bin/ffmpeg";
      };
      KeepAlive = true;
      RunAtLoad = true;
      ThrottleInterval = 30;
      StandardErrorPath = "/tmp/tdarr-node.err.log";
      StandardOutPath = "/tmp/tdarr-node.out.log";
    };
  };

  # Launch Ollama server automatically
  launchd.user.agents.ollama = {
    path = [ "/opt/homebrew/bin" ];
    serviceConfig = {
      ProgramArguments = [ "/opt/homebrew/bin/ollama" "serve" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/ollama.err.log";
      StandardOutPath = "/tmp/ollama.out.log";
    };
  };

  # Configure CUPS for printer sharing without authentication
  system.activationScripts.cups.text = ''
    echo "Configuring CUPS for shared printers..."

    # Enable printer sharing and remote access
    /usr/sbin/cupsctl --share-printers --remote-any

    # Disable authentication for the Munbyn printer (if it exists)
    if /usr/bin/lpstat -p Munbyn_ITPP941 >/dev/null 2>&1; then
      /usr/sbin/lpadmin -p Munbyn_ITPP941 -o auth-info-required=none
      echo "✓ Munbyn printer configured for guest access"
    fi

    # Restart CUPS to apply changes
    /bin/launchctl stop org.cups.cupsd 2>/dev/null || true
    /bin/launchctl start org.cups.cupsd
  '';

  # Grant TCC permissions to NullClaw binary for shell tool access (osascript, calendar, etc.)
  system.activationScripts.nullclawTcc.text = ''
    echo "Granting TCC permissions to NullClaw binary..."
    NC_BIN=$(/usr/bin/readlink -f /opt/homebrew/bin/nullclaw 2>/dev/null || echo /opt/homebrew/bin/nullclaw)
    TCC_DB="/Users/franz/Library/Application Support/com.apple.TCC/TCC.db"
    NOW=$(date +%s)

    for SERVICE in kTCCServiceAddressBook kTCCServiceCalendar kTCCServiceReminders; do
      /usr/bin/sqlite3 "$TCC_DB" \
        "INSERT OR REPLACE INTO access (service, client, client_type, auth_value, auth_reason, auth_version, csreq, indirect_object_identifier, flags, last_modified) \
         VALUES ('$SERVICE', '$NC_BIN', 1, 2, 2, 1, NULL, 'UNUSED', 0, $NOW);"
    done

    for TARGET in com.apple.AddressBook com.apple.iCal com.apple.reminders com.apple.MobileSMS com.apple.mail com.apple.Notes com.culturedcode.ThingsMac com.omnigroup.OmniFocus4; do
      /usr/bin/sqlite3 "$TCC_DB" \
        "INSERT OR REPLACE INTO access (service, client, client_type, auth_value, auth_reason, auth_version, csreq, indirect_object_identifier, indirect_object_identifier_type, flags, last_modified) \
         VALUES ('kTCCServiceAppleEvents', '$NC_BIN', 1, 2, 3, 1, NULL, '$TARGET', 0, 0, $NOW);"
    done

    /usr/bin/sqlite3 "$TCC_DB" \
      "DELETE FROM access WHERE client LIKE '%/Cellar/nullclaw/%' AND client <> '$NC_BIN';"

    echo "TCC permissions granted for $NC_BIN"
  '';

  # Grant TCC permissions to current node binary for OpenClaw
  # Runs on every darwin-rebuild switch to handle Homebrew node version changes
  system.activationScripts.openclawTcc.text = ''
    echo "Granting TCC permissions to current node binary for OpenClaw..."
    NODE_BIN=$(/usr/bin/readlink -f /opt/homebrew/opt/node/bin/node 2>/dev/null || echo /opt/homebrew/opt/node/bin/node)
    TCC_DB="/Users/franz/Library/Application Support/com.apple.TCC/TCC.db"
    NOW=$(date +%s)

    # Direct service permissions (Contacts, Calendar, Reminders)
    for SERVICE in kTCCServiceAddressBook kTCCServiceCalendar kTCCServiceReminders; do
      /usr/bin/sqlite3 "$TCC_DB" \
        "INSERT OR REPLACE INTO access (service, client, client_type, auth_value, auth_reason, auth_version, csreq, indirect_object_identifier, flags, last_modified) \
         VALUES ('$SERVICE', '$NODE_BIN', 1, 2, 2, 1, NULL, 'UNUSED', 0, $NOW);"
    done

    # AppleEvents permissions (per-target app)
    for TARGET in com.apple.AddressBook com.apple.iCal com.apple.reminders com.apple.MobileSMS com.apple.mail com.apple.Notes com.apple.Photos com.culturedcode.ThingsMac com.omnigroup.OmniFocus4; do
      /usr/bin/sqlite3 "$TCC_DB" \
        "INSERT OR REPLACE INTO access (service, client, client_type, auth_value, auth_reason, auth_version, csreq, indirect_object_identifier, indirect_object_identifier_type, flags, last_modified) \
         VALUES ('kTCCServiceAppleEvents', '$NODE_BIN', 1, 2, 3, 1, NULL, '$TARGET', 0, 0, $NOW);"
    done

    # Clean stale entries from old node versions
    /usr/bin/sqlite3 "$TCC_DB" \
      "DELETE FROM access WHERE client LIKE '%/Cellar/node/%' AND client <> '$NODE_BIN';"

    echo "✓ TCC permissions granted for $NODE_BIN (old entries cleaned)"
  '';

  # Mac Mini Homebrew configuration - minimal server/utility setup
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    taps = [
      "openhue/cli"
      "steipete/tap"
      "yakitrak/yakitrak"
    ];

    brews = [
      "agent-browser"
      "nullclaw"
      "ollama"
      "homeassistant-cli"
      "node@20"
      "ical-buddy"
      "openclaw-cli"
      "openhue/cli/openhue-cli"
      "steipete/tap/imsg"
      "steipete/tap/remindctl"
      "steipete/tap/sonoscli"
      "syncthing"
      "whisper-cpp"
      "yakitrak/yakitrak/obsidian-cli"
      "yt-dlp"
      "zeroclaw"
    ];

    # Mini-specific casks (shared.nix provides: 1password, aerospace, ghostty, google-chrome, obsidian, raycast)
    # masApps from shared.nix: Drafts, Spark, Things
    casks = [
      "bluebubbles"
      "claude-code"
      "screens-connect"
      "openclaw"
      "utm"
    ];

    masApps = {
    };
  };

  # Mac Mini dock settings - minimal
  system.defaults.dock.persistent-apps = [
    "/Applications/Ghostty.app"
  ];
}
