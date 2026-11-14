{ lib, ... }:
{
  flake.modules.homeManager.zig =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      home.packages = with pkgs; [
        zig
      ];

    };
}
