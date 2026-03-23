#!/system/bin/sh
# shellcheck disable=SC2034

SKIPUNZIP=1

# Extracting files into the module directory and service.d
unzip -qjo "$ZIPFILE" 'sv_sndasphere_rmv.sh' -d /data/adb/service.d >&2
unzip -qo "$ZIPFILE" -x 'LICENSE.txt' 'LEGAL_DISCLAIMER.txt' 'customize.sh' 'sv_sndasphere_rmv.sh' 'META-INF/*' -d "$MODPATH" >&2

# Set permissions for service.d script explicitly so Magisk can execute it
chmod 0755 /data/adb/service.d/sv_sndasphere_rmv.sh

# Setting permissions recursively
set_perm_recursive "$MODPATH" 0 0 0755 0644

# Make all shell scripts in module directory and subdirectories executable
find "$MODPATH" -type f -name "*.sh" -exec chmod 0755 {} \;

# Assigning variable with path to tuningDIY.txt
DIY="$MODPATH/tuningDIY.txt"

export IS_FLASHING=true

# Checking DIY existence
# If there's no DIY file, copy it to internal storage
if [ ! -f "$DIY" ]; then
	unzip -qjo "$ZIPFILE" 'tuningDIY.txt' -d "$MODPATH" >&2
	echo " *** PLEASE READ *** "
	sleep 1
	echo " -- Config file (tuningDIY.txt) is copied to module directory -- "
	echo " "
	echo " -- NOW MODULE WILL PROCEED WITH DEFAULT VALUES -- "
	sleep 5
fi

set +x

# Source module.prop to inject its values as variables (especially name and author)
. "$MODPATH/module.prop"

# If everything is okay, then proceed with tuning process, if not, abort flashing process
if [ "$author" = "ShadoV90" ] && [ "$name" = "SoundATMOSphere" ]; then
	set -x
	if [ -f "$MODPATH/tuning/main.sh" ]; then
		. "$MODPATH/tuning/main.sh"
	else
		echo "Error: main.sh not found in $MODPATH"
		exit 1
	fi
else
	echo "Error: Verification failed. Custom module.prop detected."
	exit 1
fi