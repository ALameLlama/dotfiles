{ lib, ... }:
{
  flake.modules.homeManager.rust = {
  config,
  lib,
  pkgs,
  ...
}:
{

  
    home.packages = with pkgs; [
      # rustup
      cargo
      clippy
      rust-analyzer
      rustc
      rustfmt
    ];
  
}
;
}
