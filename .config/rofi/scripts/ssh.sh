#!/usr/bin/env bash

##  Rofi SSH Manager
##  Place this as ~/.config/rofi/scripts/ssh.sh

dir="$HOME/.config/rofi/themes"
theme="ssh"
SSH_CONFIG="$HOME/.ssh/config"

get_ssh_hosts() {
    echo "➕ Add New Host"
    echo "🔧 Edit SSH Config"
    echo "⚡ Quick Connect"
    echo "---"

    # Parse SSH config file
    if [ -f "$SSH_CONFIG" ]; then
        awk '/^Host / && !/\*/ {
            host = $2
            user = ""
            hostname = ""
            port = ""
        }
        /^[[:space:]]*User / { user = $2 }
        /^[[:space:]]*HostName / { hostname = $2 }
        /^[[:space:]]*Port / { port = $2 }
        /^Host / && NR > 1 && prev_host != "" {
            if(prev_hostname == "") prev_hostname = prev_host
            if(prev_port == "") prev_port = "22"
            if(prev_user != "") {
                printf "🖥️  %s (%s@%s:%s)\n", prev_host, prev_user, prev_hostname, prev_port
            } else {
                printf "🖥️  %s (%s:%s)\n", prev_host, prev_hostname, prev_port
            }
        }
        {
            prev_host = host
            prev_user = user
            prev_hostname = hostname
            prev_port = port
        }
        END {
            if(host != "" && host != "*") {
                if(hostname == "") hostname = host
                if(port == "") port = "22"
                if(user != "") {
                    printf "🖥️  %s (%s@%s:%s)\n", host, user, hostname, port
                } else {
                    printf "🖥️  %s (%s:%s)\n", host, hostname, port
                }
            }
        }' "$SSH_CONFIG" 2>/dev/null
    fi
}

add_new_host() {
    host_alias=$(rofi -dmenu -p "Host Alias" -theme "$dir/$theme.rasi")
    [ -z "$host_alias" ] && return

    hostname=$(rofi -dmenu -p "Hostname/IP" -theme "$dir/$theme.rasi")
    [ -z "$hostname" ] && return

    username=$(rofi -dmenu -p "Username (optional)" -theme "$dir/$theme.rasi")
    port=$(rofi -dmenu -p "Port (default: 22)" -theme "$dir/$theme.rasi")
    [ -z "$port" ] && port="22"

    # Create SSH config entry
    {
        echo ""
        echo "Host $host_alias"
        echo "    HostName $hostname"
        [ -n "$username" ] && echo "    User $username"
        [ "$port" != "22" ] && echo "    Port $port"
        echo "    ServerAliveInterval 60"
        echo "    ServerAliveCountMax 3"
    } >> "$SSH_CONFIG"

    notify-send "SSH" "Added host: $host_alias" -i network-server
}

quick_connect() {
    connection=$(rofi -dmenu -p "user@host:port or host:port" -theme "$dir/$theme.rasi")
    [ -z "$connection" ] && return

    # Parse connection string
    if [[ "$connection" =~ ^([^@]+)@([^:]+):?([0-9]+)?$ ]]; then
        user="${BASH_REMATCH[1]}"
        host="${BASH_REMATCH[2]}"
        port="${BASH_REMATCH[3]:-22}"
        ssh_cmd="ssh -p $port $user@$host"
    elif [[ "$connection" =~ ^([^@]+)@([^:]+)$ ]]; then
        user="${BASH_REMATCH[1]}"
        host="${BASH_REMATCH[2]}"
        ssh_cmd="ssh $user@$host"
    elif [[ "$connection" =~ ^([^:]+):([0-9]+)$ ]]; then
        host="${BASH_REMATCH[1]}"
        port="${BASH_REMATCH[2]}"
        ssh_cmd="ssh -p $port $host"
    else
        ssh_cmd="ssh $connection"
    fi

    launch_ssh_terminal "$ssh_cmd"
}

launch_ssh_terminal() {
    local ssh_cmd="$1"

    # Detect available terminal
    if command -v kitty >/dev/null; then
        kitty --title "SSH: $ssh_cmd" -e bash -c "$ssh_cmd; exec bash"
    elif command -v alacritty >/dev/null; then
        alacritty --title "SSH: $ssh_cmd" -e bash -c "$ssh_cmd; exec bash"
    elif command -v wezterm >/dev/null; then
        wezterm start --cwd ~ -- bash -c "$ssh_cmd; exec bash"
    elif command -v foot >/dev/null; then
        foot --title="SSH: $ssh_cmd" bash -c "$ssh_cmd; exec bash"
    else
        x-terminal-emulator -e bash -c "$ssh_cmd; exec bash" 2>/dev/null || \
        xterm -title "SSH: $ssh_cmd" -e bash -c "$ssh_cmd; exec bash"
    fi
}

handle_selection() {
    selection="$1"

    case "$selection" in
        "➕ Add New Host")
            add_new_host
            ;;
        "🔧 Edit SSH Config")
            if command -v code >/dev/null; then
                code "$SSH_CONFIG"
            elif command -v nano >/dev/null; then
                kitty -e nano "$SSH_CONFIG" 2>/dev/null || \
                alacritty -e nano "$SSH_CONFIG" 2>/dev/null || \
                xterm -e nano "$SSH_CONFIG"
            else
                notify-send "SSH" "No suitable editor found" -i dialog-error
            fi
            ;;
        "⚡ Quick Connect")
            quick_connect
            ;;
        "---")
            ;;
        *)
            if [ -n "$selection" ] && [[ "$selection" =~ ^🖥️ ]]; then
                host_alias=$(echo "$selection" | sed 's/^🖥️  //' | awk '{print $1}')
                launch_ssh_terminal "ssh $host_alias"
                notify-send "SSH" "Connecting to $host_alias" -i network-server
            fi
            ;;
    esac
}

# Create SSH config if it doesn't exist
mkdir -p "$HOME/.ssh"
[ ! -f "$SSH_CONFIG" ] && touch "$SSH_CONFIG"

# Main execution
if [ $# -eq 0 ]; then
    selection=$(get_ssh_hosts | rofi -dmenu -p "🔐 SSH Connections" -theme ${dir}/${theme}.rasi)
    if [ -n "$selection" ]; then
        handle_selection "$selection"
    fi
else
    handle_selection "$1"
fi
