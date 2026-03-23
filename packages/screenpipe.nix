# Screenpipe CLI — prebuilt arm64 binary from the @screenpipe/cli-darwin-arm64 npm package.
# Links only against macOS system frameworks so no library patching is needed.
# Update: bump version + re-run `nix-prefetch-url <new-tgz-url>` to get the new hash.
{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "screenpipe";
  version = "0.3.201";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@screenpipe/cli-darwin-arm64/-/cli-darwin-arm64-${version}.tgz";
    hash = "sha256-tbvP1/mnJ0xxSbE5+ZuyI/t+R40Uiww02Gk7yIkWNiU=";
  };

  # The tgz unpacks to ./package/
  sourceRoot = "package";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/screenpipe $out/bin/
    chmod +x $out/bin/screenpipe
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Build AI apps that have the full context of your screen and audio";
    homepage = "https://github.com/screenpipe/screenpipe";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "screenpipe";
  };
}
