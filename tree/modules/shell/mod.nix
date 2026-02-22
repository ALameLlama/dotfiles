# Shell
# Provides zsh/starship/carapace configuration for home-manager and nixos

{ lib }:
{
  flake.nixosModules.shell = import ./nixos.nix { inherit lib; };
  flake.homeModules.shell = import ./home.nix { inherit lib; };
}
