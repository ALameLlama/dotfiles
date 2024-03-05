#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Default installer
APT_INSTALLER=apt-get

main() {
	install_gum

	if ! command -v gum &>/dev/null; then
		msg_err "gum not installed and is required. Try restarting terminal."
		exit 1
	fi

	declare -A INSTALL_OPTIONS=(
		["Nala"]="install_package nala"
		["Nvim"]="install_nvim"
		["NerdFonts"]="install_nerd_fonts"
		# --- Install base stuff for fancy nvim
		["Git"]="install_package git"
		["Make"]="install_package make"
		["Pip"]="install_package pip"
		["Python3"]="install_package python3"
		["Npm"]="install_package npm"
		["Node"]="install_package node"
		["Rust"]="install_rust"
		["Cargo"]="install_package cargo"
		["Go"]="install_go"
		# --- Install other cool stuff
		["Pipx"]="install_pipx"
		["Poetry"]="install_poetry"
		["Zsh"]="install_package zsh"
		["OhMyZsh"]="install_oh_my_zsh"
		["Tmux"]="install_package tmux"
		["Bat"]="install_package bat"
		["Fzf"]="install_package fzf"
		["Zoxide"]="install_package zoxide"
		["Entr"]="install_package entr"
		["MC"]="install_package mc"
		["TheFuck"]="install_package thefuck"
		["Eza"]="install_eza"
		["AstroNvim"]="install_astro_nvim"
		["DotFiles"]="import_dot_files"
	)

	SOFTWARE_TO_INSTALL=(
		"Nala"
		"Nvim"
		"NerdFonts"
		"Git"
		"Make"
		"Pip"
		"Python3"
		"Npm"
		"Node"
		"Rust"
		"Cargo"
		"Go"
		"Pipx"
		"Poetry"
		"Zsh"
		"OhMyZsh"
		"Tmux"
		"Bat"
		"Fzf"
		"Zoxide"
		"Entr"
		"MC"
		"TheFuck"
		"Eza"
		"AstroNvim"
		"Dotfiles"
	)

	remove_installed_from_list

	msg_succ "Select want to install"
	SELECTED_OPTIONS=$(gum choose --no-limit --cursor "* " <<<$(printf "%s\n" "${SOFTWARE_TO_INSTALL[@]}"))

	gum confirm || exit 1

	for OPTION in ${SELECTED_OPTIONS[@]}; do
		${INSTALL_OPTIONS[${OPTION}]}
	done

	printf "Restart terminal for everything to take effect 🚀🌕\n"
}

# --- Helper functions ---
msg_warn() {
	local MESSAGE=$1

	printf "%b%s%b\n" "$YELLOW" "$MESSAGE" "$NC"
}

msg_succ() {
	local MESSAGE=$1

	printf "%b%s%b\n" "$GREEN" "$MESSAGE" "$NC"
}

msg_err() {
	local MESSAGE=$1

	printf "%b%s%b\n" "$RED" "$MESSAGE" "$NC"
}

install_package() {
	local PACKAGE_NAME=$1

	if ! command -v "$PACKAGE_NAME" &>/dev/null; then
		sudo ${APT_INSTALLER} install -y "$PACKAGE_NAME"
		msg_succ "$(gum style --bold "$PACKAGE_NAME") has been installed."
	else
		msg_succ "$(gum style --bold "$PACKAGE_NAME") is already installed."
	fi
}

check_package() {
	local PACKAGE_NAME=$1

	if ! command -v "$PACKAGE_NAME" &>/dev/null; then
		msg_err "$(gum style --bold "$PACKAGE_NAME") was not be installed. Try restarting terminal."
		exit 1
	fi
}

unset_option() {
	local OPTION_INDEX=$1

	local OPTION="${SOFTWARE_TO_INSTALL[$OPTION_INDEX]}"

	msg_succ "$(gum style --bold "$OPTION") is installed."
	unset SOFTWARE_TO_INSTALL[$OPTION_INDEX]
}

remove_installed_from_list() {
	max_index=$((${#SOFTWARE_TO_INSTALL[@]} - 1)) # Calculate the maximum index

	for ((i = 0; i <= max_index; i++)); do
		OPTION="${SOFTWARE_TO_INSTALL[i]}"
		msg_warn "Checking if $(gum style --bold "$OPTION") is installed."
		case $OPTION in
		"Rust")
			if command -v rustc &>/dev/null; then
				unset_option $i
			fi
			;;
		"OhMyZsh")
			if [ -d "$HOME/.oh-my-zsh" ] && command -v zsh &>/dev/null; then
				unset_option $i
			fi
			;;
		"Bat")
			if command -v bat &>/dev/null || command -v batcat &>/dev/null; then
				unset_option $i
			fi
			;;
		*)
			if command -v "${OPTION,,}" &>/dev/null; then
				unset_option $i
			fi
			;;
		esac
	done
}

