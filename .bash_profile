export QT_QPA_PLATFORMTHEME=qt5ct
export VISUAL=vim
export EDITOR=vim
export TERMINAL=alacritty
export LIBVA_DRIVER_NAME=i965
export RANGER_LOAD_DEFAULT_RC=false

if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec startx >& ~/.xsession-errors
fi
