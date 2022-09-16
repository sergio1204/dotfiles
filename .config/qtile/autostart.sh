#!/bin/sh

setxkbmap -layout us,ru -option grp:alt_shift_toggle &
killall -q picom; picom &
gxkb &
