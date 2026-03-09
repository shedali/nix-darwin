{ pkgs, ... }: {
  imports = [ ./shared.nix ];

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

  # Personal Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    # Personal taps (nikitabobko/tap comes from shared.nix)
    taps = [
      "appleboy/tap"
      "atlassian/homebrew-acli"
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
      "ubuntu/microk8s"
      "vitorgalvao/tiny-scripts"
      "wix/brew"
      "yulrizka/tap"
    ];

    brews = [
      "agent-browser"
      "acli"
      "aichat"
      "appleboy/tap/codegpt"
      "mods"
      "ollama"
      "coreutils"
      "dash"
      "gh"
      "homeassistant-cli"
      "ipsw"
      "mas"
      "python@3.12"
      # "syncthing"  # commented out — not needed on macbook
      "tinymist"
      "typst"
      "ubuntu/microk8s/microk8s"
      "yt-dlp"
      "zeroclaw"
    ];

    # Personal casks (1password, aerospace, ghostty, google-chrome, obsidian, raycast come from shared.nix)
    # masApps: Drafts, Spark, Things come from shared.nix
    casks = [
      "airfoil"
      "antigravity"
      "atuin-desktop"
      "alfred"
      "audio-hijack"
      "autodesk-fusion"
      "bambu-studio"
      "balenaetcher"
      "bibdesk"
      "busycontacts"
      "cardhop"
      "chatgpt"
      "chatgpt-atlas"
      "claude"
      "claude-island"
      "codex-app"
      "cleanshot"
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
      "ngrok"
      "nordvpn"
      "notion-calendar"
      "notion"
      "numi"
      "opera@beta"
      "orbstack"
      "parallels"
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
      "Cardhop" = 1290358394;
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
