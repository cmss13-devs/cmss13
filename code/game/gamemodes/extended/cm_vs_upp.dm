/datum/game_mode/extended/faction_clash/cm_vs_upp
	name = "Faction Clash UPP CM"
	config_tag = "Faction Clash UPP CM"
	flags_round_type = MODE_THUNDERSTORM|MODE_FACTION_CLASH
	toggleable_flags = MODE_NO_SNIPER_SENTRY|MODE_NO_ATTACK_DEAD|MODE_NO_STRIPDRAG_ENEMY|MODE_STRONG_DEFIBS|MODE_BLOOD_OPTIMIZATION|MODE_NO_COMBAT_CAS|MODE_INDESTRUCTIBLE_SPLINTS|MODE_NO_INTERNAL_BLEEDING|MODE_MORTAR_LASER_WARNING
	taskbar_icon = 'icons/taskbar/gml_hvh.png'

/datum/game_mode/extended/faction_clash/cm_vs_upp/get_roles_list()
	return GLOB.ROLES_CM_VS_UPP

/datum/game_mode/extended/faction_clash/cm_vs_upp/post_setup()
	. = ..()
	SSweather.force_weather_holder(/datum/weather_ss_map_holder/faction_clash)
	for(var/area/area in GLOB.all_areas)
		area.base_lighting_alpha = 150
		area.update_base_lighting()

/datum/game_mode/extended/faction_clash/cm_vs_upp/announce()
	.=..()
	marine_announcement("An automated distress call has been received from the local colony.\n\nAlert! Sensors have detected a Union of Progressive People's warship in orbit of colony. Enemy Vessel has refused automated hails and is entering lower-planetary orbit. High likelihood enemy vessel is preparing to deploy dropships to local colony. Authorization to interdict and repel hostile force from allied territory has been granted. Automated thawing of cryostasis marine reserves in progress.", "ARES 3.2", 'sound/AI/commandreport.ogg', FACTION_MARINE)
	marine_announcement("Alert! Sensors have detected encroaching USCM vessel on an intercept course with local colony.\n\nIntelligence suggests this is the [MAIN_SHIP_NAME]. Confidence is high that USCM force is acting counter to Union interests in this area. Authorization to deploy ground forces to disrupt foreign power attempt to encroach on Union interests has been granted. Emergency awakening of cryostasis troop reserves in progress.", "1VAN/3", 'sound/AI/commandreport.ogg', FACTION_UPP)
