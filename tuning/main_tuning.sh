#!/bin/sh

. $MODPATH/tuning/config_loader.sh
. $MODPATH/tuning/xml_edit.sh

initialize_all_variables
	
	detect_config "$i"
    apply_global_media_intelligence_settings "$i"
    apply_tuning_settings "$i"
    apply_all_profiles "$i"
    apply_ieq_settings "$i"
    apply_volume_boosts "$i"