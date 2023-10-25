export QT_QPA_PLATFORMTHEME=qt5ct
export VISUAL=vim
export EDITOR=vim

if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx
fi
