#!/bin/sh

xrdb -merge $HOME/.Xresources

# start some programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# start WM
#exec bspwm
#exec qtile start
#exec awesome
exec xmonad
