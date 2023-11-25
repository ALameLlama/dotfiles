#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
apt_installer=apt-get

install_package() {
    local package_name=$1
    local install_command=$2

    if ! command -v "$package_name" &>/dev/null; then
        printf "${YELLOW}Do you want to install $(gum style --bold "%s")?${NC}\n" "$package_name"
        CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

        if [ "$CHOICE" == "Yes" ]; then
            sudo ${apt_installer} install -y "$package_name"
            printf "${GREEN}$(gum style --bold "%s") has been installed.${NC}\n" "$package_name"
        else
            printf "${RED}$(gum style --bold "%s") will not be installed.${NC}\n" "$package_name"
        fi
    else
        printf "${GREEN}$(gum style --bold "%s") is already installed.${NC}\n" "$package_name"
    fi
}

check_package() {
    local package_name=$1

    if ! command -v "$package_name" &>/dev/null; then
        printf "${RED}$(gum style --bold "%s") was not be installed. Try restarting terminal.${NC}\n" "$package_name"
        exit 1
    fi
}

if ! command -v gum &>/dev/null; then
    printf "${YELLOW}gum is not installed.${NC}\n"
    read -p "Do you want to install it? (y/n):" install_gum_choice

    if [ "$install_gum_choice" == "y" ]; then
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo ${apt_installer} update
        sudo ${apt_installer} install -y gum

        printf "${GREEN}gum has been installed.${NC}\n"
    else
        printf "${RED}gum will not be installed.${NC}\n"
        exit 0
    fi
fi

if ! command -v gum &>/dev/null; then
    printf "${RED}gum will not be installed. Try restarting terminal.${NC}\n"
    exit 1
fi

if ! command -v nala &>/dev/null; then
    printf "Do you want to install $(gum style --bold "nala")?\n"
    CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

    if [ "$CHOICE" == "Yes" ]; then
        echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
        wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg
        sudo apt-get update

        ubuntu_version=$(lsb_release -rs)
        if [ "$(echo "$ubuntu_version < 22" | bc)" -eq 1 ]; then
            sudo apt-get install -y nala-legacy
        else
            sudo apt-get install -y nala
        fi

        apt_installer=nala

        printf "Do you want to auto update the $(gum style --bold "mirrors")?\n"
        CHOICE=$(gum choose --item.foreground 250 "Yes" "No")
        if [ "$CHOICE" == "Yes" ]; then
            sudo ${apt_installer} fetch -y --auto
        fi

        printf "${GREEN}nala has been installed.${NC}\n"
    else
        printf "${RED}nala will not be installed.${NC}\n"
    fi
else
    apt_installer=nala
fi

if ! command -v nvim &>/dev/null; then
    printf "${YELLOW}$(gum style --bold nvim) is not installed.${NC}\n"
    printf "Do you want to install $(gum style --bold "nvim")?\n"
    CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

    if [ "$CHOICE" == "Yes" ]; then
        sudo ${apt_installer} update
        sudo ${apt_installer} install -y build-essential cmake libtool libtool-bin gettext
        git clone https://github.com/neovim/neovim.git
        cd neovim
        make CMAKE_BUILD_TYPE=Release
        sudo make install
        cd ..
        rm -rf neovim

        printf "${GREEN}nvim has been installed from source.${NC}\n"
    else
        printf "${RED}nvim will not be installed.${NC}\n"
        exit 0
    fi
else
    nvim_version=$(nvim --version | grep -oP "(?<=NVIM v)[0-9]+\.[0-9]+")

    if [ "$(awk 'BEGIN{ print ("'$nvim_version'" < 0.10) }')" -eq 1 ]; then
        printf "${YELLOW}Your nvim version is $nvim_version. Do you want to upgrade to version 0.10 or higher?${NC}\n"
        CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

        if [ "$CHOICE" == "Yes" ]; then
            git clone https://github.com/neovim/neovim.git
            cd neovim
            make CMAKE_BUILD_TYPE=Release
            sudo make install
            cd ..
            rm -rf neovim

            printf "${GREEN}nvim has been upgraded from source.${NC}\n"
        else
            printf "${RED}nvim will not be upgraded.${NC}\n"
        fi
    else
        printf "${GREEN}$(gum style --bold "nvim") is already installed and at version 0.10 or higher.${NC}\n"
    fi
fi

printf "${YELLOW}Do you want to install $(gum style --bold "Nerd Fonts")?.${NC}\n"
CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

if [ "$CHOICE" == "Yes" ]; then
    if ! command -v jq &>/dev/null; then
        sudo ${apt_installer} install -y jq
    fi

    # Fetch latest Nerd Fonts releases
    # Filter only .zip files from assets
    releases=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest")
    assets=$(echo "$releases" | jq -r '.assets | map(select(.name | endswith(".zip"))) | map(.name) | join("\n")')

    echo "Search and choose a font from the list:"
    FONT=$(echo "$assets" | gum filter)

    if [ -n "$FONT" ]; then
        mkdir -p ~/.fonts
        curl -sSLo ~/.fonts/"$FONT" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT"
        unzip ~/.fonts/"$FONT" -d ~/.fonts
        fc-cache -fv

        printf "${GREEN}$FONT has been installed.${NC}\n"
    else
        printf "${RED}No font selected. Nerd Fonts will not be installed.${NC}\n"
    fi
else
    printf "${RED}Nerd Fonts will not be installed.${NC}\n"
fi

