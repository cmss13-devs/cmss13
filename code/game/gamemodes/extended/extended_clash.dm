/datum/game_mode/extended/faction_clash
	name = "Faction Clash"
	config_tag = "Faction Clash"
	flags_round_type = MODE_THUNDERSTORM|MODE_FACTION_CLASH
	starting_round_modifiers = list(/datum/gamemode_modifier/blood_optimization, /datum/gamemode_modifier/defib_past_armor, /datum/gamemode_modifier/disable_combat_cas, /datum/gamemode_modifier/disable_ib, /datum/gamemode_modifier/disable_attacking_corpses, /datum/gamemode_modifier/disable_long_range_sentry, /datum/gamemode_modifier/disable_stripdrag_enemy, /datum/gamemode_modifier/indestructible_splints, /datum/gamemode_modifier/mortar_laser_warning, /datum/gamemode_modifier/no_body_c4)

/datum/game_mode/extended/faction_clash/get_roles_list()
	return GLOB.ROLES_FACTION_CLASH

/datum/game_mode/extended/faction_clash/post_setup()
	. = ..()
	SSweather.force_weather_holder(/datum/weather_ss_map_holder/faction_clash)
