# Vagrant host configuration
# Home-manager configuration for Vagrant VMs across all architectures

{ lib, pkgs, ... }:
{
  imports = [ ];

  features.programs.neovim.enable = true;
  features.programs.tmux.enable = true;
  features.programs.shell.enable = true;
  features.programs.cli-tools.enable = true;
  features.programs.git.enable = true;
  features.languages.javascript.enable = true;
  features.languages.javascript.fnm.enable = true;
  features.languages.python.enable = true;
  features.languages.lua.enable = true;
  features.tools.nix-tools.enable = true;
  features.tools.utilities.enable = true;
  features.tools.fonts.enable = true;

  home.username = "vagrant";
  home.homeDirectory = "/home/vagrant";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [ hyperfine ];
}
