/datum/game_mode/extended/faction_clash
	name = "Faction Clash"
	config_tag = "Faction Clash"
	flags_round_type = MODE_THUNDERSTORM

GLOBAL_LIST_EMPTY(thunder_setup_areas)

/datum/game_mode/extended/faction_clash/pre_setup()
	for(var/area/A as anything in GLOB.thunder_setup_areas)
		A.add_thunder()
	return ..()
