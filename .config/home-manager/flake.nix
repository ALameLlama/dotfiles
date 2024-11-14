{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    userConfig = builtins.fromJSON (builtins.readFile ./user-config.json);
    overlays = [
      # inputs.neovim-nightly-overlay.overlays.default
    ];
  in {
    homeConfigurations = {
      "${userConfig.username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          {
            nixpkgs.overlays = overlays;
          }
        ];
      };
    };
  };
}
