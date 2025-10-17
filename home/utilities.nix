{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.tools.utilities.enable {
    home.packages = with pkgs; [
      dive
      opencode
      lsof
    ];
  };
}
