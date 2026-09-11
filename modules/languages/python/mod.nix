{ lib, ... }:
{
  flake.modules.homeManager.python = {
  config,
  lib,
  pkgs,
  ...
}:
{

  
    home.packages = with pkgs; [
      (python313.withPackages (
        p: with p; [
          playwright
          pip
          uv
        ]
      ))
    ];
  
}
;
}
