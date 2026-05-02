# JavaScript/Node.js
# Provides JavaScript/Node.js development environment

{ lib }:
{
  flake.nixosModules.javascript = import ./nixos.nix { inherit lib; };
  flake.homeModules.javascript = import ./home.nix { inherit lib; };
}
