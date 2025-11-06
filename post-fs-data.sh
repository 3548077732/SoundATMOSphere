#!/bin/sh
MODPATH=${0%/*}
if [ ! -d $MODPATH/debug ]; then
mkdir -p $MODPATH/debug
fi
exec 2>$MODPATH/debug/post-fs_debug.txt
set -x

emergency() {
touch $MODPATH/.emergency
}

DDLB=$(find /data/adb/modules -path "*/dolby/*" -not -path "/data/adb/modules/sv_sndasphere/*" -type f \( -name "*dax*.xml" -o -name "*dap*.xml" \))
SVDLB=$(find /data/adb/modules/sv_sndasphere -path "*/dolby/*" -not -path "/data/adb/modules/sv_sndasphere/original/*" -type f \( -name "*dax*.xml" -o -name "*dap*.xml" \))
DLB=$(find /system /vendor /odm /my* /product -path "*/dolby/*" -type f \( -name "*dax*.xml" -o -name "*dap*.xml" \))

#looking for "mode" file
BLT=$MODPATH/.builtinmode
MDL=$MODPATH/.modulemode
if [ -f "$MDL" ];then
MODE=M
elif [ -f "$BLT" ];then
MODE=B
else
MODE=N
fi

#if built-in mode is detected, then check if there is a difference between original file and file copied to "original" folder
if [ "$MODE" == "B" ];then
	printf "%b\n" "$DLB" | while IFS= read -r i; do
		j="$MODPATH/original$i"
		if cmp -s "$i" "$j"; then
			echo "ok"
		else
			[ -f "$j" ] && rm -f "$j"
			echo "We have a problem"
			emergency
		fi
	done
fi

#if module mode is detected, then check if there is a difference between original file in base module and file copied to "original" folder
if [ "$MODE" == "M" ];then
	printf "%b\n" "$DDLB" | while IFS= read -r i; do
		j="$(echo $i | sed "s|/data/adb/modules/[^/]*/|$MODPATH/original/|")"
		if cmp -s "$i" "$j";then
			echo "ok"
		else
			[ -f "$j" ] && rm -f $j
			echo "We have a problem"
			emergency
		fi
	done
fi

#if no mode file is detected, then disable module to prevent any incompatibilities
if [ "$MODE" == "N" ];then
	echo "We have a problem... no 'mode' file"
	emergency
fi

if [ ! -d $MODPATH/original ]; then
	echo "We have a problem. No original file detected! Activate emergency protocol!"
	emergency
fi

if [ -f $MODPATH/.emergency ];then
. $MODPATH/tuning/main.sh
fi
