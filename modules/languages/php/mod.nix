{ ... }:
let
  phpModule =
    debug:
    { lib, pkgs, ... }:
    let
      php = pkgs.php85;
      configured = php.buildEnv {
        extensions =
          { enabled, all }:
          enabled
          ++ [
            all.imagick
            all.pcov
          ]
          ++ lib.optionals debug [ all.xdebug ];
        extraConfig = ''
          memory_limit = 2G
          upload_max_filesize = 64M
          post_max_size = 64M
        '';
      };
      phpProfile = pkgs.writeShellScriptBin "phpp" ''
        exec ${configured}/bin/php -d xdebug.mode=profile -d xdebug.start_with_request=yes -d xdebug.output_dir="$PWD" -d xdebug.profiler_output_name="cachegrind.out.%p.%t" "$@"
      '';
      phpTrace = pkgs.writeShellScriptBin "phpt" ''
        exec ${configured}/bin/php -d xdebug.mode=trace -d xdebug.trace_options=0 -d xdebug.trace_format=1 -d xdebug.start_with_request=yes -d xdebug.output_dir="$PWD" -d xdebug.trace_output_name="trace.%p.%t" -d xdebug.collect_return=1 -d xdebug.collect_assignments=1 -d xdebug.collect_params=4 "$@"
      '';
    in
    {
      home.packages = [
        configured
        configured.packages.composer
      ]
      ++ lib.optionals debug [
        phpProfile
        phpTrace
        pkgs.kdePackages.kcachegrind
      ];
    };
in
{
  flake.modules.homeManager.php = phpModule false;
  flake.modules.homeManager.php-debug = phpModule true;
}
