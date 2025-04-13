#!/bin/sh
#remove dolby settings database (will rebuild itself after reboot)
rm -f /data/vendor/dolby/*
MODPATH=${0%/*}
exec 2>$MODPATH/debug.txt
set -x
#locations variables
ADDLB=$(find /data/adb/modules -type d -name "dolby" -not -path "/data/adb/modules/sv_sndasphere/*")
if [ ! -z "$ADDLB" ];then
DDLB=$(find "$ADDLB" -type f -name "*dax*.xml" -o -name "*dap*.xml")
sleep 0.2
fi
ADLB=$(find /system /vendor /odm /my* /product -type d -name "dolby")
if [ ! -z "$ADLB" ];then
DLB=$(find "$ADLB" -type f -name "*dax*.xml" -o -name "*dap*.xml")
sleep 0.2
fi

MODE=$(find "$MODPATH" -maxdepth 1 -name "*builtinmode" -o -name "*modulemode")
if [ "$MODE" == "$MODPATH/.modulemode" ];then
MODE=M
elif [ "$MODE" == "$MODPATH/.builtinmode" ];then
MODE=B
else
MODE=N
fi

if [ "$MODE" == "B" ];then
for j in ${DLB}; do
i=$MODPATH$j
k=$MODPATH/original$j

	if [ ! "$(diff "$j" "$k")" ];then
	echo "ok"
	rm -f $MODPATH/disable
	else
	echo "We have a problem"
	sed -E -i 's/description=/description=REINSTALL MODULE! DIFFERENT DOLBY CONFIG DETECTED! /' $MODPATH/module.prop
	mv -f $MODPATH/service.sh $MODPATH/disabled_service.sh
	touch $MODPATH/disable
	rm -f $k
	fi

done
fi

if [ "$MODE" == "M" ];then
for j in ${DDLB}; do
i="$(echo $j | sed "s|/data/adb/modules/[[:alnum:]]*/|$MODPATH/|")"
k="$(echo $i | sed "s|$MODPATH|$MODPATH/original|")"

	if [ -f "$k"  ] && [ ! "$(diff "$j" "$k")" ];then
	echo "ok"
	rm -f $MODPATH/disable
	else
	echo "We have a problem"
	sed -E -i 's/description=/description=REINSTALL MODULE! DIFFERENT DOLBY CONFIG DETECTED! /' $MODPATH/module.prop
	mv -f $MODPATH/service.sh $MODPATH/disabled_service.sh
	touch $MODPATH/disable
	rm -f $k
	fi

done
fi
if [ "$MODE" == "N" ];then
echo "We have a problem... no 'mode' file"
mv -f $MODPATH/service.sh $MODPATH/disabled_service.sh
touch $MODPATH/disable
fi