#!/bin/sh
touch $MODPATH/feature.txt
chmod 0777 $MODPATH/feature.txt
harm="$(grep 'virtual-bass-harmgains' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
if [ "$harm" == 'virtual-bass-harmgains' ];then
	harm=true
	echo "harm=true">$MODPATH/feature.txt
else
	harm=false
	echo "harm=false">$MODPATH/feature.txt
fi

hvirtmode="$(grep 'headphone-virtualizer-mode' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
if [ "$hvirtmode" == 'headphone-virtualizer-mode' ];then
	hvirtmode=true
	echo "hvirtmode=true">>$MODPATH/feature.txt
else
	hvirtmode=false
	echo "hvirtmode=false">>$MODPATH/feature.txt
fi

svirtmode="$(grep 'speaker-virtualizer-mode' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
if [ "$svirtmode" == 'speaker-virtualizer-mode' ];then
	svirtmode=true
	echo "svirtmode=true">>$MODPATH/feature.txt
else
	svirtmode=false
	echo "svirtmode=false">>$MODPATH/feature.txt
fi

angle="$(grep 'advanced-headphone-virtualizer-lr-angle' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
[ "$angle" == 'advanced-headphone-virtualizer-lr-angle' ] && echo "angle=true">>$MODPATH/feature.txt || echo "angle=false">>$MODPATH/feature.txt
distance="$(grep 'headphone-virtualizer-steerer-source-distance' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
[ "$distance" == 'headphone-virtualizer-steerer-source-distance' ] && echo "distance=true">>$MODPATH/feature.txt || echo "distance=false">>$MODPATH/feature.txt
advancedvirt="$(grep 'advanced-headphone-virtualizer-rendering-config' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
[ "$advancedvirt" == 'advanced-headphone-virtualizer-rendering-config' ] && echo "advancedvirt=true">>$MODPATH/feature.txt || echo "advancedvirt=false">>$MODPATH/feature.txt
sadvancedvirt="$(grep 'advanced-speaker-virtualizer-rendering-config' $i | awk -F '[<-=]' 'NR==1{print$2}' | awk -F '[ ]' '{print$1}')"
[ "$sadvancedvirt" == 'advanced-speaker-virtualizer-rendering-config' ] && echo "sadvancedvirt=true">>$MODPATH/feature.txt || echo "sadvancedvirt=false">>$MODPATH/feature.txt

#loading variables from tuningDIY.txt
load_config() {
    if [ ! -d $MODPATH/temp ];then
    mkdir -p $MODPATH/temp
    chmod 0755 $MODPATH/temp
    fi
    local tmpfile="$MODPATH/temp/config_vars_$$.tmp"
    awk -F '=' '
        $1 ~ /^(DOLBYMIDVLEV|DOLBYMIIEQ|DOLBYMISURCOMP|DOLBYMIADAPTVIRT|DOLBYMIVIRTBIN|DOLBYMIDIALENH|HEADPHONETUNING|HIEQ|HIEQSTR|HIET_47|HIET_141|HIET_234|HIET_328|HIET_469|HIET_656|HIET_844|HIET_1031|HIET_1313|HIET_1688|HIET_2250|HIET_3000|HIET_3750|HIET_4688|HIET_5813|HIET_7125|HIET_9000|HIET_11250|HIET_13875|HIET_19688|HEQ_47|HEQ_141|HEQ_234|HEQ_328|HEQ_469|HEQ_656|HEQ_844|HEQ_1031|HEQ_1313|HEQ_1688|HEQ_2250|HEQ_3000|HEQ_3750|HEQ_4688|HEQ_5813|HEQ_7125|HEQ_9000|HEQ_11250|HEQ_13875|HEQ_19688|HRENDERBASS|HBASSBOOST|HBASSCUTOFF|HBASSWIDTH|HBASSHARMTYPE|HBASSHARMBOOST|HBASSHARMMIXFREQMIN|HBASSHARMMIXFREQMAX|HBASSHARMSRCFREQMIN|HBASSHARMSRCFREQMAX|HBASSLINGAIN|HVOLBOOST|HDE|HDEA|HDED|HVIRTUALIZER|HVIRTDIST|HSURBOOST|HADVIRTANGLE|HVIRTMOD|HADVIRTREND|HHEIGHTFILTER|HLEVELER|HLEVSTR|HLEVAMOUNT|HLEVTARGETIN|HLEVTARGETOUT|HREGULATOR|HREGOVERDRIVE|HTIMBRE|HTUNEDRATE|H_OUTPUT_CHANNELS|SPEAKERTUNING|SIEQ|SIEQSTR|SRENDERBASS|SBASSBOOST|SBASSHARMTYPE|SBASSHARMBOOST|SBASSLINGAIN|SVOLBOOST|SDE|SDEA|SDED|SVIRTUALIZER|SSURBOOST|SVIRTMOD|SADVIRTREND|SLEVELER|SLEVSTR|SLEVAMOUNT|SLEVTARGETIN|SLEVTARGETOUT|STIMBRE|STUNEDRATE|S_OUTPUT_CHANNELS)$/ {
            gsub(/[[:space:]]*/, "", $1);
            gsub(/[[:space:]]*/, "", $2);
            if ($2 != "") print $1 "=" $2
        }
    ' "$DIY" > "$tmpfile"
    if [ -f "$tmpfile" ]; then
        . "$tmpfile"
        rm -f "$tmpfile"
    else
        echo " -- Cannot read $DIY file -- " >&2
        exit 1
    fi
}

