# Nciechanowski user configuration for razorback
# Feature toggles and settings for the nciechanowski user

{ pkgs, ... }:
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
      wezterm.enable = true;
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
    };
    tools = {
      fonts.enable = true;
      nix-tools.enable = true;
      utilities.enable = true;
    };
  };

  home = {
    username = "nciechanowski";
    homeDirectory = "/home/nciechanowski";
    stateVersion = "25.05";
    packages = with pkgs; [ home-manager ];
  };
}
