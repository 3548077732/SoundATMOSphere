#Global settings
##############
sed -E -i 1,$(($last-1))'s/speaker-virtualizer-mode value="[[:alnum:]]*"/speaker-virtualizer-mode value="'"$svirtmod"'"/g' $i
#G6
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/intermediate_tuning_bass-enhancer-enable value="[[:alnum:]]*"/intermediate_tuning_bass-enhancer-enable value="true"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/intermediate_tuning_partial_virtual_bass_enable value="[[:alnum:]]*"/intermediate_tuning_partial_virtual_bass_enable value="true"/g' $i
sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/intermediate_tuning_partial_virtualizer_enable value="[[:alnum:]]*"/intermediate_tuning_partial_virtualizer_enable value="true"/g' $i
#!G6

#DYNAMIC
###############

x1=$(($dyn+$rang1))
x3=$(($dyn+$diff1))

#speaker
sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
sed -E -i $x3,$x1's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
sed -E -i $x3,$x1's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$sieq3"'"/g' $i
sed -E -i $x3,$x1's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$sieq1"'"/g' $i
sed -E -i $x3,$x1's/include preset="ieq_[[:alnum:]]*"/include preset="ieq_'"$sieq2"'"/g' $i
sed -E -i $x3,$x1's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$sieqamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$sdialog2"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$sdeamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$sdeducking"'"/g' $i
sed -E -i $x3,$x1's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
sed -E -i $x3,$x1's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="false"/g' $i
sed -E -i $x3,$x1's/surround-boost value="[[:alnum:]]*"/surround-boost value="'"$ssurboost"'"/g' $i
sed -E -i $x3,$x1's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$slevstr"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$sleveler"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$slevamount"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$slevtargetin"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$slevtargetout"'"/g' $i
sed -E -i $x3,$x1's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i

#MOVIE
###############

x1=$(($mov+$rang1))
x3=$(($mov+$diff1))

#speaker
if [ "$srenderbass" == 'VB' -a "$harm" == 'true' ]; then
	sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
	sed -E -i $x3,$x1's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
else
	sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
	sed -E -i $x3,$x1's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="true"/g' $i
fi
sed -E -i $x3,$x1's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$sieq3"'"/g' $i
sed -E -i $x3,$x1's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$sieq1"'"/g' $i
sed -E -i $x3,$x1's/include preset="ieq_[[:alnum:]]*"/include preset="ieq_'"$sieq2"'"/g' $i
sed -E -i $x3,$x1's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$sieqamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$sdialog1"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$sdeamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$sdeducking"'"/g' $i
sed -E -i $x3,$x1's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
sed -E -i $x3,$x1's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="true"/g' $i
sed -E -i $x3,$x1's/surround-boost value="[[:alnum:]]*"/surround-boost value="'"$ssurboost"'"/g' $i
sed -E -i $x3,$x1's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$slevstr"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$sleveler"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$slevamount"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$slevtargetin"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$slevtargetout"'"/g' $i
sed -E -i $x3,$x1's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i

#MUSIC
###############

x1=$(($mus+$rang1))
x3=$(($mus+$diff1))

#speaker
if [ "$srenderbass" == 'VB' -a "$harm" == 'true' ]; then
	sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
	sed -E -i $x3,$x1's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
else
	sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
	sed -E -i $x3,$x1's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="true"/g' $i
fi
sed -E -i $x3,$x1's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$sieq3"'"/g' $i
sed -E -i $x3,$x1's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$sieq1"'"/g' $i
sed -E -i $x3,$x1's/include ieq_preset="ieq_[[:alnum:]]*"/include ieq_preset="ieq_'"$sieq2"'"/g' $i
sed -E -i $x3,$x1's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$sieqamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$sdialog2"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$sdeamount"'"/g' $i
sed -E -i $x3,$x1's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$sdeducking"'"/g' $i
sed -E -i $x3,$x1's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
sed -E -i $x3,$x1's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="false"/g' $i
sed -E -i $x3,$x1's/surround-boost value="[[:alnum:]]*"/surround-boost value="'"$ssurboost"'"/g' $i
sed -E -i $x3,$x1's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$slevstr"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$sleveler"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$slevamount"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$slevtargetin"'"/g' $i
sed -E -i $x3,$x1's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$slevtargetout"'"/g' $i
sed -E -i $x3,$x1's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i

#CUSTOM
###############

if [ ! -z $cus ]; then
	x1=$(($cus+$rang1))
	x3=$(($cus+$diff1))

	#speaker
if [ "$srenderbass" == 'VB' -a "$harm" == 'true' ]; then
		sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
		sed -E -i $x3,$x1's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
	else
		sed -E -i $x3,$x1's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
		sed -E -i $x3,$x1's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="true"/g' $i
	fi
	sed -E -i $x3,$x1's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$sieq3"'"/g' $i
	sed -E -i $x3,$x1's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$sieq1"'"/g' $i
	sed -E -i $x3,$x1's/include ieq_preset="ieq_[[:alnum:]]*"/include ieq_preset="ieq_'"$sieq2"'"/g' $i
	sed -E -i $x3,$x1's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$sieqamount"'"/g' $i
	sed -E -i $x3,$x1's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$sdialog2"'"/g' $i
	sed -E -i $x3,$x1's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$sdeamount"'"/g' $i
	sed -E -i $x3,$x1's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$sdeducking"'"/g' $i
	sed -E -i $x3,$x1's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
	sed -E -i $x3,$x1's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="false"/g' $i
	sed -E -i $x3,$x1's/surround-boost value="[[:alnum:]]*"/surround-boost value="'"$ssurboost"'"/g' $i
	sed -E -i $x3,$x1's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$slevstr"'"/g' $i
	sed -E -i $x3,$x1's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$sleveler"'"/g' $i
	sed -E -i $x3,$x1's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$slevamount"'"/g' $i
	sed -E -i $x3,$x1's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$slevtargetin"'"/g' $i
	sed -E -i $x3,$x1's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$slevtargetout"'"/g' $i
	sed -E -i $x3,$x1's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i
fi