get_value() {
    local key="$1"
	local default_val="$2"
	local val
	
    eval val=\"\$$key\"
    if [ -z "$val" ]; then
        echo "$default_val"
    else
        echo "$val"
    fi
}

set_ieq() {
    local prefix="$1"
	local ieq_var ieqstr_var
	
    if [ "$prefix" = "h" ]; then
        ieq_var="HIEQ"
        ieqstr_var="HIEQSTR"
    else
        ieq_var="SIEQ"
        ieqstr_var="SIEQSTR"
    fi
	
    local ieq=$(get_value "$ieq_var" "B")
    case "$ieq" in
        [Cc]) ieq_preset=2; ieq_name="balanced"; ieq_enabled="true" ;;
        [Dd]) ieq_preset=1; ieq_name="detailed"; ieq_enabled="true" ;;
        [Ww]) ieq_preset=3; ieq_name="warm"; ieq_enabled="true" ;;
        [Nn]) ieq_preset=2; ieq_name="balanced"; ieq_enabled="false" ;;
        *)    ieq_preset=2; ieq_name="balanced"; ieq_enabled="true" ;;
    esac
	
    eval "export ${prefix}ieq1=$ieq_preset"
    eval "export ${prefix}ieq2=$ieq_name"
    eval "export ${prefix}ieq3=$ieq_enabled"
	
    local ieqstr=$(get_value "$ieqstr_var" 6)
	[ "$ieqstr" -ge 1 ] && [ "$ieqstr" -le 20 ] || ieqstr=6
    eval "export ${prefix}ieqamount=$ieqstr"
}

set_eq_loops() {
    local prefix="$1"
    local frequencies="47 141 234 328 469 656 844 1031 1313 1688 2250 3000 3750 4688 5813 7125 9000 11250 13875 19688"
	
    for freq in $frequencies; do
        if [ "$prefix" = "h" ]; then
            hiet_key="HIET_${freq}"
            eq_key="HEQ_${freq}"
        else
            hiet_key="SIET_${freq}"
            eq_key="SEQ_${freq}"
        fi
        local hiet_val=$(get_value "$hiet_key" 0)
        if [ "$hiet_val" -ge -500 ] && [ "$hiet_val" -le 500 ]; then
            eval "export ${prefix}iet_${freq}=$hiet_val"
        else
            eval "export ${prefix}iet_${freq}=0"
        fi
        local eq_val=$(get_value "$eq_key" 0)
		if [ "$(echo "$eq_val >= -12" | bc -l)" -eq 1 ] && [ "$(echo "$eq_val <= 12" | bc -l)" -eq 1 ]; then
			eval "export ${prefix}eq_${freq}=$(echo "$eq_val * 16" | bc -l | cut -d'.' -f1)"
		else
			eval "export ${prefix}eq_${freq}=0"
		fi
    done
}

