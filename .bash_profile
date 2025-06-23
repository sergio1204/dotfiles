export QT_QPA_PLATFORMTHEME=qt5ct
export VISUAL=hx
export EDITOR=hx
export TERMINAL=alacritty
export LIBVA_DRIVER_NAME=i965
export PATH="$HOME/.local/bin:$PATH"

if [ -f "$HOME"/.bashrc ]; then
	source "$HOME"/.bashrc
fi

# if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
	exec startx >&~/.xsession-errors
fi
