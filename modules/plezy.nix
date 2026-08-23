# Plezy, the third-party Plex client. Imported by the profiles that want it
# (personal, chasehost, air) — deliberately not in shared.nix, which mini also
# imports and which has no use for a GUI media client.
#
# Lands in /Applications/Nix Apps rather than /Applications, like every other
# nix-installed .app.
{ pkgs, ... }:
let
  plezy = pkgs.callPackage ../packages/plezy.nix { };
in
{
  environment.systemPackages = [ plezy ];

  # The bundle ships Sparkle and points at an appcast. A self-update would try to
  # rewrite the app inside the read-only nix store and fail every time, so turn it
  # off and let the version pin in packages/plezy.nix be the single source of truth
  # (same reasoning as the tdarr-node pin in shared.nix).
  system.defaults.CustomUserPreferences."com.edde746.plezy" = {
    SUEnableAutomaticChecks = false;
    SUAutomaticallyUpdate = false;
  };
}
