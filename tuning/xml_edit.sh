#!/bin/sh
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
	else
		echo " -- Standard config detected - Proceed -- "
	fi
}

set_headphone_profile_value() {
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$3\">/,/<\/endpoint_type>/ s|${10} value=\"[^\"]*\"|${10} value=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$4\">/,/<\/endpoint_type>/ s|${10} value=\"[^\"]*\"|${10} value=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$5\">/,/<\/endpoint_type>/ s|${10} value=\"[^\"]*\"|${10} value=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$6\">/,/<\/endpoint_type>/ s|${10} value=\"[^\"]*\"|${10} value=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$7\">/,/<\/endpoint_type>/ s|${10} value=\"[^\"]*\"|${10} value=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$8\">/,/<\/endpoint_type>/ s|${10} value=\"[^\"]*\"|${10} value=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$9\">/,/<\/endpoint_type>/ s|${10} value=\"[^\"]*\"|${10} value=\"${11}\"|g; }" "$1"
}
set_headphone_profile_no_value() {
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$3\">/,/<\/endpoint_type>/ s|${10}=\"[^\"]*\"|${10}=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$4\">/,/<\/endpoint_type>/ s|${10}=\"[^\"]*\"|${10}=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$5\">/,/<\/endpoint_type>/ s|${10}=\"[^\"]*\"|${10}=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$6\">/,/<\/endpoint_type>/ s|${10}=\"[^\"]*\"|${10}=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$7\">/,/<\/endpoint_type>/ s|${10}=\"[^\"]*\"|${10}=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$8\">/,/<\/endpoint_type>/ s|${10}=\"[^\"]*\"|${10}=\"${11}\"|g; }" "$1"
    sed -E -i "/name=\"$2\"/,/<\/profile>/ { /<endpoint_type id=\"$9\">/,/<\/endpoint_type>/ s|${10}=\"[^\"]*\"|${10}=\"${11}\"|g; }" "$1"
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
    echo " "
    echo " -- Applying endpoint tuning settings -- "
    if [ "$headphonetuning" = "true" ]; then
        set_tuning_value "$file" "headphone" "volume-leveler-compressor-enable" "true"
        set_tuning_value "$file" "headphone" "bass-mbdrc-enable" "false"
        set_tuning_value "$file" "headphone" "bass-extraction-enable" "true"
        set_tuning_value "$file" "headphone" "bass-extraction-cutoff-frequency" "200"
        set_tuning_value "$file" "headphone" "regulator-speaker-dist-enable" "true"
        set_tuning_value "$file" "headphone" "regulator-sibilance-suppress-enable" "false"
        set_tuning_value "$file" "headphone" "regulator-stress-amount" "0,0,0,0"
        set_tuning_value "$file" "headphone" "regulator-distortion-slope" "32"
        set_tuning_value "$file" "headphone" "audio-optimizer-enable" "true"
        set_tuning_value "$file" "headphone" "height-filter-mode" "$hheightfilter"
        set_tuning_value "$file" "headphone" "regulator-enable" "$hregulator"
        set_tuning_value "$file" "headphone" "regulator-overdrive" "$hregoverdrive"
        set_tuning_value "$file" "headphone" "regulator-timbre-preservation" "$htimbre"
		
        set_tuning_rate_channels_matrix "$file" "headphone" "tuned_rate" "$htunedrate"
        set_tuning_rate_channels_matrix "$file" "headphone" "output_channels" "$h_output_channels"
		
        if [ "$hrenderbass" = "BE" ]; then
            set_tuning_value "$file" "headphone" "bass-enhancer-enable" "true"
            set_tuning_value "$file" "headphone" "bass-enhancer-boost" "$hbassboost"
            set_tuning_value "$file" "headphone" "bass-enhancer-cutoff-frequency" "$hbasscutoff"
            set_tuning_value "$file" "headphone" "bass-enhancer-width" "$hbasswidth"
        else
            set_tuning_value "$file" "headphone" "bass-enhancer-enable" "false"
            if detect_feature "$file" "virtual-bass-harmgains"; then
                apply_virtual_bass "h" "$file"
            fi
        fi
    echo " -- Applying custom Mix Matrix -- "
		sed -E -i '/tuning/,/<\/tuning>/ {
    s|<mix_matrix/>|<mix_matrix>\n          <element value="0,16,14336,4096,4096,14336,12288,12288,8192,8192,16384,0,0,16384,8192,2048,2048,8192"/>\n          <element value="1,16,14336,4096,4096,14336,12288,12288,8192,8192,16384,0,0,16384,8192,2048,2048,8192"/>\n          <element value="3,16,14336,4096,4096,14336,12288,12288,8192,8192,16384,0,0,16384,8192,2048,2048,8192"/>\n          <element value="5,16,14336,4096,4096,14336,12288,12288,8192,8192,16384,0,0,16384,8192,2048,2048,8192"/>\n          <element value="10,16,14336,4096,4096,14336,12288,12288,8192,8192,16384,0,0,16384,8192,2048,2048,8192"/>\n          <element value="11,16,14336,4096,4096,14336,12288,12288,8192,8192,16384,0,0,16384,8192,2048,2048,8192"/>\n          <element value="6,16,14336,4096,4096,14336,12288,12288,8192,8192,16384,0,0,16384,8192,2048,2048,8192"/>\n        </mix_matrix>|
}' "$file"
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

        if [ "$srenderbass" = "BE" ]; then
            set_speaker_profile_value "$file" "speaker" "bass-enhancer-enable" "true"
            set_speaker_profile_value "$file" "speaker" "bass-enhancer-boost" "$sbassboost"
        else
            set_speaker_profile_value "$file" "speaker" "bass-enhancer-enable" "false"
            if detect_feature "$file" "virtual-bass-harmgains"; then
                apply_virtual_bass "s" "$file"
            fi
        fi
    fi
}

