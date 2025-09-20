#!/bin/sh

kbdd &
picom -b &
xset b off &
"$HOME"/.screenlayout/qtile.sh
