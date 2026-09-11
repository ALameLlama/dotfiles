{ lib, ... }:
{
  flake.modules.homeManager.fonts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      home.packages = with pkgs; [
        maple-mono.NF
      ];

    };
}
