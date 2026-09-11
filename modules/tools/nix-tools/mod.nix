{ lib, ... }:
{
  flake.modules.homeManager.nix-tools = {
  config,
  lib,
  pkgs,
  ...
}:
{

  
    home.packages = with pkgs; [
      alejandra
      deadnix
      nixd
      statix
      nixfmt
      nixpkgs-review
    ];
  
}
;
}
