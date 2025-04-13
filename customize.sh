SKIPUNZIP=1
#creating folders, unzipping files in proper places and giving proper permissions to created folders
unzip -qjo "$ZIPFILE" 'tuning/*' -d $TMPDIR >&2
unzip -qjo "$ZIPFILE" -x 'META-INF/*' 'webroot/*' 'tuning/*' 'LICENSE.txt' 'customize.sh' 'sv_sndasphere_rmv.sh' 'main.sh' 'tuningDIY.txt' -d $MODPATH >&2
unzip -qjo "$ZIPFILE" 'sv_sndasphere_rmv.sh' -d /data/adb/service.d >&2
mkdir $MODPATH/webroot
unzip -qjo "$ZIPFILE" 'webroot/*' -d $MODPATH/webroot >&2
chmod 0755 $MODPATH/webroot
chown root:root $MODPATH/webroot
mkdir $MODPATH/tuning
unzip -qjo "$ZIPFILE" 'tuning/*' -x 'tuning/main.sh' -d $MODPATH/tuning >&2
chmod 0755 $MODPATH/tuning
chown root:root $MODPATH/tuning
chmod 0755 /data/adb/service.d/sv_sndasphere_rmv.sh
chown root:root /data/adb/service.d/sv_sndasphere_rmv.sh

#assigning variable with path to tuningDIY.txt
DIY="/storage/emulated/0/tuningDIY.txt"

#checking DIY version and setting behavior:
if [ -f "$DIY" ]; then
    VER="$(cat "$DIY" 2>/dev/null | grep '^V=' | awk -F "=" '{print $2}' || echo 0)"
    if [ "$VER" -ge "43" ]; then
        echo " -- File tuningDIY.txt is up to date! -- "
        echo " -- Proceed -- "
        echo " "
        sleep 1
    elif [ "$VER" -lt "43" ]; then
        cp -f "$DIY" "/storage/emulated/0/tuningDIY_BACKUP_v$VER.txt"
        unzip -qjo "$ZIPFILE" 'tuningDIY.txt' -d /storage/emulated/0 >&2
        echo " *** PLEASE READ *** "
        sleep 1
        echo " -- Config file (tuningDIY.txt) is outdated! -- "
        echo " -- New config file (tuningDIY.txt) is copied to internal storage -- "
        echo " "
        echo " -- Copy of old tuning file is made. Its name is tuningDIY_BACKUP_v$VER.txt -- "
        echo " "
        echo " -- NOW MODULE WILL PROCEED WITH DEFAULT VALUES -- "
        sleep 5
    fi
else
    unzip -qjo "$ZIPFILE" 'tuningDIY.txt' -d /storage/emulated/0 >&2
    echo " *** PLEASE READ *** "
    sleep 1
    echo " -- Config file (tuningDIY.txt) is copied to internal storage -- "
    echo " "
    echo " -- NOW MODULE WILL PROCEED WITH DEFAULT VALUES -- "
    sleep 5
fi

#nevermind^^
set +x
auth=$(grep "author" "$MODPATH/module.prop" | awk -F "=" '{ print $2 }')
name=$(grep "name" "$MODPATH/module.prop" | awk -F "=" '{ print $2 }')

#if everything is okay, then proceed with tuning process, if not, abort flashing process
if [ "$auth" == "ShadoV90" ] && [ "$name" == "SoundATMOSphere" ]; then
    set -x
    if [ -f "$TMPDIR/main.sh" ]; then
        . "$TMPDIR/main.sh"
    else
        echo "Error: main.sh not found in $TMPDIR"
        exit 1
    fi
else
    exit 1
fi