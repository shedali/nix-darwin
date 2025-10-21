{ pkgs, ... }: {
  imports = [ ./shared.nix ];

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
      "homebrew/bundle"
      "homebrew/services"
      "mrkai77/cask"
      "netlify/git-credential-netlify"
      "nikitabobko/tap"
      "oxen-ai/oxen"
      "render-oss/render"
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
      "httpie"
      "ipsw"
      "mas"
      "oxen-ai/oxen/oxen"
      "python@3.12"
      "render-oss/render/render"
      "sbdchd/skim/skim"
      "ubuntu/microk8s/microk8s"
    ];

    casks = [
      "1password"
      "airfoil"
      "alacritty"
      "alfred"
      "nikitabobko/tap/aerospace"
      "arc"
      "audio-hijack"
      "balenaetcher"
      "bibdesk"
      "busycontacts"
      "calibre"
      "cardhop"
      "chatgpt"
      "claude"
      "cleanshot"
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
      "fork"
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
      "hiddenbar"
      "hookmark"
      "iina"
      "insta360-studio"
      "instantview"
      "jabref"
      "keyboard-maestro"
      "limitless"
      "loopback"
      "losslesscut"
      "macfuse"
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
      "spotify"
      "sublime-merge"
      "sublime-text"
      "telegram"
      "thingsmacsandboxhelper"
      "utm"
      "visual-studio-code"
      "whatsapp"
      "workflowy"
      "zoom"
    ];

    masApps = {
      "Actions For Obsidian" = 1659667937;
      "Actions" = 1586435171;
      "Black Out" = 1319884285;
      "Cardhop" = 1290358394;
      "ColorSlurp" = 1287239339;
      "Comic Life 3" = 688953417;
      "Compressor" = 424390742;
      "DaisyDisk" = 411643860;
      "Day One" = 1055511498;
      "Divvy" = 413857545;
      "djay Pro" = 450527929;
      "Drafts" = 1435957248;
      "Due" = 524373870;
      "ExcalidrawZ" = 6636493997;
      "Exporter" = 1099120373;
      "FileBot" = 905384638;
      "Frame.io" = 992958444;
      "ImageOptim" = 1450716465;
      "Ivory" = 6444602274;
      "Kaleidoscope" = 1575557335;
      "Keynote" = 409183694;
      "Logic Pro" = 634148309;
      "MindNode Next" = 6446116532;
      "Numbers" = 409203825;
      "OmniFocus" = 1542143627;
      "OmniGraffle" = 1142578753;
      "OneDrive" = 823766827;
      "Overlap" = 1516950324;
      "Pages" = 409201541;
      "Paprika Recipe Manager 3" = 1303222628;
      "Pixelmator" = 407963104;
      "Prime Video" = 545519333;
      "Reeder" = 1529448980;
      "Ring" = 1142753258;
      "Screens 5" = 1663047912;
      "Soro" = 1550457805;
      "Soulver 2" = 413965349;
      "Spark" = 1176895641;
      "Tailscale" = 1475387142;
      "Things" = 904280696;
      "Webp Converter" = 1527716894;
      "WhatsApp" = 310633997;
      "WiFi Explorer" = 494803304;
      "Xcode" = 497799835;
      "Yoink" = 457622435;
      "iA Writer" = 775737590;
    };
  };
}
