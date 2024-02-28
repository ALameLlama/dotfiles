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

export PATH="/usr/local/go/bin:$PATH"
