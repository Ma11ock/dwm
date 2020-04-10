#!/usr/bin/env sh

# Mark the scripts as executable and
# get the users home dir and place it in the scripts so it knows where the other scripts are
files=(dwmbar.sh dwminit.sh ryansleep.sh)

for file in $files; do
    chmod +x "$file"
    sed -i -e 's-<++>-'"$(getent passwd "`whoami`" | cut -d: -f6)"'-g' "$file"
done

