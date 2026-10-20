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

    homeConfigurations.vagrant = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      modules = [ inputs.self.modules.homeManager.vagrant ];
    };
  };
}
