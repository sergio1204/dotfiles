#!/bin/sh

xrdb -merge $HOME/.Xresources

# start some programs ==========================
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

feh --bg-scale /home/sergey/Pictures/borda2.jpg &
picom &

# start WM =====================================
#exec bspwm 2> ~/.bspwm.log
#exec i3 2> ~/.i3wm.log
#exec qtile start
#exec dwm 2> ~/.dwm.log
while true; do
    # Log stderror
    dwm 2> ~/.dwm.log
    # No error logging
    #dwm >/dev/null 2>&1
done
