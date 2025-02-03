SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'tuning.sh' 'tuningspk.sh' 'ieqregulator.sh' -d $TMPDIR >&2
unzip -qjo "$ZIPFILE" -x 'META-INF/*' 'customize.sh' 'sv_sndasphere_rmv.sh' 'tuning.sh' 'tuningspk.sh' 'ieqregulator.sh' 'tuningDIY.txt' -d $MODPATH >&2
unzip -qjo "$ZIPFILE" 'sv_sndasphere_rmv.sh' -d /data/adb/service.d >&2
chmod 0755 /data/adb/service.d/sv_sndasphere_rmv.sh
chown root:root /data/adb/service.d/sv_sndasphere_rmv.sh
DIY="/storage/emulated/0/tuningDIY.txt"
VER="$(cat $DIY | grep V= | awk -F "=" '{print $2}')"

if [ "$VER" == "21" ]; then	
	echo " -- File "tuningDIY.txt" is up to date! -- "
	echo " -- Proceed -- "
	echo " "
	sleep 1
	
elif  [ -f "$DIY" ] && [ ! "$VER" == "21" ];then

	cp -f "/storage/emulated/0/tuningDIY.txt"	"/storage/emulated/0/tuningDIY_BACKUP.txt"
	unzip -qjo "$ZIPFILE" 'tuningDIY.txt' -d /storage/emulated/0 >&2

	echo " *** PLEASE READ *** "
	sleep 1
	echo " -- Config file ( tuningDIY.txt ) is outdated! -- "
	echo " -- New config file ( tuningDIY.txt ) is copied to internal storage -- "
	echo " "
  echo " -- Copy of old tuning file is made. Its name is tuningDIY_BACKUP.txt -- "
  echo " "
	echo " -- PLEASE FILL ** tuningDIY.txt ** IN INTERNAL STORAGE with needed variables -- "
	echo " -- According to instructions --"
	echo " -- After that, save and flash this module again -- "
	echo " "
	echo " -- NOW MODULE WILL PROCEED WITH DEFAULT VALUES -- "
	
	sleep 5
	
else

	unzip -qjo "$ZIPFILE" 'tuningDIY.txt' -d /storage/emulated/0 >&2
	
	echo " *** PLEASE READ *** "
	sleep 1
	echo " -- Config file ( tuningDIY.txt ) is copied to internal storage -- "
	echo " "
	echo " -- PLEASE FILL ** tuningDIY.txt ** IN INTERNAL STORAGE with needed variables -- "
	echo " -- According to instructions --"
	echo " -- After that, save and flash this module again -- "
	echo " "
	echo " -- NOW MODULE WILL PROCEED WITH DEFAULT VALUES -- "
	
	sleep 5
fi

chmod 0755 /data/adb/service.d/sv_sndasphere_rmv.sh
set +x
auth=$(grep "author" "$MODPATH/module.prop" | awk -F "=" '{ print $2 }')
name=$(grep "name" "$MODPATH/module.prop" | awk -F "=" '{ print $2 }')
if [ $auth == "ShadoV90" ] && [ $name == "SoundATMOSphere" ]; then
	set -x
	. $TMPDIR/tuning.sh
else 
	exit 1
fi