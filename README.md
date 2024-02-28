```zsh
bash <(curl -s https://raw.githubusercontent.com/ALameLlama/dotfiles/master/scripts/installer.sh)
```

If you've imported my dotfiles. you'll need to use stow to get them to symlink

```zsh
dfs
```

or

```zsh
(cd "$HOME/.dotfiles" && stow .)
```