set_bass() {
    local prefix="$1"
	local key_prefix
	
    if [ "$prefix" = "h" ]; then
		key_prefix="H"
	else
		key_prefix="S"
	fi

    local renderbass=$(get_value "${key_prefix}RENDERBASS" "VB")
    case "$renderbass" in
	[Bb][Ee]) eval "export ${prefix}renderbass=BE" ;;
	*) eval "export ${prefix}renderbass=VB" ;;
	esac

    local bassboost=$(get_value "${key_prefix}BASSBOOST" 6)
	[ "$bassboost" -ge 0 ] && [ "$bassboost" -le 30 ] || bassboost=6
    eval "export ${prefix}bassboost=$(($bassboost * 32))"

    if [ "$prefix" = "h" ]; then
        local basscutoff=$(get_value "HBASSCUTOFF" 90)
		[ "$basscutoff" -ge 10 ] && [ "$basscutoff" -le 200 ] || basscutoff=90
        eval "export hbasscutoff=$basscutoff"
		
        local basswidth=$(get_value "HBASSWIDTH" 32)
		[ "$basswidth" -ge 1 ] && [ "$basswidth" -le 128 ] || basswidth=32
        eval "export hbasswidth=$basswidth"
    fi

    local bassharmtype=$(get_value "${key_prefix}BASSHARMTYPE" 2)
	case "$bassharmtype" in
	1|3) eval "export ${prefix}bassharmtype=$bassharmtype" ;;
	*) eval "export ${prefix}bassharmtype=2" ;;
	esac
	
    local bassharmboost=$(get_value "${key_prefix}BASSHARMBOOST" 6)
	[ "$bassharmboost" -ge 0 ] && [ "$bassharmboost" -le 15 ] || bassharmboost=12
	eval "export ${prefix}bassharmboost=$(($bassharmboost*2))"
	
    local basslingain=$(get_value "${key_prefix}BASSLINGAIN" 7)
	[ "$basslingain" -ge 0 ] && [ "$basslingain" -le 20 ] || basslingain=14
	eval "export ${prefix}basslingain=$(($basslingain*2))"

    if [ "$prefix" = "h" ]; then
        local bassharmmixfreqmin=$(get_value "HBASSHARMMIXFREQMIN" 10)
		[ "$bassharmmixfreqmin" -ge 10 ] && [ "$bassharmmixfreqmin" -le 200 ] || bassharmmixfreqmin=10
		export hbassharmmixfreqmin=$bassharmmixfreqmin
		
        local bassharmmixfreqmax=$(get_value "HBASSHARMMIXFREQMAX" 90)
		[ "$bassharmmixfreqmax" -ge 10 ] && [ "$bassharmmixfreqmax" -le 1500 ] || bassharmmixfreqmax=90
		export hbassharmmixfreqmax=$bassharmmixfreqmax
		
        local bassharmsrcfreqmin=$(get_value "HBASSHARMSRCFREQMIN" 10)
		[ "$bassharmsrcfreqmin" -ge 10 ] && [ "$bassharmsrcfreqmin" -le 200 ] || bassharmsrcfreqmin=10
		export hbassharmsrcfreqmin=$bassharmsrcfreqmin
		
        local bassharmsrcfreqmax=$(get_value "HBASSHARMSRCFREQMAX" 90)
		[ "$bassharmsrcfreqmax" -ge 10 ] && [ "$bassharmsrcfreqmax" -le 1500 ] || bassharmsrcfreqmax=90
		export hbassharmsrcfreqmax=$bassharmsrcfreqmax
    fi
}

set_volume() {
    local prefix="$1"
	local key_prefix
	if [ "$prefix" = "h" ]; then
		key_prefix="H"
	else
		key_prefix="S"
	fi
	
    local volboost=$(get_value "${key_prefix}VOLBOOST" 0)
	[ "$volboost" -ge -15 ] && [ "$volboost" -le 15 ] || volboost=0
    eval "export ${prefix}volboost=$(($volboost * 16))"
}

set_dialog() {
    local prefix="$1"
	local key_prefix
	if [ "$prefix" = "h" ]; then
		key_prefix="H"
	else
		key_prefix="S"
	fi
	
    local de=$(get_value "${key_prefix}DE" 0)
	case "$de" in
	1) eval "export ${prefix}dialog1=true"; eval "export ${prefix}dialog2=false" ;;
	2) eval "export ${prefix}dialog1=true"; eval "export ${prefix}dialog2=true" ;;
	*) eval "export ${prefix}dialog1=false"; eval "export ${prefix}dialog2=false" ;;
	esac
	
    local dea=$(get_value "${key_prefix}DEA" 6)
	[ "$dea" -ge 1 ] && [ "$dea" -le 10 ] || dea=6
	eval "export ${prefix}deamount=$dea"
	
    local ded=$(get_value "${key_prefix}DED" 0)
	[ "$ded" -ge 0 ] && [ "$ded" -le 10 ] || ded=0
	eval "export ${prefix}deducking=$ded"
}

