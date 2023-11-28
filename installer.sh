#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Default installer
APT_INSTALLER=apt-get

# --- Helper functions ---

install_package() {
    local PACKAGE_NAME=$1

    if ! command -v "$PACKAGE_NAME" &>/dev/null; then
        printf "${YELLOW}Do you want to install $(gum style --bold "%s")?${NC}\n" "$PACKAGE_NAME"
        CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

        if [ "$CHOICE" == "Yes" ]; then
            sudo ${APT_INSTALLER} install -y "$PACKAGE_NAME"
            printf "${GREEN}$(gum style --bold "%s") has been installed.${NC}\n" "$PACKAGE_NAME"
        else
            printf "${RED}$(gum style --bold "%s") will not be installed.${NC}\n" "$PACKAGE_NAME"
        fi
    else
        printf "${GREEN}$(gum style --bold "%s") is already installed.${NC}\n" "$PACKAGE_NAME"
    fi
}

check_package() {
    local PACKAGE_NAME=$1

    if ! command -v "$PACKAGE_NAME" &>/dev/null; then
        printf "${RED}$(gum style --bold "%s") was not be installed. Try restarting terminal.${NC}\n" "$PACKAGE_NAME"
        exit 1
    fi
}

# --- Start of installation ---

if ! command -v gum &>/dev/null; then
    printf "${YELLOW}gum is not installed.${NC}\n"
    read -p "Do you want to install it? (y/n):" install_gum_choice

    if [ "$install_gum_choice" == "y" ]; then
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo ${APT_INSTALLER} update -y
        sudo ${APT_INSTALLER} install -y gum

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
        sudo apt-get update -y

        UBUNTU_VERSION=$(lsb_release -rs)
        if [ "$(echo "$UBUNTU_VERSION < 22" | bc)" -eq 1 ]; then
            sudo apt-get install -y nala-legacy
        else
            sudo apt-get install -y nala
        fi

        APT_INSTALLER=nala

        printf "Do you want to auto update the $(gum style --bold "mirrors")?\n"
        CHOICE=$(gum choose --item.foreground 250 "Yes" "No")
        if [ "$CHOICE" == "Yes" ]; then
            sudo ${APT_INSTALLER} fetch -y --auto
        fi

        printf "${GREEN}nala has been installed.${NC}\n"
    else
        printf "${RED}nala will not be installed.${NC}\n"
    fi
else
    APT_INSTALLER=nala
fi

if ! command -v nvim &>/dev/null; then
    printf "${YELLOW}$(gum style --bold nvim) is not installed.${NC}\n"
    printf "Do you want to install $(gum style --bold "nvim")?\n"
    CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

    if [ "$CHOICE" == "Yes" ]; then
        sudo ${APT_INSTALLER} update -y
        sudo ${APT_INSTALLER} install -y build-essential cmake libtool libtool-bin gettext
        git clone https://github.com/neovim/neovim.git
        cd neovim
        LASTEST_NVIM_TAG=$(git tag -l | sort -V | tail -n 1)
        git checkout $LASTEST_NVIM_TAG
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
    NVIM_VERSION=$(nvim --version | grep -oP "(?<=NVIM v)[0-9]+\.[0-9]+")
    MINM=0.8

    # Bash doesn't do float math with -lt
    if awk "BEGIN{exit ($NVIM_VERSION < $MINM)}"; then
        printf "${YELLOW}Your nvim version is $NVIM_VERSION. Do you want to upgrade to version $MINM or higher?${NC}\n"
        CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

        if [ "$CHOICE" == "Yes" ]; then
            sudo ${APT_INSTALLER} update -y
            sudo ${APT_INSTALLER} install -y build-essential cmake libtool libtool-bin gettext
            git clone https://github.com/neovim/neovim.git
            cd neovim
            LASTEST_NVIM_TAG=$(git tag -l | sort -V | tail -n 1)
            git checkout $LASTEST_NVIM_TAG
            make CMAKE_BUILD_TYPE=Release
            sudo make install
            cd ..
            rm -rf neovim

            printf "${GREEN}nvim has been upgraded from source.${NC}\n"
        else
            printf "${RED}nvim will not be upgraded.${NC}\n"
        fi
    else
        printf "${GREEN}$(gum style --bold "nvim") is already installed and at version $MINM or higher.${NC}\n"
    fi
