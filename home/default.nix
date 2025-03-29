{ config, pkgs, ... }:


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
in {

  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
  # # Adds the 'hello' command to your environment. It prints a friendly
  # # "Hello, world!" when run.
  # pkgs.hello

  # # It is sometimes useful to fine-tune packages, for example, by applying
  # # overrides. You can do that directly here, just don't forget the
  # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  # # fonts?
  # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

  # # You can also create simple shell scripts directly inside your
  # # configuration. For example, this adds a command 'my-hello' to your
  # # environment:
  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')

  # prompt
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  starship
  carapace

  # AstroNvim packages
  git
  gcc
  gnumake
  unzip
  tree-sitter
  bottom
  gdu
  fd

  python3
  python312Packages.pip
  pipx
  poetry

  lua51Packages.lua
  lua51Packages.luarocks
  # luajit

  nodejs # see if this is needed or if this causes conflicts with fnm
  fnm

  rustup # this will install cargo and rustc without conflicting
  # rustc
  # cargo
  ripgrep

  go
  lazygit

  # nix packages
  alejandra
  deadnix
  nixd
  statix
  nixfmt

  # extra packages
  bat
  entr
  eza
  fzf
  superfile # use mc if this doesn't work
  tmux
  zoxide
  pay-respects

  nerd-fonts.fira-code

  # (php.withExtensions ({ enabled, all, }: enabled ++ [ all.imagick ]))
  # php.packages.composer

  gh
];

programs = {

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
      ## Need this for my mac to work??
      # Nix
       if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
           . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
       fi
       # End Nix

       bindkey '^[[3~' delete-char
       bindkey -a '^[[3~' delete-char

       eval "$(fnm env --use-on-cd --shell zsh)"

       function generate_user_config() {
         # Get system info in a more compact form
         local system
         case "$(uname -s)-$(uname -m)" in
           Darwin-x86_64) system="x86_64-darwin" ;;
           Darwin-arm64) system="aarch64-darwin" ;;
           Linux-x86_64) system="x86_64-linux" ;;
           Linux-aarch64) system="aarch64-linux" ;;
           *)
             echo "Unsupported platform: $(uname -s)-$(uname -m)"
             exit 1
             ;;
         esac

         export NIX_USERNAME=$USER
         export NIX_HOME_DIRECTORY=$HOME
         export NIX_SYSTEM=$system
       }

       generate_user_config

       if [[ -f ~/.bash_aliases ]]; then
         source ~/.bash_aliases
       fi

       prefetch-sri() {
         nix-prefetch-url "$1" | xargs nix hash convert --hash-algo sha256 --to sri
       }

      autoload -Uz add-zsh-hook

      chpwd_php_hook() {
        local php_version=""
        
        if [[ -f ".php-version" ]]; then
          php_version=$(cat .php-version)
          # echo "Found .php-version: $php_version"
        elif [[ -f "composer.json" ]]; then
          php_version=$(jq -r '.config.platform.php // empty' composer.json 2>/dev/null)
          if [[ -n "$php_version" ]]; then
            # echo "Found PHP version in composer.json: $php_version"
          fi
        fi

        if [[ -n "$php_version" ]]; then
          # Remove the dot (e.g., 7.3 → 73)
          formatted_version="php''${php_version//./}"
          # echo "Running command: $formatted_version"

          if command -v "$formatted_version" &>/dev/null; then
            "$formatted_version"
          else
            echo "Command '$formatted_version' not found."
          fi
        fi
      }

      add-zsh-hook chpwd chpwd_php_hook
    '';
    envExtra = ''
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
      dfs = ''
        (cd "$HOME/.dotfiles/.config/home-manager" && home-manager switch --impure && source "$HOME/.zshrc")'';
      dfu = ''(cd "$HOME/.dotfiles/.config/home-manager" && nix flake update)'';
      dfg = ''(cd "$HOME/.dotfiles" && lazygit)'';
      dfn = ''(cd "$HOME/.dotfiles" && nvim .)'';

      # Miscellaneous aliases
      wttr = ''clear && curl -s "https://wttr.in/3805+Australia?2"'';
      fuck = "f";
      nv = "nvim";

      ## TODO: make this work for linux and mac
      code =
        "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code";
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
    extraConfig.init.defaultBranch = "main";
  };
  gh = { enable = true; };
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
      command_timeout = 5000;

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
  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };
};
}
