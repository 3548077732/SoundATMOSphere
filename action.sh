#!/bin/sh
MODPATH=${0%/*}
mount -o rw,remount /data
mount -o rw,remount $MODPATH 2>/dev/null
exec 2>$MODPATH/actiondebug.txt
set -x

#remove dolby settings database (will rebuild itself after reboot)
rm -f /data/vendor/dolby/*

#location variable
ASVDLB=$(find $MODPATH -type d -name "dolby" -not -path "/data/adb/modules/sv_sndasphere/original/*")
if [ ! -z "$ASVDLB" ];then
	SVDLB=$(find $ASVDLB -type f -name "*dax*.xml" -o -name "*dap*.xml")
	sleep 0.2
fi

#DIY path
DIY="/storage/emulated/0/tuningDIY.txt"

rm -rf $MODPATH/temp/*
rmdir $MODPATH/temp
mkdir -p $MODPATH/temp
chmod 0755 $MODPATH/temp
sleep 0.5

OFILES=$(find $MODPATH/original -type f -name "*.xml")
FILE_COUNTER=1
for FILE in ${OFILES};do
mkdir -p "$(echo "$(dirname "$FILE")" | sed "s|$MODPATH/original|$MODPATH/temp|")"
cp "$FILE" "$(echo "$FILE" | sed "s|$MODPATH/original|$MODPATH/temp|")"
done

. $MODPATH/tuning/config_vars.sh

FILES=$(find $MODPATH/temp -type f -name "*.xml")
FILES_TOTAL="$(echo "$OFILES" | wc -w)"
FILE_COUNTER=1
echo "-- Files to patch: $FILES_TOTAL --"
echo "-- Proceed --"
sleep 1
for i in ${FILES}; do
TARGET="$(echo "$i" | sed "s|$MODPATH/temp|$MODPATH|")"
echo " "
echo " -- Applying tuning to file number: $FILE_COUNTER -- "
echo " "
	. $MODPATH/tuning/tuning_vars.sh
	
	if [ $headphonetuning == "true" ] || [ $spookertuning == "true" ];then
		. $MODPATH/tuning/tuning_global_profiles.sh
		. $MODPATH/tuning/tuning_ieq_regulator.sh
	fi
	if [ $headphonetuning == "true" ];then
		. $MODPATH/tuning/tuning_headphone_profiles.sh
		. $MODPATH/tuning/tuning_headphones.sh
	fi
	if [ $spookertuning == "true" ];then
		. $MODPATH/tuning/tuning_speaker_profiles.sh
		. $MODPATH/tuning/tuning_speaker.sh
	fi
	
if [ -s "$i" ]; then
    cat "$i" > "$TARGET"
    #Verification of success
    if [ ! -s "$TARGET" ]; then
        echo "ERROR: $TARGET is empty, trying second method" >&2
		echo "$(cat "$i")">"$(echo "$i" | sed "s|$MODPATH/temp|$MODPATH|")"
		if [ ! -s "$TARGET" ]; then
			echo "ERROR: $TARGET is still empty" >&2
			exit 1
		fi
    fi
else
    echo "ERROR: $TEMP is empty or does not exist" >&2
    exit 1
fi
FILE_COUNTER=$(($FILE_COUNTER+1))

#un-setting variables
unset harm angle distance advancedvirt dyn mov mus cus bal det warm spk spk1 hph hph1 sam pass diff1 diff2 spkend hphend last rang1 rang2

done

for DLB in ${SVDLB};do
mount -o bind "$DLB" "$(echo "$DLB" | sed "s|$MODPATH||")"
done

rm -rf $MODPATH/temp/*
rmdir $MODPATH/temp
DLBSERV=$(find /*/bin/hw -type f -name "*vendor.dolby*dms*service")
if [ ! -z "$DLBSERV" ];then
for serv in ${DLBSERV};do
echo " "
echo " -- restarting service: "
echo " $serv "
su -c setprop sys.audio.restart.hal 1
sleep 5
su -c killall "$serv"
sleep 1
su -c $serv &
done
else
su -c setprop sys.audio.restart.hal 1
fi
sleep 5
echo " "
echo " -- DONE! -- "
