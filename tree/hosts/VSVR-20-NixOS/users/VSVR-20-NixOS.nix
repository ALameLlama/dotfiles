# VSVR-20-NixOS user configuration for razorback
# Feature toggles and settings for the VSVR-20-NixOS user

{ pkgs, ... }:
{
  imports = [ ];

  features = {
    programs = {
      cli-tools.enable = true;
      git.enable = true;
      jujutsu.enable = true;
      neovim.enable = true;
      opencode = {
        enable = true;
        # config.super = true;
        config.omo = true;
      };
      shell.enable = true;
      tmux.enable = true;
    };
    languages = {
      go.enable = true;
      javascript = {
        enable = true;
        fnm.enable = true;
      };
      lua.enable = true;
      python.enable = true;
      rust.enable = true;
      zig.enable = true;
      php = {
        enable = true;
        debug.enable = true;
      };
    };
    tools = {
      nix-tools.enable = true;
      utilities.enable = true;
    };
  };

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
