#Global settings
###############
sed -E -i 1,$(($last-1))'s/headphone-virtualizer-mode value="[[:alnum:]]*"/headphone-virtualizer-mode value="'"$hvirtmod"'"/g' $i
#G6
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/intermediate_tuning_bass-enhancer-enable value="[[:alnum:]]*"/intermediate_tuning_bass-enhancer-enable value="true"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/intermediate_tuning_partial_virtual_bass_enable value="[[:alnum:]]*"/intermediate_tuning_partial_virtual_bass_enable value="true"/g' $i
sed -E -i '/endpoint_type="headphone"/,/<\/tuning>/s/intermediate_tuning_partial_virtualizer_enable value="[[:alnum:]]*"/intermediate_tuning_partial_virtualizer_enable value="true"/g' $i
#!G6

#DYNAMIC
###############

x1=$(($dyn+$rang1))
x2=$(($dyn+$rang2))

#HEADPHONES
sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
sed -E -i $x1,$x2's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$hieq1"'"/g' $i
sed -E -i $x1,$x2's/include preset="ieq_[[:alnum:]]*"/include preset="ieq_'"$hieq2"'"/g' $i
sed -E -i $x1,$x2's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$hdialog2"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$hdeamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$hdeducking"'"/g' $i
sed -E -i $x1,$x2's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
sed -E -i $x1,$x2's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="false"/g' $i
sed -E -i $x1,$x2's/surround-boost value="[[:alnum:]]*"/surround-boost value="'"$hsurboost"'"/g' $i
sed -E -i $x1,$x2's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$hlevstr"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$hleveler"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$hlevamount"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$hlevtargetin"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$hlevtargetout"'"/g' $i
sed -E -i $x1,$x2's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i

#MOVIE
###############

x1=$(($mov+$rang1))
x2=$(($mov+$rang2))

#HEADPHONES
if [ "$hrenderbass" == 'VB' -a "$harm" == 'true' ]; then
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
else
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="true"/g' $i
fi
sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
sed -E -i $x1,$x2's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$hieq1"'"/g' $i
sed -E -i $x1,$x2's/include preset="ieq_[[:alnum:]]*"/include preset="ieq_'"$hieq2"'"/g' $i
sed -E -i $x1,$x2's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$hdialog1"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$hdeamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$hdeducking"'"/g' $i
sed -E -i $x1,$x2's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
sed -E -i $x1,$x2's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="true"/g' $i
sed -E -i $x1,$x2's/surround-boost value="[[:alnum:]]*"/surround-boost value="'"$hsurboost"'"/g' $i
sed -E -i $x1,$x2's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$hlevstr"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$hleveler"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$hlevamount"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$hlevtargetin"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$hlevtargetout"'"/g' $i
sed -E -i $x1,$x2's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i

#MUSIC
###############

x1=$(($mus+$rang1))
x2=$(($mus+$rang2))

#HEADPHONES
if [ "$hrenderbass" == 'VB' -a "$harm" == 'true' ]; then
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
else
	sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
	sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="true"/g' $i
fi
sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
sed -E -i $x1,$x2's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$hieq1"'"/g' $i
sed -E -i $x1,$x2's/include preset="ieq_[[:alnum:]]*"/include preset="ieq_'"$hieq2"'"/g' $i
sed -E -i $x1,$x2's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$hdialog2"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$hdeamount"'"/g' $i
sed -E -i $x1,$x2's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$hdeducking"'"/g' $i
sed -E -i $x1,$x2's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
sed -E -i $x1,$x2's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="false"/g' $i
sed -E -i $x1,$x2's/surround-boost value="[[:alnum:]]*"/surround-boost value="'"$hsurboost"'"/g' $i
sed -E -i $x1,$x2's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$hlevstr"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$hleveler"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$hlevamount"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$hlevtargetin"'"/g' $i
sed -E -i $x1,$x2's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$hlevtargetout"'"/g' $i
sed -E -i $x1,$x2's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i

#CUSTOM
###############

if [ ! -z $cus ]; then
	x1=$(($cus+$rang1))
	x2=$(($cus+$rang2))

	#HEADPHONES
if [ "$hrenderbass" == 'VB' -a "$harm" == 'true' ]; then
		sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="true"/g' $i
		sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="false"/g' $i
	else
		sed -E -i $x1,$x2's/virtual-bass-process-enable value="[[:alnum:]]*"/virtual-bass-process-enable value="false"/g' $i
		sed -E -i $x1,$x2's/bass-enhancer-enable value="[[:alnum:]]*"/bass-enhancer-enable value="true"/g' $i
	fi
	sed -E -i $x1,$x2's/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/g' $i
	sed -E -i $x1,$x2's/include ieq_preset="[[:alnum:]]*"/include ieq_preset="'"$hieq1"'"/g' $i
	sed -E -i $x1,$x2's/include preset="ieq_[[:alnum:]]*"/include preset="ieq_'"$hieq2"'"/g' $i
	sed -E -i $x1,$x2's/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/g' $i
	sed -E -i $x1,$x2's/dialog-enhancer-enable value="[[:alnum:]]*"/dialog-enhancer-enable value="'"$hdialog2"'"/g' $i
	sed -E -i $x1,$x2's/dialog-enhancer-amount value="[[:alnum:]]*"/dialog-enhancer-amount value="'"$hdeamount"'"/g' $i
	sed -E -i $x1,$x2's/dialog-enhancer-ducking value="[[:alnum:]]*"/dialog-enhancer-ducking value="'"$hdeducking"'"/g' $i
	sed -E -i $x1,$x2's/peak-value value="[[:alnum:]]*"/peak-value value="512"/g' $i
	sed -E -i $x1,$x2's/virtualizer-enable value="[[:alnum:]]*"/virtualizer-enable value="false"/g' $i
	sed -E -i $x1,$x2's/surround-boost value="[[:alnum:]]*"/surround-boost value="'"$hsurboost"'"/g' $i
	sed -E -i $x1,$x2's/volmax-boost value="[[:alnum:]]*"/volmax-boost value="'"$hlevstr"'"/g' $i
	sed -E -i $x1,$x2's/volume-leveler-enable value="[[:alnum:]]*"/volume-leveler-enable value="'"$hleveler"'"/g' $i
	sed -E -i $x1,$x2's/volume-leveler-amount value="[[:alnum:]]*"/volume-leveler-amount value="'"$hlevamount"'"/g' $i
	sed -E -i $x1,$x2's/volume-leveler-in-target value="[-[:alnum:]]*"/volume-leveler-in-target value="-'"$hlevtargetin"'"/g' $i
	sed -E -i $x1,$x2's/volume-leveler-out-target value="[-[:alnum:]]*"/volume-leveler-out-target value="-'"$hlevtargetout"'"/g' $i
	sed -E -i $x1,$x2's/hearing-protection-enable value="[[:alnum:]]*"/hearing-protection-enable value="false"/g' $i
fi
