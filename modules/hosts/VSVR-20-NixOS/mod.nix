{ inputs, ... }:
{
  flake.modules.nixos."VSVR-20-NixOS" = {
    imports = with inputs.self.modules.nixos; [
      inputs.determinate.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      shell
      neovim
      javascript-fnm
      podman
      ./_configuration.nix
    ];

    nix.settings = {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.VSVR-20-NixOS.imports = [ inputs.self.modules.homeManager."VSVR-20-NixOS" ];
    };
  };
}
