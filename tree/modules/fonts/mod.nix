# Fonts dendritic module
# Provides custom fonts for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.tools.fonts.enable = lib.mkEnableOption "Custom fonts";

  config = lib.mkIf config.features.tools.fonts.enable {
    home.packages = with pkgs; [
      maple-mono.NF
    ];
  };
}
