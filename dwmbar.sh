#!/usr/bin/env sh

# Length of the song title mpd is playing
SONG_LEN=25

get_battery() {
    cap=$(cat /sys/class/power_supply/BAT0/capacity) || return 1
    status=$(cat /sys/class/power_supply/BAT0/status)
    emoji=🔌

    [ "$status" = "Discharging" ] && [ "$cap" -le 25 ] && emoji=❗
    [ "$status" = "Discharging" ] && emoji=🔋

    echo "$emoji $cap%"
}

get_volume() {
    volume=$(pamixer --get-volume)
    emoji=🔉 # default is medium volume

    if [ "$volume" -eq 0 ]; then
        emoji=🔇
    elif [ "$volume" -le 50 ]; then
        emoji=🔈
    elif [ "$volume" -ge 120 ]; then
        emoji=🔊
    fi

    echo "$emoji $volume%"
    
}

# Get the current song from mpd
get_song() {
    song=$(mpc current) || return 1
    emoji=🎵

    [ -z "$song" ] && emoji=''

    echo "$emoji $(echo $song | cut -c 1-$SONG_LEN)"
}

get_cpu_usage() {
    echo "💻 $(top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1"%"}')"
}

get_cpu_temp() {
    temp=$(cat /sys/class/thermal/thermal_zone1/temp | cut -c 1-2)
    emoji=🌡

    [ temp -ge 60 ] && emoji=🔥

    echo "$emoji $temp°C"
}

get_used_mem() {
    total=$(cat /proc/meminfo | awk '{print $2}' | head -1)
    free=$(cat /proc/meminfo | awk '{print $2}' | sed -n 2p)
    emoji=🧠

    used=$(expr $total / $free)

    [ used -ge 70 ] && emoji=🤯

    echo "$emoji $used%"
}

get_ssid() {
    emoji=🌐
    output=''
    
    for interface in $(ip link | awk 'NR % 2 == 1 {print $2}' | sed -e 's/://g'); do
        iwout=$(iw dev "$interface" link)
        [ "$iwout" == "Not Connected." ] || output=$(iw dev "$interface" link | sed -n  2p | sed -e 's/SSID://g' | sed -e 's/\s//g')
    done

    # Check if output is empty and set it to not conntected if so
    [ -z "$output" ] && output="Not Connected" && emoji=❗

    echo "$emoji $output"
}

while true; do
    xsetroot -name " $(get_song) | $(get_volume) | $(get_ssid) | $(get_used_mem)  | $(get_cpu_usage) | $(get_cpu_temp)  | $(get_battery) | 📅 $(date +"%a, %b %d - %I:%M %p") | $(whoami)"
    
    $HOME/src/dwm/ryansleep.sh
done
