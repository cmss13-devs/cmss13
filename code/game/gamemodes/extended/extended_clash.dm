/datum/game_mode/extended/faction_clash
	name = "Faction Clash"
	config_tag = "Faction Clash"
	flags_round_type = MODE_THUNDERSTORM|MODE_FACTION_CLASH
	toggleable_flags = MODE_NO_SNIPER_SENTRY|MODE_NO_ATTACK_DEAD|MODE_NO_STRIPDRAG_ENEMY|MODE_STRONG_DEFIBS|MODE_BLOOD_OPTIMIZATION|MODE_NO_COMBAT_CAS
	taskbar_icon = 'icons/taskbar/gml_hvh.png'

/datum/game_mode/extended/faction_clash/get_roles_list()
	return ROLES_FACTION_CLASH

GLOBAL_LIST_EMPTY(thunder_setup_areas)
GLOBAL_VAR(weather_rain_effect)

/datum/game_mode/extended/faction_clash/pre_setup()
	GLOB.weather_rain_effect = new /obj/effect/weather_vfx_holder/rain()
	for(var/area/A as anything in GLOB.thunder_setup_areas)
		A.add_thunder()
	return ..()