set_virtualizer() {
    local prefix="$1"
	local key_prefix
	
	if [ "$prefix" = "h" ];then
		key_prefix="H"
	else
		key_prefix="S"
	fi
	
    local virtualizer=$(get_value "${key_prefix}VIRTUALIZER" 1)
	case "$virtualizer" in
	0) eval "export ${prefix}virtualizer1=false"; eval "export ${prefix}virtualizer2=false" ;;
	2) eval "export ${prefix}virtualizer1=true"; eval "export ${prefix}virtualizer2=true" ;;
	*) eval "export ${prefix}virtualizer1=true"; eval "export ${prefix}virtualizer2=false" ;;
	esac
	
    local surboost=$(get_value "${key_prefix}SURBOOST" 3)
	[ "$surboost" -ge 0 ] && [ "$surboost" -le 15 ] || surboost=3
	eval "export ${prefix}surboost=$(($surboost * 16))"
	
    local virtmod=$(get_value "${key_prefix}VIRTMOD" 2)
	if [ "$virtmod" -eq 1 ];then
		eval "export ${prefix}virtmod=1"
	else
		eval "export ${prefix}virtmod=2"
	fi
	
    local advirtrend=$(get_value "${key_prefix}ADVIRTREND" "160,55000,24000,10000,1,1,1,3")
	case "$advirtrend" in
	[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*) eval "export ${prefix}advirtrend=$advirtrend" ;;
	*) eval "export ${prefix}advirtrend=160,55000,24000,10000,1,1,1,3" ;;
	esac
	
    if [ "$prefix" = "h" ]; then
	
        local virtdist=$(get_value "HVIRTDIST" 40)
		[ "$virtdist" -ge 4 ] && [ "$virtdist" -le 100 ] || virtdist=40; export hvirtdist=$virtdist
		
        local advirtangle=$(get_value "HADVIRTANGLE" 90)
		[ "$hadvirtangle" -ge 45 ] && [ "$hadvirtangle" -le 180 ] || hadvirtangle=90; export hadvirtangle=$advirtangle
		
        local heightfilter=$(get_value "HHEIGHTFILTER" 1)
		[ "$hheightfilter" -ge 0 ] && [ "$hheightfilter" -le 2 ] || hheightfilter=1; export hheightfilter=$heightfilter
    fi
}

set_leveler() {
    local prefix="$1"
	local key_prefix
	
	if [ "$prefix" = "h" ];then
		key_prefix="H"
	else
		key_prefix="S"
	fi
	
    local leveler=$(get_value "${key_prefix}LEVELER" "OFF")
	case "$leveler" in
	[Oo][Nn]) eval "export ${prefix}leveler=true" ;;
	*) eval "export ${prefix}leveler=false" ;;
	esac
	
    local levstr=$(get_value "${key_prefix}LEVSTR" 3)
	[ "$levstr" -ge 0 ] && [ "$levstr" -le 10 ] || levstr=3
	eval "export ${prefix}levstr=$(($levstr * 16))"
	
    local levamount=$(get_value "${key_prefix}LEVAMOUNT" 0)
	[ "$levamount" -ge 0 ] && [ "$levamount" -le 10 ] || levamount=0
	eval "export ${prefix}levamount=$levamount"
	
    local levtargetin=$(get_value "${key_prefix}LEVTARGETIN" 6)
	[ "$levtargetin" -ge 1 ] && [ "$levtargetin" -le 10 ] || levtargetin=6
	eval "export ${prefix}levtargetin=$((64 + (32 * $levtargetin)))"
	
    local levtargetout=$(get_value "${key_prefix}LEVTARGETOUT" 6)
	[ "$levtargetout" -ge 1 ] && [ "$levtargetout" -le 10 ] || levtargetout=6
	eval "export ${prefix}levtargetout=$((64 + (32 * $levtargetout)))"
}

