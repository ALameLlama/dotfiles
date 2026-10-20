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

function main() {
	local target="${1:-}"

	# install nix if not already installed
	if ! command -v nix >/dev/null; then
		curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
	fi

	sudo timedatectl set-timezone Australia/Melbourne

	# source nix
	source_nix

	# git clone my dotfiles
	git clone git@github.com:ALameLlama/dotfiles.git ~/.dotfiles

	mkdir -p ~/.dotfiles/.git/hooks

	echo '
	#!/usr/bin/env sh
	rm -f "$HOME/.cache/dotfiles_status_cache"' >~/.dotfiles/.git/hooks/post-merge
	chmod +x ~/.dotfiles/.git/hooks/post-merge

	if command -v nixos-rebuild >/dev/null; then
		sudo nixos-rebuild switch --flake "$HOME/.dotfiles${target:+#$target}"
	else
		target="${target:-$USER}"

		# install nix home manager
		nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
		nix-channel --update
		nix-shell '<home-manager>' -A install

		# remove existing home-manager config
		rm -rf ~/.config/home-manager
		rm -rf ~/.zshrc

		home-manager --flake "$HOME/.dotfiles#$target" switch
	fi
}

main "$@"
