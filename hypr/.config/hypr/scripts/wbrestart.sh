#!/bin/bash

killall -9 swaync
killall -9 waybar

# waybar
waybar --config ~/.config/waybar/top/config --style ~/.config/waybar/top/style.css &
# waybar --config ~/.config/waybar/bottom/config --style ~/.config/waybar/bottom/style.css &