fi

printf "${YELLOW}Do you want to install $(gum style --bold "Nerd Fonts")?.${NC}\n"
CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

if [ "$CHOICE" == "Yes" ]; then
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

        printf "${GREEN}$FONT has been installed.${NC}\n"
    else
        printf "${RED}No font selected. Nerd Fonts will not be installed.${NC}\n"
    fi
else
    printf "${RED}Nerd Fonts will not be installed.${NC}\n"
fi

# --- Install base stuff for fancy nvim

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

install_package "zsh"

if [ ! -d "$HOME/.oh-my-zsh" ] && command -v zsh &>/dev/null; then
    printf "Do you want to install $(gum style --bold "oh my zsh")?\n"
    CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

    if [ "$CHOICE" == "Yes" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh

        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

        chsh -s /usr/bin/zsh

        printf "${GREEN}oh my zsh has been installed.${NC}\n"
    else
        printf "${RED}oh my zsh will not be installed.${NC}\n"
    fi
else
    printf "${GREEN}$(gum style --bold "oh my zsh") is already installed.${NC}\n"
fi

# https://medium.com/@simontoth/best-way-to-manage-your-dotfiles-2c45bb280049
printf "Do you want to import $(gum style --bold "dotfiles")?\n"
CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

if [ "$CHOICE" == "Yes" ]; then
    URL=$(gum input --placeholder "https://github.com/ALameLlama/dotfiles.git")

    # Clone the repository to a temporary directory
    TEMP_DIR=$(mktemp -d)
    git clone "$URL" "$TEMP_DIR"

    CURRENT_DIR=$(pwd)

    # Change to the Git repository directory
    cd "$TEMP_DIR" || exit 1

    # Get the list of files in the Git repository
    FILES=$(git ls-files)

    # Loop through each file
    for FILE in $FILES; do
        # Check if the file exists on your system
        if [ -e "$HOME/$FILE" ]; then
            # Rename the file by appending "_old" to its name
            NEW_NAME="${FILE}_old"
            mv "$HOME/$FILE" "$HOME/$NEW_NAME"
            printf "${GREEN}Renamed $(gum style --bold "$FILE") to $(gum style --bold "$NEW_NAME").${NC}\n"
        else
            printf "${GREEN}$(gum style --bold "$FILE") does not exist on your system.${NC}\n"
        fi
    done

    cd "$CURRENT_DIR"

    # Clean up the temporary directory
    rm -rf "$TEMP_DIR"

    dotfiles() {
        /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
    }

    git clone --bare $URL $HOME/.dotfiles

    dotfiles config --local status.showUntrackedFiles no
    dotfiles checkout

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

printf "Do you want to install $(gum style --bold "AstroNvim")?\n"
CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

if [ "$CHOICE" == "Yes" ]; then
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

    sudo ${APT_INSTALLER} install -y xclip 

    cargo install tree-sitter-cli
    cargo install bottom
    cargo install ripgrep

    sudo add-apt-repository -y ppa:daniel-milde/gdu
    sudo ${APT_INSTALLER} update -y
    sudo ${APT_INSTALLER} install -y gdu
    
    sudo ${APT_INSTALLER} install -y xdg-utils  

    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    mv ~/.local/state/nvim ~/.local/state/nvim.bak
    mv ~/.cache/nvim ~/.cache/nvim.bak

    git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

    printf "${GREEN}AstroNvim has been installed.${NC}\n"
else
    printf "${RED}AstroNvim will not be installed.${NC}\n"
fi

printf "Restart terminal for everything to take effect :)\n"
