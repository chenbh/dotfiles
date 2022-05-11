### PROMPT
source ~/.git-prompt.sh
export PS1='\[\e[34m\]\W\[\e[32m\]$(__git_ps1 "[%s]")\[\e[m\]\$ '


### ENV VARS
export PATH="$PATH:$HOME/bin"
export EDITOR="nvim"


### COMPLETION
[[ -r "/usr/local/etc/profile.d/autojump.sh" ]] && . "/usr/local/etc/profile.d/autojump.sh"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"


### ALIAS
alias vim='nvim'
