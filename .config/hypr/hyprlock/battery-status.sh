#!/bin/bash

# Battery status script for hyprlock
# Place this in ~/.config/hypr/hyprlock/battery-status.sh
# Make executable with: chmod +x ~/.config/hypr/hyprlock/battery-status.sh

# Check if battery exists
if [ ! -d "/sys/class/power_supply/BAT0" ] && [ ! -d "/sys/class/power_supply/BAT1" ]; then
    echo "🖥️ Desktop"
    exit 0
fi

# Find the battery (usually BAT0 or BAT1)
BATTERY=""
if [ -d "/sys/class/power_supply/BAT0" ]; then
    BATTERY="BAT0"
elif [ -d "/sys/class/power_supply/BAT1" ]; then
    BATTERY="BAT1"
fi

if [ -z "$BATTERY" ]; then
    echo "🖥️ Desktop"
    exit 0
fi

# Get battery information
CAPACITY=$(cat /sys/class/power_supply/$BATTERY/capacity 2>/dev/null)
STATUS=$(cat /sys/class/power_supply/$BATTERY/status 2>/dev/null)

# Default values if files don't exist
CAPACITY=${CAPACITY:-0}
STATUS=${STATUS:-Unknown}

# Choose icon based on charging status and level
if [ "$STATUS" = "Charging" ]; then
    ICON="🔌"
elif [ "$STATUS" = "Full" ]; then
    ICON="🔋"
elif [ "$CAPACITY" -ge "80" ]; then
    ICON="🔋"
elif [ "$CAPACITY" -ge "60" ]; then
    ICON="🔋"
elif [ "$CAPACITY" -ge "40" ]; then
    ICON="🔋"
elif [ "$CAPACITY" -ge "20" ]; then
    ICON="🪫"
else
    ICON="🪫"
fi

# Output format
if [ "$STATUS" = "Charging" ]; then
    echo "$CAPACITY% (Charging)"
elif [ "$STATUS" = "Full" ]; then
    echo "$CAPACITY% (Full)"
else
    echo "$CAPACITY%"
fi
