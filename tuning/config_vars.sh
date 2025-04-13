
#Func to load config
loadconfig() {
    eval "$(awk -F '=' '
        $1 ~ /^(HEADPHONETUNING|HIEQ|HIEQSTR|HRENDERBASS|HBASSBOOST|HBASSCUTOFF|HBASSWIDTH|HBASSHARMTYPE|HBASSHARMBOOST|HBASSLINGAIN|HVOLBOOST|HDE|HDEA|HDED|HVIRTDIST|HSURBOOST|HADVIRTANGLE|HVIRTMOD|HADVIRTREND|HLEVELER|HLEVSTR|HLEVAMOUNT|HLEVTARGETIN|HLEVTARGETOUT|HREGOVERDRIVE|HREGSTRESSAMOUNT|HTIMBRE|SPEAKERTUNING|SIEQ|SIEQSTR|SRENDERBASS|SBASSBOOST|SBASSHARMTYPE|SBASSHARMBOOST|SBASSLINGAIN|SVOLBOOST|SDE|SDEA|SDED|SSURBOOST|SVIRTMOD|SADVIRTREND|SLEVELER|SLEVSTR|SLEVAMOUNT|SLEVTARGETIN|SLEVTARGETOUT|STIMBRE)$/ {
            gsub(/[[:space:]]*/, "", $1);
            gsub(/[[:space:]]*/, "", $2);
            if ($2 != "") print $1 "=\"" $2 "\""
        }
    ' "$DIY")"
}

#Loading config vars and values
sleep 1
echo " "
echo " -- HEADPHONE TUNING -- "
echo " "
sleep 0.5

#IEQ vars assign
###############

loadconfig

case "$HEADPHONETUNING" in
"YES" | "yes" | "yES" | "yEs" | "yeS" | "Yes" | "YEs" | "YeS")
	echo " -- Headphone Tuning is Enabled -- "
	headphonetuning=true;;
"NO" | "no" | "No" | "nO")
	echo " -- Headphone Tuning is Disabled -- "
	headphonetuning=false;;
*)
	echo " "
	echo " -- Wrong or no value for Headphone Tuning -- " 
	echo " -- Using default setting (YES) -- "
	echo " -- Headphone Tuning is Enabled -- "
	echo " "
	headphonetuning=true;;
esac

sleep 0.1

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
	echo " "
	echo " -- Wrong IEQ value or no value -- " 
	echo " -- Using default setting (IEQ Balanced) -- "
	echo " "
	hieq1=2
	hieq2=balanced
	hieq3=true;;
esac

sleep 0.1

if [ "$HIEQSTR" -ge "1" -a "$HIEQSTR" -le "20" ];then
	echo " -- Intelligent EQ strength setting is: $HIEQSTR -- "
	hieqamount=$HIEQSTR
else
echo " "
echo " "
	echo " -- Wrong or no value for Intelligent EQ strength -- " 
	echo " -- Using default setting (6) -- "
echo " "
	hieqamount=6
fi

sleep 0.1

#Bass boost vars assign
###############

case "$HRENDERBASS" in
"VB" | "bb" | "vB" | "Vb")
	echo " -- Bass Rendering Method setting is: Virtual Bass -- "
	hrenderbass=VB;;
"BE" | "be" | "bE" | "Be")
	echo " -- Bass Rendering Method setting is: Bass Enhancer -- "
	hrenderbass=BE;;
*)
	echo " "
	echo " -- Wrong or no value for Bass Rendering Method -- "
	echo " -- Using default setting (Virtual Bass) -- "
	echo " "
	hrenderbass=VB;;
esac

sleep 0.1

if [ "$HBASSBOOST" -ge "0" -a "$HBASSBOOST" -le "25" ];then
	echo " -- Bass Enhancer Boost setting is: $HBASSBOOST -- "
	hbassboost=$(($HBASSBOOST*32))
else
	echo " "
	echo " -- Wrong or no value for Bass Enhancer Boost -- " 
	echo " -- Using default setting (6) -- "
	echo " "
	hbassboost=192
