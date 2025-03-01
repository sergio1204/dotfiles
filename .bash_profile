export QT_QPA_PLATFORMTHEME=qt5ct
export VISUAL=nvim
export EDITOR=nvim
export TERMINAL=kitty
export LIBVA_DRIVER_NAME=i965
export RANGER_LOAD_DEFAULT_RC=false

if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec startx >& ~/.xsession-errors
fi
