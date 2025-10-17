{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.languages.javascript.enable {
    home.packages = with pkgs; [
      nodejs
      fnm
    ];
  };
}