fi

sleep 0.1

if [ "$HBASSCUTOFF" -ge "10" -a "$HBASSCUTOFF" -le "200" ];then
	echo " -- Bass Enhancer cutoff setting is: $HBASSCUTOFF -- "
	hbasscutoff=$HBASSCUTOFF
else
	echo " "
	echo " -- Wrong or no value for Bass Enhancer Frequency Cutoff -- " 
	echo " -- Using default setting (90) -- "
	echo " "
	hbasscutoff=90
fi

sleep 0.1

if [ "$HBASSWIDTH" -ge "1" -a "$HBASSWIDTH" -le "128" ];then
	echo " -- Bass Enhancer Width setting is: $HBASSWIDTH -- "
	hbasswidth=$HBASSWIDTH
else
	echo " "
	echo " -- Wrong or no value for BassBoost Width -- " 
	echo " -- Using default setting (32) -- "
	echo " "
	hbasswidth=32
fi

sleep 0.1

case "$HBASSHARMTYPE" in
"1" | "2" | "3")
	echo " -- Bass Harmonics Type setting is: $HBASSHARMTYPE -- "
	hbassharmtype=$HBASSHARMTYPE;;
*)
	echo " "
	echo " -- Wrong or no value for Bass Harmonics Type -- "
	echo " -- Using default setting (2) -- "
	echo " "
	hbassharmtype=2;;
esac

sleep 0.1

if [ "$HBASSHARMBOOST" -ge "0" -a "$HBASSHARMBOOST" -le "15" ];then
	echo " -- Bass Harmonics Boost setting is: $HBASSHARMBOOST -- "
	hbassharmboost=$(($HBASSHARMBOOST*2))
else
	echo " "
	echo " -- Wrong or no value for Bass Harmonics boost -- "
	echo " -- Using default setting (6) -- "
	echo " "
	hbassharmboost=12
fi

sleep 0.1

if [ "$HBASSLINGAIN" -ge "0" -a "$HBASSLINGAIN" -le "20" ];then
	echo " -- Virtual Bass Linear gain setting is: $HBASSLINGAIN -- "
	hbasslingain=$(($HBASSLINGAIN*2))
else
	echo " "
	echo " -- Wrong or no value for Bass Harmonics boost -- "
	echo " -- Using default setting (7) -- "
	echo " "
	hbasslingain=14
fi

sleep 0.1

#Headphone volume boost vars assign
###############

if [ "$HVOLBOOST" -ge "-15" -a "$HVOLBOOST" -le "15" ];then
	echo " -- Headphone volume boost setting is: $HVOLBOOST dB -- "
	hvolboost=$(($HVOLBOOST*16))
else
	echo " "
	echo " -- Wrong or no value for Headphone volume boost -- " 
	echo " -- Using default setting (0) -- "
	echo " "
	hvolboost=0
fi

sleep 0.1

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

sleep 0.1

if [ "$HDEA" -ge "1" -a "$HDEA" -le "10" ];then
	echo " -- Dialog Enhancer strength setting is: $HDEA -- "
	hdeamount=$HDEA
else
echo " "
	echo " -- Wrong or no value for Dialog Enhancer strength -- " 
	echo " -- Using default setting (6) -- "
echo " "
	hdeamount=6
fi

sleep 0.1

if [ "$HDED" -ge "0" -a "$HDED" -le "10" ];then
	echo " -- Dialog Enhancer ducking setting is: $HDED -- "
	hdeducking=$HDED
else
echo " "
	echo " -- Wrong or no value for Dialog Enhancer ducking -- " 
	echo " -- Using default setting (0) -- "
echo " "
	hdeducking=0
fi

sleep 0.1

#Virtualizer vars assign
###############

if [ "$HVIRTDIST" -ge "4" -a "$HVIRTDIST" -le "100" ];then
	echo " -- Virtualizer source distance setting is: $HVIRTDIST -- "
	hvirtdist=$HVIRTDIST
