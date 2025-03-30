{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      framework16 = let
        username = "nciechanowski";
        specialArgs = { inherit username; };
      in nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/framework16/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} =
              import ./users/${username}/home.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      vagrant = home-manager.lib.homeManagerConfiguration {
        modules = [
          ./home/default.nix
          ./home/neovim.nix
          {
            home = {
              username = "vagrant";
              homeDirectory = "/home/vagrant";
            };
          }
        ];
      };
    };
  };
}
