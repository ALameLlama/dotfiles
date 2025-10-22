{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  phpWithConfig = pkgs.php.buildEnv {
    extensions = { enabled, all }: enabled ++ [ all.imagick ];
    extraConfig = ''
      memory_limit = 512M
      upload_max_filesize = 64M
      post_max_size = 64M
    '';
  };
in
{
  config = mkIf config.features.languages.php.enable {
    home.packages =  with pkgs; [
      phpWithConfig
      php.packages.composer
    ];
  };
}
