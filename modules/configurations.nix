{ inputs, ... }:
{
  flake = {
    nixosConfigurations = {
      razorback = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ inputs.self.modules.nixos.razorback ];
      };
      VSVR-20-NixOS = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ inputs.self.modules.nixos."VSVR-20-NixOS" ];
      };
    };

    homeConfigurations =
      inputs.nixpkgs.lib.genAttrs
        [ "vagrant-x86_64-linux" "vagrant-aarch64-linux" "vagrant-aarch64-darwin" ]
        (
          name:
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs {
              system = inputs.nixpkgs.lib.removePrefix "vagrant-" name;
              config.allowUnfree = true;
            };
            modules = [ inputs.self.modules.homeManager.vagrant ];
          }
        );
  };
}