else
	echo " "
	echo " -- Wrong or no value for Virtualizer source distance -- " 
	echo " -- Using default setting (40) -- "
	echo " "
	hvirtdist=40
fi

sleep 0.1

if [ "$HSURBOOST" -ge "0" -a "$HSURBOOST" -le "15" ];then
	echo " -- Headphone surround boost setting is: $HSURBOOST dB -- "
	hsurboost="$(($HSURBOOST*16))"
else
echo " "
	echo " -- Wrong or no value for Headphone surround boost -- " 
	echo " -- Using default setting (3) -- "
	echo " "
	hsurboost=48
fi

sleep 0.1

if [ "$HADVIRTANGLE" -ge "45" -a "$HADVIRTANGLE" -le "90" ];then
	echo " -- Virtualizer left-right angle setting is: $HADVIRTANGLE -- "
	hadvirtangle=$HADVIRTANGLE
else
	echo " "
	echo " -- Wrong or no value for Virtualizer left-right angle -- " 
	echo " -- Using default setting (90) -- "
	echo " "
	hadvirtangle=90
fi

sleep 0.1

if [ "$HVIRTMOD" -eq "1" -o "$HVIRTMOD" -eq "2" ];then
	echo " -- Headphone Virtualizer mode setting is: $HVIRTMOD -- "
	hvirtmod=$HVIRTMOD
else
	echo " "
	echo " -- Wrong or no Headphone Virtualizer mode -- " 
	echo " -- Using default setting (2) -- "
	echo " "
	hvirtmod=2
fi

sleep 0.1

case "$HADVIRTREND" in
[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*)
	echo " "
	echo " -- Advanced virtualizer rendering setting is: -- "
	echo " -- $HADVIRTREND -- "
	echo " "
hadvirtrend="$HADVIRTREND";;
*)
	echo " "
	echo " -- Wrong or no value for advanced Virtualizer rendering. -- "
	echo " -- Using default setting (200,32568,15164,8090,1,2,3,1) -- "
	echo " "
	hadvirtrend=200,32568,15164,8090,1,2,3,1;;
esac

sleep 0.1

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
	echo " "
	echo " -- Wrong or no value for Volume Leveler -- "
	echo " -- Using default setting (OFF) -- "
	echo " "
	hleveler=false;;
esac

sleep 0.1

if [ "$HLEVSTR" -ge "0" -a "$HLEVSTR" -le "10" ];then
	echo " -- Volume Leveler Volmax Boost setting is: $HLEVSTR -- "
	hlevstr="$(($HLEVSTR*16))"
else
	echo " "
	echo " -- Wrong or no value for Volume Leveler Volmax Boost -- "
	echo " -- Using default setting (3) -- "
	echo " "
	hlevstr=48
fi

sleep 0.1

if [ "$HLEVAMOUNT" -ge "0" -a "$HLEVAMOUNT" -le "10" ];then
	echo " -- Volume Leveler amount setting is: $HLEVAMOUNT -- "
	hlevamount=$HLEVAMOUNT
else
	echo " "
	echo " -- Wrong or no value for Volume Leveler amount -- "
	echo " -- Using default setting (0) -- "
	echo " "
	hlevamount=0
fi

sleep 0.1

if [ "$HLEVTARGETIN" -ge "1" -a "$HLEVTARGETIN" -le "10" ];then
	echo " -- Volume leveler target-in setting is: $HLEVTARGETIN -- "
	hlevtargetin="$((64+(32*$HLEVTARGETIN)))"
else
	echo " "
	echo " -- Wrong or no value for Volume leveler target-in -- "
	echo " -- Using default setting (6) -- "
	echo " "
	hlevtargetin=256
fi

sleep 0.1

if [ "$HLEVTARGETOUT" -ge "1" -a "$HLEVTARGETOUT" -le "10" ];then
	echo " -- Volume leveler target-out setting is: $HLEVTARGETOUT -- "
	hlevtargetout="$((64+(32*$HLEVTARGETOUT)))"
