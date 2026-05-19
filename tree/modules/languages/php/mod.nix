# PHP
# Provides PHP development environment

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  php = pkgs.php85;

  basePhpExtensions = all: [
    all.imagick
    all.pcov

  ];

  basePhpConfig = ''
    memory_limit = 2G
    upload_max_filesize = 64M
    post_max_size = 64M
  '';

  makePhp =
    extraExtensions:
    php.buildEnv {
      extensions = { enabled, all }: enabled ++ basePhpExtensions all ++ extraExtensions all;

      extraConfig = basePhpConfig;
    };

  phpWithConfig = makePhp (_: [ ]);

  phpWithConfigDebug = makePhp (all: [
    all.xdebug
  ]);

  phpActive =
    if config.features.languages.php.debug.enable then phpWithConfigDebug else phpWithConfig;

  phpProfile = pkgs.writeShellScriptBin "phpp" ''
    exec ${phpWithConfigDebug}/bin/php \
      -d xdebug.mode=profile \
      -d xdebug.start_with_request=yes \
      -d xdebug.output_dir="$PWD" \
      -d xdebug.profiler_output_name="cachegrind.out.%p.%t" \
      "$@"
  '';

  phpTrace = pkgs.writeShellScriptBin "phpt" ''
    exec ${phpWithConfigDebug}/bin/php \
      -d xdebug.mode=trace \
      -d xdebug.trace_options=0 \
      -d xdebug.trace_format=1 \
      -d xdebug.start_with_request=yes \
      -d xdebug.output_dir="$PWD" \
      -d xdebug.trace_output_name="trace.%p.%t" \
      -d xdebug.collect_return=1 \
      -d xdebug.collect_assignments=1 \
      -d xdebug.collect_params=4 \
      "$@"
  '';
in
{
  options.features.languages.php = {
    enable = lib.mkEnableOption "PHP development";

    debug.enable = lib.mkEnableOption "PHP debugging/profiling tools";
  };

  config = lib.mkIf config.features.languages.php.enable {
    home.packages =
      with pkgs;
      [
        phpActive
        phpActive.packages.composer
      ]
      ++ lib.optionals config.features.languages.php.debug.enable [
        phpProfile
        phpTrace
        kdePackages.kcachegrind
      ];
  };
}
