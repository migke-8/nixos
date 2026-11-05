#!/usr/bin/env zsh

current_ws=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)
direction=$1

if [ "$direction" = "Right" ]; then
    local new_pos=$((current_ws+1))
    
    [ $((new_pos)) -gt 10 ] && new_pos=10
    swaymsg workspace $new_pos
elif [ "$direction" = "Left" ]; then
    local new_pos=$((current_ws-1))
    
    [ $((new_pos)) -lt 1 ] && new_pos=1
    swaymsg workspace $new_pos
fi
