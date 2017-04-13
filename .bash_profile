[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh sshfs

if which git > /dev/null
then
    if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]; then
        source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
    else
        GIT_VERSION=`git --version | awk '{print $3}'`
        if [ -f /usr/share/doc/git-$GIT_VERSION/contrib/completion/git-completion.bash ]; then
            source /usr/share/doc/git-$GIT_VERSION/contrib/completion/git-completion.bash
        fi
    fi
fi

if which brew > /dev/null && [ -f "$(brew --prefix)/Library/Contributions/brew_bash_completion.sh" ]; then
    source "$(brew --prefix)/Library/Contributions/brew_bash_completion.sh"
fi

for file in ~/bash_completion.d/*; do
    source $file;
done

which docker > /dev/null
if [[ !$? && -f $HOME/.composer/composer.phar ]]
then
    alias composer='docker run --rm -it -v $HOME:$HOME -v `pwd`:/mnt/code -e COMPOSER_HOME="$HOME/.composer" php:latest php -d memory_limit=-1 -d error_reporting=E_ALL $HOME/.composer/composer.phar'
fi

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add "$HOME/.ssh/id_rsa";
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi
