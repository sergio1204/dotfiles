alias memory='ps -eo cmd,rss,%cpu --sort=-rss | grep'
alias ls='ls -l --color=auto'
alias grep='grep --color=auto'
alias search='find * -type f | fzf -m'
alias df='df -h'
alias ..='cd ..'
alias cd..='cd ..'
alias mkdir='mkdir -pv'
alias root='sudo -i'
alias rm=trash
alias class='xprop WM_CLASS'
alias mirrors='sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias ncp="cat ${NNN_SEL:-${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection} | tr '\0' '\n'"

export NNN_OPTS='AdeH'
export NNN_ORDER="v:$HOME"
export NNN_BMS="h:$HOME;d:$HOME/Documents;D:$HOME/Downloads/;m:$HOME/Music;p:$HOME/Pictures;v:$HOME/Videos"
export NNN_COLORS='2345'
export NNN_TRASH=1
export NNN_PLUG='d:dragdrop;D:diffs;f:fzopen;m:nmount;p:preview-tui'
export NNN_FIFO=/tmp/nnn.fifo
export NNN_TERMINAL='alacritty'
export NNN_BATTHEME='TwoDark'

[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"
