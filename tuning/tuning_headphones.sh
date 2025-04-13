### HPHEND
###############

echo " -- Configuring endpoint parameters -- "
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/volume-leveler-compressor-enable value="[[:alnum:]]*"/volume-leveler-compressor-enable value="true"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/bass-extraction-enable value="[[:alnum:]]*"/bass-extraction-enable value="true"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/bass-extraction-cutoff-frequency value="[[:alnum:]]*"/bass-extraction-cutoff-frequency value="200"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/regulator-enable value="[[:alnum:]]*"/regulator-enable value="true"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/height-filter-mode value="[[:alnum:]]*"/height-filter-mode value="1"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/regulator-speaker-dist-enable value="[[:alnum:]]*"/regulator-speaker-dist-enable value="false"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtualizer-front-speaker-angle value="[[:alnum:]]*"/virtualizer-front-speaker-angle value="25"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtualizer-height-speaker-angle value="[[:alnum:]]*"/virtualizer-height-speaker-angle value="15"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtualizer-surround-speaker-angle value="[[:alnum:]]*"/virtualizer-surround-speaker-angle value="90"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/bass-enhancer-boost value="[[:alnum:]]*"/bass-enhancer-boost value="'"$hbassboost"'"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/bass-enhancer-cutoff-frequency value="[[:alnum:]]*"/bass-enhancer-cutoff-frequency value="'"$hbasscutoff"'"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/bass-enhancer-width value="[[:alnum:]]*"/bass-enhancer-width value="'"$hbasswidth"'"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/regulator-sibilance-suppress-enable value="[[:alnum:]]*"/regulator-sibilance-suppress-enable value="false"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/regulator-overdrive value="[-[:alnum:]]*"/regulator-overdrive value="'"$hregoverdrive"'"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/regulator-timbre-preservation value="[[:alnum:]]*"/regulator-timbre-preservation value="'"$htimbre"'"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/regulator-stress-amount value="[,[:alnum:]]*"/regulator-stress-amount value="48,48,0,0"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/regulator-distortion-slope value="[[:alnum:]]*"/regulator-distortion-slope value="16"/g' $i

if [ $advancedvirt == 'advanced-headphone-virtualizer-rendering-config' ];then
	sed -E -i 1,$(($last-1))'s/advanced-headphone-virtualizer-rendering-config value="[-,[:alnum:]]*"/advanced-headphone-virtualizer-rendering-config value="'"$hadvirtrend"'"/g' $i
else
	echo " "
	echo " -- Your Dolby don't support advanced virtualizer rendering -- "
	echo " -- This variable will be ignored -- "
	echo " "
	sleep 1
fi


if [ "$distance" == 'headphone-virtualizer-steerer-source-distance' ]; then
	sed -E -i 1,$(($last-1))'s/headphone-virtualizer-steerer-source-distance value="[[:alnum:]]*"/headphone-virtualizer-steerer-source-distance value="'"$hvirtdist"'"/g' $i
else
	echo " "
	echo " -- Your Dolby don't support Virtualizer source distance -- "
	echo " -- This variable will be ignored -- "
	echo " "
	sleep 1
fi

if [ "$angle" == 'advanced-headphone-virtualizer-lr-angle' ]; then
	sed -E -i 1,$(($last-1))'s/advanced-headphone-virtualizer-lr-angle value="[[:alnum:]]*"/advanced-headphone-virtualizer-lr-angle value="'"$hadvirtangle"'"/g' $i
else
	echo " "
	echo " -- Your Dolby don't support Virtualizer left-right angle -- "
	echo " -- This variable will be ignored -- "
	echo " "
	sleep 1
fi

