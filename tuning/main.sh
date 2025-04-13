mount -o rw,remount /data

#locations variables
###############
ADDLB=$(find /data/adb/modules -type d -name "dolby" -not -path "/data/adb/modules/sv_sndasphere/*")
if [ ! -z "$ADDLB" ];then
	DDLB=$(find $ADDLB -type f -name "*dax*.xml" -o -name "*dap*.xml")
	sleep 0.2
fi
ASVDLB=$(find /data/adb/modules/sv_sndasphere -type d -name "dolby" -not -path "/data/adb/modules/sv_sndasphere/original/*")
if [ ! -z "$ASVDLB" ];then
	SVDLB=$(find $ASVDLB -type f -name "*dax*.xml" -o -name "*dap*.xml")
	sleep 0.2
fi
ADLB=$(find /system /vendor /odm /my* /product -type d -name "dolby")
if [ ! -z "$ADLB" ];then
	DLB=$(find $ADLB -type f -name "*dax*.xml" -o -name "*dap*.xml")
	sleep 0.2
fi

#permission settings
###############

perms()
{
ui_print " "
ui_print "- Setting Permissions"
set_perm_recursive $MODPATH 0 0 0755 0644
for i in /system/vendor /vendor /system/vendor/app /vendor/app /system/vendor/etc /vendor/etc /system/odm/etc /odm/etc /system/vendor/odm/etc /vendor/odm/etc /system/vendor/overlay /vendor/overlay /vendor/etc/dolby /odm/etc/dolby /system/etc/dolby; do
  if [ -d "$MODPATH$i" ] && [ ! -L "$MODPATH$i" ]; then
    case $i in
      *"/vendor") set_perm_recursive $MODPATH$i 0 0 0755 0644 u:object_r:vendor_file:s0;;
      *"/app") set_perm_recursive $MODPATH$i 0 0 0755 0644 u:object_r:vendor_app_file:s0;;
      *"/overlay") set_perm_recursive $MODPATH$i 0 0 0755 0644 u:object_r:vendor_overlay_file:s0;;
      *"/etc") set_perm_recursive $MODPATH$i 0 2000 0755 0644 u:object_r:vendor_configs_file:s0;;
      *"/dolby") set_perm_recursive $MODPATH$i 0 0 0755 0644 u:object_r:vendor_configs_file:s0;;
    esac
  fi
done
chmod +x $MODPATH/action.sh
sleep 1
}

#check
###############

check()
{
auth="$(grep "author" "$MODPATH/module.prop" | awk -F "=" '{ print $2 }')"
name="$(grep "name" "$MODPATH/module.prop" | awk -F "=" '{ print $2 }')"
if [ ! $auth == "ShadoV90" ] || [ ! $name == "SoundATMOSphere" ]; then
	exit 1
fi
}

#module mode
###########

module()
{
echo " -- Dolby config file in module detected! -- "
sleep 0.75
echo " -- Proceed with Module mode -- "
echo " "
sleep 0.5
echo " -- It may take some seconds. Please wait. -- "
echo " "
sleep 1

echo " -- Extracting settings from file: -- "
. $MODPATH/tuning/config_vars.sh
builtinmode=false
FILES_TOTAL="$(echo "$DDLB" | wc -w)"
FILE_COUNTER=1
echo "-- Files to patch: $FILES_TOTAL --"
echo "-- Proceed --"
#if xml is in module
if [ ! -z $DDLB ]; then
	for j in ${DDLB}; do
		i="$(echo $j | sed "s|/data/adb/modules/[[:alnum:]]*/|$MODPATH/|")"
		k=/data/adb/modules/sv_sndasphere/original$i
		m="$(echo $i | sed "s|$MODPATH|$MODPATH/original|")" 
		touch $MODPATH/.modulemode
		mkdir -p "$(dirname "$i")"
		mkdir -p "$(dirname "$m")"

	if [ -f $k ]; then
		cp -f $k $m
		cp -f $m $i
	else
		cp -f $j $m
		cp -f $m $i
	fi
		echo " "
		echo " -- Applying tuning to file number: $FILE_COUNTER -- "
		echo " "
		sleep 0.5
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

		FILE_COUNTER=$(($FILE_COUNTER+1))

#un-setting variables
unset harm angle distance advancedvirt dyn mov mus cus bal det warm spk spk1 hph hph1 sam pass diff1 diff2 spkend hphend last rang1 rang2

	done
fi
echo " -- Done -- "
sleep 0.5
}

#ROM integrated mode
#################

builtin()
{
echo " -- Dolby integrated in ROM detected! -- "
sleep 0.75
echo " -- Proceed with ROM integrated mode -- "
echo " "
sleep 0.5
echo " -- It may take some seconds. Please wait. -- "
echo " "
sleep 1

echo " -- Extracting settings from file: -- "
. $MODPATH/tuning/config_vars.sh
builtinmode=true
FILES_TOTAL="$(echo "$DLB" | wc -w)"
FILE_COUNTER=1
echo "-- Files to patch: $FILES_TOTAL --"
echo "-- Proceed --"
sleep 1
for j in ${DLB}; do
	i=$MODPATH$j
	k=/data/adb/modules/sv_sndasphere/original$j
	m=$MODPATH/original$j
	touch $MODPATH/.builtinmode
	mkdir -p "$(dirname "$i")"
	mkdir -p "$(dirname "$m")"

	if [ -f $k ]; then
		cp -f $k $m
		cp -f $m $i
	else
		cp -f $j $m
		cp -f $m $i
	fi
	echo " "
	echo " -- Applying tuning to file number: $FILE_COUNTER -- "
	echo " "
	sleep 0.5
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

FILE_COUNTER=$(($FILE_COUNTER+1))

#un-setting variables
unset harm angle distance advancedvirt dyn mov mus cus bal det warm spk spk1 hph hph1 sam pass diff1 diff2 spkend hphend last rang1 rang2

done
echo " -- Done -- "
sleep 0.5
}

#main logic
#########

sleep 1
set +x
check
set -x

echo " -- This module have two modes -- "
sleep 0.75
echo " -- ROM integrated mode and Module mode -- "
sleep 0.75
echo " -- Script will automatically choose proper mode -- "
sleep 0.75
echo " "
echo " -- Detecting active Dolby -- "
echo " "
sleep 2

if [ ! -z "$DDLB" ]; then

	module
	perms

elif [[ ! -z "$DLB" && ! -z "$SVDLB" ]] || [ ! -z "$DLB" ]; then

	builtin
	perms

else

	echo " -- No Dolby found -- "
	sleep 1
	echo " -- ABORT --"
	rm $MODPATH/*
	rmdir $MODPATH
	exit 1
fi


