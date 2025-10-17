{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.languages.go.enable {
    home.packages = with pkgs; [
      go
    ];
  };
}
