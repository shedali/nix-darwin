{ pkgs, ... }:
let
  screenpipe = pkgs.callPackage ./packages/screenpipe.nix { };
in
{
  imports = [ ./shared.nix ];

  environment.systemPackages = [ screenpipe ];

  # Espanso text expander - launcher spawns daemon then exits
  launchd.user.agents.espanso = {
    path = [ "/opt/homebrew/bin" ];
    serviceConfig = {
      ProgramArguments = [ "/opt/homebrew/bin/espanso" "launcher" ];
      KeepAlive = false;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/espanso.err.log";
      StandardOutPath = "/tmp/espanso.out.log";
    };
  };

  # Whisper.cpp speech-to-text server (OpenAI-compatible API on port 8090)
  launchd.user.agents.whisper-server = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.whisper-cpp}/bin/whisper-server"
        "--model" "/Users/franz/.local/share/whisper-cpp/ggml-large-v3-turbo-q5_0.bin"
        "--port" "8090"
        "--host" "127.0.0.1"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/whisper-server.err.log";
      StandardOutPath = "/tmp/whisper-server.out.log";
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

  # Parkour offline-first daemon (specs/OFFLINE-CLI-DAEMON.md): a warm local
  # Y.Doc for the CLI's primary room, replacing the historical per-invocation
  # WebsocketProvider that pulled the whole ~240KB doc on every `bun run cli`
  # call. `bun run cli daemon` reads PARKOUR_ROOM/PARKOUR_API_KEY/
  # PARKOUR_SYNC_URL from the repo's own `.env` (bun auto-loads it from
  # WorkingDirectory) — no room id or credential is hardcoded here.
  launchd.user.agents.parkour-daemon = {
    serviceConfig = {
      ProgramArguments = [
        "/Users/franz/.nix-profile/bin/bun"
        "run"
        "cli"
        "daemon"
      ];
      WorkingDirectory = "/Users/franz/dev/shedali/parkour";
      KeepAlive = true;
      RunAtLoad = true;
      ThrottleInterval = 30;
      StandardErrorPath = "/tmp/parkour-daemon.err.log";
      StandardOutPath = "/tmp/parkour-daemon.out.log";
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
        nodeName = "personal-mac";
        ffmpegPath = "${pkgs.ffmpeg}/bin/ffmpeg";
      };
      KeepAlive = true;
      RunAtLoad = true;
      ThrottleInterval = 30;
      StandardErrorPath = "/tmp/tdarr-node.err.log";
      StandardOutPath = "/tmp/tdarr-node.out.log";
    };
  };

  # Personal Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.autoUpdate = false;
    onActivation.upgrade = false;
    onActivation.cleanup = "zap";

    # Personal taps (nikitabobko/tap comes from shared.nix)
    taps = [
      "appleboy/tap"
      "atlassian/homebrew-acli"
      "manaflow-ai/cmux"
      "aws/tap"
      "bbc/audiowaveform"
      "dart-lang/dart"
      "garden-io/garden"
      "hashicorp/tap"
      "heroku/brew"
      "mrkai77/cask"
      "netlify/git-credential-netlify"
      "sambadevi/powerlevel9k"
      "saulpw/vd"
      "sbdchd/skim"
      "turbot/tap"
      "vitorgalvao/tiny-scripts"
      "wix/brew"
      "yulrizka/tap"
    ];

    brews = [
      "agent-browser"
      "acli"
      "cloudflared"
      "aichat"
      "appleboy/tap/codegpt"
      "mods"
      "ollama"
      "coreutils"
      "dash"
      "homeassistant-cli"
      "ipsw"
      "python@3.12"
      # "syncthing"  # commented out — not needed on macbook
      "tinymist"
      "typst"
      "yt-dlp"
      "zeroclaw"
    ];

    # Personal casks (1password, aerospace, ghostty, google-chrome, obsidian, raycast come from shared.nix)
    # masApps: Drafts, Spark, Things come from shared.nix
    casks = [
      "manaflow-ai/cmux/cmux"
      "airfoil"
      "antigravity"
      "atuin-desktop"
      "alfred"
      "audio-hijack"
      "autodesk-fusion"
      "bambu-studio"
      # "ngrok"       # broken cask: undefined method 'postflight_steps' (brew bug)
      # "parallels"   # broken cask: undefined method 'uninstall_preflight_steps' (brew bug)
      "balenaetcher"
      "bibdesk"
      "busycontacts"
      "cardhop"
      "chatgpt"
      "chatgpt-atlas"
      "claude"
      # The CLI, not the desktop app above. `@latest` tracks the fast release
      # channel — plain `claude-code` lags it (2.1.212 vs 2.1.220 when added).
      # Deliberately NOT the nixpkgs package: Claude Code ships faster than
      # nixpkgs lands it, and being current matters more here than
      # reproducibility. Sole owner — see modules/packages.nix in home-manager.
      "claude-code@latest"
      "cleanshot"
      "codex-app"
      "cursor"
      "dash"
      "devonthink"
      "discord"
      "disk-inventory-x"
      "dropbox"
      "espanso"
      "fantastical"
      "farrago"
      "figma"
      "find-any-file"
      "firefox"
      "fission"
      "font-monaspace"
      "fontforge-app"
      "gemini"
      "gitbutler"
      "gitup-app"
      "google-drive"
      "hammerspoon"
      "handbrakebatch"
      "hazel"
      "hdhomerun"
      "hookmark"
      "iina"
      "insta360-studio"
      "instantview"
      "jabref"
      "kaleidoscope"
      "keyboard-maestro"
      "loopback"
      "losslesscut"
      "minstaller"
      "neofinder"
      "nordvpn"
      "notion-calendar"
      "notion"
      "numi"
      "opera@beta"
      "opencode-desktop"
      "orbstack"
      "path-finder"
      "pdf-expert"
      "piezo"
      "pixelsnap"
      "plex"
      "plexamp"
      "pocket-casts"
      "popclip"
      "qlmarkdown"
      "reader"
      "readwise-ibooks"
      "reaper"
      "resilio-sync"
      "rocket"
      "responsively"
      "screens-connect"
      "screenflow"
      "signal"
      "slack"
      "sonos"
      "sony-ps-remote-play"
      "soundsource"
      "sublime-merge"
      "sublime-text"
      "telegram"
      "termius"
      "thingsmacsandboxhelper"
      "typeless"
      "utm"
      "visual-studio-code"
      "warp"
      "wispr-flow"
      "zoom"
    ];

    masApps = {
      "Actions For Obsidian" = 1659667937;
      "Actions" = 1586435171;
      "Spark Classic" = 1176895641;
      "Black Out" = 1319884285;
      "ColorSlurp" = 1287239339;
      "DaisyDisk" = 411643860;
      "djay Pro" = 450527929;
      "Due" = 524373870;
      "FileBot" = 905384638;
      "MindNode Next" = 6446116532;
      "OmniFocus" = 1542143627;
      "Pixelmator" = 407963104;
      "Ring" = 1142753258;
      "Screens 5" = 1663047912;
      "Soro" = 1550457805;
      "Soulver 2" = 413965349;
      "Webp Converter" = 1527716894;
      "Xcode" = 497799835;
      "Yoink" = 457622435;
      "iA Writer" = 775737590;
    };
  };
}