if [ "$hrenderbass" == 'VB' -a "$harm" == 'true' ]; then
	sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-mode value="[[:alnum:]]*"/virtual-bass-mode value="3"/g' $i
	sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-overall-gain value="[-[:alnum:]]*"/virtual-bass-overall-gain value="0"/g' $i
	sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-slope-gain value="[-[:alnum:]]*"/virtual-bass-slope-gain value="-64"/g' $i
	if [ "$hbassharmtype" == '1' ];then
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-mix-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-mix-freqs frequency_low="10" frequency_high="200"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-src-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-src-freqs frequency_low="10" frequency_high="90"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-subgains harmonic_2="[-[:alnum:]]*" harmonic_3="[-[:alnum:]]*" harmonic_4="[-[:alnum:]]*"/virtual-bass-subgains harmonic_2="-96" harmonic_3="-240" harmonic_4="-480"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-harmgains value="[-,[:alnum:]]*"/virtual-bass-harmgains value="'"$(($hbassharmboost*12))"',0,0,0"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-hybgains value="[-,[:alnum:]]*"/virtual-bass-hybgains value="0,0,0,0,0,0"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-rolloff-gain value="[-[:alnum:]]*"/virtual-bass-rolloff-gain value="0"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-blend-linear-gain value="[-[:alnum:]]*"/virtual-bass-blend-linear-gain value="'"$hbasslingain"'"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-mix-frequency value="[,[:alnum:]]*"/virtual-bass-mix-frequency value="10,90"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-compressor-tuning value="[-,[:alnum:]]*"/virtual-bass-compressor-tuning value="10,90,-16,96,32,25,50"/g' $i
	elif [ "$hbassharmtype" == '2' ];then
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-mix-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-mix-freqs frequency_low="10" frequency_high="200"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-src-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-src-freqs frequency_low="10" frequency_high="90"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-subgains harmonic_2="[-[:alnum:]]*" harmonic_3="[-[:alnum:]]*" harmonic_4="[-[:alnum:]]*"/virtual-bass-subgains harmonic_2="64" harmonic_3="96" harmonic_4="48"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-harmgains value="[-,[:alnum:]]*"/virtual-bass-harmgains value="'"$(($hbassharmboost*12))"','"$(($hbassharmboost*10))"','"$(($hbassharmboost*15))"','"$(($hbassharmboost*15))"'"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-hybgains value="[-,[:alnum:]]*"/virtual-bass-hybgains value="0,0,0,0,0,0"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-rolloff-gain value="[-[:alnum:]]*"/virtual-bass-rolloff-gain value="0"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-blend-linear-gain value="[-[:alnum:]]*"/virtual-bass-blend-linear-gain value="'"$hbasslingain"'"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-mix-frequency value="[,[:alnum:]]*"/virtual-bass-mix-frequency value="10,90"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-compressor-tuning value="[-,[:alnum:]]*"/virtual-bass-compressor-tuning value="1,90,-16,192,64,100,150"/g' $i
	elif [ "$hbassharmtype" == '3' ];then
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-mix-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-mix-freqs frequency_low="10" frequency_high="200"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-src-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-src-freqs frequency_low="10" frequency_high="90"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-subgains harmonic_2="[-[:alnum:]]*" harmonic_3="[-[:alnum:]]*" harmonic_4="[-[:alnum:]]*"/virtual-bass-subgains harmonic_2="128" harmonic_3="192" harmonic_4="96"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-harmgains value="[-,[:alnum:]]*"/virtual-bass-harmgains value="'"$(($hbassharmboost*12))"','"$(($hbassharmboost*20))"','"$(($hbassharmboost*25))"','"$(($hbassharmboost*25))"'"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-hybgains value="[-,[:alnum:]]*"/virtual-bass-hybgains value="0,0,'"$(($hbassharmboost*16))"','"$(($hbassharmboost*16))"','"$(($hbassharmboost*5))"','"$(($hbassharmboost*5))"'"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-rolloff-gain value="[-[:alnum:]]*"/virtual-bass-rolloff-gain value="0"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-blend-linear-gain value="[-[:alnum:]]*"/virtual-bass-blend-linear-gain value="'"$hbasslingain"'"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-mix-frequency value="[,[:alnum:]]*"/virtual-bass-mix-frequency value="10,90"/g' $i
    sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/virtual-bass-compressor-tuning value="[-,[:alnum:]]*"/virtual-bass-compressor-tuning value="1,90,-16,192,64,100,150"/g' $i
	else
	echo " Something went wrong with Bass Harmonics Boost setting "
	echo " Take log and send it to mod creator "
	fi
else
	echo " "
	echo " -- Using Bass Enhancer method for headphones -- "
	echo " "
	sleep 0.5
fi