export QT_QPA_PLATFORMTHEME=qt5ct
export VISUAL=helix
export EDITOR=helix
export TERMINAL=kitty
export LIBVA_DRIVER_NAME=i965

if [ -f "$HOME"/.bashrc ]; then
  source "$HOME"/.bashrc
fi

# if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx >&~/.xsession-errors
fi
