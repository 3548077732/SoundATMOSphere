echo " -- Configuring ieq values -- "
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="47" target="[-[:digit:]]*"/band_ieq frequency="47" target="157"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="141" target="[-[:digit:]]*"/band_ieq frequency="141" target="167"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="234" target="[-[:digit:]]*"/band_ieq frequency="234" target="218"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="328" target="[-[:digit:]]*"/band_ieq frequency="328" target="218"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="469" target="[-[:digit:]]*"/band_ieq frequency="469" target="203"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="656" target="[-[:digit:]]*"/band_ieq frequency="656" target="188"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="844" target="[-[:digit:]]*"/band_ieq frequency="844" target="192"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="1031" target="[-[:digit:]]*"/band_ieq frequency="1031" target="192"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="1313" target="[-[:digit:]]*"/band_ieq frequency="1313" target="205"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="1688" target="[-[:digit:]]*"/band_ieq frequency="1688" target="213"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="2250" target="[-[:digit:]]*"/band_ieq frequency="2250" target="218"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="3000" target="[-[:digit:]]*"/band_ieq frequency="3000" target="209"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="3750" target="[-[:digit:]]*"/band_ieq frequency="3750" target="193"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="4688" target="[-[:digit:]]*"/band_ieq frequency="4688" target="159"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="5813" target="[-[:digit:]]*"/band_ieq frequency="5813" target="134"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="7125" target="[-[:digit:]]*"/band_ieq frequency="7125" target="97"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="9000" target="[-[:digit:]]*"/band_ieq frequency="9000" target="71"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="11250" target="[-[:digit:]]*"/band_ieq frequency="11250" target="22"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="13875" target="[-[:digit:]]*"/band_ieq frequency="13875" target="-90"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="19688" target="[-[:digit:]]*"/band_ieq frequency="19688" target="-283"/' $i

if [ ! -z $det ];then
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="47" target="[-[:digit:]]*"/band_ieq frequency="47" target="150"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="141" target="[-[:digit:]]*"/band_ieq frequency="141" target="142"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="234" target="[-[:digit:]]*"/band_ieq frequency="234" target="188"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="328" target="[-[:digit:]]*"/band_ieq frequency="328" target="216"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="469" target="[-[:digit:]]*"/band_ieq frequency="469" target="189"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="656" target="[-[:digit:]]*"/band_ieq frequency="656" target="195"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="844" target="[-[:digit:]]*"/band_ieq frequency="844" target="202"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="1031" target="[-[:digit:]]*"/band_ieq frequency="1031" target="199"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="1313" target="[-[:digit:]]*"/band_ieq frequency="1313" target="210"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="1688" target="[-[:digit:]]*"/band_ieq frequency="1688" target="225"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="2250" target="[-[:digit:]]*"/band_ieq frequency="2250" target="230"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="3000" target="[-[:digit:]]*"/band_ieq frequency="3000" target="236"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="3750" target="[-[:digit:]]*"/band_ieq frequency="3750" target="235"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="4688" target="[-[:digit:]]*"/band_ieq frequency="4688" target="235"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="5813" target="[-[:digit:]]*"/band_ieq frequency="5813" target="214"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="7125" target="[-[:digit:]]*"/band_ieq frequency="7125" target="165"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="9000" target="[-[:digit:]]*"/band_ieq frequency="9000" target="112"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="11250" target="[-[:digit:]]*"/band_ieq frequency="11250" target="49"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="13875" target="[-[:digit:]]*"/band_ieq frequency="13875" target="-24"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="19688" target="[-[:digit:]]*"/band_ieq frequency="19688" target="-217"/' $i
fi
if [ ! -z $warm ];then
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="47" target="[-[:digit:]]*"/band_ieq frequency="47" target="114"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="141" target="[-[:digit:]]*"/band_ieq frequency="141" target="146"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="234" target="[-[:digit:]]*"/band_ieq frequency="234" target="183"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="328" target="[-[:digit:]]*"/band_ieq frequency="328" target="169"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="469" target="[-[:digit:]]*"/band_ieq frequency="469" target="170"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="656" target="[-[:digit:]]*"/band_ieq frequency="656" target="128"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="844" target="[-[:digit:]]*"/band_ieq frequency="844" target="103"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="1031" target="[-[:digit:]]*"/band_ieq frequency="1031" target="90"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="1313" target="[-[:digit:]]*"/band_ieq frequency="1313" target="98"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="1688" target="[-[:digit:]]*"/band_ieq frequency="1688" target="126"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="2250" target="[-[:digit:]]*"/band_ieq frequency="2250" target="127"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="3000" target="[-[:digit:]]*"/band_ieq frequency="3000" target="140"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="3750" target="[-[:digit:]]*"/band_ieq frequency="3750" target="96"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="4688" target="[-[:digit:]]*"/band_ieq frequency="4688" target="85"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="5813" target="[-[:digit:]]*"/band_ieq frequency="5813" target="80"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="7125" target="[-[:digit:]]*"/band_ieq frequency="7125" target="66"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="9000" target="[-[:digit:]]*"/band_ieq frequency="9000" target="38"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="11250" target="[-[:digit:]]*"/band_ieq frequency="11250" target="-32"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="13875" target="[-[:digit:]]*"/band_ieq frequency="13875" target="-132"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="19688" target="[-[:digit:]]*"/band_ieq frequency="19688" target="-275"/' $i
fi
echo " -- Configuring audio optimizer -- "

