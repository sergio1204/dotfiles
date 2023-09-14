#!/bin/sh

xrdb -merge $HOME/.Xresources

# start some programs ==========================
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

feh --bg-scale /home/sergey/Pictures/oz.jpg &
picom &

# start WM =====================================
#exec bspwm 2> ~/.bspwm.log
exec qtile start
