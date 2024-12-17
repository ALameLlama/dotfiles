# https://home-manager-options.extranix.com/
{ pkgs }:
with pkgs; {
  # Let Home Manager install and manage itself.
  home-manager = { enable = true; };
  # Enable set zsh as default shell
  # bash = {
  #   enable = true;
  #   # update .bashrc to start zsh
  #   profileExtra = ''
  #     if [ -z "$ZSH_VERSION" ]; then
  #       exec zsh
  #     fi
  #   '';
  # };
  zsh = {
    enable = true;

    # update .zshrc
    initExtra = ''
      eval "$(fnm env --use-on-cd --shell zsh)"

      eval "$(pay-respects zsh --alias)"

      export GOBIN="$HOME/go/bin"
      export PATH="$GOBIN:$PATH"

      export PATH=$PATH:$HOME/.cargo/bin

      export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua"
      export LUA_CPATH="$HOME/.luarocks/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so"
    '';
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";

      h = "cd ~";
      c = "clear";

      ls = "eza";
      ll = "eza -alh";
      tree = "eza --tree";

      cat = "bat";

      cd = "z";
      zz = "z -";

      # Aliases for directories
      dfc = ''cd "$HOME/.dotfiles"'';
      dfs = ''(cd "$HOME/.dotfiles" && home-manager switch)'';
      dfu = ''(cd "$HOME/.dotfiles/.config/home-manager" && nix flake update)'';
      dfg = ''(cd "$HOME/.dotfiles" && lazygit)'';
      dfn = ''(cd "$HOME/.dotfiles" && nvim .)'';

      # Miscellaneous aliases
      wttr = ''clear && curl -s "https://wttr.in/3805+Australia?2"'';
      fuck = "f";
      nv = "nvim";
    };
    autocd = true;
    syntaxHighlighting = { enable = true; };
    autosuggestion = { enable = true; };
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
      format = "$time$directory$custom$character";
      palette = "catppuccin_mocha";
      right_format = "$all";
      command_timeout = 1000;

      # directory = {
      #   substitutions = {
      #     "~/tests/starship-custom" = "work-project";
      #   };
      # };

      time = {
        disabled = false;
        format = "[[ 🕒 $time ](fg:white)]($style)";
        time_format = "%I:%M %p";
      };

      character = {
        disabled = false;
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
        vimcmd_replace_one_symbol = "[❮](bold purple)";
        vimcmd_replace_symbol = "[❮](bold purple)";
        vimcmd_visual_symbol = "[❮](bold lavender)";
      };

      git_branch = { format = "[$symbol$branch(:$remote_branch)]($style)"; };

      golang = { format = "[ $version ](bold cyan)"; };

      aws = {
        format =
          ''[$symbol(profile: "$profile" )((region: $region) )]($style)'';
        disabled = false;
        style = "bold blue";
        symbol = " ";
      };

      kubernetes = {
        symbol = "☸ ";
        disabled = true;
        detect_files = [ "Dockerfile" ];
        format = "[$symbol$context( \\($namespace\\))]($style) ";
        contexts = [{
          context_pattern =
            "arn:aws:eks:us-west-2:577926974532:cluster/zd-pvc-omer";
          style = "green";
          context_alias = "omerxx";
          symbol = " ";
        }];
      };

      docker_context = { disabled = true; };

      custom = {
        dotfiles_status = {
          description = "Indicates when dotfiles need updating";
          command = ''
            CACHE_FILE="$HOME/.cache/dotfiles_status_cache"
            SESSION_START_FILE="/tmp/.session_start_$(whoami)"

            # Check if we need to refresh (no cache, old cache, or new session)
            NEEDS_REFRESH=0

            # Check if this is first login of session
            if [ ! -f "$SESSION_START_FILE" ]; then
              NEEDS_REFRESH=1
              touch "$SESSION_START_FILE"
            fi

            # Check if cache is older than 24 hours
            if [ ! -f "$CACHE_FILE" ] || [ "$(find "$CACHE_FILE" -mtime +1)" ]; then
              NEEDS_REFRESH=1
            fi

            # If we need to refresh, do the git check
            if [ "$NEEDS_REFRESH" = "1" ]; then
              # Ensure cache directory exists
              mkdir -p "$HOME/.cache"

              if [ -d ~/.dotfiles ]; then
                cd ~/.dotfiles || exit
                git fetch -q
                BEHIND=$(git rev-list HEAD..@{u} --count 2>/dev/null)
                if [ "$BEHIND" -gt 0 ]; then
                  echo "📦" > "$CACHE_FILE"
                else
                  echo "" > "$CACHE_FILE"
                fi
              fi
            fi

            # Read from cache
            if [ -f "$CACHE_FILE" ]; then
              cat "$CACHE_FILE"
            fi
          '';
          when = "test -d ~/.dotfiles";
          shell = [ "bash" "--noprofile" "--norc" ];
          format = "$output";
          disabled = false;
        };
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
  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  # pay-respects = { # waiting for https://github.com/nix-community/home-manager/pull/6210
  #   enable = true;
  #   enableZshIntegration = true;
  # };
}
