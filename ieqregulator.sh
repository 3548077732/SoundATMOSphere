echo " -- Configuring ieq values -- "
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="47" target="[-[:alnum:]]*"/band_ieq frequency="47" target="157"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="141" target="[-[:alnum:]]*"/band_ieq frequency="141" target="167"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="234" target="[-[:alnum:]]*"/band_ieq frequency="234" target="218"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="328" target="[-[:alnum:]]*"/band_ieq frequency="328" target="218"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="469" target="[-[:alnum:]]*"/band_ieq frequency="469" target="203"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="656" target="[-[:alnum:]]*"/band_ieq frequency="656" target="188"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="844" target="[-[:alnum:]]*"/band_ieq frequency="844" target="192"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="1031" target="[-[:alnum:]]*"/band_ieq frequency="1031" target="192"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="1313" target="[-[:alnum:]]*"/band_ieq frequency="1313" target="205"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="1688" target="[-[:alnum:]]*"/band_ieq frequency="1688" target="213"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="2250" target="[-[:alnum:]]*"/band_ieq frequency="2250" target="218"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="3000" target="[-[:alnum:]]*"/band_ieq frequency="3000" target="209"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="3750" target="[-[:alnum:]]*"/band_ieq frequency="3750" target="193"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="4688" target="[-[:alnum:]]*"/band_ieq frequency="4688" target="159"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="5813" target="[-[:alnum:]]*"/band_ieq frequency="5813" target="134"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="7125" target="[-[:alnum:]]*"/band_ieq frequency="7125" target="97"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="9000" target="[-[:alnum:]]*"/band_ieq frequency="9000" target="71"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="11250" target="[-[:alnum:]]*"/band_ieq frequency="11250" target="22"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="13875" target="[-[:alnum:]]*"/band_ieq frequency="13875" target="-90"/' $i
sed -E -i $bal,$(($bal+22))'s/band_ieq frequency="19688" target="[-[:alnum:]]*"/band_ieq frequency="19688" target="-283"/' $i

if [ ! -z $det ];then
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="47" target="[-[:alnum:]]*"/band_ieq frequency="47" target="150"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="141" target="[-[:alnum:]]*"/band_ieq frequency="141" target="142"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="234" target="[-[:alnum:]]*"/band_ieq frequency="234" target="188"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="328" target="[-[:alnum:]]*"/band_ieq frequency="328" target="216"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="469" target="[-[:alnum:]]*"/band_ieq frequency="469" target="189"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="656" target="[-[:alnum:]]*"/band_ieq frequency="656" target="195"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="844" target="[-[:alnum:]]*"/band_ieq frequency="844" target="202"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="1031" target="[-[:alnum:]]*"/band_ieq frequency="1031" target="199"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="1313" target="[-[:alnum:]]*"/band_ieq frequency="1313" target="210"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="1688" target="[-[:alnum:]]*"/band_ieq frequency="1688" target="225"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="2250" target="[-[:alnum:]]*"/band_ieq frequency="2250" target="230"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="3000" target="[-[:alnum:]]*"/band_ieq frequency="3000" target="236"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="3750" target="[-[:alnum:]]*"/band_ieq frequency="3750" target="235"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="4688" target="[-[:alnum:]]*"/band_ieq frequency="4688" target="235"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="5813" target="[-[:alnum:]]*"/band_ieq frequency="5813" target="214"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="7125" target="[-[:alnum:]]*"/band_ieq frequency="7125" target="165"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="9000" target="[-[:alnum:]]*"/band_ieq frequency="9000" target="112"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="11250" target="[-[:alnum:]]*"/band_ieq frequency="11250" target="49"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="13875" target="[-[:alnum:]]*"/band_ieq frequency="13875" target="-24"/' $i
	sed -E -i $det,$(($det+22))'s/band_ieq frequency="19688" target="[-[:alnum:]]*"/band_ieq frequency="19688" target="-217"/' $i
