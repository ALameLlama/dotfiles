{
  description = "Llamas NixOS Configuration - Dendritic Pattern";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      determinate,
      ...
    }:
    let
      lib = nixpkgs.lib;

      # Auto-discover all dendritic modules
      discovered = import ./tree/discover.nix { inherit lib; };
      homeModules = discovered.homeModules;
      nixosModules = discovered.nixosModules;

      # Helper: get packages for a system
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      flake = {
        inherit homeModules nixosModules;

        nixosConfigurations = {
          razorback = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              determinate.nixosModules.default
              ./tree/hosts/razorback/configuration.nix
              inputs.nixos-hardware.nixosModules.framework-16-7040-amd
              { imports = lib.attrValues nixosModules; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.nciechanowski.imports = lib.attrValues homeModules ++ [
                  ./tree/hosts/razorback/users/nciechanowski.nix
                ];
              }
            ];
          };
        };

        homeConfigurations = lib.listToAttrs (
          map
            (system: {
              name = "vagrant-${system}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = pkgsFor system;
                modules = [
                  { imports = lib.attrValues homeModules; }
                  ./tree/hosts/vagrant/home.nix
                ];
              };
            })
            [
              "x86_64-linux"
              "aarch64-linux"
              "aarch64-darwin"
            ]
        );
      };
    };
}
