mount -o rw,remount /data

[ -z $MODPATH ] && MODPATH=/data/adb/modules/sv_sndasphere

if [ ! -d $MODPATH/debug ]; then
	mkdir -p $MODPATH/debug
	chmod 0755 $MODPATH/debug
fi

exec 2>$MODPATH/debug/main_or_emergency_debug.txt
set -x

#locations variables
###############
DDLB=$(find /data/adb/modules -path "*/dolby/*" -not -path "/data/adb/modules/sv_sndasphere/*" -type f \( -name "*dax*.xml" -o -name "*dap*.xml" \))
SVDLB=$(find /data/adb/modules/sv_sndasphere -path "*/dolby/*" -not -path "/data/adb/modules/sv_sndasphere/original/*" -type f \( -name "*dax*.xml" -o -name "*dap*.xml" \))
DLB=$(find /system /vendor /odm /my* /product -path "*/dolby/*" -type f \( -name "*dax*.xml" -o -name "*dap*.xml" \))

if [ -f $MODPATH/.emergency ];then
DIY="$MODPATH/tuningDIY.txt"
fi

#permission settings
###############

perms()
{
echo " "
echo " -- Setting Permissions --"

permset() {
mod=$(stat -c %a "$orig" 2>/dev/null || echo "755")
own=$(stat -c %U:%G "$orig" 2>/dev/null || echo "root:root")
con=$(ls -Zd "$orig" | awk '{print $1}')

if [ -z "$con" ]; then 

	ext=$(echo "$filedir" | grep -oE '\.[^.]+$' | tr -d '.' || echo "none")
	
	orig_dir=$(dirname "$orig")
	
	if [ "$ext" == "none" ]; then 
		con=$(ls -Z "$orig_dir"/* 2>/dev/null | grep -vE '\.' | awk '{print $1}' | sort | uniq -c | sort -nr | head -1 | awk '{print $2}') 
	else 
		con=$(ls -Z "$orig_dir"/*."$ext" 2>/dev/null | awk '{print $1}' | sort | uniq -c | sort -nr | head -1 | awk '{print $2}') 
	fi
	
	if [ -z "$con" ]; then 
		case "$orig_dir" in 
			/system/*) con="u:object_r:system_file:s0" ;; 
			/vendor/*) con="u:object_r:vendor_file:s0" ;; 
			/vendor/etc*) con="u:object_r:vendor_configs_file:s0" ;; 
			/odm/*) con="u:object_r:vendor_file:s0" ;; 
			/odm/etc/*) con="u:object_r:vendor_configs_file:s0" ;; 
			/data/*) con="u:object_r:app_data_file:s0" ;; 
			*) con="u:object_r:system_file:s0" ;; 
		esac
	fi 
fi

    chmod "$mod" "$filedir"
    chown "$own" "$filedir"
    chcon "$con" "$filedir"
    echo " -- ********************************* -- "
	echo " "
    echo " -- Setting permissions for $filedir -- "
    echo " -- Permissions = $mod -- "
    echo " -- owner:group = $own -- "
    echo " -- SeLinux Context = $con -- "
	echo " "
}

filedirlist=$(find "$MODPATH")

printf "%b\n" "$filedirlist" | while IFS= read -r filedir; do
    if [ "$filedir" = "$MODPATH" ]; then
        continue
    fi
    local orig=$(echo "$filedir" | sed "s|$MODPATH||")
    if [ -e "$orig" ]; then
        permset
    else
        local orig=$(echo "$filedir" | sed "s|$MODPATH/system||")
        permset
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

builtinmode=false

if [ ! -z $DDLB ]; then
	printf "%b\n" "$DDLB" | while IFS= read -r j; do
		i="$(echo $j | sed "s|/data/adb/modules/[[:alnum:]]*/|$MODPATH/|")"
		k=/data/adb/modules/sv_sndasphere/original$i
		m="$(echo $i | sed "s|$MODPATH|$MODPATH/original|")" 
		touch $MODPATH/.modulemode
		mkdir -p "$(dirname "$i")"
		mkdir -p "$(dirname "$m")"

	if [ -f $k ]; then
		cp -p $k $m
		cp -p $m $i
	else
		cp -p $j $m
		cp -p $m $i
	fi
	done
fi
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

builtinmode=true

printf "%b\n" "$DLB" | while IFS= read -r j; do
	i=$MODPATH$j
	k=/data/adb/modules/sv_sndasphere/original$j
	m=$MODPATH/original$j
	touch $MODPATH/.builtinmode
	mkdir -p "$(dirname "$i")"
	mkdir -p "$(dirname "$m")"

	if [ -f $k ]; then
		cp -p $k $m
		cp -p $m $i
	else
		cp -p $j $m
		cp -p $m $i
	fi
done
}


#main logic
#########

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
sleep 1

if [ ! -z "$DDLB" ]; then
	module
elif [[ ! -z "$DLB" && ! -z "$SVDLB" ]] || [ ! -z "$DLB" ]; then
	builtin
else
	echo " -- No Dolby found -- "
	sleep 1
	echo " -- ABORT --"
	rm $MODPATH/*
	rmdir $MODPATH
	exit 1
fi

perms
. $MODPATH/action.sh
	
if [ -f $MODPATH/.emergency ]; then
rm -f $MODPATH/.emergency
touch $MODPATH/.emergencydone
fi