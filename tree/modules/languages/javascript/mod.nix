# JavaScript/Node.js dendritic module
# Provides JavaScript/Node.js development environment for home-manager and nixos

{ lib }:
{
  flake.nixosModules.javascript = import ./nixos.nix { inherit lib; };
  flake.homeModules.javascript = import ./home.nix { inherit lib; };
}