if [ "$sam" == 'false' ];then
#SPEAKER VOLUME BOOST
gleft="$(sed -E -n '/endpoint_type="speaker"/,/<\/tuning>/p' $i | grep 'gain_left' | awk -F'"' '{print $4}' | sort -nru)"
gright="$(sed -E -n '/endpoint_type="speaker"/,/<\/tuning>/p' $i | grep 'gain_right' | awk -F'"' '{print $6}' | sort -nru)"
	
	for sgleft in ${gleft};do
	sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/gain_left="'"$sgleft"'"/gain_left="'"$(($sgleft+$svolboost))"'"/g' $i
	done
	
	for sgright in ${gright};do
	sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/gain_right="'"$sgright"'"/gain_right="'"$(($sgright+$svolboost))"'"/g' $i
	done
	
#HEADPHONE VOLUME BOOST
if [ "$spookertuning" == 'true' ];then
	sed -E -i '/endpoint_type="speaker"/,/audio-optimizer-enable/s/audio-optimizer-enable value="[[:alnum:]]*"/audio-optimizer-enable value="true"/g' $i
fi
if [ "$headphonetuning" == 'true' ];then
	sed -E -i '/endpoint_type="headphone"/,/audio-optimizer-enable value/s/audio-optimizer-enable value="false"/audio-optimizer-enable value="true"/g' $i
	sed -E -i '/endpoint_type="bluetooth"/,/audio-optimizer-enable value/s/audio-optimizer-enable value="false"/audio-optimizer-enable value="true"/g' $i
	sed -E -i '/endpoint_type="other"/,/audio-optimizer-enable value/s/audio-optimizer-enable value="false"/audio-optimizer-enable value="true"/g' $i

fi

sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/gain_left="[-[:digit:]]*" gain_right="[-[:digit:]]*"/gain_left="'"$hvolboost"'" gain_right="'"$hvolboost"'"/g' $i
sed -E -i '/endpoint_type="bluetooth"/,/<\/tuning>/s/gain_left="[-[:digit:]]*" gain_right="[-[:digit:]]*"/gain_left="'"$hvolboost"'" gain_right="'"$hvolboost"'"/g' $i
sed -E -i '/endpoint_type="other"/,/<\/tuning>/s/gain_left="[-[:digit:]]*" gain_right="[-[:digit:]]*"/gain_left="'"$hvolboost"'" gain_right="'"$hvolboost"'"/g' $i

