#!/bin/sh

kbdd &
picom -b &
xset b off &
"$HOME"/.screenlayout/one_monitor.sh &
qtile cmd-obj -o cmd -f reload_config &
