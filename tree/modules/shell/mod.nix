# Shell (zsh) dendritic module
# Provides zsh/starship/carapace configuration for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.programs.shell.enable = lib.mkEnableOption "Shell (zsh) configuration";

  config = lib.mkIf config.features.programs.shell.enable {
    home.packages = with pkgs; [
      zsh
      zsh-autosuggestions
      zsh-syntax-highlighting
      starship
      carapace
    ];

    programs = {
      zsh = {
        enable = true;

        initContent = ''
          bindkey '^[[3~' delete-char
          bindkey -a '^[[3~' delete-char

          if [[ -f ~/.bash_aliases ]]; then
            source ~/.bash_aliases
          fi

          prefetch-sri() {
            nix-prefetch-url "$1" | xargs nix hash convert --hash-algo sha256 --to sri
          }

          function dfs() {
            flake_host="''${1:-}"
            
            if command -v nixos-rebuild &>/dev/null; then
              # NixOS: use host name directly (e.g., razorback)
              cmd='sudo nixos-rebuild switch --flake ~/.dotfiles''${flake_host:+#''${flake_host}} --impure'
            else
              # Home-manager: append system architecture (e.g., vagrant-x86_64-linux)
              local host=''${flake_host:-vagrant}
              local arch=$(uname -m)
              local sys
              case "$arch" in
                x86_64) sys="x86_64-linux" ;;
                aarch64|arm64) sys="aarch64-linux" ;;
                *) sys="''${arch}-linux" ;;
              esac
              
              # Check if running on Darwin (macOS)
              if [[ $(uname -s) == "Darwin" ]]; then
                case "$arch" in
                  x86_64) sys="x86_64-darwin" ;;
                  aarch64|arm64) sys="aarch64-darwin" ;;
                esac
              fi
              
              cmd="home-manager --flake ~/.dotfiles#''${host}-''${sys} switch --impure"
            fi

            echo "Running: ''$cmd"
            eval $cmd || return 1

            nvim --headless "+Lazy! sync" +qa

            zsh
          }

          function dfu() {
            (cd "$HOME/.dotfiles" && nix flake update)

            nvim --headless "+Lazy! update" +qa
            nvim --headless "+TSUpdate" +qa
          }

          function dfc() {
            nix-store --optimize
            nix-collect-garbage -d
            sudo nix-collect-garbage -d
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
                  if [[ -n "$versions" ]]; then
                    php_version=$(echo "$versions" | head -n 1)
                    echo "Found PHP version in composer.json (require.php):\e[0;34m $php_version\e[0m"
                  fi
                fi
              fi
            fi

            if [[ -n "$php_version" ]]; then
              formatted_version="php''${php_version//./}"
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
          export EDITOR="nvim"
        '';

        shellAliases = {
          ".." = "cd ..";
          "..." = "cd ../..";
          h = "cd ~";
          c = "clear";
          dfcd = ''cd "$HOME/.dotfiles"'';
          dfg = ''(cd "$HOME/.dotfiles" && lazygit)'';
          dfn = ''(cd "$HOME/.dotfiles" && nvim)'';
          wttr = ''clear && curl -s "https://wttr.in/3805+Australia?2"'';
          nv = "nvim";
        };

        autocd = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
      };

      carapace = {
        enable = true;
        enableZshIntegration = true;
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = true;
          palette = "catppuccin_mocha";
          command_timeout = 5000;

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

          git_status.disabled = true;

          golang.format = "[ $version ](bold cyan)";

          aws = {
            format = ''[$symbol(profile: "$profile" )((region: $region) )]($style)'';
            disabled = false;
            style = "bold blue";
            symbol = " ";
          };

          kubernetes = {
            symbol = "☸ ";
            disabled = true;
            detectFiles = [ "Dockerfile" ];
            format = "[$symbol$context( \\($namespace\\))]($style) ";
          };

          docker_context.disabled = true;

          custom = {
            dotfiles_status = {
              description = "Indicates when dotfiles need updating";
              command = ''
                CACHE_FILE="$HOME/.cache/dotfiles_status_cache"
                SESSION_START_FILE="/tmp/.session_start_$(whoami)"
                NEEDS_REFRESH=0
                if [ ! -f "$SESSION_START_FILE" ]; then
                  NEEDS_REFRESH=1
                  touch "$SESSION_START_FILE"
                fi
                if [ ! -f "$CACHE_FILE" ] || [ "$(find "$CACHE_FILE" -mtime +1)" ]; then
                  NEEDS_REFRESH=1
                fi
                if [ "$NEEDS_REFRESH" = "1" ]; then
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

          palettes.catppuccin_mocha = {
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
