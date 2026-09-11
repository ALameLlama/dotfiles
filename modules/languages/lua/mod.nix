{ lib, ... }:
{
  flake.modules.homeManager.lua =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

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
