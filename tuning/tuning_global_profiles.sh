echo " -- Configuring profiles -- "

sed -E -i '/name="Dynamic"/,/<endpoint_type/s/mi-dialog-enhancer-steering-enable value="[[:alnum:]]*"/mi-dialog-enhancer-steering-enable value="true"/' $i
sed -E -i '/name="Dynamic"/,/<endpoint_type/s/mi-dv-leveler-steering-enable value="[[:alnum:]]*"/mi-dv-leveler-steering-enable value="true"/g' $i
sed -E -i '/name="Dynamic"/,/<endpoint_type/s/mi-ieq-steering-enable value="[[:alnum:]]*"/mi-ieq-steering-enable value="true"/g' $i
sed -E -i '/name="Dynamic"/,/<endpoint_type/s/mi-surround-compressor-steering-enable value="[[:alnum:]]*"/mi-surround-compressor-steering-enable value="true"/g' $i
sed -E -i '/name="Dynamic"/,/<endpoint_type/s/mi-adaptive-virtualizer-steering-enable value="[[:alnum:]]*"/mi-adaptive-virtualizer-steering-enable value="true"/g' $i

sed -E -i '/name="Movie"/,/<endpoint_type/s/mi-dialog-enhancer-steering-enable value="[[:alnum:]]*"/mi-dialog-enhancer-steering-enable value="false"/' $i
sed -E -i '/name="Movie"/,/<endpoint_type/s/mi-dv-leveler-steering-enable value="[[:alnum:]]*"/mi-dv-leveler-steering-enable value="false"/g' $i
sed -E -i '/name="Movie"/,/<endpoint_type/s/mi-ieq-steering-enable value="[[:alnum:]]*"/mi-ieq-steering-enable value="false"/g' $i
sed -E -i '/name="Movie"/,/<endpoint_type/s/mi-surround-compressor-steering-enable value="[[:alnum:]]*"/mi-surround-compressor-steering-enable value="false"/g' $i
sed -E -i '/name="Movie"/,/<endpoint_type/s/mi-adaptive-virtualizer-steering-enable value="[[:alnum:]]*"/mi-adaptive-virtualizer-steering-enable value="false"/g' $i

sed -E -i '/name="Music"/,/<endpoint_type/s/mi-dialog-enhancer-steering-enable value="[[:alnum:]]*"/mi-dialog-enhancer-steering-enable value="false"/' $i
sed -E -i '/name="Music"/,/<endpoint_type/s/mi-dv-leveler-steering-enable value="[[:alnum:]]*"/mi-dv-leveler-steering-enable value="false"/g' $i
sed -E -i '/name="Music"/,/<endpoint_type/s/mi-ieq-steering-enable value="[[:alnum:]]*"/mi-ieq-steering-enable value="false"/g' $i
sed -E -i '/name="Music"/,/<endpoint_type/s/mi-surround-compressor-steering-enable value="[[:alnum:]]*"/mi-surround-compressor-steering-enable value="false"/g' $i
sed -E -i '/name="Music"/,/<endpoint_type/s/mi-adaptive-virtualizer-steering-enable value="[[:alnum:]]*"/mi-adaptive-virtualizer-steering-enable value="false"/g' $i

sed -E -i '/name="Custom"/,/<endpoint_type/s/mi-dialog-enhancer-steering-enable value="[[:alnum:]]*"/mi-dialog-enhancer-steering-enable value="false"/' $i
sed -E -i '/name="Custom"/,/<endpoint_type/s/mi-dv-leveler-steering-enable value="[[:alnum:]]*"/mi-dv-leveler-steering-enable value="false"/g' $i
sed -E -i '/name="Custom"/,/<endpoint_type/s/mi-ieq-steering-enable value="[[:alnum:]]*"/mi-ieq-steering-enable value="false"/g' $i
sed -E -i '/name="Custom"/,/<endpoint_type/s/mi-surround-compressor-steering-enable value="[[:alnum:]]*"/mi-surround-compressor-steering-enable value="false"/g' $i
sed -E -i '/name="Custom"/,/<endpoint_type/s/mi-adaptive-virtualizer-steering-enable value="[[:alnum:]]*"/mi-adaptive-virtualizer-steering-enable value="false"/g' $i
#Global settings
###############

if [ $headphonetuning == "true" ] && [ $spookertuning == "true" ];then 
sed -E -i '/<profile/,/<endpoint_type/s/preset="ieq_[[:alnum:]]*"/preset="ieq_'"$hieq2"'"/g' $i
sed -E -i '/<\/data>/,/<\/profile>/s/preset="ieq_[[:alnum:]]*"/preset="ieq_'"$hieq2"'"/g' $i
sed -E -i '/<profile/,/<endpoint_type/s/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/' $i
sed -E -i '/<profile/,/<endpoint_type/s/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/'  $i
elif [ $headphonetuning == "true" ] && [ $spookertuning == "false" ];then 
sed -E -i '/<profile/,/<endpoint_type/s/preset="ieq_[[:alnum:]]*"/preset="ieq_'"$hieq2"'"/g' $i
sed -E -i '/<\/data>/,/<\/profile>/s/preset="ieq_[[:alnum:]]*"/preset="ieq_'"$hieq2"'"/g' $i
sed -E -i '/<profile/,/<endpoint_type/s/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$hieq3"'"/' $i
sed -E -i '/<profile/,/<endpoint_type/s/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$hieqamount"'"/'  $i
elif [ $headphonetuning == "false" ] && [ $spookertuning == "true" ];then 
sed -E -i '/<profile/,/<endpoint_type/s/preset="ieq_[[:alnum:]]*"/preset="ieq_'"$sieq2"'"/g' $i
sed -E -i '/<\/data>/,/<\/profile>/s/preset="ieq_[[:alnum:]]*"/preset="ieq_'"$sieq2"'"/g' $i
sed -E -i '/<profile/,/<endpoint_type/s/ieq-enable value="[[:alnum:]]*"/ieq-enable value="'"$sieq3"'"/' $i
sed -E -i '/<profile/,/<endpoint_type/s/ieq-amount value="[[:alnum:]]*"/ieq-amount value="'"$sieqamount"'"/'  $i
fi
sed -E -i 1,$(($last-1))'s/intermediate_profile_partial_virtual_bass_enable value="[[:alnum:]]*"/intermediate_profile_partial_virtual_bass_enable value="true"/g' $i
