/datum/game_mode/extended/faction_clash
	name = "Faction Clash"
	config_tag = "Faction Clash"
	flags_round_type = MODE_THUNDERSTORM|MODE_FACTION_CLASH
	toggleable_flags = MODE_NO_SNIPER_SENTRY|MODE_NO_ATTACK_DEAD|MODE_NO_STRIPDRAG_ENEMY|MODE_STRONG_DEFIBS|MODE_BLOOD_OPTIMIZATION|MODE_NO_COMBAT_CAS
	taskbar_icon = 'icons/taskbar/gml_hvh.png'

/datum/game_mode/extended/faction_clash/get_roles_list()
	return GLOB.ROLES_FACTION_CLASH

/datum/game_mode/extended/faction_clash/post_setup()
	. = ..()
	SSweather.force_weather_holder(/datum/weather_ss_map_holder/faction_clash)