else
	echo " "
	echo " -- Wrong or no value for Volume leveler target-out -- "
	echo " -- Using default setting (6) -- "
	echo " "
	hlevtargetout=256
fi

sleep 0.1


#Regulator Timbre Preservation vars assign
###############

if [ "$HREGOVERDRIVE" -ge "0" -a "$HREGOVERDRIVE" -le "10" ];then
	echo " -- Regulator Overdrive setting is: $HREGOVERDRIVE -- "
	hregoverdrive="$(($HREGOVERDRIVE*32))"
else
	echo " "
	echo " -- Wrong or no value for Regulator Overdrive -- "
	echo " -- Using default setting (8) -- "
	echo " "
	hregoverdrive=256
fi

sleep 0.1

if [ "$HTIMBRE" -ge "1" -a "$HTIMBRE" -le "4" ];then
	echo " -- Timbre Preservation setting is: $HTIMBRE -- "
	htimbre="$(($HTIMBRE*6))"
else
	echo " "
	echo " -- Wrong or no value for Timbre Preservation -- "
	echo " -- Using default setting (2) -- "
	echo " "
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
	echo " -- Speaker Tuning setting is Enabled -- "
	spookertuning=true;;
"NO" | "no" | "No" | "nO")
	echo " -- Speaker Tuning setting is Disabled -- "
	spookertuning=false;;
*)
	echo " "
	echo " -- Wrong or no value for Speaker Tuning -- " 
	echo " -- Using default setting (YES) -- "
	echo " -- Speaker Tuning setting is Enabled -- "
	echo " "
	spookertuning=true;;
esac

sleep 0.1

case "$SIEQ" in
"B" | "b")
	echo " -- IEQ will be set to: Balanced -- "
	sieq1=2
	sieq2=balanced
	sieq3=true;;
"D" | "d")
	echo " -- IEQ will be set to: Detailed -- "
	sieq1=1
	sieq2=detailed
	sieq3=true;;
"W" | "w")
	echo " -- IEQ will be set to: Warm -- "
	sieq1=3
	sieq2=warm
	sieq3=true;;
"N" | "n")
	echo " -- IEQ will be disabled -- "
	sieq1=2
	sieq2=balanced
	sieq3=false;;
*)
	echo " "
	echo " -- Wrong IEQ value or no value -- " 
	echo " -- Using default setting (IEQ Balanced) -- "
	echo " "
	sieq1=2
	sieq2=balanced
	sieq3=true;;
esac

sleep 0.1

if [ "$SIEQSTR" -ge "1" -a "$SIEQSTR" -le "20" ];then
	echo " -- Intelligent EQ strength setting is: $SIEQSTR -- "
	sieqamount=$SIEQSTR
else
	echo " "
	echo " -- Wrong or no value for Intelligent EQ strength -- " 
	echo " -- Using default setting (6) -- "
	echo " "
	sieqamount=6
fi

sleep 0.1

#Bass boost vars assign
###############

case "$SRENDERBASS" in
"VB" | "bb" | "vB" | "Vb")
	echo " -- Bass Rendering Method setting is: Virtual Bass -- "
	srenderbass=VB;;
"BE" | "be" | "bE" | "Be")
	echo " -- Bass Rendering Method setting is: Bass Enhancer -- "
	srenderbass=BE;;
*)
	echo " "
	echo " -- Wrong or no value for Bass Rendering Method -- "
	echo " -- Using default setting (Virtual Bass) -- "
	echo " "
	srenderbass=VB;;
esac

sleep 0.1

if [ "$SBASSBOOST" -ge "0" -a "$SBASSBOOST" -le "25" ];then
	echo " -- BassBoost setting is: $SBASSBOOST -- "
	sbassboost=$(($SBASSBOOST*32))
else
	echo " "
	echo " -- Wrong or no value for BassBoost -- " 
	echo " -- Using default setting (6) -- "
	echo " "
	sbassboost=192
