# PHP
# Provides PHP development environment for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
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
  options.features.languages.php.enable = lib.mkEnableOption "PHP development environment";

  config = lib.mkIf config.features.languages.php.enable {
    home.packages = with pkgs; [
      phpWithConfig
      php.packages.composer
    ];
  };
}
