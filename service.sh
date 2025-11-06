#!/bin/sh
MODPATH=${0%/*}
if [ ! -d $MODPATH/debug ]; then
	mkdir $MODPATH/debug
fi
exec 2>$MODPATH/debug/service_debug.txt
set -x

check_mount_restart() {
find "$MODPATH" -type f -name "*.xml" -not -path "$MODPATH/original/*" | while read -r x; do
    y="${x#$MODPATH}"
    if [ -f "$y" ]; then
        if ! cmp -s "$x" "$y"; then
            echo " -- Files $x and $y are different. Mounting modded file. -- "
            mount -o bind "$x" "$y" && touch "$FLAG_FILE"
        else
            echo " -- Files $x and $y are identical. Skip. -- "
        fi
    else
        echo " -- File $y NOT found even in service stage. Check module dependencies. --"
    fi
done

if [ -f "$FLAG_FILE" ]; then
    rm -f "$FLAG_FILE"
    rm -f /data/vendor/dolby/*

    find /*/bin/hw -type f -name '*dolby*' 2>/dev/null | while read -r SERV; do
        if [ -s "$SERV" ]; then
            echo " -- restarting service: $SERV"
            PID=$(pidof "$(basename "$SERV")")
            if [ -n "$PID" ]; then
                for p in $PID; do
                    echo "PID: $p"
                    kill "$p"
                done
            fi
        fi
    done

    pkill -f mediaserver
    pkill -f audioserver
else
    echo "No new files were mounted. No services restarted."
fi
}

FLAG_FILE="$MODPATH/debug/MOUNTED_FLAG"
IS_MOUNTED=false

resetprop -n audio.safemedia.bypass true

rm -f "$FLAG_FILE"

check_mount_restart


until [ "$(getprop sys.boot_completed)" = "1" ]; do
	sleep 1
done

check_mount_restart

chmod +x $MODPATH/service_watcher.sh 2>/dev/null
setsid "$MODPATH/service_watcher.sh" &

if [ -f $MODPATH/.emergencydone ]; then
    rm -f $MODPATH/.emergency
    rm -f $MODPATH/.emergencydone
fi