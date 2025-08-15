#!/bin/bash

# Get current power profile using powerprofilesctl
PROFILE=$(powerprofilesctl get 2>/dev/null)

# Fallback
PROFILE=${PROFILE:-"unknown"}

case "$PROFILE" in
    performance)
        echo "speed"
        ;;
    balanced)
        echo "battery_std"
        ;;
    power-saver)
        echo "battery_saver"
        ;;
    *)
        echo "power_off"
        ;;
esac
