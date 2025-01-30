#DYNAMIC
x1=$(($dyn+$rang1))
x3=$(($dyn+$diff1))

#SPEAKER
sed -E -i $x3,$x1's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="false"/g' $i
sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i

#MOVIE
x1=$(($mov+$rang1))
x3=$(($mov+$diff1))

#SPEAKER
sed -E -i $x3,$x1's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="false"/g' $i
sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i

#MUSIC
x1=$(($mus+$rang1))
x3=$(($mus+$diff1))

#SPEAKER
sed -E -i $x3,$x1's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="false"/g' $i
sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i

#CUSTOM
if [ ! -z $cus ]; then
	x1=$(($cus+$rang1))
	x3=$(($cus+$diff1))

	#SPEAKER
	sed -E -i $x3,$x1's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="false"/g' $i
	sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
fi

### SPKEND
sed -E -i $spkend,$(($hphend-1))'s/regulator-speaker-dist-enable value="[[:alnum:]]*"/regulator-speaker-dist-enable value="true"/g' $i
sed -E -i $spkend,$(($hphend-1))'s/virtualizer-front-speaker-angle value="[[:alnum:]]*"/virtualizer-front-speaker-angle value="23"/g' $i
sed -E -i $spkend,$(($hphend-1))'s/virtualizer-height-speaker-angle value="[[:alnum:]]*"/virtualizer-height-speaker-angle value="10"/g' $i
sed -E -i $spkend,$(($hphend-1))'s/virtualizer-surround-speaker-angle value="[[:alnum:]]*"/virtualizer-surround-speaker-angle value="10"/g' $i
if [ $harm == 'virtual-bass-harmgains' ]; then
	sed -E -i $spkend,$(($hphend-1))'s/bass-enhancer-boost value="[[:alnum:]]*"/bass-enhancer-boost value="0"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-mode value="[[:alnum:]]*"/virtual-bass-mode value="3"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-overall-gain value="[-[:alnum:]]*"/virtual-bass-overall-gain value="-164"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-slope-gain value="[-[:alnum:]]*"/virtual-bass-slope-gain value="0"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-mix-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-mix-freqs frequency_low="289" frequency_high="498"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-src-freqs frequency_low="[-[:alnum:]]*" frequency_high="[-[:alnum:]]*"/virtual-bass-src-freqs frequency_low="80" frequency_high="150"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-subgains harmonic_2="[-[:alnum:]]*" harmonic_3="[-[:alnum:]]*" harmonic_4="[-[:alnum:]]*"/virtual-bass-subgains harmonic_2="-16" harmonic_3="-144" harmonic_4="-192"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-harmgains value="[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*"/virtual-bass-harmgains value="-80,0,0,0"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-hybgains value="[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*"/virtual-bass-hybgains value="0,0,0,-48,-80,-128"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-rolloff-gain value="[-[:alnum:]]*"/virtual-bass-rolloff-gain value="0"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-blend-linear-gain value="[-[:alnum:]]*"/virtual-bass-blend-linear-gain value="23"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-mix-frequency value="[[:alnum:]]*,[[:alnum:]]*"/virtual-bass-mix-frequency value="100,600"/g' $i
	sed -E -i $spkend,$(($hphend-1))'s/virtual-bass-compressor-tuning value="[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*,[-[:alnum:]]*"/virtual-bass-compressor-tuning value="0,0,-16,96,32,25,50"/g' $i
fi
