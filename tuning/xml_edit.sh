#!/bin/sh
# shellcheck disable=SC2154

# Global flags
samsung=false

_add_hp_sed() {
	local generator_func="$1"
	local setting_name="$2"
	local new_value="$3"
	local devices_list="$4"
	local command=""

	# shellcheck disable=SC2086
	command=$($generator_func "$setting_name" "$new_value" $devices_list)

	echo "$command"
}

_generate_sed_headphone_value() {
	local setting_name="$1"
	local new_value="$2"
	local devices_list="$3"
	local endpoint_id

	local commands=""
	# shellcheck disable=SC2086
	for endpoint_id in $devices_list; do
		commands="${commands} /<endpoint_type id=\"$endpoint_id\">/,/<\/endpoint_type>/ s|${setting_name} value=\"[^\"]*\"|${setting_name} value=\"${new_value}\"|g;"
	done
	echo "$commands"
}

_generate_sed_headphone_no_value() {
	local setting_name="$1"
	local new_value="$2"
	local devices_list="$3"
	local endpoint_id

	local commands=""
	# shellcheck disable=SC2086
	for endpoint_id in $devices_list; do
		commands="${commands} /<endpoint_type id=\"$endpoint_id\">/,/<\/endpoint_type>/ s|${setting_name}=\"[^\"]*\"|${setting_name}=\"${new_value}\"|g;"
	done
	echo "$commands"
}

_generate_sed_speaker_value() {
	local endpoint_id="$1"
	local setting_name="$2"
	local new_value="$3"
	echo " /<endpoint_type id=\"$endpoint_id\">/,/<\/endpoint_type>/ s|$setting_name value=\"[^\"]*\"|$setting_name value=\"$new_value\"|g;"
}

_generate_sed_speaker_no_value() {
	local endpoint_id="$1"
	local setting_name="$2"
	local new_value="$3"
	echo " /<endpoint_type id=\"$endpoint_id\">/,/<\/endpoint_type>/ s|$setting_name=\"[^\"]*\"|$setting_name=\"$new_value\"|g;"
}

_generate_sed_profile_global_value() {
	local setting_name="$1"
	local new_value="$2"
	echo " s|${setting_name} value=\"[^\"]*\"|${setting_name} value=\"${new_value}\"|g;"
}

_generate_sed_tuning_value() {
	local endpoint_type="$1"
	local setting_name="$2"
	local new_value="$3"
	echo "/<tuning .*endpoint_type=\"$endpoint_type\"/,/<\/tuning>/ s|${setting_name} value=\"[^\"]*\"|${setting_name} value=\"${new_value}\"|g;"
}

detect_feature() {
	local file="$1"
	local feature_tag="$2"
	if grep -q "$feature_tag" "$file"; then
		return 0
	else
		return 1
	fi
}

detect_config(){
	local file="$1"
	if detect_feature "$file" 'id="default"'; then
		echo " -- Samsung-style config detected - Proceed -- "
		samsung=true
	else
		echo " -- Standard config detected - Proceed -- "
		samsung=false
	fi
}

set_headphone_profile_value() {
	local file="$1"
	local profile_name="$2"
	local setting_name="$3"
	local new_value="$4"
	local endpoint_id
	shift 4

	for endpoint_id in "$@"; do
		sed -E -i "/name=\"$profile_name\"/,/<\/profile>/ { /<endpoint_type id=\"$endpoint_id\">/,/<\/endpoint_type>/ s|${setting_name} value=\"[^\"]*\"|${setting_name} value=\"${new_value}\"|g; }" "$file"
	done
}

set_headphone_profile_no_value() {
	local file="$1"
	local profile_name="$2"
	local setting_name="$3"
	local new_value="$4"
	local endpoint_id
	shift 4

	for endpoint_id in "$@"; do
		sed -E -i "/name=\"$profile_name\"/,/<\/profile>/ { /<endpoint_type id=\"$endpoint_id\">/,/<\/endpoint_type>/ s|${setting_name}=\"[^\"]*\"|${setting_name}=\"${new_value}\"|g; }" "$file"
	done
}

set_speaker_profile_value() {
	sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$3\">/,/<\/endpoint_type>/ s|$4 value=\"[^\"]*\"|$4 value=\"$5\"|g; }" "$1"
}

set_speaker_profile_no_value() {
	sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$3\">/,/<\/endpoint_type>/ s|$4=\"[^\"]*\"|$4=\"$5\"|g; }" "$1"
}

set_tuning_value() {
	sed -E -i "/<tuning .*endpoint_type=\"$2\"/,/<\/tuning>/ s|$3 value=\"[^\"]*\"|$3 value=\"$4\"|g" "$1"
}

