#!/bin/sh
MODPATH=/data/adb/modules/sv_sndasphere
exec 2>$MODPATH/debug2.txt
set -x
#locations variables

ADDLB=$(find /data/adb/modules -type d -name "dolby" -not -path "/data/adb/modules/sv_sndasphere/*")
if [ ! -z "$ADDLB" ];then
	DDLB=$(find $ADDLB -type f -name "*dax*.xml" -o -name "*dap*.xml")
fi
sleep 0.2
ASVDLB=$(find /data/adb/modules/sv_sndasphere -type d -name "dolby" -not -path "/data/adb/modules/sv_sndasphere/original/*")
if [ ! -z "$ASVDLB" ];then
	SVDLB=$(find $ASVDLB -type f -name "*dax*.xml" -o -name "*dap*.xml")
fi
sleep 0.2

MODULE=$(find $MODPATH -maxdepth 1 -name "*modulemode")

if [ ! -z "$MODULE" ] && [ -z "$DDLB" ];then
	echo "Houston! We have a problem!"
	sed -E -i 's/description=/description=THIS MODULE WILL BE DELETED! DETECTED DOLBY UNINSTALLED! /' $MODPATH/module.prop
	touch $MODPATH/disable
	touch $MODPATH/remove
fi