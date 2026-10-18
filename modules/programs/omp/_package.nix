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
        hash = "sha256:01fbb5f08b0ce0d70bd0b1d6655a6ccd59cefcae0f1023e02bb30f9a70bc2d0a";
      };
      aarch64-linux = {
        asset = "omp-linux-arm64";
        hash = "sha256:c39cf4ab3633a7003a37c619744838125a99208d36ca748e59c4e62815170cba";
      };
      x86_64-darwin = {
        asset = "omp-darwin-x64";
        hash = "sha256:42f51af9b9d015a4c422283b803378fceca9a6b0516809797485ade298d07b3a";
      };
      aarch64-darwin = {
        asset = "omp-darwin-arm64";
        hash = "sha256:d518310d647d467a2c5c3f2d38e34489a761996d766395c03b37c61a2203d02b";
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
  version = "18.11.3";

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