set_tuning_rate_channels_matrix() {
	sed -E -i "/<tuning .*endpoint_type=\"$2\"/,/<\/tuning>/ s|$3=\"[^\"]*\"|$3=\"$4\"|g" "$1"
}

set_profile_global_value() {
	sed -E -i "/<data>/,/<\/data>/ s|$3 value=\"[^\"]*\"|$3 value=\"$4\"|g" "$1"
}

apply_global_media_intelligence_settings() {
	local file="$1"
	local profile

	echo " "
	echo " -- Applying media intelligence and global settings -- "
	for profile in "Dynamic" "Movie" "Music"; do
		if grep -q "name=\"$profile\"" "$file"; then
			set_profile_global_value "$file" "$profile" "mi-dv-leveler-steering-enable" "$dolbymidvlev"
			set_profile_global_value "$file" "$profile" "mi-ieq-steering-enable" "$dolbymiieq"
			set_profile_global_value "$file" "$profile" "mi-surround-compressor-steering-enable" "$dolbymisurcomp"
			set_profile_global_value "$file" "$profile" "mi-adaptive-virtualizer-steering-enable" "$dolbmiadaptvirt"
			set_profile_global_value "$file" "$profile" "headphone-virtualizer-mode" "$hvirtmod"
			set_profile_global_value "$file" "$profile" "mi-virtualizer-binaural-steering-enable" "$dolbymivirtbin"
			set_profile_global_value "$file" "$profile" "mi-dialog-enhancer-steering-enable"  "$dolbymidialenh"
		fi
	done
}

apply_tuning_settings() {
	local file="$1"
	local frequencies="47 141 234 328 469 656 844 1031 1313 1688 2250 3000 3750 4688 5813 7125 9000 11250 13875 19688"
	local freq
	local low
	local high
	local isolated
	local sed_script_file

	echo " "
	echo " -- Applying endpoint tuning settings -- "

	if [ "$headphonetuning" = "true" ]; then
		set_tuning_value "$file" "headphone" "volume-leveler-compressor-enable" "true"
		set_tuning_value "$file" "headphone" "bass-mbdrc-enable" "false"
		set_tuning_value "$file" "headphone" "bass-extraction-enable" "true"
		set_tuning_value "$file" "headphone" "bass-extraction-cutoff-frequency" "200"
		set_tuning_value "$file" "headphone" "regulator-speaker-dist-enable" "true"
		set_tuning_value "$file" "headphone" "regulator-sibilance-suppress-enable" "false"
		set_tuning_value "$file" "headphone" "regulator-stress-amount" "96,96,96,96"
		set_tuning_value "$file" "headphone" "regulator-distortion-slope" "16"
		set_tuning_value "$file" "headphone" "audio-optimizer-enable" "true"
		set_tuning_value "$file" "headphone" "height-filter-mode" "$hheightfilter"
		set_tuning_value "$file" "headphone" "regulator-enable" "$hregulator"
		set_tuning_value "$file" "headphone" "regulator-overdrive" "$hregoverdrive"
		set_tuning_value "$file" "headphone" "regulator-timbre-preservation" "$htimbre"

		sed_script_file=$(mktemp "$TMPDIR/sed_tuning_commands.XXXXXX")

		for freq in $frequencies; do
			if [ "$freq" -lt 150 ]; then
				low="-192"
				high="0"
				isolated="false"
			else
				low="-192"
				high="0"
				isolated="false"
			fi

			echo "/endpoint_type=\"headphone\"/,/<\/tuning>/ s|frequency=\"$freq\" threshold_low=\"[^\"]*\" threshold_high=\"[^\"]*\" isolated_band=\"[^\"]*\"|frequency=\"$freq\" threshold_low=\"$low\" threshold_high=\"$high\" isolated_band=\"$isolated\"|" >> "$sed_script_file"
		done

		if [ -s "$sed_script_file" ]; then
			sed -i -E -f "$sed_script_file" "$file"
		fi
		rm -f "$sed_script_file"

		set_tuning_rate_channels_matrix "$file" "headphone" "tuned_rate" "$htunedrate"
		set_tuning_rate_channels_matrix "$file" "headphone" "output_channels" "$h_output_channels"

		# Applied DRY Principle: Apply bass enhancer settings once
		set_tuning_value "$file" "headphone" "bass-enhancer-enable" "true"
		set_tuning_value "$file" "headphone" "bass-enhancer-boost" "$hbassboost"
		set_tuning_value "$file" "headphone" "bass-enhancer-cutoff-frequency" "$hbasscutoff"
		set_tuning_value "$file" "headphone" "bass-enhancer-width" "$hbasswidth"

		# Apply virtual bass specifically if VB mode is selected and supported
		if [ "$hrenderbass" = "VB" ]; then
			if detect_feature "$file" "virtual-bass-harmgains"; then
				apply_virtual_bass "h" "$file"
			fi
		fi
	fi

	if [ "$speakertuning" = "true" ]; then
		set_tuning_value "$file" "speaker" "volume-leveler-compressor-enable" "true"
		set_tuning_value "$file" "speaker" "regulator-enable" "true"
		set_tuning_value "$file" "speaker" "regulator-speaker-dist-enable" "true"
		set_tuning_value "$file" "speaker" "regulator-sibilance-suppress-enable" "false"
		set_tuning_value "$file" "speaker" "audio-optimizer-enable" "true"
		set_tuning_value "$file" "speaker" "regulator-timbre-preservation" "$stimbre"
		set_tuning_value "$file" "speaker" "speaker-virtualizer-mode" "$svirtmod"
		set_tuning_rate_channels_matrix "$file" "speaker" "tuned_rate" "$stunedrate"
		set_tuning_rate_channels_matrix "$file" "speaker" "output_channels" "$s_output_channels"

		if detect_feature "$file" "advanced-speaker-virtualizer-rendering-config"; then
			set_tuning_value "$file" "speaker" "advanced-speaker-virtualizer-rendering-config" "$sadvirtrend"
		fi

		# Applied DRY Principle: Apply bass enhancer settings once based on mode
		if [ "$srenderbass" = "BE" ]; then
			set_speaker_profile_value "$file" "speaker" "bass-enhancer-enable" "true"
			set_speaker_profile_value "$file" "speaker" "bass-enhancer-boost" "$sbassboost"
		else
			set_speaker_profile_value "$file" "speaker" "bass-enhancer-enable" "true"
			set_speaker_profile_value "$file" "speaker" "bass-enhancer-boost" "$sbassboost"
			if detect_feature "$file" "virtual-bass-harmgains"; then
				apply_virtual_bass "s" "$file"
			fi
		fi
	fi
}

