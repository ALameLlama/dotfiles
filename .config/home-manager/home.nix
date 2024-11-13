# https://home-manager-options.extranix.com/

# TODO: port rest of my .env and stuff over
# look at anything else I need to configure via home-manager

{ config, pkgs, ... }:

let
  userConfig = builtins.fromJSON (builtins.readFile ./user-config.json);
in
{
  nix = {
    package = pkgs.nix;
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
    bash
    zsh
    starship

    # nvim packages
    neovim
    git
    gcc
    gnumake
    unzip

    python3
    python312Packages.pip
    pipx 

    nodejs

    rustc
    cargo
    ripgrep

    go
    lazygit

    # extra packages
    tmux
    bat
    fzf
    zoxide
    entr
    superfile # use mc if this doesn't work
    eza
    carapace
    fnm
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/home-manager".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/home-manager";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink  "${config.home.homeDirectory}/.dotfiles/.config/nvim";
    # ".config/tmux".source = "${config.home.homeDirectory}/.dotfiles/.config/tmux";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/vagrant/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
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
          detect_files = [ "Dockerfile" ];
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
      shell =  "${pkgs.zsh}/bin/zsh";
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
  };
}
