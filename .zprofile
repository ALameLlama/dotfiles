# https://unix.stackexchange.com/questions/12195/how-to-avoid-being-asked-passphrase-each-time-i-push-to-bitbucket
SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent
if [ -f "${SSH_ENV}" ]; then
     . ${SSH_ENV} > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

function dotfile_check_updates() {
    if [ -d "$HOME/.dotfiles" ]; then
        (
            cd "$HOME/.dotfiles" || exit
            git fetch origin master >/dev/null 2>&1
            LOCAL=$(git rev-parse @)
            REMOTE=$(git rev-parse origin/master)
            if [ "$LOCAL" != "$REMOTE" ]; then
                toast_notification "Your .dotfiles have updates available. Please run 'dfg' to update." 5
            else
                toast_notification "Your .dotfiles are up to date" 5
            fi
        )
    fi
}

(dotfile_check_updates &)