apply_all_profiles() {
	local file="$1"
	local sed_script_file
	local profile
	local existing_profiles
	local hdialog_setting
	local hvirtualizer_setting
	local sdialog_setting
	local svirtualizer_setting
	local hp_devices="headphone bluetooth other usb remote_submix digital_aux default"

	sed_script_file=$(mktemp "$TMPDIR/sed_profiles.XXXXXX")

	local headphone_vbass_available=false
	local headphone_adv_virt_available=false
	local headphone_virt_dist_available=false
	local headphone_virt_lr_angle_available=false
	local speaker_vbass_available=false
	local speaker_adv_virt_available=false

	local vbass_found=false
	local h_adv_virt_found=false
	local h_dist_found=false
	local h_angle_found=false
	local s_adv_virt_found=false

	eval "$(awk '
		/virtual-bass-process-enable/ { print "vbass_found=true" }
		/advanced-headphone-virtualizer-rendering-config/ { print "h_adv_virt_found=true" }
		/headphone-virtualizer-steerer-source-distance/ { print "h_dist_found=true" }
		/advanced-headphone-virtualizer-lr-angle/ { print "h_angle_found=true" }
		/advanced-speaker-virtualizer-rendering-config/ { print "s_adv_virt_found=true" }
	' "$file" | sort -u)"

	if [ "$headphonetuning" = "true" ]; then
		[ "$vbass_found" = "true" ] && headphone_vbass_available=true
		[ "$h_adv_virt_found" = "true" ] && headphone_adv_virt_available=true
		[ "$h_dist_found" = "true" ] && headphone_virt_dist_available=true
		[ "$h_angle_found" = "true" ] && headphone_virt_lr_angle_available=true
	fi
	if [ "$speakertuning" = "true" ]; then
		[ "$vbass_found" = "true" ] && speaker_vbass_available=true
		[ "$s_adv_virt_found" = "true" ] && speaker_adv_virt_available=true
	fi

	echo " "
	echo " -- Applying profile settings -- "

	existing_profiles=$(grep -E -o 'name="(Dynamic|Movie|Music|Custom)"' "$file" | cut -d'"' -f2 | sort -u)

	for profile in $existing_profiles; do
		echo "/name=\"$profile\"/,/<\/profile>/ {"

		if [ "$headphonetuning" = "true" ]; then
			hdialog_setting="$hdialog2"
			hvirtualizer_setting="$hvirtualizer2"

			if [ "$profile" = "Movie" ]; then
				hdialog_setting="$hdialog1"
				hvirtualizer_setting="$hvirtualizer1"
			fi

			if [ "$hrenderbass" = "VB" ] && [ "$headphone_vbass_available" = "true" ]; then
				_generate_sed_headphone_value "virtual-bass-process-enable" "true" "$hp_devices"
				_generate_sed_headphone_value "bass-enhancer-enable" "true" "$hp_devices"
			else
				_generate_sed_headphone_value "virtual-bass-process-enable" "false" "$hp_devices"
				_generate_sed_headphone_value "bass-enhancer-enable" "true" "$hp_devices"
			fi

			_generate_sed_headphone_value "ieq-enable" "$hieq3" "$hp_devices"
			if [ "$samsung" = "false" ]; then
				_generate_sed_headphone_no_value "include ieq_preset" "$hieq1" "$hp_devices"
				_generate_sed_headphone_no_value "include preset" "ieq_$hieq2" "$hp_devices"
			else
				_generate_sed_headphone_no_value "include preset" "ieq_balanced" "$hp_devices"
			fi

			_generate_sed_headphone_value "ieq-amount" "$hieqamount" "$hp_devices"
			_generate_sed_headphone_value "dialog-enhancer-enable" "$hdialog_setting" "$hp_devices"
			_generate_sed_headphone_value "dialog-enhancer-amount" "$hdeamount" "$hp_devices"
			_generate_sed_headphone_value "dialog-enhancer-ducking" "$hdeducking" "$hp_devices"
			_generate_sed_headphone_value "virtualizer-enable" "$hvirtualizer_setting" "$hp_devices"
			_generate_sed_headphone_value "surround-boost" "$hsurboost" "$hp_devices"
			_generate_sed_headphone_value "volmax-boost" "$hlevstr" "$hp_devices"
			_generate_sed_headphone_value "volume-leveler-enable" "$hleveler" "$hp_devices"
			_generate_sed_headphone_value "volume-leveler-amount" "$hlevamount" "$hp_devices"
			_generate_sed_headphone_value "volume-leveler-in-target" "$hlevtargetin" "$hp_devices"
			_generate_sed_headphone_value "volume-leveler-out-target" "$hlevtargetout" "$hp_devices"
			_generate_sed_headphone_value "peak-value" "512" "$hp_devices"
			_generate_sed_headphone_value "hearing-protection-enable" "false" "$hp_devices"
			_generate_sed_headphone_value "virtualizer-start-band" "0" "$hp_devices"
			_generate_sed_profile_global_value "surround-decoder-diffuse-relocating-to-front-amount" "-5"

			if [ "$headphone_adv_virt_available" = "true" ]; then
				_generate_sed_profile_global_value "advanced-headphone-virtualizer-rendering-config" "$hadvirtrend"
			fi
			if [ "$headphone_virt_dist_available" = "true" ]; then
				_generate_sed_profile_global_value "headphone-virtualizer-steerer-source-distance" "$hvirtdist"
			fi
			if [ "$headphone_virt_lr_angle_available" = "true" ]; then
				_generate_sed_profile_global_value "advanced-headphone-virtualizer-lr-angle" "$hadvirtangle"
			fi
		fi

		if [ "$speakertuning" = "true" ]; then
			sdialog_setting="$sdialog2"
			svirtualizer_setting="$svirtualizer2"
			if [ "$profile" = "Movie" ]; then
				sdialog_setting="$sdialog1"
				svirtualizer_setting="$svirtualizer1"
			fi

			if [ "$srenderbass" = "VB" ] && [ "$speaker_vbass_available" = "true" ]; then
				_generate_sed_speaker_value "speaker" "virtual-bass-process-enable" "true"
				_generate_sed_speaker_value "speaker" "bass-enhancer-enable" "false"
			else
				_generate_sed_speaker_value "speaker" "virtual-bass-process-enable" "false"
				_generate_sed_speaker_value "speaker" "bass-enhancer-enable" "true"
			fi

			_generate_sed_speaker_value "speaker" "ieq-enable" "$sieq3"
			_generate_sed_speaker_no_value "speaker" "include ieq_preset" "$sieq1"
			_generate_sed_speaker_value "speaker" "ieq-amount" "$sieqamount"
			_generate_sed_speaker_value "speaker" "dialog-enhancer-enable" "$sdialog_setting"
			_generate_sed_speaker_value "speaker" "dialog-enhancer-amount" "$sdeamount"
			_generate_sed_speaker_value "speaker" "dialog-enhancer-ducking" "$sdeducking"
			_generate_sed_speaker_value "speaker" "virtualizer-enable" "$svirtualizer_setting"
			_generate_sed_speaker_value "speaker" "surround-boost" "$ssurboost"
			_generate_sed_speaker_value "speaker" "volmax-boost" "$slevstr"
			_generate_sed_speaker_value "speaker" "volume-leveler-enable" "$sleveler"
			_generate_sed_speaker_value "speaker" "volume-leveler-amount" "$slevamount"
			_generate_sed_speaker_value "speaker" "volume-leveler-in-target" "$slevtargetin"
			_generate_sed_speaker_value "speaker" "volume-leveler-out-target" "$slevtargetout"
			_generate_sed_speaker_value "speaker" "peak-value" "512"
			_generate_sed_speaker_value "speaker" "hearing-protection-enable" "false"

			if [ "$speaker_adv_virt_available" = "true" ]; then
				_generate_sed_profile_global_value "advanced-speaker-virtualizer-rendering-config" "$sadvirtrend"
			fi
		fi

		echo "}"
	done >> "$sed_script_file"

	if [ -s "$sed_script_file" ]; then
		 sed -E -i -f "$sed_script_file" "$file"
		 echo " -- Profile settings applied successfully -- "
	else
		 echo " -- No profile settings to apply -- "
	fi
	rm -f "$sed_script_file"
}

