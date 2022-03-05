/datum/game_mode/extended/faction_clash
	name = "Faction Clash"
	config_tag = "Faction Clash"
	flags_round_type = MODE_THUNDERSTORM|MODE_FACTION_CLASH
	toggleable_flags = MODE_NO_SNIPER_SENTRY|MODE_NO_ATTACK_DEAD|MODE_NO_STRIPDRAG_ENEMY|MODE_STRONG_DEFIBS

/datum/game_mode/extended/faction_clash/get_roles_list()
	return ROLES_FACTION_CLASH

GLOBAL_LIST_EMPTY(thunder_setup_areas)

/datum/game_mode/extended/faction_clash/pre_setup()
	for(var/area/A as anything in GLOB.thunder_setup_areas)
		A.add_thunder()
	return ..()
