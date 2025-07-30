#!/usr/bin/env bash

##  Rofi Wallpaper Manager with Matugen Integration
##  Place this as ~/.config/rofi/scripts/wallpaper.sh

dir="$HOME/.config/rofi/themes"
theme="wallpaper"
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CURRENT_WALLPAPER="$HOME/.cache/current_wallpaper"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

get_wallpaper_options() {
    echo "📁 Browse Wallpapers"
    echo "🎨 Generate Colors (Matugen)"
    echo "🔄 Reload Apps"
    echo "⚙️  Settings"
    echo "---"

    # List current wallpaper if exists
    if [ -f "$CURRENT_WALLPAPER" ]; then
        current=$(cat "$CURRENT_WALLPAPER")
        echo "📄 Current: $(basename "$current")"
        echo "---"
    fi

    # List wallpapers in directory
    if [ -d "$WALLPAPER_DIR" ] && [ "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]; then
        find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" \) -printf "🖼️  %f\n" | sort
    else
        echo "❌ No wallpapers found in $WALLPAPER_DIR"
    fi
}

browse_wallpapers() {
    if command -v thunar >/dev/null; then
        thunar "$WALLPAPER_DIR" &
    elif command -v nautilus >/dev/null; then
        nautilus "$WALLPAPER_DIR" &
    elif command -v dolphin >/dev/null; then
        dolphin "$WALLPAPER_DIR" &
    elif command -v pcmanfm >/dev/null; then
        pcmanfm "$WALLPAPER_DIR" &
    else
        notify-send "Wallpaper Manager" "No supported file manager found" -i dialog-error
    fi
}

set_wallpaper() {
    local wallpaper_name="$1"
    local wallpaper_path="$WALLPAPER_DIR/$wallpaper_name"

    if [ ! -f "$wallpaper_path" ]; then
        notify-send "Wallpaper Manager" "Wallpaper not found: $wallpaper_name" -i dialog-error
        return 1
    fi

    # Set wallpaper using hyprpaper
    if command -v hyprctl >/dev/null && pgrep -x hyprpaper >/dev/null; then
        hyprctl hyprpaper preload "$wallpaper_path"
        hyprctl hyprpaper wallpaper ",$wallpaper_path"
    elif command -v swww >/dev/null; then
        swww img "$wallpaper_path" --transition-type wipe --transition-duration 1
    elif command -v swaybg >/dev/null; then
        pkill swaybg
        swaybg -i "$wallpaper_path" -m fill &
    else
        notify-send "Wallpaper Manager" "No supported wallpaper utility found" -i dialog-error
        return 1
    fi

    # Save current wallpaper
    echo "$wallpaper_path" > "$CURRENT_WALLPAPER"

    notify-send "Wallpaper Manager" "Wallpaper set: $wallpaper_name" -i image-x-generic
    return 0
}

run_matugen() {
    if [ ! -f "$CURRENT_WALLPAPER" ]; then
        notify-send "Wallpaper Manager" "No wallpaper set. Set a wallpaper first." -i dialog-error
        return 1
    fi

    local wallpaper_path=$(cat "$CURRENT_WALLPAPER")

    if ! command -v matugen >/dev/null; then
        notify-send "Wallpaper Manager" "Matugen not installed" -i dialog-error
        return 1
    fi

    notify-send "Wallpaper Manager" "Generating color scheme..." -i preferences-color

    # Run matugen with the current wallpaper
    if matugen image "$wallpaper_path"; then
        notify-send "Wallpaper Manager" "Color scheme generated successfully!" -i preferences-color

        # Ask if user wants to reload applications
        reload_apps=$(echo -e "Yes\nNo" | rofi -dmenu -p "Reload applications?" -theme "$dir/$theme.rasi")
        if [ "$reload_apps" = "Yes" ]; then
            reload_applications
        fi
    else
        notify-send "Wallpaper Manager" "Failed to generate color scheme" -i dialog-error
    fi
}

reload_applications() {
    notify-send "Wallpaper Manager" "Reloading applications..." -i view-refresh

    # Reload Waybar
    pkill waybar
    sleep 1
    waybar &

    notify-send "Wallpaper Manager" "Applications reloaded" -i dialog-information
}

show_settings() {
    settings_options="🖼️  Set Wallpaper Directory
📋 Show Current Wallpaper Path
🔄 Reset to Default"

    selection=$(echo "$settings_options" | rofi -dmenu -p "⚙️ Settings" -theme "$dir/$theme.rasi")

    case "$selection" in
        "🖼️  Set Wallpaper Directory")
            new_dir=$(rofi -dmenu -p "Wallpaper Directory Path" -theme "$dir/$theme.rasi")
            if [ -n "$new_dir" ] && [ -d "$new_dir" ]; then
                WALLPAPER_DIR="$new_dir"
                notify-send "Wallpaper Manager" "Wallpaper directory set to: $new_dir" -i folder
            fi
            ;;
        "📋 Show Current Wallpaper Path")
            if [ -f "$CURRENT_WALLPAPER" ]; then
                current=$(cat "$CURRENT_WALLPAPER")
                echo "$current" | rofi -dmenu -p "Current Wallpaper" -theme "$dir/$theme.rasi"
            else
                notify-send "Wallpaper Manager" "No wallpaper currently set" -i dialog-information
            fi
            ;;
        "🔄 Reset to Default")
            rm -f "$CURRENT_WALLPAPER"
            notify-send "Wallpaper Manager" "Reset to default" -i edit-undo
            ;;
    esac
}

handle_selection() {
    selection="$1"

    case "$selection" in
        "📁 Browse Wallpapers")
            browse_wallpapers
            ;;
        "🎨 Generate Colors (Matugen)")
            run_matugen
            ;;
        "🔄 Reload Apps")
            reload_applications
            ;;
        "⚙️  Settings")
            show_settings
            ;;
        "📄 Current:"*)
            if [ -f "$CURRENT_WALLPAPER" ]; then
                current=$(cat "$CURRENT_WALLPAPER")
                notify-send "Current Wallpaper" "$(basename "$current")\n$current" -i image-x-generic
            fi
            ;;
        "❌ No wallpapers found"*)
            browse_wallpapers
            ;;
        "---")
            ;;
        *)
            if [ -n "$selection" ] && [[ "$selection" =~ ^🖼️ ]]; then
                wallpaper_name=$(echo "$selection" | sed 's/^🖼️  //')

                if set_wallpaper "$wallpaper_name"; then
                    generate_colors=$(echo -e "Yes\nNo" | rofi -dmenu -p "Generate color scheme?" -theme "$dir/$theme.rasi")
                    if [ "$generate_colors" = "Yes" ]; then
                        run_matugen
                    fi
                fi
            fi
            ;;
    esac
}

# Main execution
if [ $# -eq 0 ]; then
    selection=$(get_wallpaper_options | rofi -dmenu -p "🎨 Wallpaper Manager" -theme ${dir}/${theme}.rasi)
    if [ -n "$selection" ]; then
        handle_selection "$selection"
    fi
else
    handle_selection "$1"
fi
