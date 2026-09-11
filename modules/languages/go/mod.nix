{ lib, ... }:
{
  flake.modules.homeManager.go = {
  config,
  lib,
  pkgs,
  ...
}:
{

  
    home.packages = with pkgs; [
      go
    ];
  
}
;
}
