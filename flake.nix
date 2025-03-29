{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        config = { allowUnfree = true; };
      };

    in {
      nixosConfigurations = {
        framework16 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [
            ./hosts/framework16/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nciechanowski = {
                imports = [ ./home/default.nix ./modules/neovim.nix ];
              };
            }
          ];
        };
      };

      homeConfigurations = {
        vagrant = home-manager.lib.homeManagerConfiguration {
          inherit system;
          users.vagrant = {
            imports = [ ./home/default.nix ./modules/neovim.nix ];
          };
        };
      };
    };
}
