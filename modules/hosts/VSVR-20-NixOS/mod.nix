{ inputs, ... }:
{
  flake.modules.nixos."VSVR-20-NixOS" = {
    imports = with inputs.self.modules.nixos; [
      inputs.determinate.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      shell
      neovim
      javascript-fnm
      ./_configuration.nix
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.VSVR-20-NixOS.imports = [ inputs.self.modules.homeManager."VSVR-20-NixOS" ];
    };
  };
}
