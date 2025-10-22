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

  # Personal Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    taps = [
      "alexanderwillner/tap"
      "appleboy/tap"
      "aws/tap"
      "bbc/audiowaveform"
      "dart-lang/dart"
      "garden-io/garden"
      "hashicorp/tap"
      "heroku/brew"
      "mrkai77/cask"
      "netlify/git-credential-netlify"
      "nikitabobko/tap"
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
      "appleboy/tap/codegpt"
      "coreutils"
      "dash"
      "gh"
      "homeassistant-cli"
      "ipsw"
      "mas"
      "oxen-ai/oxen/oxen"
      "python@3.12"
      "ubuntu/microk8s/microk8s"
    ];

    casks = [
      "1password"
      "airfoil"
      "alfred"
      "nikitabobko/tap/aerospace"
      "audio-hijack"
      "balenaetcher"
      "bibdesk"
      "busycontacts"
      "cardhop"
      "chatgpt"
      "chatgpt-atlas"
      "claude"
      "cleanshot"
      "comet-ai"
      "cursor"
      "dash"
      "devonthink"
      "discord"
      "disk-inventory-x"
      "fantastical"
      "farrago"
      "figma"
      "find-any-file"
      "firefox"
      "fission"
      "font-monaspace"
      "fontforge-app"
      "gemini"
      "ghostty"
      "gitbutler"
      "gitup-app"
      "google-chrome"
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
      "keyboard-maestro"
      "limitless"
      "loopback"
      "losslesscut"
      "minstaller"
      "neofinder"
      "ngrok"
      "nordvpn"
      "notion-calendar"
      "notion"
      "numi"
      "obsidian"
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
      "raycast"
      "reader"
      "readwise-ibooks"
      "reaper"
      "resilio-sync"
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
      "thingsmacsandboxhelper"
      "utm"
      "visual-studio-code"
      "zoom"
    ];

    masApps = {
      "Actions For Obsidian" = 1659667937;
      "Actions" = 1586435171;
      "Black Out" = 1319884285;
      "Cardhop" = 1290358394;
      "ColorSlurp" = 1287239339;
      "DaisyDisk" = 411643860;
      "djay Pro" = 450527929;
      "Drafts" = 1435957248;
      "Due" = 524373870;
      "FileBot" = 905384638;
      "MindNode Next" = 6446116532;
      "OmniFocus" = 1542143627;
      "Pixelmator" = 407963104;
      "Ring" = 1142753258;
      "Screens 5" = 1663047912;
      "Soro" = 1550457805;
      "Soulver 2" = 413965349;
      "Tailscale" = 1475387142;
      "Things" = 904280696;
      "Webp Converter" = 1527716894;
      "Xcode" = 497799835;
      "Yoink" = 457622435;
      "iA Writer" = 775737590;
    };
  };
}
