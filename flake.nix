{
  description = "NixOS Configuration";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      determinate,
      ...
    }@inputs:
    let
      system = builtins.currentSystem;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        razorback =
          let
            username = "nciechanowski";
            specialArgs = {
              inherit username;
              inherit pkgs;
            };
          in
          nixpkgs.lib.nixosSystem {
            modules = [
              determinate.nixosModules.default
              ./hosts/razorback/configuration.nix
              inputs.nixos-hardware.nixosModules.framework-16-7040-amd
              ./users/${username}/home.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = inputs // specialArgs;
              }
            ];
          };
      };

      homeConfigurations = {
        vagrant = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/features.nix
            ./home/core.nix
            ./home/programs/neovim
            ./home/programs/tmux
            ./home/programs/shell
            ./home/programs/cli-tooling
            ./home/programs/wezterm
            ./home/programs/git
            ./home/programs/language
            ./home/nix-tools.nix
            ./home/fonts.nix
            ./home/utilities.nix
            ./home/profiles/developer.nix
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