fi

sleep 0.1

case "$SBASSHARMTYPE" in
"1" | "2" | "3")
	echo " -- Bass Harmonics Type setting is: $SBASSHARMTYPE -- "
	sbassharmtype=$SBASSHARMTYPE;;
*)
	echo " "
	echo " -- Wrong or no value for Bass Harmonics Type -- "
	echo " -- Using default setting (1) -- "
	echo " "
	sbassharmtype=1;;
esac

sleep 0.1

if [ "$SBASSHARMBOOST" -ge "0" -a "$SBASSHARMBOOST" -le "15" ];then
	echo " -- Bass Harmonics Boost setting is: $SBASSHARMBOOST -- "
	sbassharmboost=$(($SBASSHARMBOOST*2))
else
	echo " "
	echo " -- Wrong or no value for Bass Harmonics boost -- "
	echo " -- Using default setting (2) -- "
	echo " "
	sbassharmboost=4
fi

sleep 0.1

if [ "$SBASSLINGAIN" -ge "0" -a "$SBASSLINGAIN" -le "20" ];then
	echo " -- Virtual Bass Linear gain setting is: $SBASSLINGAIN -- "
	sbasslingain=$(($SBASSLINGAIN*2))
else
	echo " "
	echo " -- Wrong or no value for Bass Harmonics boost -- "
	echo " -- Using default setting (12) -- "
	echo " "
	sbasslingain=24
fi

sleep 0.1

#Headphone volume boost vars assign
###############

if [ "$SVOLBOOST" -ge "-15" -a "$SVOLBOOST" -le "15" ];then
	echo " -- Headphone volume boost setting is: $SVOLBOOST dB -- "
	svolboost=$(($SVOLBOOST*16))
else
	echo " "
	echo " -- Wrong or no value for Headphone volume boost -- " 
	echo " -- Using default setting (0) -- "
	echo " "
	svolboost=0
fi

sleep 0.1

#Dialog Enhancer vars assign
###############

case "$SDE" in
0)
	echo " -- Dialog Enhancer setting is: OFF -- "
	sdialog1=false
	sdialog2=false;;
1)
	echo " -- Dialog Enhancer setting is: ON (MOVIE only) -- "
	sdialog1=true
	sdialog2=false;;
2)
	echo " -- Dialog Enhancer setting is: ON (every preset) -- "
	sdialog1=true
	sdialog2=true;;
*)
	echo " "
	echo " -- Wrong or no value for Dialog Enhancer -- " 
	echo " -- Using default setting (0 - OFF) -- "
	echo " "
	sdialog1=false
	sdialog2=false;;
esac

sleep 0.1

if [ "$SDEA" -ge "1" -a "$SDEA" -le "10" ];then
	echo " -- Dialog Enhancer strength setting is: $SDEA -- "
	sdeamount=$SDEA
else
	echo " "
	echo " -- Wrong or no value for Dialog Enhancer strength -- " 
	echo " -- Using default setting (6) -- "
	echo " "
	sdeamount=6
fi

sleep 0.1

if [ "$SDED" -ge "0" -a "$SDED" -le "10" ];then
	echo " -- Dialog Enhancer ducking setting is: $SDED -- "
	sdeducking=$SDED
else
	echo " "
	echo " -- Wrong or no value for Dialog Enhancer ducking -- " 
	echo " -- Using default setting (0) -- "
	echo " "
	sdeducking=0
fi

sleep 0.1

#Virtualizer vars assign
###############

if [ "$SSURBOOST" -ge "0" -a "$SSURBOOST" -le "15" ];then
	echo " -- Headphone surround boost setting is: $SSURBOOST dB -- "
	ssurboost="$(($SSURBOOST*16))"
else
	echo " "
	echo " -- Wrong or no value for Headphone surround boost -- " 
	echo " -- Using default setting (3) -- "
	echo " "
	ssurboost=48
fi

sleep 0.1

