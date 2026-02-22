# Zig
# Provides Zig development environment for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.languages.zig.enable = lib.mkEnableOption "Zig development environment";

  config = lib.mkIf config.features.languages.zig.enable {
    home.packages = with pkgs; [
      zig_0_15
    ];
  };
}
