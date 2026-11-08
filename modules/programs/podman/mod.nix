{ inputs, ... }:
{
  flake.modules.nixos.podman = {
    virtualisation.containers.registries.settings."unqualified-search-registries" = [ "docker.io" ];

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
    home-manager.sharedModules = [ inputs.self.modules.homeManager.podman ];
  };
  flake.modules.homeManager.podman =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        podman
        podman-compose
      ];
    };
}
