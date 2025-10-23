#!/bin/sh

kbdd &
picom -b &
xset b off &
"$HOME"/.screenlayout/one_monitor.sh &
