#!/bin/sh
MODPATH=/data/adb/modules/sv_sndasphere
if [ ! -d $MODPATH/debug ]; then
mkdir $MODPATH/debug
fi
exec 2>$MODPATH/debug/debug2.txt
set -x
#locations variables
DDLB=$(find /data/adb/modules -path "*/dolby/*" -not -path "/data/adb/modules/sv_sndasphere/*" -type f \( -name "*dax*.xml" -o -name "*dap*.xml" \))
SVDLB=$(find /data/adb/modules/sv_sndasphere -path "*/dolby/*" -not -path "/data/adb/modules/sv_sndasphere/original/*" -type f \( -name "*dax*.xml" -o -name "*dap*.xml" \))

MODULE=$(find $MODPATH -maxdepth 1 -name "*modulemode")

if [ ! -z "$MODULE" ] && [ -z "$DDLB" ];then
	echo "Houston! We have a problem!"
	sed -E -i 's/description=/description=THIS MODULE WILL BE DELETED! DETECTED DOLBY UNINSTALLED! /' $MODPATH/module.prop
	touch $MODPATH/disable
	touch $MODPATH/remove
fi