if [ "$hrenderbass" == 'BE' -a "$headphonetuning" == 'true' ] ;then
	
	sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/frequency="47" gain_left="[-[:digit:]]*" gain_right="[-[:digit:]]*"/frequency="47" gain_left="'"$((($hbassboost/4)+$hvolboost))"'" gain_right="'"$((($hbassboost/4)+$hvolboost))"'"/g' $i
	sed -E -i '/endpoint_type="bluetooth"/,/<\/tuning>/s/frequency="47" gain_left="[-[:digit:]]*" gain_right="[-[:digit:]]*"/frequency="47" gain_left="'"$((($hbassboost/4)+$hvolboost))"'" gain_right="'"$((($hbassboost/4)+$hvolboost))"'"/g' $i
	sed -E -i '/endpoint_type="other"/,/<\/tuning>/s/frequency="47" gain_left="[-[:digit:]]*" gain_right="[-[:digit:]]*"/frequency="47" gain_left="'"$((($hbassboost/4)+$hvolboost))"'" gain_right="'"$((($hbassboost/4)+$hvolboost))"'"/g' $i

	sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/frequency="141" gain_left="[-[:digit:]]*" gain_right="[-[:digit:]]*"/frequency="141" gain_left="'"$((($hbassboost/8)+$hvolboost))"'" gain_right="'"$((($hbassboost/8)+$hvolboost))"'"/g' $i
	sed -E -i '/endpoint_type="bluetooth"/,/<\/tuning>/s/frequency="141" gain_left="[-[:digit:]]*" gain_right="[-[:digit:]]*"/frequency="141" gain_left="'"$((($hbassboost/8)+$hvolboost))"'" gain_right="'"$((($hbassboost/8)+$hvolboost))"'"/g' $i
	sed -E -i '/endpoint_type="other"/,/<\/tuning>/s/frequency="141" gain_left="[-[:digit:]]*" gain_right="[-[:digit:]]*"/frequency="141" gain_left="'"$((($hbassboost/8)+$hvolboost))"'" gain_right="'"$((($hbassboost/8)+$hvolboost))"'"/g' $i
fi

###SAMSUNG VOLUME BOOST
#######################
elif [ $sam == "true" ];then
	spksysgain="$(sed -E -n '/<endpoint_type id="speaker">/,/<system-gain/p' $i | grep 'system-gain' | awk -F'"' '{print $2}' | sort -nru)"
	hphsysgain="$(sed -E -n '/<endpoint_type id="headphone">/,/<system-gain/p' $i | grep 'system-gain' | awk -F'"' '{print $2}' | sort -nru)"
	for ssysgain in ${spksysgain};do
		sed -E -i '/<endpoint_type id="speaker">/,/<system-gain/s/system-gain value ="'"sysgain"'"/system-gain value ="'"$(($sysgain+$svolboost))"'"/g' $i
	done
	
	for hsysgain in ${hphsysgain};do
		sed -E -i '/<endpoint_type id="headphone">/,/<system-gain/s/system-gain value ="'"$hsysgain"'"/system-gain value ="'"$(($hsysgain+$hvolboost))"'"/g' $i
		sed -E -i '/<endpoint_type id="bluetooth">/,/<system-gain/s/system-gain value ="'"$hsysgain"'"/system-gain value ="'"$(($hsysgain+$hvolboost))"'"/g' $i
		sed -E -i '/<endpoint_type id="usb">/,/<system-gain/s/system-gain value ="'"$hsysgain"'"/system-gain value ="'"$(($hsysgain+$hvolboost))"'"/g' $i
		sed -E -i '/<endpoint_type id="default">/,/<system-gain/s/system-gain value ="'"$hsysgain"'"/system-gain value ="'"$(($hsysgain+$hvolboost))"'"/g' $i
	done
fi

sleep 1

echo " -- Configuring band regulator -- "

sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/threshold_low="[-[:digit:]]*" threshold_high="[-[:digit:]]*" isolated_band="[a-z]*"/threshold_low="-192" threshold_high="0" isolated_band="true"/g' $i
sed -E -i '/endpoint_type="bluetooth"/,/<\/tuning>/s/threshold_low="[-[:digit:]]*" threshold_high="[-[:digit:]]*" isolated_band="[a-z]*"/threshold_low="-192" threshold_high="0" isolated_band="true"/g' $i
sed -E -i '/endpoint_type="other"/,/<\/tuning>/s/threshold_low="[-[:digit:]]*" threshold_high="[-[:digit:]]*" isolated_band="[a-z]*"/threshold_low="-192" threshold_high="0" isolated_band="true"/g' $i
