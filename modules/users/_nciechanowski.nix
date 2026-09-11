# Nciechanowski user configuration for razorback
# Feature toggles and settings for the nciechanowski user

{ pkgs, ... }:
{
  home = {
    username = "nciechanowski";
    homeDirectory = "/home/nciechanowski";
    stateVersion = "25.05";
    packages = with pkgs; [
      home-manager
      forgejo-cli
    ];
  };
}
