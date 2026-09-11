# VSVR-20-NixOS user configuration for razorback
# Feature toggles and settings for the VSVR-20-NixOS user

{ pkgs, ... }:
{
  home = {
    username = "VSVR-20-NixOS";
    homeDirectory = "/home/VSVR-20-NixOS";
    stateVersion = "26.05";
    packages = with pkgs; [
      home-manager
      forgejo-cli
    ];
  };
}
