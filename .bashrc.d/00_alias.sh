
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# System update alias
alias up='sudo rpm-ostree update'

# Layered package management aliases
alias install='sudo rpm-ostree install'
alias remove='sudo rpm-ostree remove'
alias search='sudo rpm-ostree search'
alias clean='sudo rpm-ostree cleanup'

# Reinstall must be a function to handle the package name
reinstall() {
    if [ -z "$1" ]; then
        echo "Usage: reinstall <package-name>"
        return 1
    fi
    sudo rpm-ostree remove "$1" && sudo rpm-ostree install "$1"
}

# System aliases
alias cd0='cd /'
alias cd1='cd ../'
alias cd2='cd ../../'
alias cd3='cd ../../../'
alias cd4='cd ../../../../'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gpush='git push'
alias gpull='git pull'
alias gdiff='git diff'
alias glog='git log --oneline --graph --decorate --all'

# Programming helpers
alias py='python3'
alias ipy='ipython'
alias venv='python3 -m venv'
alias mkdir='mkdir -pv'
alias ports='netstat -tulanp'
alias header='curl -I'
alias weather='curl wttr.in'

# Docker shortcuts
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias drun='docker run -it'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dlogs='docker logs'

# Kubernetes shortcuts
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kaf='kubectl apply -f'
alias kl='kubectl logs'
alias kx='kubectl exec -it'

# Make terminal better
alias c='clear'
alias histg='history | grep'
alias mkcd='_mkcd(){ mkdir -p "$1"; cd "$1"; }; _mkcd'
alias count='find . -type f | wc -l'
alias tf='tail -f'

# Safety nets
alias rm='rm -Ir'
alias mv='mv -i'
alias cp='cp -ir'
alias ln='ln -is'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
