# Vagrant host configuration

{ lib, pkgs, ... }:
{
  imports = [ ];

  features = {
    programs = {
      cli-tools.enable = true;
      git.enable = true;
      jujutsu.enable = true;
      neovim.enable = true;
      shell.enable = true;
      tmux.enable = true;
    };
    languages = {
      javascript = {
        enable = true;
        fnm.enable = true;
      };
      lua.enable = true;
      python.enable = true;
    };
    tools = {
      fonts.enable = true;
      nix-tools.enable = true;
      utilities.enable = true;
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
