{ lib, stdenvNoCC, fetchurl }:
let
  sources = builtins.fromJSON (builtins.readFile ./_sources.json);
in
stdenvNoCC.mkDerivation {
  pname = "magpie";
  version = sources.version;

  src = fetchurl {
    url = "https://github.com/yetone/magpie-releases/releases/download/v${sources.version}/magpie-cli-linux-amd64";
    hash = sources.hash;
  };

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/magpie"
    runHook postInstall
  '';

  meta = {
    mainProgram = "magpie";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    homepage = "https://usemagpie.ai/";
  };
}
