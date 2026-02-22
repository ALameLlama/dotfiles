# Nciechanowski user configuration for razorback
# Feature toggles and settings for the nciechanowski user

{ pkgs, ... }:
{
  imports = [ ];

  features = {
    programs = {
      neovim.enable = true;
      tmux.enable = true;
      shell.enable = true;
      cli-tools.enable = true;
      wezterm.enable = true;
      git.enable = true;
    };
    languages = {
      lua.enable = true;
      go.enable = true;
      javascript.enable = true;
      javascript.fnm.enable = true;
      rust.enable = true;
      python.enable = true;
      zig.enable = true;
    };
    tools = {
      nix-tools.enable = true;
      utilities.enable = true;
      fonts.enable = true;
    };
  };

  home = {
    username = "nciechanowski";
    homeDirectory = "/home/nciechanowski";
    stateVersion = "25.05";
    packages = with pkgs; [ home-manager ];
  };
}
