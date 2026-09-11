{ inputs, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.default
    inputs.flake-parts.flakeModules.modules
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt-tree;
  };

  flake-file = {
    description = "Llamas NixOS Configuration - Dendritic Pattern";
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      flake-file.url = "github:denful/flake-file";
      flake-parts.url = "github:hercules-ci/flake-parts";
      import-tree.url = "github:denful/import-tree";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    };
    outputs = "dendritic";
  };
}
