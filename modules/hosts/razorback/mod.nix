{ inputs, ... }:
{
  flake.modules.nixos.razorback = {
    imports = with inputs.self.modules.nixos; [
      inputs.determinate.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
      shell neovim steam javascript-fnm
      ./_configuration.nix
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.nciechanowski.imports = [ inputs.self.modules.homeManager.nciechanowski ];
    };
  };
}
