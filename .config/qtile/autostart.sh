#!/bin/sh

setxkbmap -layout us,ru -option grp:caps_toggle,grp_led:caps &
killall -q picom; picom &
gxkb &