apply_virtual_bass() {
	local prefix="$1"
	local file="$2"
	local endpoint
	local neghbasslingain
	local negsbasslingain

	[ "$prefix" = "h" ] && endpoint="headphone" || endpoint="speaker"
	echo " -- Applying Virtual Bass for endpoint: $endpoint -- "

	sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mode value=\"[^\"]*\"|virtual-bass-mode value=\"3\"|g" "$file"

	if [ "$prefix" = "h" ]; then
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-overall-gain value=\"[^\"]*\"|virtual-bass-overall-gain value=\"-96\"|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-slope-gain value=\"[^\"]*\"|virtual-bass-slope-gain value=\"8\"|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-rolloff-gain value=\"[^\"]*\"|virtual-bass-rolloff-gain value=\"2\"|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-subgains .*|virtual-bass-subgains harmonic_2=\"96\" harmonic_3=\"64\" harmonic_4=\"20\"/>|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mix-freqs frequency_low=\"[^\"]*\" frequency_high=\"[^\"]*\"|virtual-bass-mix-freqs frequency_low=\"$hbassharmmixfreqmin\" frequency_high=\"$hbassharmmixfreqmax\"|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-src-freqs frequency_low=\"[^\"]*\" frequency_high=\"[^\"]*\"|virtual-bass-src-freqs frequency_low=\"$hbassharmsrcfreqmin\" frequency_high=\"$hbassharmsrcfreqmax\"|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-blend-linear-gain value=\"[^\"]*\"|virtual-bass-blend-linear-gain value=\"$hbasslingain\"|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mix-frequency value=\"[^\"]*\"|virtual-bass-mix-frequency value=\"$hbassharmmixfreqmin,$hbassharmmixfreqmax\"|g" "$file"

		if [ "$hbasscompstrength" -eq 0 ]; then
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-compressor-tuning value=\"[^\"]*\"|virtual-bass-compressor-tuning value=\"0,0,0,0,0,0,0\"|g" "$file"
		else
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-compressor-tuning value=\"[^\"]*\"|virtual-bass-compressor-tuning value=\"1,$((hbasscompstrength*36)),$((hbasscompstrength*-24)),$((hbasscompstrength*48)),$((hbasscompstrength*12)),$((hbasscompstrength*24)),$((hbasscompstrength*24))\"|g" "$file"
		fi

		if [ "$hbasslingain" -gt "0" ]; then
			neghbasslingain=$((hbasslingain*-1))
		else
			neghbasslingain=$hbasslingain
		fi

		if [ "$hbassharmtype" -eq 0 ]; then
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$((neghbasslingain*0)),$((hbassharmboost*10)),$((hbassharmboost*10)),$((hbassharmboost*5))\"/>|g" "$file"
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$((neghbasslingain*0)),$((neghbasslingain*15)),$((neghbasslingain*15)),$((neghbasslingain*15)),$((neghbasslingain*15)),$((neghbasslingain*15))\"/>|g" "$file"
		elif [ "$hbassharmtype" -eq 1 ]; then
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$((neghbasslingain*0)),$((hbassharmboost*10)),$((hbassharmboost*15)),$((hbassharmboost*15))\"/>|g" "$file"
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$((neghbasslingain*0)),$((neghbasslingain*15)),$((neghbasslingain*15)),$((neghbasslingain*15)),$((neghbasslingain*15)),$((neghbasslingain*15))\"/>|g" "$file"
		elif [ "$hbassharmtype" -eq 2 ]; then
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$((neghbasslingain*0)),$((hbassharmboost*15)),$((hbassharmboost*20)),$((hbassharmboost*20))\"/>|g" "$file"
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$((neghbasslingain*0)),$((neghbasslingain*15)),$((neghbasslingain*15)),$((neghbasslingain*15)),$((neghbasslingain*15)),$((neghbasslingain*15))\"/>|g" "$file"
		elif [ "$hbassharmtype" -eq 3 ]; then
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$((neghbasslingain*0)),$((hbassharmboost*15)),$((hbassharmboost*20)),$((hbassharmboost*20))\"/>|g" "$file"
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$((neghbasslingain*0)),$((neghbasslingain*0)),$((neghbasslingain*0)),$((neghbasslingain*0)),$((neghbasslingain*0)),$((neghbasslingain*0))\"/>|g" "$file"
		fi
	else
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mix-freqs .*|virtual-bass-mix-freqs frequency_low=\"289\" frequency_high=\"498\"/>|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-src-freqs .*|virtual-bass-src-freqs frequency_low=\"80\" frequency_high=\"150\"/>|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-subgains .*|virtual-bass-subgains harmonic_2=\"-48\" harmonic_3=\"-48\" harmonic_4=\"-48\"/>|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-blend-linear-gain .*|virtual-bass-blend-linear-gain value=\"$sbasslingain\"/>|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mix-frequency .*|virtual-bass-mix-frequency value=\"100,600\"/>|g" "$file"
		sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-compressor-tuning .*|virtual-bass-compressor-tuning value=\"1,$sbasscompstrength,-16,96,32,25,50\"/>|g" "$file"

		if [ "$sbasslingain" -gt "0" ]; then
			negsbasslingain=$((sbasslingain*-1))
		else
			negsbasslingain=$sbasslingain
		fi

		if [ "$sbassharmtype" -eq 0 ]; then
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$((negsbasslingain*0)),$((sbassharmboost*10)),$((sbassharmboost*10)),$((sbassharmboost*5))\"/>|g" "$file"
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$((negsbasslingain*0)),$((negsbasslingain*15)),$((negsbasslingain*15)),$((negsbasslingain*15)),$((negsbasslingain*15)),$((negsbasslingain*15))\"/>|g" "$file"
		elif [ "$sbassharmtype" -eq 1 ]; then
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$((negsbasslingain*0)),$((sbassharmboost*10)),$((sbassharmboost*15)),$((sbassharmboost*15))\"/>|g" "$file"
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$((negsbasslingain*0)),$((negsbasslingain*15)),$((negsbasslingain*15)),$((negsbasslingain*15)),$((negsbasslingain*15)),$((negsbasslingain*15))\"/>|g" "$file"
		elif [ "$sbassharmtype" -eq 2 ]; then
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$((negsbasslingain*0)),$((sbassharmboost*15)),$((sbassharmboost*20)),$((sbassharmboost*30))\"/>|g" "$file"
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$((negsbasslingain*0)),$((negsbasslingain*15)),$((negsbasslingain*15)),$((negsbasslingain*15)),$((negsbasslingain*15)),$((negsbasslingain*15))\"/>|g" "$file"
		elif [ "$sbassharmtype" -eq 3 ]; then
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$((negsbasslingain*0)),$((sbassharmboost*15)),$((sbassharmboost*20)),$((sbassharmboost*30))\"/>|g" "$file"
			sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$((negsbasslingain*0)),$((negsbasslingain*0)),$((negsbasslingain*0)),$((negsbasslingain*0)),$((negsbasslingain*0)),$((negsbasslingain*0))\"/>|g" "$file"
		fi
	fi
}

