export QT_QPA_PLATFORMTHEME=qt5ct
export VISUAL=vim
export EDITOR=vim
export TERMINAL=alacritty
export LIBVA_DRIVER_NAME=i965
export PATH=$PATH:~/.spoof-dpi/bin

if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

#if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
if [ -z "$DISPLAY" ] && [ "$(fgconsole)" -eq 1 ]; then
    exec startx >& ~/.xsession-errors
fi
