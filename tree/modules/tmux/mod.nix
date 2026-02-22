# Tmux
# Provides tmux configuration for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "dreamsofcode-io";
      repo = "catppuccin-tmux";
      rev = "main";
      sha256 = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
    };
  };
in
{
  options.features.programs.tmux.enable = lib.mkEnableOption "Tmux configuration";

  config = lib.mkIf config.features.programs.tmux.enable {
    home.packages = with pkgs; [ tmux ];

    programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      mouse = true;
      escapeTime = 1;
      baseIndex = 1;
      prefix = "C-Space";
      keyMode = "vi";

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        vim-tmux-navigator
        catppuccin
        resurrect
        continuum
      ];

      extraConfig = ''
        set-option -sa terminal-overrides ",xterm*:Tc"
        set -s set-clipboard on

        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        bind -n S-Left  previous-window
        bind -n S-Right next-window

        bind -n M-H previous-window
        bind -n M-L next-window

        run '~/.tmux/plugins/tpm/tpm'

        unbind '"'
        unbind '%'
        bind '\\' split-window -v -c "#{pane_current_path}"
        bind '|' split-window -h -c "#{pane_current_path}"
      '';
    };
  };
}