fi
if [ ! -z $warm ];then
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="47" target="[-[:alnum:]]*"/band_ieq frequency="47" target="114"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="141" target="[-[:alnum:]]*"/band_ieq frequency="141" target="146"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="234" target="[-[:alnum:]]*"/band_ieq frequency="234" target="183"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="328" target="[-[:alnum:]]*"/band_ieq frequency="328" target="169"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="469" target="[-[:alnum:]]*"/band_ieq frequency="469" target="170"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="656" target="[-[:alnum:]]*"/band_ieq frequency="656" target="128"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="844" target="[-[:alnum:]]*"/band_ieq frequency="844" target="103"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="1031" target="[-[:alnum:]]*"/band_ieq frequency="1031" target="90"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="1313" target="[-[:alnum:]]*"/band_ieq frequency="1313" target="98"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="1688" target="[-[:alnum:]]*"/band_ieq frequency="1688" target="126"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="2250" target="[-[:alnum:]]*"/band_ieq frequency="2250" target="127"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="3000" target="[-[:alnum:]]*"/band_ieq frequency="3000" target="140"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="3750" target="[-[:alnum:]]*"/band_ieq frequency="3750" target="96"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="4688" target="[-[:alnum:]]*"/band_ieq frequency="4688" target="85"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="5813" target="[-[:alnum:]]*"/band_ieq frequency="5813" target="80"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="7125" target="[-[:alnum:]]*"/band_ieq frequency="7125" target="66"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="9000" target="[-[:alnum:]]*"/band_ieq frequency="9000" target="38"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="11250" target="[-[:alnum:]]*"/band_ieq frequency="11250" target="-32"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="13875" target="[-[:alnum:]]*"/band_ieq frequency="13875" target="-132"/' $i
	sed -E -i $warm,$(($warm+22))'s/band_ieq frequency="19688" target="[-[:alnum:]]*"/band_ieq frequency="19688" target="-275"/' $i
fi
echo " -- Configuring audio optimizer -- "

sed -E -i $hphend,$(($last-1))'s/gain_left="[-[:alnum:]]*" gain_right="[-[:alnum:]]*"/gain_left="0" gain_right="0"/g' $i
sleep 1

echo " -- Configuring band regulator -- "

if [ $builtinmode == "true" ];then
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="47" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="47" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
		case "$HIEQ" in
			"N" | "n")
			sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="141" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="141" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
			;;
			"D" | "d" | "B" | "b")
			sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="141" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="141" threshold_low="-576" threshold_high="-192" isolated_band="true"/g' $i
			;;
			*)
			sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="141" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="141" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
			;;
		esac
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="234" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="234" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="328" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="328" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="469" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="469" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="656" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="656" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="844" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="844" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="1031" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="1031" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="1313" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="1313" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="1688" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="1688" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="2250" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="2250" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="3000" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="3000" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="3750" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="3750" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="4688" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="4688" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="5813" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="5813" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="7125" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="7125" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="9000" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="9000" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="11250" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="11250" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="13875" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="13875" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="19688" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="19688" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
else
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="47" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="47" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="141" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="141" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="234" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="234" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="328" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="328" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="469" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="469" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="656" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="656" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="844" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="844" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="1031" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="1031" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="1313" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="1313" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="1688" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="1688" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="2250" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="2250" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="3000" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="3000" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="3750" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="3750" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="4688" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="4688" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="5813" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="5813" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="7125" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="7125" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="9000" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="9000" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="11250" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="11250" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="13875" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="13875" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
	sed -E -i $hphend,$(($last-1))'s/band_regulator frequency="19688" threshold_low="[-[:alnum:]]*" threshold_high="[-[:alnum:]]*" isolated_band="[[:alnum:]]*"/band_regulator frequency="19688" threshold_low="-384" threshold_high="0" isolated_band="true"/g' $i
fi
