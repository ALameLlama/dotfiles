echo "Starting .zprofile 💅"

# Start SSH agent (if not already running)
if ! pgrep -q ssh-agent; then
    eval $(ssh-agent -s)
fi

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519

# # Run the weather command in the background and capture its output
# wttr_output=$(wttr &)
#
# # Check if the .dotfiles Git repository is out of date in the background and capture its output
# dotfiles_output=$(
#     if [ -d "$HOME/.dotfiles" ]; then
#         (
#         cd "$HOME/.dotfiles"
#         git fetch origin master 2>&1
#         LOCAL=$(git rev-parse @)
#         REMOTE=$(git rev-parse origin/master)
#         BASE=$(git merge-base @ origin/master)
#         if [ $LOCAL = $REMOTE ]; then
#             echo -e "\e[32mYour .dotfiles are up to date.\e[0m"
#         elif [ $LOCAL = $BASE ]; then
#             echo -e "\e[31mThere are updates available for your .dotfiles. Please run 'dfg' to update.\e[0m"
#         fi
#         )
#     fi
# )
#
# # Wait for both background processes to finish
# wait
#
# # Print the captured output of the background processes
# echo "$wttr_output"
# echo "$dotfiles_output"

