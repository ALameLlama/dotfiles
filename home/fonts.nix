{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.tools.fonts.enable {
    home.packages = with pkgs; [
      maple-mono.NF
    ];
  };
}
