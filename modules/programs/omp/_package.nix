{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  bun,
  ompSource,
}:
let
  platform =
    {
      x86_64-linux = {
        asset = "omp-linux-x64";
        hash = "sha256:9513ef9f19d7991aac6ae0cb6077bcf16662092ddde861c002a91cedc6f47f9a";
      };
      aarch64-linux = {
        asset = "omp-linux-arm64";
        hash = "sha256:967d64fce514586e94c9ac5f978743b4fce29b999c8763747ce4754811407d1a";
      };
      x86_64-darwin = {
        asset = "omp-darwin-x64";
        hash = "sha256:dcd3fa827ae73bdb471bb838171ef1c9c5be665a68eaec45ffc6d6e5cf128b92";
      };
      aarch64-darwin = {
        asset = "omp-darwin-arm64";
        hash = "sha256:abd9a5b0fef77f4204078e348e233faa0dd3d5d81719cf2b6a9b9478c10eee48";
      };
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported precompiled OMP platform: ${stdenvNoCC.hostPlatform.system}");
  runtimeLibraries = lib.optionals stdenvNoCC.hostPlatform.isLinux (
    [ stdenv.cc.cc.lib ] ++ lib.optional (stdenv.cc.cc ? libgcc) stdenv.cc.cc.libgcc
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "omp-bin";
  version = "18.12.2";

  src = fetchurl {
    url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/${platform.asset}";
    inherit (platform) hash;
  };

  dontUnpack = true;
  dontStrip = true;
  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
    makeWrapper
    bun
  ];
  buildInputs = runtimeLibraries;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/omp"
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    patchelf --add-needed libstdc++.so.6 "$out/bin/omp"
    wrapProgram "$out/bin/omp" \
      --set-default OMP_NATIVE_LIBRARY_PATH "${lib.makeLibraryPath runtimeLibraries}"
  '';

  # Bun binaries need this repair after patchelf moves their version tables.
  preInstallCheck = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    bun ${ompSource}/scripts/fix-dt-verdef.ts "$out/bin/.omp-wrapped"
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    smokeOutput="$(HOME="$TMPDIR" "$out/bin/omp" --smoke-test)"
    grep -q "smoke-test: ok" <<<"$smokeOutput"
    runHook postInstallCheck
  '';

  meta = {
    description = "Precompiled OMP coding agent";
    homepage = "https://github.com/can1357/oh-my-pi";
    license = lib.licenses.mit;
    mainProgram = "omp";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
