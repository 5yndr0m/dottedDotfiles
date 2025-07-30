#!/usr/bin/env bash

##  Rofi App Launcher
##  Author: Material Design Rofi
##  Place this as ~/.config/rofi/scripts/launcher.sh

dir="$HOME/.config/rofi/themes"
theme="launcher"

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
