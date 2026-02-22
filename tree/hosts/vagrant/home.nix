# Vagrant host configuration

{ lib, pkgs, ... }:
{
  imports = [ ];

  features = {
    programs = {
      neovim.enable = true;
      tmux.enable = true;
      shell.enable = true;
      cli-tools.enable = true;
      git.enable = true;
    };
    languages = {
      javascript.enable = true;
      javascript.fnm.enable = true;
      python.enable = true;
      lua.enable = true;
    };
    tools = {
      nix-tools.enable = true;
      utilities.enable = true;
      fonts.enable = true;
    };
  };

  home = {
    username = "vagrant";
    homeDirectory = "/home/vagrant";
    stateVersion = "25.05";
    packages = with pkgs; [
      hyperfine
      home-manager
    ];
  };
}
