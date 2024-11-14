{pkgs}:
with pkgs; {
  # Let Home Manager install and manage itself.
  home-manager = {
    enable = true;
  };
  # Enable set zsh as default shell
  bash = {
    enable = true;
    # update .bashrc to start zsh
    profileExtra = ''
      if [ -z "$ZSH_VERSION" ]; then
        exec zsh
      fi
    '';
  };
  zsh = {
    enable = true;
    # update .zshrc
    initExtra = ''
      eval "$(fnm env --use-on-cd --shell zsh)"
    '';
  };
  neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  git = {
    enable = true;
    userName = "Nicholas Ciechanowski";
    userEmail = "nicholasaciechanowski@gmail.com";
  };
  # TODO:, look into manually stying this since I can't see selected input
  carapace = {
    enable = true;
    enableZshIntegration = true;
  };
  starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$character";
      palette = "catppuccin_mocha";
      right_format = "$all";
      command_timeout = 1000;

      directory = {
        substitutions = {
          "~/tests/starship-custom" = "work-project";
        };
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style)";
      };

      # TODO: test these lol
      php = {
        symbol = "🐘 ";
        format = "[$symbol$version]($style)";
        style = "bold purple";
      };

      lua = {
        symbol = "🌙 ";
        format = "[$symbol$version]($style)";
        style = "bold blue";
      };

      rust = {
        symbol = "🦀 ";
        format = "[$symbol$version]($style)";
        style = "bold red";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol$version]($style)";
        style = "bold green";
      };

      golang = {
        format = "[ ](bold cyan)";
      };

      aws = {
        format = "[$symbol(profile: \"$profile\" )(\(region: $region\) )]($style)";
        disabled = false;
        style = "bold blue";
        symbol = " ";
      };

      kubernetes = {
        symbol = "☸ ";
        disabled = true;
        detect_files = ["Dockerfile"];
        format = "[$symbol$context( \\($namespace\\))]($style) ";
        contexts = [
          {
            context_pattern = "arn:aws:eks:us-west-2:577926974532:cluster/zd-pvc-omer";
            style = "green";
            context_alias = "omerxx";
            symbol = " ";
          }
        ];
      };

      docker_context = {
        disabled = true;
      };

      palettes = {
        catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
    };
  };
  tmux = {
    enable = true;

    # Set your default shell and terminal
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";

    # Enable mouse and set escape time
    mouse = true;
    escapeTime = 1;

    # Set base index for windows and panes
    baseIndex = 1;

    # Set prefix to Ctrl-Space
    prefix = "C-Space";

    # Use vi-style keybindings
    keyMode = "vi";

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

      # Keybindings for vi-mode copy
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Astronvim-style splits
      unbind '"'
      unbind '%'
      bind '\' split-window -v -c "#{pane_current_path}"
      bind '|' split-window -h -c "#{pane_current_path}"
    '';

    # Enable tmux plugins and install them automatically
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      catppuccin
      resurrect
      continuum
    ];
  };
}
