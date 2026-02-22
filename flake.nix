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
        # Export all discovered modules
        inherit homeModules nixosModules;

        # NixOS configurations
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
                home-manager.users.nciechanowski = {
                  imports = lib.attrValues homeModules;
                  features.programs.neovim.enable = true;
                  features.programs.tmux.enable = true;
                  features.programs.shell.enable = true;
                  features.programs.cli-tools.enable = true;
                  features.programs.wezterm.enable = true;
                  features.programs.git.enable = true;
                  features.languages.lua.enable = true;
                  features.languages.go.enable = true;
                  features.languages.javascript.enable = true;
                  features.languages.javascript.fnm.enable = true;
                  features.languages.rust.enable = true;
                  features.languages.python.enable = true;
                  features.languages.zig.enable = true;
                  features.tools.nix-tools.enable = true;
                  features.tools.utilities.enable = true;
                  features.tools.fonts.enable = true;
                  home.username = "nciechanowski";
                  home.homeDirectory = "/home/nciechanowski";
                  home.stateVersion = "25.05";
                };
              }
            ];
          };
        };

        # Generate home configurations per-system (like flake-utils' eachSystem pattern)
        # This generates: vagrant-x86_64-linux, vagrant-aarch64-linux, etc.
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
              "x86_64-darwin"
              "aarch64-darwin"
            ]
        );
      };
    };
}
