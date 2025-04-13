### SPKEND


sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/volume-leveler-compressor-enable value="[[:alnum:]]*"/volume-leveler-compressor-enable value="true"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/regulator-enable value="[[:alnum:]]*"/regulator-enable value="true"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/height-filter-mode value="[[:alnum:]]*"/height-filter-mode value="1"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/regulator-speaker-dist-enable value="[[:alnum:]]*"/regulator-speaker-dist-enable value="true"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtualizer-front-speaker-angle value="[[:alnum:]]*"/virtualizer-front-speaker-angle value="23"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtualizer-height-speaker-angle value="[[:alnum:]]*"/virtualizer-height-speaker-angle value="10"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtualizer-surround-speaker-angle value="[[:alnum:]]*"/virtualizer-surround-speaker-angle value="10"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/bass-enhancer-boost value="[[:alnum:]]*"/bass-enhancer-boost value="'"$sbassboost"'"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/bass-enhancer-cutoff-frequency value="[[:alnum:]]*"/bass-enhancer-cutoff-frequency value="500"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/bass-enhancer-width value="[[:alnum:]]*"/bass-enhancer-width value="32"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/regulator-sibilance-suppress-enable value="[[:alnum:]]*"/regulator-sibilance-suppress-enable value="false"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/regulator-timbre-preservation value="[[:alnum:]]*"/regulator-timbre-preservation value="'"$stimbre"'"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/regulator-stress-amount value="[,[:alnum:]]*"/regulator-stress-amount value="192,192,96,96"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/regulator-distortion-slope value="[[:alnum:]]*"/regulator-distortion-slope value="16"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/speaker-virtualizer-mode value="[[:digit:]]"/speaker-virtualizer-mode value="'"$svirtmod"'"/g' $i


if [ "$srenderbass" == 'VB' -a "$harm" == 'true' ]; then
	sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-mode value="[[:alnum:]]*"/virtual-bass-mode value="3"/g' $i
	sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-overall-gain value="[-[:alnum:]]*"/virtual-bass-overall-gain value="0"/g' $i
	sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-slope-gain value="[-[:alnum:]]*"/virtual-bass-slope-gain value="0"/g' $i
	if [ "$sbassharmtype" == '1' ];then
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-mix-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-mix-freqs frequency_low="289" frequency_high="498"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-src-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-src-freqs frequency_low="80" frequency_high="150"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-subgains harmonic_2="[-[:alnum:]]*" harmonic_3="[-[:alnum:]]*" harmonic_4="[-[:alnum:]]*"/virtual-bass-subgains harmonic_2="-96" harmonic_3="-240" harmonic_4="-480"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-harmgains value="[-,[:alnum:]]*"/virtual-bass-harmgains value="'"$(($sbassharmboost*12))"',0,0,0"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-hybgains value="[-,[:alnum:]]*"/virtual-bass-hybgains value="0,0,0,0,0,0"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-rolloff-gain value="[-[:alnum:]]*"/virtual-bass-rolloff-gain value="0"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-blend-linear-gain value="[-[:alnum:]]*"/virtual-bass-blend-linear-gain value="'"$sbasslingain"'"/g' $i
	sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-mix-frequency value="[[:alnum:]]*,[[:alnum:]]*"/virtual-bass-mix-frequency value="100,600"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-compressor-tuning value="[-,[:alnum:]]*"/virtual-bass-compressor-tuning value="0,0,-16,96,32,25,50"/g' $i
	elif [ "$sbassharmtype" == '2' ];then
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-mix-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-mix-freqs frequency_low="289" frequency_high="498"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-src-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-src-freqs frequency_low="80" frequency_high="150"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-subgains harmonic_2="[-[:alnum:]]*" harmonic_3="[-[:alnum:]]*" harmonic_4="[-[:alnum:]]*"/virtual-bass-subgains harmonic_2="64" harmonic_3="96" harmonic_4="48"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-harmgains value="[-,[:alnum:]]*"/virtual-bass-harmgains value="'"$(($sbassharmboost*12))"','"$(($sbassharmboost*10))"','"$(($sbassharmboost*15))"','"$(($sbassharmboost*15))"'"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-hybgains value="[-,[:alnum:]]*"/virtual-bass-hybgains value="0,0,0,0,0,0"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-rolloff-gain value="[-[:alnum:]]*"/virtual-bass-rolloff-gain value="0"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-blend-linear-gain value="[-[:alnum:]]*"/virtual-bass-blend-linear-gain value="'"$sbasslingain"'"/g' $i
	sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-mix-frequency value="[[:alnum:]]*,[[:alnum:]]*"/virtual-bass-mix-frequency value="100,600"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-compressor-tuning value="[-,[:alnum:]]*"/virtual-bass-compressor-tuning value="0,0,-16,96,32,25,50"/g' $i
	elif [ "$sbassharmtype" == '3' ];then
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-mix-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-mix-freqs frequency_low="289" frequency_high="498"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-src-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-src-freqs frequency_low="80" frequency_high="150"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-subgains harmonic_2="[-[:alnum:]]*" harmonic_3="[-[:alnum:]]*" harmonic_4="[-[:alnum:]]*"/virtual-bass-subgains harmonic_2="128" harmonic_3="192" harmonic_4="96"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-harmgains value="[-,[:alnum:]]*"/virtual-bass-harmgains value="'"$(($sbassharmboost*12))"','"$(($sbassharmboost*20))"','"$(($sbassharmboost*25))"','"$(($sbassharmboost*25))"'"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-hybgains value="[-,[:alnum:]]*"/virtual-bass-hybgains value="0,0,'"$(($sbassharmboost*16))"','"$(($sbassharmboost*16))"','"$(($sbassharmboost*5))"','"$(($sbassharmboost*5))"'"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-rolloff-gain value="[-[:alnum:]]*"/virtual-bass-rolloff-gain value="0"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-blend-linear-gain value="[-[:alnum:]]*"/virtual-bass-blend-linear-gain value="'"$sbasslingain"'"/g' $i
	sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-mix-frequency value="[[:alnum:]]*,[[:alnum:]]*"/virtual-bass-mix-frequency value="100,600"/g' $i
    sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/virtual-bass-compressor-tuning value="[-,[:alnum:]]*"/virtual-bass-compressor-tuning value="0,0,-16,96,32,25,50"/g' $i
	else
	echo " Something went wrong with Bass Harmonics Boost setting "
	echo " Take log and send it to mod creator "
	fi
else 
	echo " "
	echo " -- Using Bass Enhancer method for speaker -- "
	echo " "
	sleep 0.5
fi