#!/bin/bash

# Power profile script for Waybar
# Place this at ~/.config/waybar/scripts/power-profile.sh
# Make it executable: chmod +x ~/.config/waybar/scripts/power-profile.sh

get_current_profile() {
    powerprofilesctl get 2>/dev/null || echo "balanced"
}

get_profile_icon() {
    case "$1" in
        "power-saver")
            echo "󰌪"  # Battery save icon
            ;;
        "balanced")
            echo "󰾅"  # Balanced icon
            ;;
        "performance")
            echo "󰓅"  # Performance/rocket icon
            ;;
        *)
            echo "󰾅"  # Default to balanced
            ;;
    esac
}

cycle_profile() {
    current=$(get_current_profile)

    case "$current" in
        "power-saver")
            powerprofilesctl set balanced
            ;;
        "balanced")
            powerprofilesctl set performance
            ;;
        "performance")
            powerprofilesctl set power-saver
            ;;
        *)
            powerprofilesctl set balanced
            ;;
    esac
}

if [ "$1" = "toggle" ]; then
    cycle_profile
else
    current_profile=$(get_current_profile)
    icon=$(get_profile_icon "$current_profile")
    echo "$icon"
fi