apply_all_profiles() {
    local file="$1"
    echo " "
    echo " -- Applying profile settings -- "

    #feature check
    local headphone_vbass_available=false
    local headphone_adv_virt_available=false
    local headphone_virt_dist_available=false
    local headphone_virt_lr_angle_available=false
		
    if [ "$headphonetuning" = "true" ]; then
        detect_feature "$file" "virtual-bass-process-enable" && headphone_vbass_available=true
        detect_feature "$file" "advanced-headphone-virtualizer-rendering-config" && headphone_adv_virt_available=true
        detect_feature "$file" "headphone-virtualizer-steerer-source-distance" && headphone_virt_dist_available=true
        detect_feature "$file" "advanced-headphone-virtualizer-lr-angle" && headphone_virt_lr_angle_available=true
    fi

    local speaker_vbass_available=false
    local speaker_adv_virt_available=false
    if [ "$speakertuning" = "true" ]; then
        detect_feature "$file" "virtual-bass-process-enable" && speaker_vbass_available=true
        detect_feature "$file" "advanced-speaker-virtualizer-rendering-config" && speaker_adv_virt_available=true
    fi

    #text display tracking (to force display text only once)
    local headphone_vbass_message_displayed=false
    local headphone_adv_virt_message_displayed=false
    local headphone_virt_dist_message_displayed=false
    local headphone_virt_lr_angle_message_displayed=false
    local speaker_vbass_message_displayed=false
    local speaker_adv_virt_message_displayed=false

    for profile in "Dynamic" "Movie" "Music" "Custom"; do
        if ! grep -q "name=\"$profile\"" "$file"; then continue; fi

        if [ "$headphonetuning" = "true" ]; then
            local hdialog_setting="$hdialog2"; local hvirtualizer_setting="$hvirtualizer2"
            [ "$profile" = "Movie" ] && { hdialog_setting="$hdialog1"; hvirtualizer_setting="$hvirtualizer1"; }
            
            if [ "$hrenderbass" = "VB" ] && [ "$headphone_vbass_available" = "true" ]; then
                set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "virtual-bass-process-enable" "true"
                set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "bass-enhancer-enable" "false"
            else
                if [ "$headphone_vbass_message_displayed" = "false" ]; then
                    echo " -- Virtual Bass for headphones is not available - using Bass Enhancer instead -- "
                    headphone_vbass_message_displayed=true
                fi
                set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "virtual-bass-process-enable" "false"
                set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "bass-enhancer-enable" "true"
            fi

            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "ieq-enable" "$hieq3"
            set_headphone_profile_no_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "include ieq_preset" "$hieq1"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "ieq-amount" "$hieqamount"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "dialog-enhancer-enable" "$hdialog_setting"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "dialog-enhancer-amount" "$hdeamount"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "dialog-enhancer-ducking" "$hdeducking"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "virtualizer-enable" "$hvirtualizer_setting"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "surround-boost" "$hsurboost"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "volmax-boost" "$hlevstr"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "volume-leveler-enable" "$hleveler"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "volume-leveler-amount" "$hlevamount"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "volume-leveler-in-target" "-$hlevtargetin"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "volume-leveler-out-target" "-$hlevtargetout"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "peak-value" "256"
            set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "hearing-protection-enable" "false"
			
            if [ "$headphone_adv_virt_available" = "true" ]; then
                set_profile_global_value "$file" "$profile" "advanced-headphone-virtualizer-rendering-config" "$hadvirtrend"
                set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "advanced-headphone-virtualizer-rendering-config" "$hadvirtrend"
                set_tuning_value "$file" "headphone" "advanced-headphone-virtualizer-rendering-config" "$hadvirtrend"
            elif [ "$headphone_adv_virt_message_displayed" = "false" ]; then
                echo " -- advanced virtualizer renderer not found - variable will be ignored -- "
                headphone_adv_virt_message_displayed=true
            fi
            if [ "$headphone_virt_dist_available" = "true" ]; then
                set_profile_global_value "$file" "$profile" "headphone-virtualizer-steerer-source-distance" "$hvirtdist"
                set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "headphone-virtualizer-steerer-source-distance" "$hvirtdist"
                set_tuning_value "$file" "headphone" "headphone-virtualizer-steerer-source-distance" "$hvirtdist"
            elif [ "$headphone_virt_dist_message_displayed" = "false" ]; then
                echo " -- virtualizer source distance not found - variable will be ignored -- "
                headphone_virt_dist_message_displayed=true
            fi
            if [ "$headphone_virt_lr_angle_available" = "true" ]; then
                set_profile_global_value "$file" "$profile" "advanced-headphone-virtualizer-lr-angle" "$hadvirtangle"
                set_headphone_profile_value "$file" "$profile" "headphone" "bluetooth" "other" "usb" "remote_submix" "digital_aux" "default" "advanced-headphone-virtualizer-lr-angle" "$hadvirtangle"
                set_tuning_value "$file" "headphone" "advanced-headphone-virtualizer-lr-angle" "$hadvirtangle"
            elif [ "$headphone_virt_lr_angle_message_displayed" = "false" ]; then
                echo " -- virtualizer left-right angle not found - variable will be ignored -- "
                headphone_virt_lr_angle_message_displayed=true
            fi
        fi

        if [ "$speakertuning" = "true" ]; then
            local sdialog_setting="$sdialog2"; local svirtualizer_setting="$svirtualizer2"
            [ "$profile" = "Movie" ] && { sdialog_setting="$sdialog1"; svirtualizer_setting="$svirtualizer1"; }

            if [ "$srenderbass" = "VB" ] && [ "$speaker_vbass_available" = "true" ]; then
                set_speaker_profile_value "$file" "$profile" "speaker" "virtual-bass-process-enable" "true"
                set_speaker_profile_value "$file" "$profile" "speaker" "bass-enhancer-enable" "false"
            else
                if [ "$speaker_vbass_message_displayed" = "false" ]; then
                    echo " -- Virtual Bass for speaker is not available - using Bass Enhancer instead -- "
                    speaker_vbass_message_displayed=true
                fi
                set_speaker_profile_value "$file" "$profile" "speaker" "virtual-bass-process-enable" "false"
                set_speaker_profile_value "$file" "$profile" "speaker" "bass-enhancer-enable" "true"
            fi

            set_speaker_profile_value "$file" "$profile" "speaker" "ieq-enable" "$sieq3"
            set_speaker_profile_no_value "$file" "$profile" "speaker" "include ieq_preset" "$sieq1"
            set_speaker_profile_value "$file" "$profile" "speaker" "ieq-amount" "$sieqamount"
            set_speaker_profile_value "$file" "$profile" "speaker" "dialog-enhancer-enable" "$sdialog_setting"
            set_speaker_profile_value "$file" "$profile" "speaker" "dialog-enhancer-amount" "$sdeamount"
            set_speaker_profile_value "$file" "$profile" "speaker" "dialog-enhancer-ducking" "$sdeducking"
            set_speaker_profile_value "$file" "$profile" "speaker" "virtualizer-enable" "$svirtualizer_setting"
            set_speaker_profile_value "$file" "$profile" "speaker" "surround-boost" "$ssurboost"
            set_speaker_profile_value "$file" "$profile" "speaker" "volmax-boost" "$slevstr"
            set_speaker_profile_value "$file" "$profile" "speaker" "volume-leveler-enable" "$sleveler"
            set_speaker_profile_value "$file" "$profile" "speaker" "volume-leveler-amount" "$slevamount"
            set_speaker_profile_value "$file" "$profile" "speaker" "volume-leveler-in-target" "-$slevtargetin"
            set_speaker_profile_value "$file" "$profile" "speaker" "volume-leveler-out-target" "-$slevtargetout"
            set_speaker_profile_value "$file" "$profile" "speaker" "peak-value" "256"
            set_speaker_profile_value "$file" "$profile" "speaker" "hearing-protection-enable" "false"

            if [ "$speaker_adv_virt_available" = "true" ]; then
                set_profile_global_value "$file" "$profile" "advanced-speaker-virtualizer-rendering-config" "$sadvirtrend"
                set_speaker_profile_value "$file" "$profile" "speaker" "advanced-speaker-virtualizer-rendering-config" "$sadvirtrend"
                set_tuning_value "$file" "speaker" "advanced-speaker-virtualizer-rendering-config" "$sadvirtrend"
            elif [ "$speaker_adv_virt_message_displayed" = "false" ]; then
                echo " -- advanced speaker virtualizer renderer not found - variable will be ignored -- "
                speaker_adv_virt_message_displayed=true
            fi
        fi
    done
}

