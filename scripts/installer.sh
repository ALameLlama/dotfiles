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

	install_nala

	install_nvim

	install_nerd_fonts

	# --- Install base stuff for fancy nvim
	install_package "git"
	install_package "make"
	install_package "pip"
	install_package "python3"
	install_package "npm"
	install_package "node"

	install_rust
	install_package "cargo"

	install_go

	# --- Install other cool stuff
	install_pipx
	install_package "zsh"
	install_oh_my_zsh

	install_package "tmux"

	install_bat

	install_package "fzf"
	install_package "zoxide"
	install_package "entr"
	install_package "mc"
	install_package "thefuck"

	install_eza

	install_astro_nvim

	import_dot_files

	printf "Restart terminal for everything to take effect :)\n"
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

gum_choice() {
	local PACKAGE_NAME=$1

	msg_warn "Do you want to install $(gum style --bold "$PACKAGE_NAME")?"
	CHOICE=$(gum choose --item.foreground 250 "Yes" "No")
	[ "$CHOICE" = "Yes" ]
}

install_package() {
	local PACKAGE_NAME=$1

	if ! command -v "$PACKAGE_NAME" &>/dev/null; then
		if gum_choice "$PACKAGE_NAME"; then
			sudo ${APT_INSTALLER} install -y "$PACKAGE_NAME"
			msg_succ "$(gum style --bold "$PACKAGE_NAME") has been installed."
		else
			msg_err "$(gum style --bold "$PACKAGE_NAME") will not be installed."
		fi
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
		if gum_choice "nala"; then
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

			if gum_choice "Mirrors"; then
				sudo ${APT_INSTALLER} fetch -y --auto
			fi

			msg_succ "nala has been installed."
		else
			msg_err "nala will not be installed."
		fi
	else
		APT_INSTALLER=nala
	fi
}

install_nvim() {
	if ! command -v nvim &>/dev/null; then
		msg_warn "$(gum style --bold nvim) is not installed."
		if gum_choice "nvim"; then
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
			msg_err "nvim will not be installed."
			exit 0
		fi
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
	if gum_choice "Nerd Fonts"; then
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
	else
		msg_err "Nerd Fonts will not be installed."
	fi
}

install_rust() {
	if ! command -v rustc &>/dev/null; then
		msg_warn "$(gum style --bold "rust") is not installed."
		if gum_choice "rust"; then
			curl -LsS https://sh.rustup.rs | sh -s -- -y

			source "$HOME/.cargo/env"

			msg_succ "rust has been installed."
		else
			msg_err "rust will not be installed."
		fi
	else
		msg_succ "$(gum style --bold "rust") is already installed."
	fi
}

install_pipx() {
	if ! command -v pipx &>/dev/null; then
		msg_warn "$(gum style --bold "pipx") is not installed."
		if gum_choice "pipx"; then
			sudo ${APT_INSTALLER} install -y pipx
			pipx ensurepath

			msg_succ "pipx has been installed."

			if ! command -v poetry &>/dev/null; then
				msg_warn "$(gum style --bold "poetry") is not installed."
				if gum_choice "poetry"; then
					pipx install poetry

					poetry completions bash >>~/.bash_completion

					msg_succ "poetry has been installed."
				else
					msg_err "poetry will not be installed."
				fi
			else
				msg_succ "$(gum style --bold "poetry") is already installed."
			fi
		else
			msg_err "pipx will not be installed."
		fi
	else
		msg_succ "$(gum style --bold "pipx") is already installed."
	fi
}

install_go() {
	if ! command -v go &>/dev/null; then
		msg_warn "$(gum style --bold "go") is not installed."
		if gum_choice "go"; then
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
			msg_err "go will not be installed."
		fi
	else
		msg_succ "$(gum style --bold "go") is already installed."
	fi
}

install_oh_my_zsh() {
	if [ ! -d "$HOME/.oh-my-zsh" ] && command -v zsh &>/dev/null; then
		if gum_choice "Oh My ZSH"; then
			git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"

			git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
			git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

			if command -v poetry &>/dev/null; then
				mkdir "$ZSH_CUSTOM/plugins/poetry"
				poetry completions zsh >"$ZSH_CUSTOM/plugins/poetry/_poetry"
			fi

			chsh -s /usr/bin/zsh

			msg_succ "oh my zsh has been installed."
		else
			msg_err "oh my zsh will not be installed."
		fi
	else
		msg_succ "$(gum style --bold "oh my zsh") is already installed."
	fi
}

install_bat() {
	if ! command -v bat &>/dev/null && ! command -v batcat &>/dev/null; then
		msg_warn "$(gum style --bold "bat") is not installed."
		if gum_choice "bat"; then

			sudo ${APT_INSTALLER} install -y bat

			msg_succ "bat has been installed."
		else
			msg_err "bat will not be installed."
		fi
	else
		msg_succ "$(gum style --bold "bat") is already installed."
	fi
}

install_eza() {
	if ! command -v eza &>/dev/null; then
		msg_warn "$(gum style --bold "eza") is not installed."
		if gum_choice "eza"; then
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
			msg_err "eza will not be installed."
		fi
	else
		msg_succ "$(gum style --bold "eza") is already installed."
	fi
}

install_astro_nvim() {
	if gum_choice "AstroNvim"; then
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
	else
		msg_err "AstroNvim will not be installed."
	fi
}

import_dot_files() {
	if gum_choice "dotfiles"; then
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
	else
		msg_err "dotfiles will not be installed."
	fi
}

# --- Start of installation ---
main
