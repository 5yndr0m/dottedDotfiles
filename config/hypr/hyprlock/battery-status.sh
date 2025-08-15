#!/bin/bash

# Outputs Material Symbols icon names based on battery state

# Desktop fallback
if [ ! -d "/sys/class/power_supply/BAT0" ] && [ ! -d "/sys/class/power_supply/BAT1" ]; then
    echo "desktop_windows"
    exit 0
fi

# Determine battery path
BATTERY=""
if [ -d "/sys/class/power_supply/BAT0" ]; then
    BATTERY="BAT0"
elif [ -d "/sys/class/power_supply/BAT1" ]; then
    BATTERY="BAT1"
fi

# Read battery data
CAPACITY=$(cat /sys/class/power_supply/$BATTERY/capacity 2>/dev/null)
STATUS=$(cat /sys/class/power_supply/$BATTERY/status 2>/dev/null)

CAPACITY=${CAPACITY:-0}
STATUS=${STATUS:-Unknown}

if [ "$STATUS" = "Charging" ]; then
    echo "battery_charging_full"
elif [ "$STATUS" = "Full" ]; then
    echo "battery_full"
else
    if [ "$CAPACITY" -ge 90 ]; then
        echo "battery_full"
    elif [ "$CAPACITY" -ge 80 ]; then
        echo "battery_6_bar"
    elif [ "$CAPACITY" -ge 60 ]; then
        echo "battery_5_bar"
    elif [ "$CAPACITY" -ge 50 ]; then
        echo "battery_4_bar"
    elif [ "$CAPACITY" -ge 30 ]; then
        echo "battery_3_bar"
    elif [ "$CAPACITY" -ge 15 ]; then
        echo "battery_2_bar"
    elif [ "$CAPACITY" -ge 5 ]; then
        echo "battery_1_bar"
    else
        echo "battery_0_bar"
    fi
fi
