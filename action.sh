#!/bin/sh
if [ ! $MODPATH ]; then
MODPATH=${0%/*}
fi

mount -o rw,remount /data
mount -o rw,remount $MODPATH 2>/dev/null
if [ ! -d $MODPATH/debug ]; then
	mkdir $MODPATH/debug
fi
exec 2>$MODPATH/debug/action_debug.txt
set -x

#location variable
SVDLB=$(find /data/adb/modules/sv_sndasphere -path "*/dolby/*" -not -path "/data/adb/modules/sv_sndasphere/original/*" -type f \( -name "*dax*.xml" -o -name "*dap*.xml" \))

#DIY path
DIY="/storage/emulated/0/tuningDIY.txt"
if [ ! -f $DIY ]; then
	DIY="$MODPATH/tuningDIY.txt"
fi

#remove temp (if something went wrong and it's still exist) and create fresh temp 
rm -f /data/vendor/dolby/*

rm -rf $MODPATH/temp/*
rmdir $MODPATH/temp
mkdir -p $MODPATH/temp
chmod 0755 $MODPATH/temp
sleep 0.5

OFILES=$(find $MODPATH/original -type f -name "*.xml")
FILE_COUNTER=1
printf "%b\n" "$OFILES" | while IFS= read -r FILE; do
	#copying original XML to temp with full path
	mkdir -p "$(echo "$(dirname "$FILE")" | sed "s|$MODPATH/original|$MODPATH/temp|")"
	cp "$FILE" "$(echo "$FILE" | sed "s|$MODPATH/original|$MODPATH/temp|")"
done

#launch config variables (needed later)
cp -f $DIY $MODPATH


#finding files to patch and counting how many of them need to be patched
FILES=$(find $MODPATH/temp -type f -name "*.xml")
FILES_TOTAL="$(echo "$OFILES" | wc -w)"
FILE_COUNTER=1

echo " "
echo "-- Files to patch: $FILES_TOTAL --"
echo "-- Proceed --"
sleep 1

#setting proper target file(s)
printf "%b\n" "$FILES" | while IFS= read -r i; do
	TARGET="$(echo "$i" | sed "s|$MODPATH/temp|$MODPATH|")"
	echo " "
	echo " -- Applying tuning to file number: $FILE_COUNTER -- "
	echo " "

	#tuning
	. $MODPATH/tuning/main_tuning.sh
	
	#copying changed file from temp to proper place in module
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
	#increase counter (for multi file patching purpose)
	FILE_COUNTER=$(($FILE_COUNTER+1))
done

#mount bind fresh modified files from module to proper place
printf "%b\n" "$DLB" | while IFS= read -r DLB; do
	mount -o bind "$DLB" "$(echo "$DLB" | sed "s|$MODPATH||")"
	sleep 1
done

#remove temp
rm -rf $MODPATH/temp/*
rmdir $MODPATH/temp

#locate dolby service(s)
DLBSERV=$(find /*/bin/hw -type f -name *dolby*)
if [ ! -z "$DLBSERV" ]; then
	printf "%b\n" "$DLBSERV" | while IFS= read -r SERV; do
		if [ -s "$SERV" ]; then
			echo " "
			echo " -- restarting service: "
			echo " $SERV "
			PID=$(pidof "$(basename $SERV)")
			if [ -n "$PID" ];then
				for p in ${PID};do
					echo "PID: $p"
					su -c "kill "$p""
					sleep 0.5
				done
			fi
			sleep 0.5
		fi
		sleep 1
	done
fi

echo " "
echo " -- DONE! -- "