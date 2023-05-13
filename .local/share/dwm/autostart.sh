#!/bin/sh

killall -q slstatus; slstatus &
killall -q picom; picom &
setxkbmap -layout us,ru -option grp:caps_toggle,grp_led:caps &
feh --bg-scale /home/sergey/Pictures/metro-eskalator.jpg &
