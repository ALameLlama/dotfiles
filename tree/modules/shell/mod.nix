# Shell
# Provides zsh/starship/carapace configuration

{ lib }:
{
  flake.nixosModules.shell = import ./nixos.nix { inherit lib; };
  flake.homeModules.shell = import ./home.nix { inherit lib; };
}
