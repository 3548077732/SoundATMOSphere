#!/bin/sh
MODPATH=${0%/*}
#deleting dolby database (should rebuild itself after reboot if xml is properly patched)
rm -rf /data/vendor/dolby/*

#disable volume warning
resetprop -n audio.safemedia.bypass true

#mounting files (and restart audioserver)
for i in $(find $MODPATH -type f -name "*.xml"); do 
  j=$(echo $i | sed "s|$MODPATH||")
  mount -o bind $i $j
done
while [ "$(getprop sys.boot_completed)" =! 1]; do
sleep 1
done
killall -q com.dolby.daxservice
killall -q com.oplus.audio.effectcenter
killall -q com.oplus.persist.multimedia
killall -q audioserver