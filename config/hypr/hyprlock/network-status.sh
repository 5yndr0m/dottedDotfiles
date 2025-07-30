#!/bin/bash

# Network status script for hyprlock
# Place this in ~/.config/hypr/hyprlock/network-status.sh
# Make executable with: chmod +x ~/.config/hypr/hyprlock/network-status.sh

# Check for ethernet connection first
ETH_INTERFACE=$(ip route | grep default | grep -E 'eth[0-9]|enp[0-9]' | head -1 | awk '{print $5}')
if [ -n "$ETH_INTERFACE" ]; then
    ETH_STATUS=$(cat /sys/class/net/$ETH_INTERFACE/operstate 2>/dev/null)
    if [ "$ETH_STATUS" = "up" ]; then
        echo "Ethernet Connected"
        exit 0
    fi
fi

# Check for WiFi connection
WIFI_INTERFACE=$(ip route | grep default | grep -E 'wlan[0-9]|wlp[0-9]' | head -1 | awk '{print $5}')
if [ -n "$WIFI_INTERFACE" ]; then
    WIFI_STATUS=$(cat /sys/class/net/$WIFI_INTERFACE/operstate 2>/dev/null)
    if [ "$WIFI_STATUS" = "up" ]; then
        # Try to get WiFi network name using different methods
        SSID=""

        # Method 1: iwgetid
        if command -v iwgetid >/dev/null 2>&1; then
            SSID=$(iwgetid -r 2>/dev/null)
        fi

        # Method 2: nmcli (NetworkManager)
        if [ -z "$SSID" ] && command -v nmcli >/dev/null 2>&1; then
            SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2 | head -1)
        fi

        # Method 3: iw (if available)
        if [ -z "$SSID" ] && command -v iw >/dev/null 2>&1; then
            SSID=$(iw dev $WIFI_INTERFACE link | grep SSID | awk '{print $2}')
        fi

        # Method 4: wpa_cli (if available)
        if [ -z "$SSID" ] && command -v wpa_cli >/dev/null 2>&1; then
            SSID=$(wpa_cli -i $WIFI_INTERFACE status 2>/dev/null | grep '^ssid=' | cut -d'=' -f2)
        fi

        if [ -n "$SSID" ]; then
            echo "$SSID"
        else
            echo "WiFi Connected"
        fi
        exit 0
    fi
fi

# Check if any interface has internet connectivity
if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo "Connected"
else
    # Check if any interface is up but no internet
    if ip route | grep default >/dev/null 2>&1; then
        echo "No Internet"
    else
        echo "Disconnected"
    fi
fi
