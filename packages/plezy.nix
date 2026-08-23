# Plezy — third-party Plex/Jellyfin client (github.com/edde746/plezy).
#
# Not in nixpkgs and not in homebrew-cask (checked against the full cask index,
# 2026-08-23), and the App Store listing is the iOS build only. The desktop app
# ships solely as a notarized DMG on GitHub Releases, so we unpack that.
#
# The DMG is an LZMA-compressed APFS image, which `undmg` cannot read — 7zz can,
# and it round-trips the framework symlinks so the Developer ID signature still
# verifies after extraction (`codesign --verify --deep --strict` passes).
# `dontFixup` is required: the default darwin fixup phase strips binaries, which
# would invalidate that signature and leave Gatekeeper refusing to launch it.
#
# Update: bump version, then
#   nix hash file <(curl -sL https://github.com/edde746/plezy/releases/download/<ver>/plezy-macos.dmg)
# or simply set a wrong hash and copy the one nix reports.
{ pkgs }:

pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plezy";
  version = "2.16.0";

  src = pkgs.fetchurl {
    url = "https://github.com/edde746/plezy/releases/download/${finalAttrs.version}/plezy-macos.dmg";
    hash = "sha256-h1aBFYEP1ie6v9BZZ/vH0b+fQL047tMZz3tASwnkcWI=";
  };

  nativeBuildInputs = [ pkgs._7zz ];

  sourceRoot = ".";

  unpackPhase = ''
    runHook preUnpack
    7zz x -y "$src" > /dev/null
    runHook postUnpack
  '';

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R Plezy.app "$out/Applications/"
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Modern cross-platform Plex & Jellyfin client";
    homepage = "https://plezy.app/";
    license = licenses.gpl3Only;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
