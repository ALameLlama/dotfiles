{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.features.languages.go.enable {
    home.packages = with pkgs; [
      go
    ];
  };
}