# --- Install more packages that require special handling ---
install_gum() {
	if ! command -v gum &>/dev/null; then
		msg_warn "gum is not installed"
		read -rp "Do you want to install it? (y/n):" install_gum_choice

		if [ "$install_gum_choice" == "y" ]; then
			sudo mkdir -p /etc/apt/keyrings
			curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
			echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
			sudo ${APT_INSTALLER} update
			sudo ${APT_INSTALLER} install -y gum

			msg_succ "gum has been installed."
		else
			msg_err "gum will not be installed."
			exit 0
		fi
	fi
}

install_nala() {
	if ! command -v nala &>/dev/null; then
		echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
		wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg
		sudo apt-get update -y

		UBUNTU_VERSION=$(lsb_release -rs)
		if [ "$(echo "$UBUNTU_VERSION < 21" | bc)" -eq 1 ]; then
			sudo apt-get install -y nala-legacy
		else
			sudo apt-get install -y nala
		fi

		APT_INSTALLER=nala

		sudo ${APT_INSTALLER} fetch -y --auto

		msg_succ "nala has been installed."
	else
		APT_INSTALLER=nala
	fi
}

install_nvim() {
	if ! command -v nvim &>/dev/null; then
		msg_warn "$(gum style --bold nvim) is not installed."
		sudo ${APT_INSTALLER} update
		sudo ${APT_INSTALLER} install -y build-essential cmake libtool libtool-bin gettext
		git clone https://github.com/neovim/neovim.git
		cd neovim || exit
		LASTEST_NVIM_TAG=$(git tag -l | sort -V | tail -n 1)
		git checkout "$LASTEST_NVIM_TAG"
		make CMAKE_BUILD_TYPE=Release
		sudo make install
		cd ..
		rm -rf neovim

		msg_succ "nvim has been installed from source."
	else
		NVIM_VERSION=$(nvim --version | grep -oP "(?<=NVIM v)[0-9]+\.[0-9]+")
		MINM=0.8

		# Bash doesn't do float math with -lt
		if (($(echo "$NVIM_VERSION < $MINM" | bc -l))); then
			msg_warn "Your nvim version is $NVIM_VERSION. Do you want to upgrade to version $MINM or higher?"
			CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

			if [ "$CHOICE" == "Yes" ]; then
				sudo ${APT_INSTALLER} update
				sudo ${APT_INSTALLER} install -y build-essential cmake libtool libtool-bin gettext
				git clone https://github.com/neovim/neovim.git
				cd neovim || exit
				LASTEST_NVIM_TAG=$(git tag -l | sort -V | tail -n 1)
				git checkout "$LASTEST_NVIM_TAG"
				make CMAKE_BUILD_TYPE=Release
				sudo make install
				cd ..
				rm -rf neovim

				msg_succ "nvim has been upgraded from source."
			else
				msg_err "nvim will not be upgraded."
			fi
		else
			msg_succ "$(gum style --bold "nvim") is already installed and at version $MINM or higher."
		fi
	fi
}

install_nerd_fonts() {
	if ! command -v jq &>/dev/null; then
		sudo ${APT_INSTALLER} install -y jq
	fi

	# Fetch latest Nerd Fonts releases
	# Filter only .zip files from assets
	RELEASES=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest")
	ASSETS=$(echo "$RELEASES" | jq -r '.assets | map(select(.name | endswith(".zip"))) | map(.name) | join("\n")')

	echo "Search and choose a font from the list:"
	FONT=$(echo "$ASSETS" | gum filter)

	if [ -n "$FONT" ]; then
		mkdir -p ~/.fonts
		curl -sSLo ~/.fonts/"$FONT" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT"
		unzip ~/.fonts/"$FONT" -d ~/.fonts
		fc-cache -fv

		msg_succ "$FONT has been installed."
	else
		msg_err "No font selected. Nerd Fonts will not be installed."
	fi
}

install_rust() {
	if ! command -v rustc &>/dev/null; then
		msg_warn "$(gum style --bold "rust") is not installed."
		curl -LsS https://sh.rustup.rs | sh -s -- -y

		source "$HOME/.cargo/env"

		msg_succ "rust has been installed."
	else
		msg_succ "$(gum style --bold "rust") is already installed."
	fi
}

install_pipx() {
	if ! command -v pipx &>/dev/null; then
		msg_warn "$(gum style --bold "pipx") is not installed."
		sudo ${APT_INSTALLER} install -y pipx
		pipx ensurepath

		msg_succ "pipx has been installed."
	else
		msg_succ "$(gum style --bold "pipx") is already installed."
	fi
}

install_poetry() {
	if ! command -v poetry &>/dev/null; then
		msg_warn "$(gum style --bold "poetry") is not installed."
		pipx install poetry

		poetry completions bash >>~/.bash_completion

		msg_succ "poetry has been installed."
	else
		msg_succ "$(gum style --bold "poetry") is already installed."
	fi
}

