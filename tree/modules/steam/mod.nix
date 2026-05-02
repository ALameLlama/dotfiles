# Steam
# Provides Steam configuration

{ lib }:
{
  flake.nixosModules.steam = import ./nixos.nix { inherit lib; };
  flake.homeModules.steam = import ./home.nix { inherit lib; };
}
