autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit

if which git > /dev/null
then
    if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.zsh ]; then
        fpath=(/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.zsh $fpath)
    else
        GIT_VERSION=`git --version | awk '{print $3}'`
        if [ -f /usr/share/doc/git-$GIT_VERSION/contrib/completion/git-completion.zsh ]; then
            fpath=(/usr/share/doc/git-$GIT_VERSION/contrib/completion/git-completion.zsh $fpath)
        fi
    fi
fi

source .bash_profile
