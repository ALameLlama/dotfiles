{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.features.tools.utilities.enable {
    home.packages = with pkgs; [
      dive
      opencode
      lsof
    ];
  };
}
