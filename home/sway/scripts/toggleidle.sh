#!/usr/bin/env zsh
if [[ "$(pgrep "swayidle")" != "" ]]; then
  pkill -9 'swayidle' && notify-send "lock disabled"
else
  swayidle -w timeout 300 'swaylock -f -c 000000' \
    timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
  before-sleep 'swaylock -f -c 000000'&
  notify-send "lock enabled"
fi
