#!/bin/sh

xrdb -merge "$HOME/.Xresources"

# start some programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setxkbmap -layout us,ru -option grp:alt_shift_toggle && xmodmap ~/.Xmodmap

# start WM
# exec i3
# exec bspwm
# exec qtile start
exec awesome
