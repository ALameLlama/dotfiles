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
	# install nix if not already installed
	if ! command -v nix >/dev/null; then
		curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
	fi

	sudo timedatectl set-timezone Australia/Melbourne

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

	mkdir -p ~/.dotfiles/.git/hooks
	echo '#!/bin/bash
	rm -f "$HOME/.cache/dotfiles_status_cache"' >~/.dotfiles/.git/hooks/post-merge
	chmod +x ~/.dotfiles/.git/hooks/post-merge

	home-manager --flake ~/.dotfiles switch --impure
}

main
