files_to_source=(
  "$HOME/.bash_aliases"
  "$HOME/.profile"
  "$HOME/.aliases"
  "$HOME/.cargo/env"
)

for file in "${files_to_source[@]}"; do
  if [ -f "$file" ]; then
    source "$file"
  fi
done
