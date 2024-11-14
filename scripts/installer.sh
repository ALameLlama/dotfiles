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
	echo "{
	\"username\": \"$(whoami)\",
	\"homeDirectory\": \"$HOME\"
	}" >~/.dotfiles/.config/home-manager/user-config.json

	# link home-manager config
	home-manager switch -f ~/.dotfiles/.config/home-manager/home.nix -b initbackup
}

main
