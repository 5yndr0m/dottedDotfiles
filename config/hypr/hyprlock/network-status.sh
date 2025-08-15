#!/bin/bash

# Outputs Material Symbols icon names based on network connection status

# Check Ethernet connection
ETH_INTERFACE=$(ip route | grep default | grep -E 'eth[0-9]|enp[0-9]' | head -1 | awk '{print $5}')
if [ -n "$ETH_INTERFACE" ]; then
    ETH_STATUS=$(cat /sys/class/net/$ETH_INTERFACE/operstate 2>/dev/null)
    if [ "$ETH_STATUS" = "up" ]; then
        echo "cable"  # Material icon for Ethernet
        exit 0
    fi
fi

# Check Wi-Fi connection
WIFI_INTERFACE=$(ip route | grep default | grep -E 'wlan[0-9]|wlp[0-9]' | head -1 | awk '{print $5}')
if [ -n "$WIFI_INTERFACE" ]; then
    WIFI_STATUS=$(cat /sys/class/net/$WIFI_INTERFACE/operstate 2>/dev/null)
    if [ "$WIFI_STATUS" = "up" ]; then
        echo "wifi"  # Material icon for Wi-Fi
        exit 0
    fi
fi

# Check general connectivity (e.g., VPN, unknown iface)
if ping -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
    echo "network_check"  # Generic "Connected" icon
    exit 0
fi

# No connectivity
echo "signal_wifi_off"  # Material icon for "No connection"
