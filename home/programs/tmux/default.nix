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
  config = lib.mkIf config.features.programs.tmux.enable {
    home.packages = with pkgs; [ tmux ];

    programs = {
      tmux = {
        enable = true;

        # Set your default shell and terminal
        shell = "${pkgs.zsh}/bin/zsh";
        terminal = "tmux-256color";

        # Enable mouse and set escape time
        mouse = true;
        escapeTime = 1;

        # Set base index for windows and panes
        baseIndex = 1;

        # Set prefix to Ctrl-Space
        prefix = "C-Space";

        # Use vi-style keybindings
        keyMode = "vi";

        # Enable tmux plugins and install them automatically
        plugins = with pkgs.tmuxPlugins; [
          sensible
          yank
          vim-tmux-navigator
          catppuccin
          resurrect
          continuum
        ];

        # Additional configuration for custom bindings and plugins
        extraConfig = ''
          # Enable clipboard and color overrides
          set-option -sa terminal-overrides ",xterm*:Tc"
          set -s set-clipboard on

          # Use Alt-arrow keys to switch panes without prefix
          bind -n M-Left select-pane -L
          bind -n M-Right select-pane -R
          bind -n M-Up select-pane -U
          bind -n M-Down select-pane -D

          # Shift arrow to switch windows
          bind -n S-Left  previous-window
          bind -n S-Right next-window

          # Shift Alt vim keys to switch windows
          bind -n M-H previous-window
          bind -n M-L next-window

          run '~/.tmux/plugins/tpm/tpm'

          # Astronvim-style splits
          unbind '"'
          unbind '%'
          bind '\' split-window -v -c "#{pane_current_path}"
          bind '|' split-window -h -c "#{pane_current_path}"
        '';
      };
    };
  };
}