set_regulator_timbre() {
    local prefix="$1"
	local key_prefix
	
	if [ "$prefix" = "h" ];then
		key_prefix="H"
	else
		key_prefix="S"
	fi
	
    local timbre=$(get_value "${key_prefix}TIMBRE" 2)
	[ "$timbre" -ge 1 ] && [ "$timbre" -le 4 ] || timbre=2
	eval "export ${prefix}timbre=$(($timbre * 6))"
	
    if [ "$prefix" = "h" ]; then
        local regulator=$(get_value "HREGULATOR" "ON")
		
	case "$regulator" in
	[Oo][Ff][Ff]) eval "export hregulator=false" ;;
	*) eval "export hregulator=true" ;;
	esac
	
        local regoverdrive=$(get_value "HREGOVERDRIVE" 0)
	[ "$regoverdrive" -ge 0 ] && [ "$regoverdrive" -le 10 ] || regoverdrive=0
	eval "export hregoverdrive=$(($regoverdrive * 32))"
	
    fi
}

set_tunedrate() {
    local prefix="$1"
	local key_prefix
	
	if [ "$prefix" = "h" ];then
		key_prefix="H"
	else
		key_prefix="S"
	fi
	
    local tunedrate=$(get_value "${key_prefix}TUNEDRATE" "48000")
	eval "export ${prefix}tunedrate=$tunedrate"
}

set_output_channels() {
    local prefix="$1"
	local key_prefix
	
	if [ "$prefix" = "h" ];then
		key_prefix="H_"
	else
		key_prefix="S_"
	fi
	
    local output_channels=$(get_value "${key_prefix}OUTPUT_CHANNELS" "2")
	eval "export ${prefix}_output_channels=$output_channels"
}

set_dolbymi() {
	get_mi_bool() {
		local key="$1"
		local value

		value=$(get_value "$key" "OFF")
		
		case "$value" in
			[Oo][Nn])
				echo "true"
				;;
			*)
				echo "false"
				;;
		esac
	}
    export dolbymidvlev=$(get_mi_bool "DOLBYMIDVLEV")
    export dolbymiieq=$(get_mi_bool "DOLBYMIIEQ")
    export dolbymisurcomp=$(get_mi_bool "DOLBYMISURCOMP")
    export dolbmiadaptvirt=$(get_mi_bool "DOLBYMIADAPTVIRT")
    export dolbymivirtbin=$(get_mi_bool "DOLBYMIVIRTBIN")
    export dolbymidialenh=$(get_mi_bool "DOLBYMIDIALENH")
}

initialize_all_variables() {
    echo " -- Loading config from tuningDIY.txt -- "
	
    load_config
	
	set_dolbymi
	
    headphonetuning=$(get_value "HEADPHONETUNING" "YES")
	case "$headphonetuning" in
	[Nn][Oo]) export headphonetuning="false" ;;
	*) export headphonetuning="true" ;;
	esac
	
    speakertuning=$(get_value "SPEAKERTUNING" "YES")
	case "$speakertuning" in
	[Nn][Oo]) export speakertuning="false" ;;
	*) export speakertuning="true" ;;
	esac
	
    echo ""
    echo " -- Dolby Media Intelligence (Auto settings): -- "
    echo ""
    echo " -- MI - Volume leveler: $dolbymidvlev -- "
    echo ""
    echo " -- MI - IEQ Steering: $dolbymiieq -- "
    echo ""
    echo " -- MI - Surround Compressor: $dolbymisurcomp -- "
    echo ""
    echo " -- MI - Adaptive Virtualizer: $dolbmiadaptvirt -- "
    echo ""
    echo " -- MI - Virtualizer Binaural Steering: $dolbymivirtbin -- "
    echo ""
    echo " -- MI - Dialog Enhancer: $dolbymidialenh -- "
    echo ""
    echo " -- Headphone Tuning: $headphonetuning -- "
    echo ""
    echo " -- Speaker Tuning: $speakertuning -- "
    echo ""
    echo " -- Processing variables -- "
    echo ""
    for prefix in h s; do
        set_ieq "$prefix"; set_eq_loops "$prefix"; set_bass "$prefix"; set_volume "$prefix"
        set_dialog "$prefix"; set_virtualizer "$prefix"; set_leveler "$prefix"
        set_regulator_timbre "$prefix"; set_tunedrate "$prefix"; set_output_channels "$prefix"
    done
}