# Modern Nix Home Manager Configuration
# This file now only imports the core configuration and features system
# All specific programs and languages are conditionally loaded via the features system

{ config, pkgs, ... }:
{
  imports = [
    ./features.nix
    ./core.nix
  ];

  # All other configuration is now managed through the features system
  # and enabled/disabled via profiles (see ./profiles/ directory)
}
