# Vagrant host configuration

{ pkgs, ... }:
{
  home = {
    username = "vagrant";
    homeDirectory = "/home/vagrant";
    stateVersion = "25.05";
    packages = with pkgs; [
      home-manager
      claude-code
      github-copilot-cli
      perl
    ];
  };
}
