#!/bin/sh

kbdd &
picom -b &
xset b off &
setxkbmap -layout us,ru -option grp:alt_shift_toggle &
