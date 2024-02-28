echo "Starting .zprofile 💅"

# https://unix.stackexchange.com/questions/12195/how-to-avoid-being-asked-passphrase-each-time-i-push-to-bitbucket
SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
    echo succeeded
    chmod 600 ${SSH_ENV}
    . ${SSH_ENV} > /dev/null
    /usr/bin/ssh-add
}

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
                echo -e "\e[31mThere are updates available for your .dotfiles. Please run 'dfg' to update.\e[0m"
            else 
                echo -e "\e[32mYour .dotfiles are up to date.\e[0m"
            fi
        )
    fi
}

(dotfile_check_updates &)
