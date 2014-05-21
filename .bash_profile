[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

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
