/datum/game_mode/extended/faction_clash/cm_vs_upp
	name = "Faction Clash UPP CM"
	config_tag = "Faction Clash UPP CM"
	flags_round_type = MODE_THUNDERSTORM|MODE_FACTION_CLASH
	toggleable_flags = MODE_NO_SNIPER_SENTRY|MODE_NO_ATTACK_DEAD|MODE_NO_STRIPDRAG_ENEMY|MODE_STRONG_DEFIBS|MODE_BLOOD_OPTIMIZATION|MODE_NO_COMBAT_CAS|MODE_INDESTRUCTIBLE_SPLINTS|MODE_NO_INTERNAL_BLEEDING
	taskbar_icon = 'icons/taskbar/gml_hvh.png'

/datum/game_mode/extended/faction_clash/cm_vs_upp/get_roles_list()
	return GLOB.ROLES_CM_VS_UPP

/datum/game_mode/extended/faction_clash/cm_vs_upp/post_setup()
	. = ..()
	SSweather.force_weather_holder(/datum/weather_ss_map_holder/faction_clash)
	for(var/area/area in GLOB.all_areas)
		area.base_lighting_alpha = 150
		area.update_base_lighting()

/datum/game_mode/extended/faction_clash/cm_vs_upp/declare_completion()
	announce_ending()
	var/musical_track
	var/end_icon = "draw"
	switch(round_finished)
		if(MODE_FACTION_CLASH_UPP_MAJOR)
			musical_track = pick('sound/theme/lastmanstanding_upp.ogg')
			end_icon = "upp_major"
		if(MODE_FACTION_CLASH_UPP_MINOR)
			musical_track = pick('sound/theme/lastmanstanding_upp.ogg')
			end_icon = "upp_minor"
		if(MODE_INFESTATION_M_MAJOR)
			musical_track = pick('sound/theme/winning_triumph1.ogg','sound/theme/winning_triumph2.ogg')
			end_icon = "marine_major"
		if(MODE_INFESTATION_M_MINOR)
			musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
			end_icon = "marine_minor"
		if(MODE_BATTLEFIELD_DRAW_STALEMATE)
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
	var/sound/S = sound(musical_track, channel = SOUND_CHANNEL_LOBBY)
	S.status = SOUND_STREAM
	sound_to(world, S)

	calculate_end_statistics()
	show_end_statistics(end_icon)

	declare_completion_announce_fallen_soldiers()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	declare_fun_facts()

	return 1
