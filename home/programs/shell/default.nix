{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    starship
    carapace
  ];

  programs = {
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
      initContent = ''
        bindkey '^[[3~' delete-char
        bindkey -a '^[[3~' delete-char

        eval "$(fnm env --use-on-cd --shell zsh)"

        if [[ -f ~/.bash_aliases ]]; then
          source ~/.bash_aliases
        fi

        prefetch-sri() {
          nix-prefetch-url "$1" | xargs nix hash convert --hash-algo sha256 --to sri
        }

        function dfs() {
          flake_host="''${1:-}"
          if command -v nixos-rebuild &>/dev/null; then
            # add --verbose if you want more
            sudo nixos-rebuild switch --flake ~/.dotfiles''${flake_host:+\#''${flake_host}} --impure || return 1
          else
            home-manager --flake ~/.dotfiles''${flake_host:+\#''${flake_host}} switch --impure || return 1
          fi

          # make this dynamic if I have nvim module setup
          nvim --headless "+Lazy! sync" +qa

          zsh
        }

        function dfu() {
          (cd "$HOME/.dotfiles" && nix flake update)

          # make this dynamic if I have nvim module setup
          nvim --headless "+Lazy! update" +qa
        }

        update-php() {
          local domain=$1
          local php_version=$2

          if [[ -z "$domain" || -z "$php_version" ]]; then
              echo "Usage: update-php {domain} {php_version (e.g., 8.2)}"
              return 1
          fi

          for file in /etc/apache2/sites-enabled/''${domain}.conf /etc/apache2/sites-enabled/''${domain}-ssl.conf; do
              if [[ -f "$file" ]]; then
                  echo "Updating PHP version in $file to php$php_version"
                  sudo sed -i -E "s/php[0-9]+\.[0-9]+/php$php_version/g" "$file"
              else
                  echo "File not found: $file"
              fi
          done

          echo "Restarting Apache..."
          sudo systemctl restart apache2

          echo "Done."
        }


        autoload -Uz add-zsh-hook

        chpwd_php_hook() {
          local php_version=""

          if [[ -f ".php-version" ]]; then
            php_version=$(cat .php-version)
            echo "Found .php-version:\e[0;34m $php_version\e[0m"
          elif [[ -f "composer.json" ]]; then
            php_version=$(jq -r '.config.platform.php // empty' composer.json 2>/dev/null)
            if [[ -n "$php_version" ]]; then
              echo "Found PHP version in composer.json (config.platform.php):\e[0;34m $php_version\e[0m"
            else
              php_versions=$(jq -r '.require.php // empty' composer.json 2>/dev/null)
              if [[ -n "$php_versions" ]]; then
                versions=$(echo "$php_versions" | grep -oP '\d+\.\d+(\.\d+)?' | sort -V)

                # If versions were found, pick the lowest one
                if [[ -n "$versions" ]]; then
                  php_version=$(echo "$versions" | head -n 1)
                  echo "Found PHP version in composer.json (require.php):\e[0;34m $php_version\e[0m"
                fi
              fi
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
        export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

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

        # Aliases for directories
        dfc = ''cd "$HOME/.dotfiles"'';
        dfg = ''(cd "$HOME/.dotfiles" && lazygit)'';
        dfn = ''(cd "$HOME/.dotfiles" && nvim)'';

        # Miscellaneous aliases
        wttr = ''clear && curl -s "https://wttr.in/3805+Australia?2"'';
        nv = "nvim";
      };
      autocd = true;
      syntaxHighlighting = {
        enable = true;
      };
      autosuggestion = {
        enable = true;
      };
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
        add_newline = true;
        # format = "$time$directory$custom$character";
        palette = "catppuccin_mocha";
        # right_format = "$all";
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

        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style)";
        };

        git_status = {
          disabled = true;
        };

        golang = {
          format = "[ $version ](bold cyan)";
        };

        aws = {
          format = ''[$symbol(profile: "$profile" )((region: $region) )]($style)'';
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
            shell = [
              "bash"
              "--noprofile"
              "--norc"
            ];
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
  };
}
