{ pkgs, ... }: {
  imports = [ ./shared.nix ];

  # Launch AeroSpace automatically
  launchd.user.agents.aerospace = {
    path = [ "/usr/bin" "/usr/local/bin" ];
    serviceConfig = {
      ProgramArguments = [ "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/aerospace.err.log";
      StandardOutPath = "/tmp/aerospace.out.log";
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
