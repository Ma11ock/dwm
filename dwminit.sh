#!/usr/bin/env sh

# Ryan's dwm init script

xwallpaper --zoom <-->
compton -b # You might want to change this line

<++>/src/dwm/dwmbar.sh &

exec dwm
