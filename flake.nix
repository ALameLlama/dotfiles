{
  description = "NixOS Configuration";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, determinate, ... }@inputs:
    let
      system = builtins.currentSystem;
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in {
      nixosConfigurations = {
        framework16 = let
          username = "nciechanowski";
          specialArgs = {
            inherit username;
            inherit pkgs;
          };
        in nixpkgs.lib.nixosSystem {
          modules = [
            determinate.nixosModules.default
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
          inherit pkgs;
          modules = [
            ./home/default.nix
            ./home/programs/neovim
            ./home/programs/tmux
            ./home/programs/shell
            ./home/programs/cli-tooling
            {
              home = {
                username = "vagrant";
                homeDirectory = "/home/vagrant";
              };
              nix.package = pkgs.nix;
            }
          ];
        };
      };
    };
}
