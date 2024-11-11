#!/usr/bin/env bash

# install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# install nix home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# git clone my dotfiles
git clone git@github.com:ALameLlama/dotfiles.git ~/.dotfiles

	# source nix
	source_nix

	# install nix home manager
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update

	nix-shell '<home-manager>' -A install

	nix-env -iA nixpkgs.stow

	rm -rf ~/.config/home-manager
	
	# git clone my dotfiles
	git clone git@github.com:ALameLlama/dotfiles.git ~/.dotfiles
	# switch to the nix branch
	( cd ~/.dotfiles && git checkout nix )
	( cd ~/.dotfiles && stow .)

	# mkdir -p ~/.config/home-manager
	# ln -s ~/.dotfiles/.config/home-manager ~/.config/home-manager

	echo "{
	\"username\": \"$(whoami)\",
	\"homeDirectory\": \"$HOME\"
	}" > ~/.config/home-manager/user-config.json

	# install home manager
	home-manager switch
}

main