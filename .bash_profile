# Autocomplete hostnames for ssh & related commands
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh sshfs

# Setup Brew
which brew > /dev/null
brew_found="$?"
if [[ "$brew_found" == "0" ]]
then
    # Add brew installed commands to available commands
    PATH=/usr/local/bin:$PATH
fi

# Only add certain auto completions for when not using zsh
if [[ -z ${ZSH_VERSION-} ]]; then
    # Autocomplete git from wherever it may be installed
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

    # Add in brew command completion
    if [[ "$brew_found" == "0" && -f "$(brew --prefix)/Homebrew/completions/bash/brew" ]]
    then
        source "$(brew --prefix)/Homebrew/completions/bash/brew"
    fi
fi

# Add in any other command auto completion
for file in ~/bash_completion.d/*; do
    source $file;
done

# Add in ability to run composer inside docker
which docker > /dev/null
if [[ !$? && -f $HOME/.composer/composer.phar ]]
then
    alias composer='docker run --rm -it -v $HOME:$HOME -v `pwd`:/mnt/code -e COMPOSER_HOME="$HOME/.composer" php:latest php -d memory_limit=-1 -d error_reporting=E_ALL $HOME/.composer/composer.phar'
fi

# Add command to flush dns if on a mac
[ -s "/usr/bin/dscacheutil" ] && alias flushdns='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'

# Setup NVM for using different node versions
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Setup ssh-agent so only have to enter ssl key once
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

# Setup path to source commands from local NPM / Composer paths first
PATH=./vendor/bin:./node_modules/.bin:$HOME/.composer/vendor/bin:$PATH
