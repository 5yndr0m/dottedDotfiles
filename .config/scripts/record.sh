#!/bin/bash

pidfile="/tmp/wf-recorder.pid"

case $1 in
    "area")
        if [ -f "$pidfile" ]; then
            notify-send "Recording" "Already recording"
            exit 1
        fi

        geometry=$(slurp)
        if [ -n "$geometry" ]; then
            wf-recorder -g "$geometry" -f ~/Videos/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4 &
            echo $! > "$pidfile"
            notify-send "Recording Started" "Recording selected area"
        fi
        ;;
    "screen")
        if [ -f "$pidfile" ]; then
            notify-send "Recording" "Already recording"
            exit 1
        fi

        wf-recorder -f ~/Videos/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4 &
        echo $! > "$pidfile"
        notify-send "Recording Started" "Recording full screen"
        ;;
    "stop")
        if [ -f "$pidfile" ]; then
            kill $(cat "$pidfile")
            rm "$pidfile"
            notify-send "Recording Stopped" "Video saved to Videos/Recordings"
        else
            notify-send "Recording" "No active recording"
        fi
        ;;
esac
