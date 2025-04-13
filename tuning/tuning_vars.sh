#Variables used by functions
####################
harm="$(grep 'virtual-bass-harmgains' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
if [ "$harm" == 'virtual-bass-harmgains' ]; then
harm=true
else
harm=false
fi

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

#Check for samsung dolby config
sam="$(grep -n 'id="default"' $i | awk -F ':' 'NR==1{print$1}')"
if [ ! -z "$sam" ];then
	sam=true
else
	sam=false
fi

#Check for g6 or its type dolby config
pass="$(grep -n 'id="passthrough"' $i | awk -F ':' 'NR==1{print$1}')"
if [ ! -z "$pass" ];then
	pass="true"
else
	pass="false"
fi

diff1=$(($spk1-$dyn))
diff2=$(($hph1-$spk1))

spkend="$(grep -n 'endpoint_type="speaker"' $i | awk -F ':' 'NR==1{print$1}')"

if [ ! -z "$(grep -n 'endpoint_type="headphone"' $i | awk -F ':' 'NR==1{print$1}')" ]; then
	hphend="$(grep -n 'endpoint_type="headphone"' $i | awk -F ':' 'NR==1{print$1}')"
else
	hphend="$(grep -n 'endpoint_type="bluetooth"' $i | awk -F ':' 'NR==1{print$1}')"
fi

last="$(wc -l $i | awk -F ' ' '{print$1}')"

rang1="$(($diff1+$diff2))"
if [ "$sam" == 'true' ];then
	rang2="$(($diff1+(7*$diff2)))"
elif [ "$pass" == 'true' ];then
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
