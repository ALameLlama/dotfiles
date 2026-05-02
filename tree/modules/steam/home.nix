# Steam NixOS module

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.programs.steam = {
    enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkMerge [
    (lib.mkIf config.features.programs.steam.enable {
      home.packages = with pkgs; [
        steam
      ];
    })
  ];
}
