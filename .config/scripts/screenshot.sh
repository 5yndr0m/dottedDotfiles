#!/bin/bash

case $1 in
    "area")
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot" "Area copied to clipboard"
        ;;
    "screen")
        grim - | wl-copy
        notify-send "Screenshot" "Full screen copied to clipboard"
        ;;
    "window")
        grim -g "$(slurp -w)" - | wl-copy
        notify-send "Screenshot" "Window copied to clipboard"
        ;;
    "save-area")
        grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
        notify-send "Screenshot" "Area saved to Pictures/Screenshots"
        ;;
    "save-screen")
        grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
        notify-send "Screenshot" "Full screen saved to Pictures/Screenshots"
        ;;
esac
