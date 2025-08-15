#!/bin/bash
# Get current track info
artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ] && [ -n "$artist" ] && [ -n "$title" ]; then
    echo "$artist - $title"
elif [ "$status" = "Paused" ] && [ -n "$artist" ] && [ -n "$title" ]; then
    echo "⏸ $artist - $title"
else
    echo "♪ No music playing"
fi
