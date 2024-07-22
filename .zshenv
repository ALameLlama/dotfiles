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

export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua"
export LUA_CPATH="$HOME/.luarocks/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so"

