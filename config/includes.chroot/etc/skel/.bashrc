# ~/.bashrc

export PS1="\[\e[32m\][\u@\h \W]\$\[\e[0m\] "
export LANG=fr_FR.UTF-8
export LANGUAGE=fr_FR:fr:en_US:en

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'

neofetch 2>/dev/null || true
