#!/usr/bin/env bash

function source_nix() {
	if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
		source "$HOME/.nix-profile/etc/profile.d/nix.sh"
	elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
		source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
	else
		echo "Could not find Nix profile script. Please restart your shell manually."
		exit 1
	fi
}

function generate_user_config() {
	case "$(uname -s)" in
	Darwin)
		case "$(uname -m)" in
		arm64)
			system="aarch64-darwin"
			;;
		x86_64)
			system="x86_64-darwin"
			;;
		*)
			echo "Unsupported architecture on macOS: $(uname -m)"
			exit 1
			;;
		esac
		;;
	Linux)
		case "$(uname -m)" in
		arm64 | aarch64)
			system="aarch64-linux"
			;;
		x86_64)
			system="x86_64-linux"
			;;
		*)
			echo "Unsupported architecture on Linux: $(uname -m)"
			exit 1
			;;
		esac
		;;
	*)
		echo "Unsupported OS: $(uname -s)"
		exit 1
		;;
	esac

	cat >~/.dotfiles/.config/home-manager/user-config.json <<EOF
{
  "username": "$(whoami)",
  "homeDirectory": "$HOME",
  "system": "$system"
}
EOF
}

# TODO:
# Fix timezone e.g sudo timedatectl set-timezone Australia/Melbourne
# add login message to show git repo status
# look into weird zsh prompt issue, having missing spaces?

function main() {
	# install nix if not already installed
	if [ ! -f /etc/profile.d/nix.sh ]; then
		sh <(curl -L https://nixos.org/nix/install) --daemon
	fi

	# source nix
	source_nix

	# install nix home manager
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install

	# remove existing home-manager config
	rm -rf ~/.config/home-manager

	# git clone my dotfiles
	git clone git@github.com:ALameLlama/dotfiles.git ~/.dotfiles

	# create user config
	generate_user_config

	# link home-manager config
	home-manager switch -f ~/.dotfiles/.config/home-manager/home.nix -b init-backup
}

main
