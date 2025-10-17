{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.languages.lua.enable {
    home.packages = [
      pkgs.pkg-config
      pkgs.lux-cli
      (pkgs.luajit.withPackages (
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
