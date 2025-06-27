{ config, lib, pkgs, ... }:

let
  phpWithConfig = pkgs.php.buildEnv {
    extensions = { enabled, all }: enabled ++ [ all.imagick ];
    extraConfig = ''
      memory_limit = 512M
      upload_max_filesize = 64M
      post_max_size = 64M
    '';
  };
in { home.packages = [ phpWithConfig pkgs.php.packages.composer ]; }

