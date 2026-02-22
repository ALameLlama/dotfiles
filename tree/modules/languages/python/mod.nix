# Python
# Provides Python development environment for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.languages.python.enable = lib.mkEnableOption "Python development";

  config = lib.mkIf config.features.languages.python.enable {
    home.packages = with pkgs; [
      (python313.withPackages (
        p: with p; [
          playwright
          pip
          uv
        ]
      ))
    ];
  };
}
