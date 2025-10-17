{ config, pkgs, ... }:
{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  home.stateVersion = "25.05";

  programs = {
    home-manager = {
      enable = true;
    };
  };
}