apply_virtual_bass() {
    local prefix="$1"; local file="$2"
    local endpoint; [ "$prefix" = "h" ] && endpoint="headphone" || endpoint="speaker"
    echo " -- Applying Virtual Bass for endpoint: $endpoint -- "
    
    sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mode value=\"[^\"]*\"|virtual-bass-mode value=\"3\"|g" "$file"
    sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-overall-gain value=\"[^\"]*\"|virtual-bass-overall-gain value=\"0\"|g" "$file"
    sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-slope-gain value=\"[^\"]*\"|virtual-bass-slope-gain value=\"0\"|g" "$file"
    sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-rolloff-gain value=\"[^\"]*\"|virtual-bass-rolloff-gain value=\"0\"|g" "$file"

    if [ "$prefix" = "h" ]; then
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mix-freqs frequency_low=\"[^\"]*\" frequency_high=\"[^\"]*\"|virtual-bass-mix-freqs frequency_low=\"$hbassharmmixfreqmin\" frequency_high=\"$hbassharmmixfreqmax\"|g" "$file"
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-src-freqs frequency_low=\"[^\"]*\" frequency_high=\"[^\"]*\"|virtual-bass-src-freqs frequency_low=\"$hbassharmsrcfreqmin\" frequency_high=\"$hbassharmsrcfreqmax\"|g" "$file"
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-blend-linear-gain value=\"[^\"]*\"|virtual-bass-blend-linear-gain value=\"$hbasslingain\"|g" "$file"
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mix-frequency value=\"[^\"]*\"|virtual-bass-mix-frequency value=\"$hbassharmmixfreqmin,$hbassharmmixfreqmax\"|g" "$file"
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-compressor-tuning value=\"[^\"]*\"|virtual-bass-compressor-tuning value=\"1,96,-96,96,32,50,90\"|g" "$file"
        if [ "$hbassharmtype" = "1" ]; then
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-subgains .*|virtual-bass-subgains harmonic_2=\"-480\" harmonic_3=\"-480\" harmonic_4=\"-480\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"0,-2048,-2048,-2048\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$(($hbassharmboost*8)),-2048,-2048,-2048,-2048,-2048\"/>|g" "$file"
        elif [ "$hbassharmtype" = "2" ]; then
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-subgains .*|virtual-bass-subgains harmonic_2=\"-16\" harmonic_3=\"-48\" harmonic_4=\"-96\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$(($hbassharmboost*0)),$(($hbassharmboost*0)),$(($hbassharmboost*0)),$(($hbassharmboost*0))\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$(($hbassharmboost*10)),$(($hbassharmboost*12)),$(($hbassharmboost*8)),$(($hbassharmboost*8)),$(($hbassharmboost*8)),$(($hbassharmboost*8))\"/>|g" "$file"
        elif [ "$hbassharmtype" = "3" ]; then
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-subgains .*|virtual-bass-subgains harmonic_2=\"192\" harmonic_3=\"192\" harmonic_4=\"128\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"-$(($hbassharmboost*6)),$(($hbassharmboost*0)),$(($hbassharmboost*0)),$(($hbassharmboost*0))\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$(($hbassharmboost*18)),$(($hbassharmboost*15)),$(($hbassharmboost*20)),$(($hbassharmboost*20)),$(($hbassharmboost*22)),$(($hbassharmboost*22))\"/>|g" "$file"
        fi
    else
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mix-freqs .*|virtual-bass-mix-freqs frequency_low=\"289\" frequency_high=\"498\"/>|g" "$file"
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-src-freqs .*|virtual-bass-src-freqs frequency_low=\"80\" frequency_high=\"150\"/>|g" "$file"
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-blend-linear-gain .*|virtual-bass-blend-linear-gain value=\"$sbasslingain\"/>|g" "$file"
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-mix-frequency .*|virtual-bass-mix-frequency value=\"100,600\"/>|g" "$file"
        sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-compressor-tuning .*|virtual-bass-compressor-tuning value=\"0,0,-16,96,32,25,50\"/>|g" "$file"
        if [ "$sbassharmtype" = "1" ]; then
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-subgains .*|virtual-bass-subgains harmonic_2=\"-480\" harmonic_3=\"-480\" harmonic_4=\"-480\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$(($sbassharmboost*8)),-2048,-2048,-2048\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$(($sbassharmboost*0)),-2048,-2048,-2048,-2048,-2048\"/>|g" "$file"
        elif [ "$sbassharmtype" = "2" ]; then
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-subgains .*|virtual-bass-subgains harmonic_2=\"-16\" harmonic_3=\"-48\" harmonic_4=\"-96\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"$(($hbassharmboost*0)),$(($hbassharmboost*0)),$(($hbassharmboost*0)),$(($hbassharmboost*0))\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$(($hbassharmboost*10)),$(($hbassharmboost*12)),$(($hbassharmboost*8)),$(($hbassharmboost*8)),$(($hbassharmboost*8)),$(($hbassharmboost*8))\"/>|g" "$file"
        elif [ "$sbassharmtype" = "3" ]; then
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-subgains .*|virtual-bass-subgains harmonic_2=\"192\" harmonic_3=\"192\" harmonic_4=\"128\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-harmgains .*|virtual-bass-harmgains value=\"-$(($hbassharmboost*6)),$(($hbassharmboost*0)),$(($hbassharmboost*0)),$(($hbassharmboost*0))\"/>|g" "$file"
            sed -E -i "/endpoint_type=\"$endpoint\"/,/<\/tuning>/s|virtual-bass-hybgains .*|virtual-bass-hybgains value=\"$(($hbassharmboost*18)),$(($hbassharmboost*15)),$(($hbassharmboost*20)),$(($hbassharmboost*20)),$(($hbassharmboost*22)),$(($hbassharmboost*22))\"/>|g" "$file"
        fi
    fi
}

