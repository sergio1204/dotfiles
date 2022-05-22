#!/bin/sh

setxkbmap -model pc102 -layout us,ru -option grp:alt_shift_toggle &
gxkb &
picom &
