#!/bin/bash

PIDFILE="$HOME/.cache/hypridle.pid"
ICON_ON="☕"
ICON_OFF="💤"

toggle_caffeine() {
    if pgrep -f hypridle > /dev/null; then
        # Hypridle is running, kill it (caffeine ON)
        pkill hypridle
        notify-send "Caffeine" "Sleep prevention enabled $ICON_ON" -t 2000
        echo "Caffeine: ON"
    else
        # Hypridle is not running, start it (caffeine OFF)
        hypridle &
        notify-send "Caffeine" "Sleep prevention disabled $ICON_OFF" -t 2000
        echo "Caffeine: OFF"
    fi
}

status_caffeine() {
    if pgrep -f hypridle > /dev/null; then
        echo "$ICON_OFF OFF"
    else
        echo "$ICON_ON ON"
    fi
}

case "$1" in
    toggle)
        toggle_caffeine
        ;;
    status)
        status_caffeine
        ;;
    *)
        echo "Usage: $0 {toggle|status}"
        exit 1
        ;;
esac
