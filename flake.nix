{
  description = "Llamas NixOS Configuration - Dendritic Pattern with Auto-Discovery";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

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

      # Systems that support vagrant configs
      vagrantSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper to create a vagrant home configuration for a specific system
      mkVagrantConfig =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            # Import ALL discovered home modules (they enable themselves based on feature flags)
            { imports = lib.attrValues homeModules; }
            {
              features.programs.neovim.enable = true;
              features.programs.tmux.enable = true;
              features.programs.shell.enable = true;
              features.programs.cli-tools.enable = true;
              features.programs.git.enable = true;
              features.languages.javascript.enable = true;
              features.languages.javascript.fnm.enable = true;
              features.languages.python.enable = true;
              features.languages.lua.enable = true;
              features.tools.nix-tools.enable = true;
              features.tools.utilities.enable = true;
              features.tools.fonts.enable = true;

              home.username = "vagrant";
              home.homeDirectory = "/home/vagrant";
              home.stateVersion = "25.05";

              home.packages = with pkgs; [ hyperfine ];
            }
          ];
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = vagrantSystems;

      flake = {
        # Export all discovered modules
        inherit homeModules nixosModules;

        # NixOS configurations
        nixosConfigurations = {
          razorback = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              determinate.nixosModules.default
              ./hosts/razorback/configuration.nix
              inputs.nixos-hardware.nixosModules.framework-16-7040-amd

              # Import ALL discovered NixOS modules (they enable themselves based on feature flags)
              { imports = lib.attrValues nixosModules; }

              # Enable home-manager module
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.nciechanowski = {
                  # Import ALL home modules and set feature toggles
                  imports = lib.attrValues homeModules;

                  # Toggle which features to enable
                  features.programs.neovim.enable = true;
                  features.programs.tmux.enable = true;
                  features.programs.shell.enable = true;
                  features.programs.cli-tools.enable = true;
                  features.programs.wezterm.enable = true;
                  features.programs.git.enable = true;
                  features.languages.lua.enable = true;
                  features.languages.go.enable = true;
                  features.languages.javascript.enable = true;
                  features.languages.javascript.fnm.enable = true; # Enable fnm (auto-enables nix-ld)
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

        # Standalone home-manager configurations
        homeConfigurations = lib.listToAttrs (
          map (system: {
            name = "vagrant-${system}";
            value = mkVagrantConfig system;
          }) vagrantSystems
        );
      };
    };
}