install_go() {
	if ! command -v go &>/dev/null; then
		msg_warn "$(gum style --bold "go") is not installed."
		ARCH=$(arch)
		if [[ "$ARCH" == "aarch64" ]]; then
			GOLANG_LATEST_STABLE_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o 'go.*.linux-arm64.tar.gz' | head -n 1 | tr -d '\r\n')
			curl -LsS "https://dl.google.com/go/${GOLANG_LATEST_STABLE_VERSION}" -o golang.tar.gz
		else
			GOLANG_LATEST_STABLE_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o 'go.*.linux-amd64.tar.gz' | head -n 1 | tr -d '\r\n')
			curl -LsS "https://dl.google.com/go/${GOLANG_LATEST_STABLE_VERSION}" -o golang.tar.gz
		fi

		sudo tar -C /usr/local -xzf golang.tar.gz go
		printf "\nPATH=\"/usr/local/go/bin:\$PATH\"\n" | tee -a ~/.profile
		rm -rf golang.tar.gz

		export PATH="/usr/local/go/bin:$PATH"

		msg_succ "go has been installed."
	else
		msg_succ "$(gum style --bold "go") is already installed."
	fi
}

install_oh_my_zsh() {
	if [ ! -d "$HOME/.oh-my-zsh" ] && command -v zsh &>/dev/null; then
		git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"

		if command -v poetry &>/dev/null; then
			mkdir "$ZSH_CUSTOM/plugins/poetry"
			poetry completions zsh >"$ZSH_CUSTOM/plugins/poetry/_poetry"
		fi

		git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
		git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

		chsh -s /usr/bin/zsh

		msg_succ "oh my zsh has been installed."
	else
		msg_succ "$(gum style --bold "oh my zsh") is already installed."
	fi
}

install_bat() {
	if ! command -v bat &>/dev/null && ! command -v batcat &>/dev/null; then
		msg_warn "$(gum style --bold "bat") is not installed."

		sudo ${APT_INSTALLER} install -y bat

		msg_succ "bat has been installed."

	else
		msg_succ "$(gum style --bold "bat") is already installed."
	fi
}

install_eza() {
	if ! command -v eza &>/dev/null; then
		msg_warn "$(gum style --bold "eza") is not installed."
		sudo apt update
		sudo apt install -y gpg

		sudo mkdir -p /etc/apt/keyrings
		wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
		echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
		sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
		sudo apt update
		sudo apt install -y eza

		msg_succ "eza has been installed."
	else
		msg_succ "$(gum style --bold "eza") is already installed."
	fi
}

install_astro_nvim() {
	# --- Check if the required stuff for astronvim is installed
	check_package "nvim"
	check_package "git"
	check_package "make"
	check_package "pip"
	check_package "python3"
	check_package "npm"
	check_package "node"
	check_package "rustc"
	check_package "cargo"
	check_package "go"

	# --- Install deps for astro
	ARCH=$(arch)
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

	if [[ "$ARCH" == "aarch64" ]]; then
		curl -sSLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
	else
		curl -sSLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	fi

	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin
	rm -rf lazygit.tar.gz lazygit

	cargo install tree-sitter-cli
	cargo install bottom
	cargo install ripgrep

	sudo ${APT_INSTALLER} install -y python3-launchpadlib

	sudo add-apt-repository -y ppa:daniel-milde/gdu
	sudo ${APT_INSTALLER} update
	sudo ${APT_INSTALLER} install -y gdu

	sudo ${APT_INSTALLER} install -y xdg-utils

	mv ~/.config/nvim ~/.config/nvim.bak
	mv ~/.local/share/nvim ~/.local/share/nvim.bak
	mv ~/.local/state/nvim ~/.local/state/nvim.bak
	instmv ~/.cache/nvim ~/.cache/nvim.bak

	git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

	msg_succ "AstroNvim has been installed."
}

import_dot_files() {
	MYDOTFIlES="git@github.com:ALameLlama/dotfiles.git"
	URL=$(gum input --value "$MYDOTFIlES" --placeholder "$MYDOTFIlES")

	# Clone the repository to a temporary directory
	DOTFILES_DIR="$HOME/.dotfiles"
	git clone "$URL" "$DOTFILES_DIR"

	CURRENT_DIR=$(pwd)

	# Change to the Git repository directory
	cd "$DOTFILES_DIR" || exit 1

	# Get the list of files in the Git repository
	FILES=$(git ls-files)

	# Loop through each file
	for FILE in $FILES; do
		# Check if the file exists on your system
		if [ -e "$HOME/$FILE" ]; then
			# Rename the file by appending ".bak" to its name
			NEW_NAME="${FILE}.bak"
			mv "$HOME/$FILE" "$HOME/$NEW_NAME"

			msg_succ "Renamed $(gum style --bold "$FILE") to $(gum style --bold "$NEW_NAME")."
		else
			msg_succ "$(gum style --bold "$FILE") does not exist on your system."
		fi
	done

	if ! command -v stow &>/dev/null; then
		sudo ${APT_INSTALLER} install -y stow
	fi

	stow .

	cd "$CURRENT_DIR" || exit 1

	msg_succ "dotfiles has been imported."
}

# --- Start of installation ---
main