if [ "$SVIRTMOD" -eq "1" -o "$SVIRTMOD" -eq "2" ];then
	echo " -- Headphone Virtualizer mode setting is: $SVIRTMOD -- "
	svirtmod=$SVIRTMOD
else
	echo " "
	echo " -- Wrong or no Headphone Virtualizer mode -- " 
	echo " -- Using default setting (2) -- "
	echo " "
	svirtmod=2
fi

sleep 0.1

case "$SADVIRTREND" in
[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*)
	echo " "
	echo " -- Advanced virtualizer rendering setting is: -- "
	echo " -- $SADVIRTREND -- "
	echo " "
	sadvirtrend="$SADVIRTREND";;
*)
	echo " "
	echo " -- Wrong or no value for advanced Virtualizer rendering. -- "
	echo " -- Using default setting (103,32568,11164,5090,0,3,3,3) -- "
	echo " "
	sadvirtrend=103,32568,11164,5090,0,3,3,3;;
esac

sleep 0.1

#Volume leveler vars assign
###############

case "$SLEVELER" in
"ON" | "on" | "On" | "oN")
	echo " -- Volume Leveler setting is: ON -- "
	sleveler=true;;
"OFF" | "off" | "OFf" | "Off" | "OfF" | "oFF" | "oFf" | "ofF")
	echo " -- Volume Leveler setting is: OFF -- "
	sleveler=false;;
*)
	echo " "
	echo " -- Wrong or no value for Volume Leveler -- "
	echo " -- Using default setting (OFF) -- "
	echo " "
	sleveler=false;;
esac

sleep 0.1

if [ "$SLEVSTR" -ge "0" -a "$SLEVSTR" -le "10" ];then
	echo " -- Volume Leveler Volmax Boost setting is: $SLEVSTR -- "
	slevstr="$(($SLEVSTR*16))"
else
	echo " "
	echo " -- Wrong or no value for Volume Leveler Volmax Boost -- "
	echo " -- Using default setting (3) -- "
	echo " "
	slevstr=48
fi

sleep 0.1

if [ "$SLEVAMOUNT" -ge "0" -a "$SLEVAMOUNT" -le "10" ];then
	echo " -- Volume Leveler amount setting is: $SLEVAMOUNT -- "
	slevamount=$SLEVAMOUNT
else
	echo " "
	echo " -- Wrong or no value for Volume Leveler amount -- "
	echo " -- Using default setting (0) -- "
	echo " "
	slevamount=0
fi

sleep 0.1

if [ "$SLEVTARGETIN" -ge "1" -a "$SLEVTARGETIN" -le "10" ];then
	echo " -- Volume leveler target-in setting is: $SLEVTARGETIN -- "
	slevtargetin="$((64+(32*$SLEVTARGETIN)))"
else
	echo " "
	echo " -- Wrong or no value for Volume leveler target-in -- "
	echo " -- Using default setting (6) -- "
	echo " "
	slevtargetin=256
fi

sleep 0.1

if [ "$SLEVTARGETOUT" -ge "1" -a "$SLEVTARGETOUT" -le "10" ];then
	echo " -- Volume leveler target-out setting is: $SLEVTARGETOUT -- "
	slevtargetout="$((64+(32*$SLEVTARGETOUT)))"
else
	echo " "
	echo " -- Wrong or no value for Volume leveler target-out -- "
	echo " -- Using default setting (6) -- "
	echo " "
	slevtargetout=256
fi

sleep 0.1


#Regulator Timbre Preservation vars assign
###############

if [ "$STIMBRE" -ge "1" -a "$STIMBRE" -le "4" ];then
	echo " -- Timbre Preservation setting is: $STIMBRE -- "
	stimbre="$(($STIMBRE*6))"
else
	echo " "
	echo " -- Wrong or no value for Timbre Preservation -- "
	echo " -- Using default setting (2) -- "
	echo " "
	stimbre=12
fi

sleep 0.5

echo " "
echo " "
