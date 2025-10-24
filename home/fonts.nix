{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.features.tools.fonts.enable {
    home.packages = with pkgs; [
      maple-mono.NF
    ];
  };
}
