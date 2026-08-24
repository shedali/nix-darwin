{ pkgs, lib, config, ... }: {
  # Chase VM profile - for Chase virtual machines (standalone, does not import shared.nix)
  imports = [ ./base.nix ];

  # Override base.nix packages — exclude neovim (its nixpkg fetches from npmjs, blocked by Netskope)
  # neovim is installed via brew instead
  environment.systemPackages = lib.mkForce [ pkgs.vim ];

  # Work Homebrew configuration - minimal set for work
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    # Declare every tap the brews/casks below come from. Leaving this empty does
    # not stop brew resolving `acli` and `aerospace` through already-installed
    # taps -- it just means `brew bundle --cleanup` sees them as unmanaged and
    # reports "Would untap", which exits 1 and fails the whole activation.
    taps = [
      "atlassian/homebrew-acli"
      "nikitabobko/homebrew-tap"
    ];

    brews = [
      "acli"
      "gh"
      "git-lfs"
      "llmfit"
      "mas"
      "neovim"
    ];

    casks = [
      "1password"
      "aerospace"
      "ghostty"
      "google-chrome"
      "slack"
      "warp"
    ];

    masApps = {};
  };

  # Pre-trust the third-party taps before `brew bundle` runs.
  #
  # Homebrew refuses to load formulae/casks from untrusted taps, which fails the
  # bundle as a whole -- so a fresh VM installs none of the casks, 1Password
  # included. `brew trust` cannot be used here because nix-darwin invokes brew as
  # `sudo --preserve-env=PATH --user=... --set-home env brew bundle`: XDG_CONFIG_HOME
  # is not preserved, so brew reads ~/.homebrew/trust.json, not the
  # ~/.config/homebrew/trust.json that an interactive `brew trust` writes.
  system.activationScripts.preActivation.text = ''
    HOME_DIR=$(/usr/bin/dscl . -read "/Users/${config.system.primaryUser}" NFSHomeDirectory | /usr/bin/awk '{print $2}')
    if [ -n "$HOME_DIR" ] && [ -d "$HOME_DIR" ]; then
      /bin/mkdir -p "$HOME_DIR/.homebrew"
      /usr/bin/printf '{"trustedtaps":["atlassian/acli","nikitabobko/tap"]}\n' \
        > "$HOME_DIR/.homebrew/trust.json"
      /usr/sbin/chown -R "${config.system.primaryUser}" "$HOME_DIR/.homebrew"
    fi
  '';

  system.defaults.dock.persistent-apps = [
    "/Applications/Ghostty.app"
    "/Applications/Slack.app"
    "/Applications/Google Chrome.app"
  ];
}
