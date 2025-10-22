{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.languages.lua.enable {
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
