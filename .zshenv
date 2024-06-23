files_to_source=(
  "$HOME/.bash_aliases"
  "$HOME/.profile"
  "$HOME/.functions"
  "$HOME/.aliases"
  "$HOME/.personal_env"
  "$HOME/.cargo/env"
)

for file in "${files_to_source[@]}"; do
  if [ -f "$file" ]; then
    source "$file"
  fi
done


export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$(go env GOPATH)/bin
export GOBIN=$HOME/go/bin

export PATH=$PATH:$GOPATH/bin

export PATH=$PATH:$HOME/.cargo/bin
. "$HOME/.cargo/env"
