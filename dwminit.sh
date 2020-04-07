#!/usr/bin/env sh

xwallpaper --zoom /home/rmj/Pictures/wallpapers/Gnu_wallpaper.png
compton -b

/home/rmj/src/scripts/dwmbar.sh &

exec dwm
