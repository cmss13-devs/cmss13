/datum/config_entry/keyed_list/probability
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/probability/ValidateListEntry(key_name)
	return key_name in config.modes

/datum/config_entry/keyed_list/max_pop
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/max_pop/ValidateListEntry(key_name)
	return key_name in config.modes

/datum/config_entry/keyed_list/min_pop
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/min_pop/ValidateListEntry(key_name, key_value)
	return key_name in config.modes


/datum/config_entry/flag/emojis

/datum/config_entry/string/alert_delta
	config_entry_value = "Destruction of the station is imminent. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."

/datum/config_entry/number/revival_brain_life
	config_entry_value = -1
	integer = FALSE
	min_val = -1

/datum/config_entry/number/movedelay //Used for modifying movement speed for mobs.
	abstract_type = /datum/config_entry/number/movedelay

/datum/config_entry/number/movedelay/run_delay
	config_entry_value = 0
	integer = FALSE

/datum/config_entry/number/movedelay/walk_delay
	config_entry_value = 0
	integer = FALSE

/datum/config_entry/number/organ_health_multiplier
	config_entry_value = 1

/datum/config_entry/number/organ_regeneration_multiplier
	config_entry_value = 0.75

/datum/config_entry/flag/limbs_can_break
	config_entry_value = TRUE

/datum/config_entry/number/revive_grace_period
	config_entry_value = 3000
	min_val = 0

/datum/config_entry/flag/bones_can_break
	config_entry_value = TRUE

/datum/config_entry/flag/allow_synthetic_gun_use

/datum/config_entry/flag/remove_gun_restrictions

/datum/config_entry/flag/jobs_have_minimal_access

/datum/config_entry/number/minimal_access_threshold //If the number of players is larger than this threshold, minimal access will be turned on.
	config_entry_value = 10
	min_val = 0

/datum/config_entry/flag/humans_need_surnames

/datum/config_entry/flag/allow_ai

/datum/config_entry/flag/allow_ai_multicam // allow ai multicamera mode

/datum/config_entry/flag/fun_allowed //a lot of LRP features

/datum/config_entry/number/min_xenos
	config_entry_value = 5
	min_val = 1

/datum/config_entry/number/crash_larvapoints_required
	config_entry_value = 9
	min_val = 1

/datum/config_entry/number/distress_larvapoints_required
	config_entry_value = 8
	min_val = 1

/datum/config_entry/keyed_list/lobby_music
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_TEXT

/datum/config_entry/flag/distress_ert_allowed
	config_entry_value = TRUE

/datum/config_entry/flag/events_disallowed
	config_entry_value = FALSE

/datum/config_entry/flag/aggressive_changelog

/datum/config_entry/flag/continous_rounds

/datum/config_entry/flag/ert_admin_call_only

/datum/config_entry/flag/use_loyalty_implants

/datum/config_entry/number/explosive_antigrief
	min_val = ANTIGRIEF_DISABLED
	max_val = ANTIGRIEF_ENABLED
	config_entry_value = ANTIGRIEF_NEW_PLAYERS

/// Relative inclusion path for nightmare configuration files
/datum/config_entry/string/nightmare_path
	config_entry_value = "maps/Nightmare/"

/datum/config_entry/flag/events_disallowed
	config_entry_value = FALSE


///Used to determine how many extra larva you want per burst. Supports fractions. See /datum/hive_status/proc/increase_larva_after_burst()
/datum/config_entry/number/extra_larva_per_burst
	config_entry_value = 0
	integer = FALSE

///Used to determine how many extra larva you want per burst if nested. Supports fractions. See /datum/hive_status/proc/increase_larva_after_burst()
/datum/config_entry/number/extra_larva_per_nested_burst
	config_entry_value = 1
	integer = FALSE

/datum/config_entry/number/embryo_burst_timer
	min_val = 1
	config_entry_value = 450
	integer = TRUE

/datum/config_entry/number/whiskey_required_players
	min_val = 0
	config_entry_value = 140
	integer = TRUE

/datum/config_entry/number/nuclear_lock_marines_percentage
	min_val = 0
	config_entry_value = 0	// Type 0 to disable lock
	max_val = 100
	integer = TRUE
