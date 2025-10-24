{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.features.languages.javascript.enable {
    home.packages = with pkgs; [
      nodejs
      fnm
    ];
  };
}