apply_ieq_settings() {
	local file="$1"
	local frequencies
	local freq
	local target_val
	local source_preset="balanced"
	local target_preset="custom"
	local all_targets
	local remaining_targets
	local block
	local new_block
	local insert_point_pattern
	local sed_script_file
	local working_preset

	echo " "
	echo " -- Checking IEQ settings -- "

	case "$HIEQ" in
	[Cc][Bb])
		target_preset="balanced"
		;;
	esac

	if ! grep -q "name=\"$target_preset\"" "$file" && ! grep -q "id=\"ieq_$target_preset\"" "$file"; then
		block=$(sed -n "/<preset.*name=\"$source_preset\".*>/,/<\/preset>/p" "$file")

		if [ -n "$block" ]; then
			insert_point_pattern="name=\"$source_preset\""
			new_block=$(echo "$block" | sed "s/name=\"$source_preset\"/name=\"$target_preset\"/; s/id=\"[0-9]*\"/id=\"4\"/")
		else
			block=$(sed -n "/<preset.*id=\"ieq_$source_preset\".*>/,/<\/preset>/p" "$file")

			if [ -n "$block" ]; then
				insert_point_pattern="id=\"ieq_$source_preset\""
				new_block=$(echo "$block" | sed "s/id=\"ieq_$source_preset\"/id=\"ieq_$target_preset\"/")
			else
				echo "Error: Source preset '$source_preset' not found! Cannot create custom preset."
				return 1
			fi
		fi

		echo "$new_block" > /tmp/ieq_new_preset.tmp
		sed -i "/<preset.*$insert_point_pattern.*>/,/<\/preset>/ {
			/<\/preset>/r /tmp/ieq_new_preset.tmp
		}" "$file"

		rm /tmp/ieq_new_preset.tmp
		echo " -- Custom preset created -- "
	fi

	working_preset="$target_preset"

	frequencies=$(sed -n "/<preset.*name=\"$working_preset\".*>/,/<\/preset>/ s/.*band_ieq frequency=\"\([0-9]*\)\".*/\1/p" "$file")
	if [ -z "$frequencies" ]; then
		frequencies=$(sed -n "/<preset.*id=\"ieq_$working_preset\".*>/,/<\/preset>/ s/.*band_ieq frequency=\"\([0-9]*\)\".*/\1/p" "$file")
	fi

	sed_script_file=$(mktemp "$TMPDIR/sed_ieq_commands.XXXXXX")

	if [ "$headphonetuning" = "true" ]; then
		case "$HIEQ" in
		[Cc]|[Cc][Bb])
			echo " -- Applying Headphones Custom IEQ to '$working_preset' -- "
			for freq in $frequencies; do
				eval "target_val=\$hiet_${freq}"
				echo "/<preset .*name=\"$working_preset\"/,/<\/preset>/ s|band_ieq frequency=\"$freq\" target=\"[^\"]*\"|band_ieq frequency=\"$freq\" target=\"$target_val\"|" >> "$sed_script_file"
				echo "/<preset .*id=\"ieq_$working_preset\"/,/<\/preset>/ s|band_ieq frequency=\"$freq\" target=\"[^\"]*\"|band_ieq frequency=\"$freq\" target=\"$target_val\"|" >> "$sed_script_file"
			done
			;;
		esac

		if [ "$samsung" = "true" ]; then
			case "$HIEQ" in
			[Dd]|[Ww])
				working_preset="balanced"
				echo " -- Applying Samsung IEQ to '$working_preset' -- "
				case "$HIEQ" in
				[Dd])
					all_targets="150 142 188 216 189 195 202 199 210 225 230 236 235 235 214 165 112 49 -24 -217";;
				[Ww])
					all_targets="114 146 183 169 170 128 103 90 98 126 127 140 96 85 80 66 38 -32 -132 -275";;
				esac

				remaining_targets="$all_targets"

				for freq in $frequencies; do
					target_val="${remaining_targets%% *}"
					if [ -z "$target_val" ]; then break; fi
					remaining_targets="${remaining_targets#* }"

					echo "/<preset .*name=\"$working_preset\"/,/<\/preset>/ s|band_ieq frequency=\"$freq\" target=\"[^\"]*\"|band_ieq frequency=\"$freq\" target=\"$target_val\"|" >> "$sed_script_file"
					echo "/<preset .*id=\"ieq_$working_preset\"/,/<\/preset>/ s|band_ieq frequency=\"$freq\" target=\"[^\"]*\"|band_ieq frequency=\"$freq\" target=\"$target_val\"|" >> "$sed_script_file"
				done
				;;
			esac
		fi
	fi

	if [ -s "$sed_script_file" ]; then
		sed -i -f "$sed_script_file" "$file"
	fi
	rm -f "$sed_script_file"
}

