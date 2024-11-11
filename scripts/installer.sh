# /bin/env 

# install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# install nix home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# git clone my dotfiles
git clone git@github.com:ALameLlama/dotfiles.git ~/.dotfiles

# symlink nix package manager
ln -s ~/.dotfiles/.config/home-manager ~/.config/home-manager