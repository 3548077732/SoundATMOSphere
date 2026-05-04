#!/bin/sh
MODPATH=${0%/*}
if [ ! -d "$MODPATH/debug" ]; then
    mkdir "$MODPATH/debug"
fi

exec >"$MODPATH/debug/watcher.txt" 2>&1
set -x

# Looking for builtin mode, it's important
[ -f "$MODPATH/.builtinmode" ] && BUILTIN=true || BUILTIN=false

# Assigning variables, by default they are zero
bootcomplete=0
dolbyservice=0
DLBSERV=""

# Checking for boot complete
boottest(){
    timeout1=60
    while [ "$(getprop sys.boot_completed)" != 1 ] && [ $timeout1 -gt 0 ];do
        sleep 1
        timeout1=$((timeout1-1))
    done
    
    if [ "$timeout1" -eq 0 ]; then
        echo " -- System boot_complete prop wasn't set to 1 -- "
        exit 1
    else
        echo " -- System boot completed - Proceed -- "
        bootcomplete=1
    fi
}

# Checking for dolby service files
servicetest(){
    DLBSERV=$(find /*/bin/hw -type f -name '*dms*' -o -name '*dolby*' 2>/dev/null)
    
    if [ -z "$DLBSERV" ]; then
        echo " -- no Dolby service BINARIES found - break operation immediately! -- "
        exit 1
    else
        echo " -- Dolby service binaries found! - Proceed -- "
        dolbyservice=1
    fi
}

# Launching functions
boottest
servicetest

# Main watcher logic
if [ $bootcomplete -eq 1 ] && [ $dolbyservice -eq 1 ];then
    if [ ! -z "$DLBSERV" ]; then
        restart_service() {
            srv_path="$1"
            srv_name=$(basename "$srv_path")
            PID_RECHECK=$(pidof "$srv_name")
            if [ -z "$PID_RECHECK" ]; then
                echo " -- restarting service: $srv_name -- "
                if ! start "$srv_name"; then
                    echo " -- 'start' failed (service unknown to init?), trying su -c fallback -- "
                    su -c "$srv_path" &
                fi
            fi
        }
        set +x
        # Main watcher loop
        while true; do
            # Grab the exact line with mWakefulness (stops parsing after first match for efficiency)
            WAKE_STATE=$(dumpsys power 2>/dev/null | grep -m 1 "mWakefulness=")
            
            if [ -z "$WAKE_STATE" ]; then
                # FAIL-SAFE: If dumpsys fails or format changes completely
                # Fall back to a safe 3-second interval and proceed with checking.
                sleep 3
                elif echo "$WAKE_STATE" | grep -q -e "Awake" -e "1"; then
                # Screen is ON
                sleep 1
            else
                # Screen is OFF (e.g. Asleep, Dozing, 0, 3)
                sleep 10
                continue
            fi
            
            echo "$DLBSERV" | while read -r SRV; do
                if [ -s "$SRV" ]; then
                    SRV_NAME=$(basename "$SRV")
                    PID=$(pidof "$SRV_NAME")
                    
                    if [ -z "$PID" ]; then
                        set -x
                        echo " -- Service $SRV_NAME seems to be down! -- "
                        if [ "$BUILTIN" = true ]; then
                            sleep 5
                            restart_service "$SRV" &
                        else
                            sleep 1
                            restart_service "$SRV" &
                        fi
                        set +x
                    fi
                fi
            done
        done
    fi
fi
