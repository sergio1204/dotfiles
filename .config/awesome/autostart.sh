#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run picom -b
run xset b off
run setxkbmap -layout us,ru -option grp:alt_shift_toggle
