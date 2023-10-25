export QT_QPA_PLATFORMTHEME=qt5ct
export VISUAL=vim
export EDITOR=vim

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx
fi
