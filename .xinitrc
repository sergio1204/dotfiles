#!/bin/sh

xrdb -merge "$HOME/.Xresources"

# start some programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setxkbmap -layout us,ru -option grp:caps_toggle,grp_led:caps && xmodmap ~/.Xmodmap

# start WM
# exec bspwm
exec qtile start
# exec awesome
