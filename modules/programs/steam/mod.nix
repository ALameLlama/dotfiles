{ inputs, ... }:
{
  flake.modules.homeManager.steam =
    # Steam NixOS module

    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        steam
      ];
    };

  flake.modules.nixos.steam =
    # Steam
    # Provides

    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };
      home-manager.sharedModules = [ inputs.self.modules.homeManager.steam ];
    };
}