install_package "git"
install_package "make"
install_package "pip"
install_package "python3"
install_package "npm"
install_package "node"

if ! command -v rustc &>/dev/null; then
    printf "${YELLOW}$(gum style --bold "rust") is not installed.${NC}\n"
    printf "Do you want to install $(gum style --bold "rust")?\n"
    CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

    if [ "$CHOICE" == "Yes" ]; then
        curl -LsS https://sh.rustup.rs | sh -s -- -y

        source "$HOME/.cargo/env"

        printf "${GREEN}rust has been installed.${NC}\n"
    else
        printf "${RED}rust will not be installed.${NC}\n"
    fi
else
    printf "${GREEN}$(gum style --bold "rust") is already installed.${NC}\n"
fi

install_package "cargo"

if ! command -v go &>/dev/null; then
    printf "${YELLOW}$(gum style --bold "go") is not installed.${NC}\n"
    printf "Do you want to install $(gum style --bold "go")?\n"
    CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

    if [ "$CHOICE" == "Yes" ]; then
        ARCH=$(arch)
        if [[ "$ARCH" == "aarch64" ]]; then
            GOLANG_LATEST_STABLE_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o 'go.*.linux-arm64.tar.gz' | head -n 1 | tr -d '\r\n')
            curl -LsS https://dl.google.com/go/${GOLANG_LATEST_STABLE_VERSION} -o golang.tar.gz
        else
            GOLANG_LATEST_STABLE_VERSION=$(curl -s https://go.dev/dl/?mode=json | grep -o 'go.*.linux-amd64.tar.gz' | head -n 1 | tr -d '\r\n')
            curl -LsS https://dl.google.com/go/${GOLANG_LATEST_STABLE_VERSION} -o golang.tar.gz
        fi

        sudo tar -C /usr/local -xzf golang.tar.gz go
        printf "\nPATH=\"/usr/local/go/bin:\$PATH\"\n" | tee -a ~/.profile
        rm -rf golang.tar.gz

        export PATH="/usr/local/go/bin:$PATH"

        printf "${GREEN}go has been installed.${NC}\n"
    else
        printf "${RED}go will not be installed.${NC}\n"
    fi
else
    printf "${GREEN}$(gum style --bold "go") is already installed.${NC}\n"
fi

if ! command -v lazygit &>/dev/null; then
    printf "${YELLOW}$(gum style --bold "lazygit") is not installed.${NC}\n"
    printf "Do you want to install $(gum style --bold "lazygit")?\n"
    CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

    if [ "$CHOICE" == "Yes" ]; then
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

        printf "${GREEN}lazygit has been installed.${NC}\n"
    else
        printf "${RED}lazygit will not be installed.${NC}\n"
    fi
else
    printf "${GREEN}$(gum style --bold "lazygit") is already installed.${NC}\n"
fi

install_package "zsh"

if [ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/zap" ] && command -v zsh; then
    printf "Do you want to install $(gum style --bold "zap")?\n"
    CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

    if [ "$CHOICE" == "Yes" ]; then
        zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

        printf "${GREEN}zap has been installed.${NC}\n"
    else
        printf "${RED}zap will not be installed.${NC}\n"
    fi
else
    printf "${GREEN}$(gum style --bold "zap") is already installed.${NC}\n"
fi

# https://medium.com/@simontoth/best-way-to-manage-your-dotfiles-2c45bb280049
printf "Do you want to import $(gum style --bold "dotfiles")?\n"
CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

if [ "$CHOICE" == "Yes" ]; then
    URL=$(gum input --placeholder "https://github.com/ALameLlama/dotfiles.git")

    # Clone the repository to a temporary directory
    temp_dir=$(mktemp -d)
    git clone "$URL" "$temp_dir"

    current_dir=$(pwd)

    # Change to the Git repository directory
    cd "$temp_dir" || exit 1

    # Get the list of files in the Git repository
    files=$(git ls-files)

    # Loop through each file
    for file in $files; do
        # Check if the file exists on your system
        if [ -e "$HOME/$file" ]; then
            # Rename the file by appending "_old" to its name
            new_name="${file}_old"
            mv "$HOME/$file" "$HOME/$new_name"
            printf "${GREEN}Renamed $(gum style --bold "$file") to $(gum style --bold "$new_name").${NC}\n"
        else
            printf "${GREEN}$(gum style --bold "$file") does not exist on your system.${NC}\n"
        fi
    done

    cd "$current_dir"

    # Clean up the temporary directory
    rm -rf "$temp_dir"

    dotfiles() {
        /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
    }

    git clone --bare $URL $HOME/.dotfiles

    dotfiles config --local status.showUntrackedFiles no
    dotfiles checkout

    source ~/.zshrc

    printf "${GREEN}dotfile has been imported.${NC}\n"
else
    printf "${RED}dotfiles will not be installed.${NC}\n"
fi

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
check_package "lazygit"

if ! command -v lvim &>/dev/null; then
    printf "Do you want to install $(gum style --bold "LunarVim")?\n"
    CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

    if [ "$CHOICE" == "Yes" ]; then
        bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
        export PATH=~/.local/bin:\$PATH

        printf "${GREEN}LunarVim has been installed.${NC}\n"
    else
        printf "${RED}LunarVim will not be installed.${NC}\n"
    fi
else
    printf "${GREEN}$(gum style --bold "LunarVim") is already installed.${NC}\n"
fi

printf "Restart terminal for everything to take effect :)"
