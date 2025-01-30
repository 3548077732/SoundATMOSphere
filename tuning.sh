#remove dolby settings database (will rebuild itself after reboot)
rm -f /data/vendor/dolby/*

#locations variables
###############
ADDLB="$(find /data/adb/modules -type d -name "dolby" -not -path "/data/adb/modules/sv_sndasphere/*")"
if [ ! -z "$ADDLB" ];then
	DDLB="$(find $ADDLB -type f -name "*dax*.xml" -o -name "*dap*.xml")"
	sleep 0.2
fi
ASVDLB="$(find /data/adb/modules/sv_sndasphere -type d -name "dolby" -not -path "/data/adb/modules/sv_sndasphere/original/*")"
if [ ! -z "$ASVDLB" ];then
	SVDLB="$(find $ASVDLB -type f -name "*dax*.xml" -o -name "*dap*.xml")"
	sleep 0.2
fi
ADLB="$(find /system /vendor /odm /my* /product -type d -name "dolby")"
if [ ! -z "$ADLB" ];then
	DLB="$(find $ADLB -type f -name "*dax*.xml" -o -name "*dap*.xml")"
	sleep 0.2
fi

#DIY variables
###############
DIY="/storage/emulated/0/tuningDIY.txt"
HIEQ="$(cat $DIY | grep 'HIEQ=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HIEQSTR="$(cat $DIY | grep 'HIEQSTR=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HBASS="$(cat $DIY | grep 'HBASS=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HVOLBOOST="$(cat $DIY | grep 'HVOLBOOST=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HDE="$(cat $DIY | grep 'HDE=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HDEA="$(cat $DIY | grep 'HDEA=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HDED="$(cat $DIY | grep 'HDED=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HVIRTSTR="$(cat $DIY | grep 'HVIRTSTR=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HVIRTWID="$(cat $DIY | grep 'HVIRTWID=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HVIRTMOD="$(cat $DIY | grep 'HVIRTMOD=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HVIRTREND="$(cat $DIY | grep 'HVIRTREND=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HLEVELER="$(cat $DIY | grep 'HLEVELER=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HLEVSTR="$(cat $DIY | grep 'HLEVSTR=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HLEVAMOUNT="$(cat $DIY | grep 'HLEVAMOUNT=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HLEVTARGETIN="$(cat $DIY | grep 'HLEVTARGETIN=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HLEVTARGETOUT="$(cat $DIY | grep 'HLEVTARGETOUT=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
HTIMBRE="$(cat $DIY | grep 'HTIMBRE=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
SPEAKERTUNING="$(cat $DIY | grep 'SPEAKERTUNING=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
SVOLBOOST="$(cat $DIY | grep 'SVOLBOOST=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
SLEVELER="$(cat $DIY | grep 'SLEVELER=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
SVIRT="$(cat $DIY | grep 'SVIRT=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
SVIRTMOD="$(cat $DIY | grep 'SVIRTMOD=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
SDE="$(cat $DIY | grep 'SDE=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
SDEA="$(cat $DIY | grep 'SDEA=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"
SDED="$(cat $DIY | grep 'SDED=' | awk -F "=" '{print $2}' | sed "s|[[:space:]]*||")"

propcheck()
{
sleep 1
echo " "
echo " -- HEADPHONE TUNING -- "
echo " "
sleep 0.5

#IEQ vars assign
###############
case "$HIEQ" in
"B" | "b")
echo " -- IEQ will be set to: Balanced -- "
hieq1=2
hieq2=balanced
hieq3=true;;
"D" | "d")
echo " -- IEQ will be set to: Detailed -- "
hieq1=1
hieq2=detailed
hieq3=true;;
"W" | "w")
echo " -- IEQ will be set to: Warm -- "
hieq1=3
hieq2=warm
hieq3=true;;
"N" | "n")
echo " -- IEQ will be disabled -- "
hieq1=2
hieq2=balanced
hieq3=false;;
*)
echo " -- Wrong IEQ value or no value -- " 
echo " -- Using default setting (IEQ Balanced) -- "
hieq1=2
hieq2=balanced
hieq3=true;;
esac

sleep 0.5

if [ "$HIEQSTR" -ge "1" -a "$HIEQSTR" -le "20" ];then
	echo " -- Intelligent EQ strength setting is: '"$HIEQSTR"' -- "
	hieqamount="$HIEQSTR"
else
	echo " -- Wrong or no value for Intelligent EQ strength -- " 
  echo " -- Using default setting (8) -- "
	hieqamount=8
fi

sleep 0.5

#Bass boost vars assign
###############
if [ "$HBASS" -ge "0" -a "$HBASS" -le "20" ];then
	echo " -- BassBoost setting is: '"$HBASS"' -- "
	hbass1="$(($HBASS*32))"
	hbass2="$(($HBASS*20))"
else
	echo " -- Wrong or no value for BassBoost -- " 
  echo " -- Using default setting (7) -- "
	hbass1=224
	hbass2=140
fi

sleep 0.5

#Headphone volume boost vars assign
###############
if [ "$HVOLBOOST" -ge "0" -a "$HVOLBOOST" -le "15" ];then
	echo " -- Headphone volume boost setting is: '"$HVOLBOOST" dB' -- "
	hvolboost="$(($HVOLBOOST*16))"
else
	echo " -- Wrong or no value for Headphone volume boost -- " 
  echo " -- Using default setting (0) -- "
	hvolboost=0
fi

sleep 0.5

#Dialog Enhancer vars assign
###############
case "$HDE" in
0)
echo " -- Dialog Enhancer setting is: OFF -- "
hdialog1=false
hdialog2=false;;
1)
echo " -- Dialog Enhancer setting is: ON (MOVIE only) -- "
hdialog1=true
hdialog2=false;;
2)
echo " -- Dialog Enhancer setting is: ON (every preset) -- "
hdialog1=true
hdialog2=true;;
*)
echo " -- Wrong or no value for Dialog Enhancer -- " 
echo " -- Using default setting (0 - OFF) -- "
hdialog1=false
hdialog2=false;;
esac

sleep 0.5

if [ "$HDEA" -ge "1" -a "$HDEA" -le "10" ];then
	echo " -- Dialog Enhancer strength setting is: '"$HDEA"' -- "
	hdeamount="$HDEA"
else
	echo " -- Wrong or no value for Dialog Enhancer strength -- " 
  echo " -- Using default setting (6) -- "
	hdeamount=6
fi

sleep 0.5

if [ "$HDED" -ge "0" -a "$HDED" -le "10" ];then
	echo " -- Dialog Enhancer ducking setting is: '"$HDED"' -- "
	hdeducking="$HDED"
else
	echo " -- Wrong or no value for Dialog Enhancer ducking -- " 
  echo " -- Using default setting (0) -- "
	hdeducking=0
fi

sleep 0.5

#Virtualizer vars assign
###############

if [ "$HVIRTSTR" -ge "4" -a "$HVIRTSTR" -le "100" ];then
	echo " -- Virtualizer strength setting is: '"$HVIRTSTR"' -- "
	hvirtstr="$HVIRTSTR"
else
	echo " -- Wrong or no value for Virtualizer strength -- " 
echo " -- Using default setting (20) -- "
	hvirtstr=20
fi
sleep 0.5

if [ "$HVIRTWID" -ge "45" -a "$HVIRTWID" -le "90" ];then
	echo " -- Virtualizer left-right angle setting is: '"$HVIRTWID"' -- "
	hvirtwid="$HVIRTWID"
else
	echo " -- Wrong or no value for Virtualizer left-right angle -- " 
echo " -- Using default setting (90) -- "
	hvirtwid=90
fi
sleep 0.5

if [ "$HVIRTMOD" -eq "1" -o "$HVIRTMOD" -eq "2" ];then
	echo " -- Headphone Virtualizer mode setting is: '"$HVIRTMOD"' -- "
	hvirtmod="$HVIRTMOD"
else
	echo " -- Wrong or no Headphone Virtualizer mode -- " 
  echo " -- Using default setting (2) -- "
	hvirtmod=2
fi

sleep 0.5

case "$HVIRTREND" in
"YES" | "yes" | "yES" | "yEs" | "yeS" | "Yes" | "YEs" | "YeS")
echo " -- Advanced virtualizer rendering setting is: YES -- "
hvirtrend=true;;
"NO" | "no" | "No" | "nO")
echo " -- Advanced Virtualizer rendering setting is: NO -- "
hvirtrend=false;;
*)
echo " -- Wrong or no value for advanced Virtualizer rendering. -- "
echo " -- Using default setting (YES) -- "
hvirtrend=true;;
esac

sleep 0.5

#Volume leveler vars assign
###############
case "$HLEVELER" in
"ON" | "on" | "On" | "oN")
echo " -- Volume Leveler setting is: ON -- "
hleveler=true;;
"OFF" | "off" | "OFf" | "Off" | "OfF" | "oFF" | "oFf" | "ofF")
echo " -- Volume Leveler setting is: OFF -- "
hleveler=false;;
*)
echo " -- Wrong or no value for Volume Leveler -- "
echo " -- Using default setting (OFF) -- "
hleveler=false;;
esac

sleep 0.5

if [ "$HLEVSTR" -ge "0" -a "$HLEVSTR" -le "10" ];then
	echo " -- Volume Leveler Volmax Boost setting is: '"$HLEVSTR"' -- "
	hlevstr="$(($HLEVSTR*16))"
else
	echo " -- Wrong or no value for Volume Leveler Volmax Boost -- "
	echo " -- Using default setting (Disabled) -- "
	hlevstr=48
	hleveler=false
fi

sleep 0.5

if [ "$HLEVAMOUNT" -ge "0" -a "$HLEVAMOUNT" -le "10" ];then
	echo " -- Volume Leveler amount setting is: '"$HLEVAMOUNT"' -- "
	hlevamount="$HLEVAMOUNT"
else
	echo " -- Wrong or no value for Volume Leveler amount -- "
	echo " -- Using default setting (0) -- "
	hlevamount=0
fi

sleep 0.5

if [ "$HLEVTARGETIN" -ge "1" -a "$HLEVTARGETIN" -le "10" ];then
	echo " -- Volume leveler target-in setting is: '"$HLEVTARGETIN"' -- "
	hlevtargetin="$((64+(32*$HLEVTARGETIN)))"
else
	echo " -- Wrong or no value for Volume leveler target-in -- "
	echo " -- Using default setting (6) -- "
	hlevtargetin=256
fi

sleep 0.5

if [ "$HLEVTARGETOUT" -ge "1" -a "$HLEVTARGETOUT" -le "10" ];then
	echo " -- Volume leveler target-out setting is: '"$HLEVTARGETOUT"' -- "
	hlevtargetout="$((64+(32*$HLEVTARGETOUT)))"
else
	echo " -- Wrong or no value for Volume leveler target-out -- "
	echo " -- Using default setting (6) -- "
	hlevtargetout=256
fi

sleep 0.5


#Regulator Timbre Preservation vars assign
###############
if [ "$HTIMBRE" -ge "1" -a "$HTIMBRE" -le "4" ];then
	echo " -- Timbre Preservation setting is: '"$HTIMBRE"' -- "
	htimbre="$(($HTIMBRE*6))"
else
	echo " -- Wrong or no value for Timbre Preservation -- "
  echo " -- Using default setting (2) -- "
	htimbre=12
fi

sleep 0.5
echo " "
echo " -- SPEAKER TUNING -- "
echo " "
sleep 0.5

#Speakertuning vars assign
###############
case "$SPEAKERTUNING" in
"YES" | "yes" | "yES" | "yEs" | "yeS" | "Yes" | "YEs" | "YeS")
echo " -- Speaker Tuning setting is: YES -- "
spookertuning=true;;
"NO" | "no" | "No" | "nO")
echo " -- Speaker Tuning setting is: NO -- "
spookertuning=false;;
*)
echo " -- Wrong or no value for Speaker Tuning -- " 
echo " -- Using default setting (NO) -- "
spookertuning=false;;
esac

sleep 0.5

if [ "$SVOLBOOST" -ge "0" -a "$SVOLBOOST" -le "15" ];then
	echo " -- Speaker Boost level setting is: '"$SVOLBOOST" dB' -- "
	svolboost="$(($SVOLBOOST*16))"
else
	echo " -- Wrong or no value for Speaker Boost level -- "
  echo " -- Using default setting (0) -- "
	svolboost=0
fi

sleep 0.5

#Speaker Volume leveler vars assign
###############
case "$SLEVELER" in
"ON" | "on" | "On" | "oN")
echo " -- Speaker Volume Leveler setting is: ON -- "
sleveler=true;;
"OFF" | "off" | "OFf" | "Off" | "OfF" | "oFF" | "oFf" | "ofF")
echo " -- Speaker Volume Leveler setting is: OFF -- "
sleveler=false;;
*)
echo " -- Wrong or no value for Speaker Volume Leveler -- "
echo " -- Using default setting (OFF) -- "
sleveler=false;;
esac

sleep 0.5

#Speaker Virtualizer vars assign
###############
case "$SVIRT" in
0)
echo " -- Virtualizer setting is: OFF -- "
svirt1=false
svirt2=false;;
1)
echo " -- Virtualizer setting is: ON (MOVIE only) -- "
svirt1=true
svirt2=false;;
2)
echo " -- Virtualizer setting is: ON (every preset) -- "
svirt1=true
svirt2=true;;
*)
echo " -- Wrong or no value for Speaker Virtualizer -- "
echo " -- Using default setting (1) -- "
svirt1=true
svirt2=false;;
esac

sleep 0.5

if [ "$SVIRTMOD" -eq "1" -o "$SVIRTMOD" -eq "2" ];then
	echo " -- Speaker Virtualizer mode setting is: '"$SVIRTMOD"' -- "
	svirtmod="$SVIRTMOD"
else
	echo " -- Wrong or no value for Speaker Virtualizer mode -- "
  echo " -- Using default setting (2) -- "
	svirtmod=2
fi

sleep 0.5

#Speaker Dialog Enhancer vars assign
###############
case "$SDE" in
0)
echo " -- Dialog Enhancer setting is: OFF -- "
sdialog1=false
sdialog2=false;;
1)
echo " -- Dialog Enhancer setting is: ON (MOVIE preset) -- "
sdialog1=true
sdialog2=false;;
2)
echo " -- Dialog Enhancer setting is: ON (every preset) -- "
sdialog1=true
sdialog2=true;;
*)
echo " -- Wrong or no value for Speaker Dialog Enhancer -- "
echo " -- Using default setting (0) -- "
sdialog1=false
sdialog2=false;;
esac

sleep 0.5

if [ "$SDEA" -ge "1" -a "$SDEA" -le "10" ];then
	echo " -- Dialog Enhancer strength setting is: '"$SDEA"' -- "
	sdeamount="$SDEA"
else
	echo " -- Wrong or no value for Speaker Dialog Enhancer strength -- "
  echo " -- Using default setting (6) -- "
	sdeamount=6
fi

sleep 0.5

if [ "$SDED" -ge "0" -a "$SDED" -le "10" ];then
	echo " -- Dialog Enhancer ducking setting is: '"$SDED"' -- "
	sdeducking="$SDED"
else
	echo " -- Wrong or no value for Speaker Dialog Enhancer ducking -- " 
  echo " -- Using default setting (0) -- "
	sdeducking=0
fi

sleep 0.5

echo " "
echo " "
}

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

#variables used by mod 1 and mod 2 function
####################
var()
{
harm="$(grep 'virtual-bass-harmgains' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
angle="$(grep 'advanced-headphone-virtualizer-lr-angle' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
distance="$(grep 'headphone-virtualizer-steerer-source-distance' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
advancedvirt="$(grep 'advanced-headphone-virtualizer-rendering-config' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"

dyn="$(grep -n 'name="Dynamic"' $i | awk -F ':' 'NR==1{print$1}')"
mov="$(grep -n 'name="Movie"' $i | awk -F ':' 'NR==1{print$1}')"
mus="$(grep -n 'name="Music"' $i | awk -F ':' 'NR==1{print$1}')"
cus="$(grep -n 'name="Custom"' $i | awk -F ':' 'NR==1{print$1}')"

bal="$(grep -n 'balanced' $i | awk -F ':' 'NR==1{print$1}')"
det="$(grep -n 'detailed' $i | awk -F ':' 'NR==1{print$1}')"
warm="$(grep -n 'warm' $i | awk -F ':' 'NR==1{print$1}')"

spk="$(grep -n 'id="speaker"' $i | awk -F ':' '{print$1}')"
spk1="$(grep -n 'id="speaker"' $i | awk -F ':' 'NR==1{print$1}')"
hph="$(grep -n 'id="headphone"' $i | awk -F ':' '{print$1}')"
hph1="$(grep -n 'id="headphone"' $i | awk -F ':' 'NR==1{print$1}')"

sam="$(grep -n 'id="default"' $i | awk -F ':' 'NR==1{print$1}')"
pass="$(grep -n 'id="passthrough"' $i | awk -F ':' 'NR==1{print$1}')"

diff1="$(($spk1-$dyn))"
diff2="$(($hph1-$spk1))"

spkend="$(grep -n 'endpoint_type="speaker"' $i | awk -F ':' 'NR==1{print$1}')"

if [ ! -z "$(grep -n 'endpoint_type="headphone"' $i | awk -F ':' 'NR==1{print$1}')" ]; then
	hphend="$(grep -n 'endpoint_type="headphone"' $i | awk -F ':' 'NR==1{print$1}')"
else
	hphend="$(grep -n 'endpoint_type="bluetooth"' $i | awk -F ':' 'NR==1{print$1}')"
fi

last="$(wc -l $i | awk -F ' ' '{print$1}')"

rang1="$(($diff1+$diff2))"
if [ ! -z $sam ];then
	rang2="$(($diff1+(7*$diff2)))"
elif [ ! -z $pass ];then
	rang2="$(($diff1+(4*$diff2)))"
else
	rang2="$(($diff1+(3*$diff2)))"
fi

if [[ "$HIEQ" == "W" || "$HIEQ" == "w" ]] && [ -z $warm ]; then
	echo " "
	echo " -- No Warm IEQ in dolby config. IEQ will be set to: Balanced -- "
	echo " "
	hieq1=2
	hieq2=balanced
	hieq3=true
	sleep 1
fi

if [[ "$HIEQ" == "D" || "$HIEQ" == "d" ]] && [ -z $det ]; then
	echo " "
	echo " -- No Detailed IEQ in dolby config. IEQ will be set to: Balanced -- "
	echo " "
	hieq1=2
	hieq2=balanced
	hieq3=true
	sleep 1
fi
}


tuning()
{
##modification section
################
#Global settings
###############
sed -E -i 1,$(($last-1))'s/headphone-virtualizer-mode value="[[:alnum:]]*"/headphone-virtualizer-mode value="'"$hvirtmod"'"/g' $i
sed -E -i 1,$(($last-1))'s/speaker-virtualizer-mode value="[[:alnum:]]*"/speaker-virtualizer-mode value="'"$svirtmod"'"/g' $i
sed -E -i 1,$(($last-1))'s/audio-optimizer-enable value="[[:alnum:]]*"/audio-optimizer-enable value="true"/g' $i
echo " -- Configuring profiles -- "
#G6
sed -E -i $mov,$(($mov+5))'s/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/' $i
sed -E -i $mov,$(($mov+5))'s/ieq-amount value="[[:alnum:]]*"/ieq-amount value="6"/'  $i
sed -E -i $mus,$(($mus+5))'s/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/' $i
sed -E -i $mus,$(($mus+5))'s/ieq-amount value="[[:alnum:]]*"/ieq-amount value="6"/'  $i
if [ ! -z $det ];then
	sed -E -i 1,$(($last-1))'s/include preset="[[:alnum:]]*"/include preset="'"ieq_$hieq2"'"/g' $i
else
	sed -E -i 1,$(($last-1))'s/include preset="[[:alnum:]]*"/include preset="ieq_balanced"/g' $i
fi
sed -E -i 1,$(($last-1))'s/intermediate_profile_partial_virtual_bass_enable value="[[:alnum:]]*"/intermediate_profile_partial_virtual_bass_enable value="true"/g' $i
sed -E -i $hphend,$(($last-1))'s/intermediate_tuning_bass-enhancer-enable value="[[:alnum:]]*"/intermediate_tuning_bass-enhancer-enable value="true"/g' $i
sed -E -i $hphend,$(($last-1))'s/intermediate_tuning_partial_virtual_bass_enable value="[[:alnum:]]*"/intermediate_tuning_partial_virtual_bass_enable value="true"/g' $i
sed -E -i $hphend,$(($last-1))'s/intermediate_tuning_partial_virtualizer_enable value="[[:alnum:]]*"/intermediate_tuning_partial_virtualizer_enable value="true"/g' $i
#!G6

#DYNAMIC
###############
x1=$(($dyn+$rang1))
x2=$(($dyn+$rang2))
x3=$(($dyn+$diff1))

#HEADPHONES
sed -E -i $dyn,$x1's/mi-dialog-enhancer-steering-enable value="[[:alnum:]]*"/mi-dialog-enhancer-steering-enable value="true"/g' $i
sed -E -i $dyn,$x1's/mi-dv-leveler-steering-enable value="[[:alnum:]]*"/mi-dv-leveler-steering-enable value="true"/g' $i
sed -E -i $dyn,$x1's/mi-ieq-steering-enable value="[[:alnum:]]*"/mi-ieq-steering-enable value="true"/g' $i
sed -E -i $dyn,$x1's/mi-surround-compressor-steering-enable value="[[:alnum:]]*"/mi-surround-compressor-steering-enable value="true"/g' $i
sed -E -i $dyn,$x1's/mi-adaptive-virtualizer-steering-enable value="[[:alnum:]]*"/mi-adaptive-virtualizer-steering-enable value="true"/g' $i
if [ "$harm" == 'virtual-bass-harmgains' ]; then
	sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
else
	sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
fi
sed -E -i $x1,$x2's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$hieq1"'"/g' $i
sed -E -i $x1,$x2's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$hdialog2"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$hdeamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$hdeducking"'"/g' $i
sed -E -i $x1,$x2's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
sed -E -i $x1,$x2's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="false"/g' $i
sed -E -i $x1,$x2's/surround-boost value="[[:alnum:]]*"/surround-boost value="96"/g' $i
sed -E -i $x1,$x2's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$hlevstr"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$hleveler"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$hlevamount"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$hlevtargetin"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$hlevtargetout"'"/g' $i
sed -E -i $x1,$x2's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i
#SPEAKER
sed -E -i $x3,$x1's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$sleveler"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="0"/g' $i
sed -E -i $x3,$x1's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-224"/g' $i
sed -E -i $x3,$x1's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-224"/g' $i
sed -E -i $x3,$x1's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="'"$svirt2"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$sdialog2"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$sdeamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$sdeducking"'"/g' $i

#MOVIE
###############
x1=$(($mov+$rang1))
x2=$(($mov+$rang2))
x3=$(($mov+$diff1))

#HEADPHONES
if [ "$harm" == 'virtual-bass-harmgains' ]; then
	sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
else
	sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="true"/g' $i
fi
sed -E -i $x1,$x2's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$hieq1"'"/g' $i
sed -E -i $x1,$x2's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$hdialog1"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$hdeamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$hdeducking"'"/g' $i
sed -E -i $x1,$x2's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
sed -E -i $x1,$x2's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="true"/g' $i
sed -E -i $x1,$x2's/surround-boost value="[[:alnum:]]*"/surround-boost value="64"/g' $i
sed -E -i $x1,$x2's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$hlevstr"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$hleveler"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$hlevamount"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$hlevtargetin"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$hlevtargetout"'"/g' $i
sed -E -i $x1,$x2's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i
#SPEAKER
sed -E -i $x3,$x1's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$sleveler"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="0"/g' $i
sed -E -i $x3,$x1's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-224"/g' $i
sed -E -i $x3,$x1's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-224"/g' $i
sed -E -i $x3,$x1's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="'"$svirt1"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$sdialog1"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$sdeamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$sdeducking"'"/g' $i

#MUSIC
###############
x1=$(($mus+$rang1))
x2=$(($mus+$rang2))
x3=$(($mus+$diff1))

#HEADPHONES
if [ "$harm" == 'virtual-bass-harmgains' ]; then
	sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
else
	sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="true"/g' $i
fi
sed -E -i $x1,$x2's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$hieq1"'"/g' $i
sed -E -i $x1,$x2's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$hdialog2"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$hdeamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$hdeducking"'"/g' $i
sed -E -i $x1,$x2's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
sed -E -i $x1,$x2's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="false"/g' $i
sed -E -i $x1,$x2's/surround-boost value="[[:alnum:]]*"/surround-boost value="96"/g' $i
sed -E -i $x1,$x2's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$hlevstr"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$hleveler"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$hlevamount"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$hlevtargetin"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$hlevtargetout"'"/g' $i
sed -E -i $x1,$x2's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i
#SPEAKER
sed -E -i $x3,$x1's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$sleveler"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="0"/g' $i
sed -E -i $x3,$x1's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-224"/g' $i
sed -E -i $x3,$x1's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-224"/g' $i
sed -E -i $x3,$x1's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="'"$svirt2"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$sdialog2"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$sdeamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$sdeducking"'"/g' $i

#CUSTOM
###############
if [ ! -z $cus ]; then
	x1=$(($cus+$rang1))
	x2=$(($cus+$rang2))
	x3=$(($cus+$diff1))

	#HEADPHONES
	if [ "$harm" == 'virtual-bass-harmgains' ]; then
		sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
		sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
		sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
	else
		sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
		sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
		sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="true"/g' $i
	fi
	sed -E -i $x1,$x2's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$hieq1"'"/g' $i
	sed -E -i $x1,$x2's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/g' $i
	sed -E -i $x1,$x2's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$hdialog2"'"/g' $i
	sed -E -i $x1,$x2's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$hdeamount"'"/g' $i
	sed -E -i $x1,$x2's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$hdeducking"'"/g' $i
	sed -E -i $x1,$x2's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
	sed -E -i $x1,$x2's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="false"/g' $i
	sed -E -i $x1,$x2's/surround-boost value="[[:alnum:]]*"/surround-boost value="96"/g' $i
	sed -E -i $x1,$x2's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$hlevstr"'"/g' $i
	sed -E -i $x1,$x2's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$hleveler"'"/g' $i
	sed -E -i $x1,$x2's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$hlevamount"'"/g' $i
	sed -E -i $x1,$x2's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$hlevtargetin"'"/g' $i
	sed -E -i $x1,$x2's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$hlevtargetout"'"/g' $i
	sed -E -i $x1,$x2's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i
fi
#SPEAKER
sed -E -i $x3,$x1's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$sleveler"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="0"/g' $i
sed -E -i $x3,$x1's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-224"/g' $i
sed -E -i $x3,$x1's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-224"/g' $i
sed -E -i $x3,$x1's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="'"$svirt2"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$sdialog2"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$sdeamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$sdeducking"'"/g' $i

#SVOLBOOST
for x in ${spk}; do
sed -E -i $x,$(($x+$diff2))'s/calibration-boost value="[[:alnum:]]*"/calibration-boost value="'"$svolboost"'"/g' $i
done

#HVOLBOOST
for x in ${hph}; do
sed -E -i $x,$(($x+$rang2-$rang1))'s/calibration-boost value="[[:alnum:]]*"/calibration-boost value="'"$hvolboost"'"/g' $i
done

### HPHEND
###############
echo " -- Configuring endpoint parameters -- "
sed -E -i $hphend,$(($last-1))'s/volume-leveler-compressor-enable value="[[:alnum:]]*"/volume-leveler-compressor-enable value="true"/g' $i
sed -E -i $hphend,$(($last-1))'s/bass-extraction-enable value="[[:alnum:]]*"/bass-extraction-enable value="true"/g' $i
sed -E -i $hphend,$(($last-1))'s/bass-extraction-cutoff-frequency value="[[:alnum:]]*"/bass-extraction-cutoff-frequency value="90"/g' $i
sed -E -i $hphend,$(($last-1))'s/regulator-enable value="[[:alnum:]]*"/regulator-enable value="true"/g' $i
sed -E -i $hphend,$(($last-1))'s/height-filter-mode value="[[:alnum:]]*"/height-filter-mode value="1"/g' $i
sed -E -i $hphend,$(($last-1))'s/regulator-speaker-dist-enable value="[[:alnum:]]*"/regulator-speaker-dist-enable value="true"/g' $i
sed -E -i $hphend,$(($last-1))'s/virtualizer-front-speaker-angle value="[[:alnum:]]*"/virtualizer-front-speaker-angle value="25"/g' $i
sed -E -i $hphend,$(($last-1))'s/virtualizer-height-speaker-angle value="[[:alnum:]]*"/virtualizer-height-speaker-angle value="15"/g' $i
sed -E -i $hphend,$(($last-1))'s/virtualizer-surround-speaker-angle value="[[:alnum:]]*"/virtualizer-surround-speaker-angle value="90"/g' $i
sed -E -i $hphend,$(($last-1))'s/bass-enhancer-boost value="[[:alnum:]]*"/bass-enhancer-boost value="'"$hbass1"'"/g' $i
sed -E -i $hphend,$(($last-1))'s/bass-enhancer-cutoff-frequency value="[[:alnum:]]*"/bass-enhancer-cutoff-frequency value="90"/g' $i
sed -E -i $hphend,$(($last-1))'s/bass-enhancer-width value="[[:alnum:]]*"/bass-enhancer-width value="32"/g' $i
sed -E -i $hphend,$(($last-1))'s/regulator-sibilance-suppress-enable value="[[:alnum:]]*"/regulator-sibilance-suppress-enable value="false"/g' $i
sed -E -i $hphend,$(($last-1))'s/regulator-overdrive value="[-[:alnum:]]*"/regulator-overdrive value="1"/g' $i
sed -E -i $hphend,$(($last-1))'s/regulator-timbre-preservation value="[[:alnum:]]*"/regulator-timbre-preservation value="'"$htimbre"'"/g' $i
sed -E -i $hphend,$(($last-1))'s/regulator-stress-amount value="[,[:alnum:]]*"/regulator-stress-amount value="96,96,96,96"/g' $i
sed -E -i $hphend,$(($last-1))'s/regulator-distortion-slope value="[[:alnum:]]*"/regulator-distortion-slope value="16"/g' $i

if [ "$hvirtrend" == "true" ]; then
	if [ $advancedvirt == 'advanced-headphone-virtualizer-rendering-config' ];then
		sed -E -i 1,$(($last-1))'s/advanced-headphone-virtualizer-rendering-config value="[-,[:alnum:]]*"/advanced-headphone-virtualizer-rendering-config value="160,32767,12379,8090,2,3,3,1"/g' $i
	else
		echo " "
		echo " -- Your Dolby don't support advanced virtualizer rendering. Variable will be ignored. -- "
		echo " "
		sleep 1
	fi
fi

if [ "$distance" == 'headphone-virtualizer-steerer-source-distance' ]; then
	sed -E -i 1,$(($last-1))'s/headphone-virtualizer-steerer-source-distance value="[[:alnum:]]*"/headphone-virtualizer-steerer-source-distance value="'"$hvirtstr"'"/g' $i
else
	echo " "
	echo " -- Your Dolby don't support Virtualizer strength. This variable will be ignored. -- "
	echo " "
	sleep 1
fi

if [ "$angle" == 'advanced-headphone-virtualizer-lr-angle' ]; then
	sed -E -i 1,$(($last-1))'s/advanced-headphone-virtualizer-lr-angle value="[[:alnum:]]*"/advanced-headphone-virtualizer-lr-angle value="'"$hvirtwid"'"/g' $i
else
	echo " "
	echo " -- Your Dolby don't support Virtualizer left-right angle. This variable will be ignored. -- "
	echo " "
	sleep 1
fi

if [ "$harm" == 'virtual-bass-harmgains' ]; then
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-mode value="[[:alnum:]]*"/virtual-bass-mode value="3"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-overall-gain value="[-[:alnum:]]*"/virtual-bass-overall-gain value="0"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-slope-gain value="[-[:alnum:]]*"/virtual-bass-slope-gain value="0"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-mix-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-mix-freqs frequency_low="10" frequency_high="200"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-src-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-src-freqs frequency_low="10" frequency_high="90"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-subgains harmonic_2="[-[:alnum:]]*" harmonic_3="[-[:alnum:]]*" harmonic_4="[-[:alnum:]]*"/virtual-bass-subgains harmonic_2="-96" harmonic_3="-240" harmonic_4="-480"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-harmgains value="[-,[:alnum:]]*"/virtual-bass-harmgains value="'"$hbass2"',0,0,0"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-hybgains value="[-,[:alnum:]]*"/virtual-bass-hybgains value="0,0,0,0,80,80"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-rolloff-gain value="[-[:alnum:]]*"/virtual-bass-rolloff-gain value="0"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-blend-linear-gain value="[-[:alnum:]]*"/virtual-bass-blend-linear-gain value="10"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-mix-frequency value="[,[:alnum:]]*"/virtual-bass-mix-frequency value="10,90"/g' $i
	sed -E -i $hphend,$(($last-1))'s/virtual-bass-compressor-tuning value="[-,[:alnum:]]*"/virtual-bass-compressor-tuning value="10,90,-16,96,32,25,50"/g' $i
else 
	echo " "
	echo " -- No virtual bass harmonic gains in config -- "
	sleep 0.5
	echo " "
	echo " -- Using Bass Enhancer method instead -- "
	echo " "
	sleep 0.5
fi

if [ "$spookertuning" == "true" ]; then
	. $TMPDIR/tuningspk.sh
fi
. $TMPDIR/ieqregulator.sh
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
propcheck
builtinmode=false
#if xml is in module
if [ ! -z "$DDLB" ]; then
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

		var
		echo " "
		echo " -- Applying tuning... -- "
		echo " "
		sleep 0.5
		tuning

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
propcheck
builtinmode=true
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

	var
	echo " "
	echo " -- Applying tuning... -- "
	echo " "
	sleep 0.5
	tuning

	cp -f $i /storage/emulated/0/"$(basename "$i")"
	umount -f $j
	sleep 1
	mount -f $i $j
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
	exit 1
fi
