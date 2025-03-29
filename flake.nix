{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        config = { allowUnfree = true; };
      };

    in {
      nixosConfigurations = {
        framework16 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };
          modules =
            [ ./hosts/framework16/configuration.nix ./home/default.nix ];
        };
      };
    };
}
