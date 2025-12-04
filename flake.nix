{
  description = "Llamas NixOS Configuration";

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
            ./home
            {
              home = {
                username = "vagrant";
                homeDirectory = "/home/vagrant";
              };
              nix.package = pkgs.nix;
              features = {
                programs = {
                  neovim.enable = true;
                  tmux.enable = true;
                  shell.enable = true;
                  cli-tooling.enable = true;
                  wezterm.enable = false;
                  git.enable = true;
                };
                languages = {
                  php.enable = false;
                  python.enable = true;
                  javascript = {
                    enable = true;
                    fnm.enable = true;
                  };
                  rust.enable = false;
                  lua.enable = true;
                  go.enable = false;
                  zig.enable = false;
                };
                tools = {
                  nix-tools.enable = true;
                  utilities.enable = true;
                  fonts.enable = true;
                };
              };
              home.packages = with pkgs; [
                hyperfine
              ];
            }
          ];
        };
      };
    };
}
