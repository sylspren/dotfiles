# User specific environment and startup programs
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Conditional additions
if [ -d /Developer/Tools ];then
    export PATH=$PATH:/Developer/Tools:/Developer/usr/bin:/Developer/usr/sbin
fi
if [ -d /opt/local/bin ]; then
  export PATH=$PATH:/opt/local/bin
fi

if [ -d /opt/local/sbin ]; then
  export PATH=$PATH:/opt/local/sbin
fi

BASH_ENV=$HOME/.bashrc
ENV=$HOME/.bashrc

if [ -d ~/.bash_completion.d ]; then
    for c in ~/.bash_completion.d/*; do
        . "$c"
    done
fi

export BASH_ENV ENV PATH PS1 DISPLAY

# Setup bash history options
# export HISTCONTROL=erasedups
export HISTCONTROL='ignoreboth'
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTSIZE=90000
export HISTTIMEFORMAT='%b %d %H:%M:%S: '
shopt -s histappend
set cmdhist

bind "set completion-ignore-case on"
shopt -s cdspell

# history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Colors
export GREP_OPTIONS='--color=auto'
export CLICOLOR=1



# Prompt
# lei@Leis-MacBook-Pro Documents $
# PS1='\[\e[0;34m\]\u@\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] \$ '
#
# lei Documents $
PS1='\[\e[0;34m\]\u \[\e[1;34m\]\W\[\e[m\] \$ '

# always use physical path. +p to turn off
set -P

## Macros
# from macosxhints.com
#cdf() # cd's to frontmost window of Finder
#{
#    cd "`osascript -e 'tell application "Finder"' \
#        -e 'set myname to POSIX path of (target of window 1 as alias)' \
#        -e 'end tell' 2>/dev/null`"
#}

## Scripts
# use ssh-add -K /path/to/your/secret/key to add the key password to your
# keychain. Then the ssh-add -k below will use your keychain and not harass
# you for a password.
if [ $(ssh-add -l | grep -c "The agent has no identities." ) -eq 1 ]; then
    if [ -f /mach_kernel ]; then
        ssh-add -k
    fi
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# git completions
source ~/.bash_plugins/_git-completion.bash
_git_completion_add()
{
    COMPREPLY=( $(compgen -W "$(git ls-files --other --modified --exclude-standard)" -- $1) )
    return 0
}

#_git_completion_checkout()
#{
#    COMPREPLY=( $(compgen -W "$(git diff --name-only)" -- $1) )
#    return 0
#}

_git_completion_reset()
{
    COMPREPLY=( $(compgen -W "$(git diff --name-only --cached)" -- $1) )
    return 0
}

_git_completion()
{
    local cur command
    cur="${COMP_WORDS[COMP_CWORD]}"
    command="${COMP_WORDS[1]}"

    _git
    case ${command} in
      add)
        _git_completion_add ${cur}
        ;;
      reset)
        _git_completion_reset ${cur}
        ;;
      #checkout)
      #  _git_completion_checkout ${cur}
      #  ;;
    esac
    return 0
}
complete -o bashdefault -o default -F _git_completion git

# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Node
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# After nvm sets up the path
export PATH="./node_modules/.bin:$PATH" # locally installed node binaries

# keyboard hack
# sudo kextload /Applications/Seil.app/Contents/Library/Seil.10.10.signed.kext/

## Aliases

alias rm='rm -i'
alias ll='ls -l'
alias vi='mvim -v'
alias la='ls -a'
alias be='bundle exec'
alias bi='bundle install'

# git
alias gll='git log --graph --stat -C -w'
# This one is a higher density version of git whatchanged:
alias gL='git log --format="%n%Cblue--- %Cred%h %Cgreen(%ci) %Cred%an %Cblue---%n  %s | %b" --name-status'

# goodeggs
alias cdg='cd ~/Projects/garbanzo'
eval "$(pyenv init -)"
eval "$(direnv hook bash)"

source ~/.profile
