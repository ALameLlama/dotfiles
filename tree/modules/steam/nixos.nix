# Steam
# Provides

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  anyUserHasSteam = lib.any (userConfig: userConfig.features.programs.steam.enable or false) (
    lib.attrValues config.home-manager.users
  );
in
{
  config = lib.mkIf anyUserHasSteam {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };
}