apply_ieq_settings() {
    local file="$1"
    echo " "
    echo " -- Applying IEQ settings -- "
    if [ "$headphonetuning" = "true" ]; then
        if [ "$HIEQ" = "C" ] || [ "$HIEQ" = "c" ]; then
            echo " -- Applying Headphones Custom IEQ -- "
            local frequencies="47 141 234 328 469 656 844 1031 1313 1688 2250 3000 3750 4688 5813 7125 9000 11250 13875 19688"
            for freq in $frequencies; do
                eval "local target_val=\$hiet_${freq}"
                sed -E -i "/<preset .*name=\"balanced\"/,/<\/preset>/ s|band_ieq frequency=\"$freq\" target=\"[^\"]*\"|band_ieq frequency=\"$freq\" target=\"$target_val\"|" "$file"
            done
        fi
    fi
}

apply_volume_boosts() {
    local file="$1"
    echo " "
    echo " -- Applying Digital Volume Gains and EQ -- "
    echo " "
	#Samsung check (some different vars) 
    if detect_feature "$file" 'id="default"'; then
        if [ "$speakertuning" = "true" ] && [ "$svolboost" -ne 0 ]; then
            local spksysgain=$(sed -E -n '/<endpoint_type id="speaker">/,/<\/endpoint_type>/p' "$file" | grep 'system-gain' | awk -F'"' '{print $2}')
            if [ -n "$spksysgain" ]; then
                sed -E -i '/<endpoint_type id="speaker">/,/<\/endpoint_type>/s|system-gain value=\"'$spksysgain'\"|system-gain value=\"'$(($spksysgain + $svolboost))'\"|g' "$file"
            fi
        fi
        if [ "$headphonetuning" = "true" ] && [ "$hvolboost" -ne 0 ]; then
            local hphsysgain=$(sed -E -n '/<endpoint_type id="headphone">/,/<\/endpoint_type>/p' "$file" | grep 'system-gain' | awk -F'"' '{print $2}')
            if [ -n "$hphsysgain" ]; then
                for endpoint in "headphone" "bluetooth" "usb" "default"; do
                     sed -E -i '/<endpoint_type id="'$endpoint'">/,/<\/endpoint_type>/s|system-gain value=\"'$hphsysgain'\"|system-gain value=\"'$(($hphsysgain + $hvolboost))'\"|g' "$file"
                done
            fi
        fi
    else
        if [ "$speakertuning" = "true" ] && [ "$svolboost" -ne 0 ]; then
			if [ "$svolboost" -gt 0 ]; then
				local gleft=$(sed -E -n '/endpoint_type="speaker"/,/<\/tuning>/p' "$file" | grep 'gain_left' | awk -F'"' '{print $4}' | sort -nru)
				local gright=$(sed -E -n '/endpoint_type="speaker"/,/<\/tuning>/p' "$file" | grep 'gain_right' | awk -F'"' '{print $6}' | sort -nru)
			else
				local gleft=$(sed -E -n '/endpoint_type="speaker"/,/<\/tuning>/p' "$file" | grep 'gain_left' | awk -F'"' '{print $4}' | sort -nu)
				local gright=$(sed -E -n '/endpoint_type="speaker"/,/<\/tuning>/p' "$file" | grep 'gain_right' | awk -F'"' '{print $6}' | sort -nu)
			fi
							
			for sgleft in ${gleft};do
			sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/gain_left="'"$sgleft"'"/gain_left="'"$(($sgleft+$svolboost))"'"/g' "$file"
			done
			
			for sgright in ${gright};do
			sed -E -i '/endpoint_type="speaker"/,/<\/tuning>/s/gain_right="'"$sgright"'"/gain_right="'"$(($sgright+$svolboost))"'"/g' "$file"
			done	

        fi
        if [ "$headphonetuning" = "true" ]; then
            local frequencies="47 141 234 328 469 656 844 1031 1313 1688 2250 3000 3750 4688 5813 7125 9000 11250 13875 19688"
            for freq in $frequencies; do
                eval "local eq_val=\$heq_${freq}"
                local final_gain=$(($hvolboost + $eq_val))
                if [ "$hrenderbass" = "BE" ]; then
                    if [ "$freq" = "47" ]; then final_gain=$(($final_gain + ($hbassboost / 4))); fi
                    if [ "$freq" = "141" ]; then final_gain=$(($final_gain + ($hbassboost / 8))); fi
                fi
                for endpoint in "headphone" "bluetooth"; do
                    sed -E -i "/<tuning .*endpoint_type=\"$endpoint\"/,/<\/tuning>/s|frequency=\"$freq\" gain_left=\"[^\"]*\" gain_right=\"[^\"]*\"|frequency=\"$freq\" gain_left=\"$final_gain\" gain_right=\"$final_gain\"|g" "$file"
                done
            done
        fi
    fi
}