apply_volume_boosts() {
	local file="$1"
	local frequencies
	local freq
	local final_spk_gain
	local spk_hph_eq_val
	local hph_eq_val
	local final_hph_gain
	local hvolleft_gain
	local hvolright_gain
	local ep_type

	local sed_script_file
	sed_script_file=$(mktemp "$TMPDIR/sed_boosts_commands.XXXXXX")

	echo " "
	echo " -- Applying Digital Volume Gains and EQ -- "
	{
		if detect_feature "$file" 'id="default"'; then
			if [ "$speakertuning" = "true" ] && [ "$svolboost" -ne 0 ]; then
				echo "/<endpoint_type id=\"speaker\">/,/<\/endpoint_type>/ s|system-gain value=\"[^\"]*\"|system-gain value=\"$((svolboost))\"|g"
			fi
			if [ "$headphonetuning" = "true" ] && [ "$hvolboost" -ne 0 ]; then
				local final_gain=$((hvolboost + hvolbalance))
				echo "/<endpoint_type id=\"headphone\">/,/<\/endpoint_type>/ s|system-gain value=\"[^\"]*\"|system-gain value=\"$final_gain\"|g"
				echo "/<endpoint_type id=\"bluetooth\">/,/<\/endpoint_type>/ s|system-gain value=\"[^\"]*\"|system-gain value=\"$final_gain\"|g"
				echo "/<endpoint_type id=\"usb\">/,/<\/endpoint_type>/ s|system-gain value=\"[^\"]*\"|system-gain value=\"$final_gain\"|g"
				echo "/<endpoint_type id=\"default\">/,/<\/endpoint_type>/ s|system-gain value=\"[^\"]*\"|system-gain value=\"$final_gain\"|g"
			fi
		else
			if [ "$speakertuning" = "true" ]; then
				echo "/<tuning .*endpoint_type=\"speaker.*\"/,/<\/tuning>/ {"

				awk -F'"' '/<tuning .*endpoint_type="speaker.*"/, /<\/tuning>/ {
					if ($0 ~ "<band_optimizer .*frequency=") {
						f = ""; gl = ""; gr = "";
						for(i=1; i<=NF; i++) {
							if ($i ~ /frequency=$/) f = $(i+1)
							if ($i ~ /gain_left=$/) gl = $(i+1)
							if ($i ~ /gain_right=$/) gr = $(i+1)
						}
						if (f != "" && gl != "" && gr != "") {
							print f, gl, gr
						}
					}
				}' "$file" | while read -r freq gl gr; do
					eval "spk_hph_eq_val=\$seq_${freq}"
					[ -z "$spk_hph_eq_val" ] && spk_hph_eq_val=0
					
					final_spk_gain=$((svolboost + spk_hph_eq_val))

					if [ "$final_spk_gain" -ne 0 ]; then
						new_gl=$((gl + final_spk_gain))
						new_gr=$((gr + final_spk_gain))
						
						echo "s|frequency=\"$freq\" gain_left=\"$gl\" gain_right=\"$gr\"|frequency=\"$freq\" gain_left=\"$new_gl\" gain_right=\"$new_gr\"|g"
					fi
				done

				echo "}"
			fi

			if [ "$headphonetuning" = "true" ]; then
				frequencies=$(sed -E -n '/<tuning .*endpoint_type="headphone"/,/<\/tuning>/p' "$file" | sed -E -n 's/.*frequency="([0-9]*)".*/\1/p' | sort -nu)

				for ep_type in "headphone" "bluetooth"; do
					echo "/<tuning .*endpoint_type=\"$ep_type\"/,/<\/tuning>/ {"

					for freq in $frequencies; do
						eval "hph_eq_val=\$heq_${freq}"
						[ -z "$hph_eq_val" ] && hph_eq_val=0
						final_hph_gain=$((hvolboost + hph_eq_val))

						if [ "$hvolbalance" -gt 0 ]; then
							hvolleft_gain=$(( -1 * hvolbalance ))
							hvolright_gain=0
						elif [ "$hvolbalance" -lt 0 ]; then
							hvolleft_gain=0
							hvolright_gain=$(( 1 * hvolbalance ))
						else
							hvolleft_gain=0
							hvolright_gain=0
						fi

						echo "s|frequency=\"$freq\" gain_left=\"[^\"]*\" gain_right=\"[^\"]*\"|frequency=\"$freq\" gain_left=\"$((final_hph_gain + hvolleft_gain))\" gain_right=\"$((final_hph_gain + hvolright_gain))\"|g"
					done
					echo "}"
				done
			fi
		fi
	} >> "$sed_script_file"

	if [ -s "$sed_script_file" ]; then
		sed -E -i -f "$sed_script_file" "$file"
		echo " -- Volume boosts applied successfully -- "
	fi

	rm -f "$sed_script_file"
}

apply_custom_frequencies() {
	local file="$1"
	local temp_file="${file}.tmp"
	local target_list="47 141 234 328 469 656 844 1031 1313 1688 2250 3000 3750 4688 5813 7125 9000 11250 13875 19688"

	awk -v targets="$target_list" '
	BEGIN {
		count = split(targets, freqs, " ")
		current_idx = 1
	}

	/<ieq-bands/ || /<graphic-equalizer-bands/ || /<audio-optimizer-bands/ || /<regulator-tuning/ {
		current_idx = 1
	}

	/<band_/ && /frequency="[0-9]+"/ {
		if (current_idx <= count) {
			sub(/frequency="[0-9]+"/, "frequency=\"" freqs[current_idx] "\"")
			current_idx++
		}
	}

	{ print $0 }
	' "$file" > "$temp_file"

	if [ -s "$temp_file" ]; then
		mv "$temp_file" "$file"
		echo " -- Custom frequencies applied successfully -- "
	else
		echo " -- Error: Temp file empty, changes aborted -- "
		rm -f "$temp_file"
	fi
}
