#!/bin/sh

killall -q slstatus; slstatus &
killall -q picom; picom &
setxkbmap -layout us,ru -option grp:alt_shift_toggle &
feh --bg-scale /home/sergey/Pictures/metro-eskalator.jpg &
