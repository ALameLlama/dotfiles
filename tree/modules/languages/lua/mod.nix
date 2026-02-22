# Lua dendritic module
# Provides Lua development environment for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.languages.lua.enable = lib.mkEnableOption "Lua development environment";

  config = lib.mkIf config.features.languages.lua.enable {
    home.packages = with pkgs; [
      lux-cli
      (luajit.withPackages (
        p: with p; [
          luarocks
          lux-lua
          busted
          inspect
        ]
      ))
    ];
  };
}
