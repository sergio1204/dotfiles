#!/bin/sh

run() {
  if ! pgrep -f "$1"; then
    "$@" &
  fi
}

run picom -b
run xset b off
run "$HOME"/.screenlayout/one_monitor.sh
