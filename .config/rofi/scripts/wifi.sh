#!/usr/bin/env bash

##  Rofi WiFi Manager
##  Place this as ~/.config/rofi/scripts/wifi.sh

dir="$HOME/.config/rofi/themes"
theme="wifi"

get_wifi_status() {
    if nmcli radio wifi | grep -q "enabled"; then
        echo "enabled"
    else
        echo "disabled"
    fi
}

get_current_connection() {
    nmcli connection show --active | grep wifi | awk '{print $1}' | head -1
}

scan_networks() {
    current=$(get_current_connection)

    # WiFi controls
    if [ "$(get_wifi_status)" = "enabled" ]; then
        echo "󰖪  Disable WiFi"
    else
        echo "󰖩  Enable WiFi"
    fi

    echo "🔄 Refresh Networks"

    # Show current connection
    if [ -n "$current" ]; then
        echo "---"
        echo "📶 Connected: $current"
    fi

    echo "---"

    # Scan for networks if WiFi is enabled
    if [ "$(get_wifi_status)" = "enabled" ]; then
        nmcli device wifi rescan 2>/dev/null
        sleep 1

        nmcli device wifi list | awk '
        NR>1 {
            # Extract SSID (handle spaces in SSID)
            ssid = ""
            for(i=2; i<=NF-6; i++) {
                if(i==2) ssid = $i
                else ssid = ssid " " $i
            }

            # Extract other fields
            signal = $(NF-2)
            security = $(NF-1)

            # Skip empty SSIDs
            if(ssid != "" && ssid != "--") {
                # Determine icon based on signal strength
                if(signal >= 75) icon = "󰤨"
                else if(signal >= 50) icon = "󰤥"
                else if(signal >= 25) icon = "󰤢"
                else icon = "󰤟"

                # Add security icon
                if(security ~ /WPA|WEP/) sec_icon = "🔒"
                else sec_icon = "🔓"

                printf "%s %s %s %s%%\n", icon, ssid, sec_icon, signal
            }
        }' | sort -k4 -nr | head -15
    fi
}

handle_selection() {
    selection="$1"

    case "$selection" in
        "󰖪 Disable WiFi")
            nmcli radio wifi off
            notify-send "WiFi" "WiFi disabled" -i network-wireless-disabled
            ;;
        "󰖩 Enable WiFi")
            nmcli radio wifi on
            notify-send "WiFi" "WiFi enabled" -i network-wireless
            ;;
        "🔄 Refresh Networks")
            exec "$0"
            ;;
        "📶 Connected:"*)
            # Show connection details
            current=$(get_current_connection)
            notify-send "WiFi" "Currently connected to: $current" -i network-wireless
            ;;
        "---")
            ;;
        *)
            if [ -n "$selection" ]; then
                # Extract SSID from selection
                ssid=$(echo "$selection" | sed 's/^[^ ]* //' | sed 's/ [🔒🔓] [0-9]*%$//')

                # Check if network requires password
                security=$(nmcli device wifi list | grep -F "$ssid" | awk '{print $(NF-1)}' | head -1)

                if [[ "$security" =~ "WPA" ]] || [[ "$security" =~ "WEP" ]]; then
                    # Prompt for password
                    password=$(rofi -dmenu -p "Password for $ssid" -password -theme "$dir/wifi.rasi")
                    if [ -n "$password" ]; then
                        if nmcli device wifi connect "$ssid" password "$password"; then
                            notify-send "WiFi" "Connected to $ssid" -i network-wireless
                        else
                            notify-send "WiFi" "Failed to connect to $ssid" -i dialog-error
                        fi
                    fi
                else
                    # Open network
                    if nmcli device wifi connect "$ssid"; then
                        notify-send "WiFi" "Connected to $ssid" -i network-wireless
                    else
                        notify-send "WiFi" "Failed to connect to $ssid" -i dialog-error
                    fi
                fi
            fi
            ;;
    esac
}

# Main execution
if [ $# -eq 0 ]; then
    selection=$(scan_networks | rofi -dmenu -p "󰤨 WiFi Networks" -theme ${dir}/${theme}.rasi)
    if [ -n "$selection" ]; then
        handle_selection "$selection"
    fi
else
    handle_selection "$1"
fi
