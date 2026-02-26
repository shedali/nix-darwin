{ pkgs, ... }: {
  imports = [ ./shared.nix ];

  # Personal Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    # Personal taps (nikitabobko/tap comes from shared.nix)
    taps = [
      "alexanderwillner/tap"
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
      "oxen-ai/oxen"
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
      "acli"
      "appleboy/tap/codegpt"
      "coreutils"
      "dash"
      "gh"
      "homeassistant-cli"
      "ipsw"
      "mas"
      "oxen-ai/oxen/oxen"
      "python@3.12"
      "syncthing"
      "ubuntu/microk8s/microk8s"
    ];

    # Personal casks (1password, aerospace, ghostty, google-chrome, obsidian, raycast come from shared.nix)
    # masApps: Drafts, Spark, Things come from shared.nix
    casks = [
      "airfoil"
      "antigravity"
      "alfred"
      "bambu-studio"
      "audio-hijack"
      "autodesk-fusion"
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
      "whisperflow"
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
