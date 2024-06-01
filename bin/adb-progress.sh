#!/bin/bash

# function usage()
# {
#     echo "$0 source destination"
#     exit 1
# }

# function progressbar()
# {
#     bar="=================================================="
#     barlength=${#bar}
#     n=$(($1*barlength/100))
#     printf "\r[%-${barlength}s] %d%%" "${bar:0:n}" "$1"
#     # echo -ne "\b$1"
# }

# export -f progressbar

# [[ $# < 2 ]] && usage

# SRC=$1
# DST=$2

# [ ! -f $SRC ] && { \
#     echo "source file not found"; \
#     exit 2; \
# }

# which adb >/dev/null 2>&1 || { \
#     echo "adb doesn't exist in your path"; \
#     exit 3; \
# }

# SIZE=$(ls -l $DST | awk '{print $5}')
# ADB_TRACE=adb adb pull $SRC $DST 2>&1 \
#     | sed -n '/DATA/p' \
#     | awk -v T=$SIZE 'BEGIN{FS="[=:]"}{t+=$7;system("progressbar " sprintf("%d\n", t/T*100))}'

`adb -s 102793736C000579 pull -p /storage/emulated/0/DCIM/VID_20240217_092556~2.mp4 /Users/taidm/Downloads > ./adb_pull_progress.txt` 
adb_pull_pid=$!

# Continuously read the progress lines from the temporary file until the `adb pull` command exits
while read -r line; do
  # Check if the line contains progress information (e.g., "42%...")
    # Extract the progress percentage from the line
    progress_percentage=extractProgressPercentage "$line"

    # Update the progress UI or perform necessary actions based on progress
    echo "Progress: $progress_percentage%"
    # ... Your progress handling logic here ...
done < ./adb_pull_progress.txt

# Wait for the `adb pull` command to finish
wait $adb_pull_pid
