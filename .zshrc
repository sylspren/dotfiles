# History
HISTFILE=~/.zsh_history
HISTSIZE=90000
SAVEHIST=90000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS

# History search with up/down arrows
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive

# Typo correction for cd
setopt CORRECT

# Colors
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

# Prompt: lei Documents $
PS1='%F{75}%n %B%F{117}%1~%b%f $ '

# Always use physical path
setopt CHASE_LINKS

# SSH keys
if [ "$(ssh-add -l 2>/dev/null | grep -c 'The agent has no identities.')" -eq 1 ]; then
    ssh-add --apple-use-keychain 2>/dev/null
fi

# Aliases
alias rm='rm -i'
alias ll='ls -l'
alias vi='mvim -v'
alias la='ls -a'
alias grep='grep --color=auto'

# Git aliases
alias gll='git log --graph --stat -C -w'
alias gL='git log --format="%n%Cblue--- %Cred%h %Cgreen(%ci) %Cred%an %Cblue---%n  %s | %b" --name-status'
