#!/bin/bash

alias memory='ps -eo cmd,rss,%cpu --sort=-rss | grep'
alias search="fzf --preview 'bat --color=always {}'"
alias grep='grep --color=auto'
alias logclear='truncate -s 0'
alias cat='bat'

alias c='clear'
alias h='history'
alias :q='exit'
alias q='exit'

alias ls='ls -l --color=auto'
alias mkdir='mkdir -pv'
alias df='df -h'
alias ..='cd ..'
alias cd..='cd ..'

alias class='xprop WM_CLASS'
