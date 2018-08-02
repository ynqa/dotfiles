if [[ ! -d ${HOME}/.zplug ]]; then
    git clone https://github.com/zplug/zplug ${HOME}/.zplug
fi
source ${HOME}/.zplug/init.zsh

# theme: https://github.com/sindresorhus/pure
zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

# syntax highlighting: https://github.com/zsh-users/zsh-syntax-highlighting
zplug "zsh-users/zsh-syntax-highlighting"

# autocomplete: https://github.com/zsh-users/zsh-completions
zplug "zsh-users/zsh-completions"

# # history: https://github.com/zsh-users/zsh-history-substring-search
zplug "zsh-users/zsh-history-substring-search"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# history searching with arrow keys
if zplug check "zsh-users/zsh-history-substring-search"; then
    bindkey '^P' history-substring-search-up
    bindkey '^N' history-substring-search-down
fi

# save history to
export HISTFILE=${HOME}/.zsh_history
# number of history on mem
export HISTSIZE=1000
# number of history on disk
export SAVEHIST=100000
# drop duplicated history
setopt hist_ignore_dups

# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init - zsh)"

# direnv
export EDITOR=vim
eval "$(direnv hook zsh)"

# kubectl zsh completion
source <(kubectl completion zsh)

# alias
alias g="git"
alias drm='docker rm -f $(docker ps -aq)'
alias drmi='docker rmi -f $(docker images -aq)'
alias drsh='docker run --entrypoint="bash" -it'
