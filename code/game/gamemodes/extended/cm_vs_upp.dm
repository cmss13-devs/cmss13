/datum/game_mode/extended/faction_clash/cm_vs_upp
	name = "Faction Clash UPP CM"
	config_tag = "Faction Clash UPP CM"
	flags_round_type = MODE_THUNDERSTORM|MODE_FACTION_CLASH
	toggleable_flags = MODE_NO_SNIPER_SENTRY|MODE_NO_ATTACK_DEAD|MODE_NO_STRIPDRAG_ENEMY|MODE_STRONG_DEFIBS|MODE_BLOOD_OPTIMIZATION|MODE_NO_COMBAT_CAS|MODE_INDESTRUCTIBLE_SPLINTS|MODE_NO_INTERNAL_BLEEDING|MODE_MORTAR_LASER_WARNING
	taskbar_icon = 'icons/taskbar/gml_hvh.png'
	var/upp_ship = "ssv_rostock.dmm"

/datum/game_mode/extended/faction_clash/cm_vs_upp/pre_setup()
	. = ..()
	GLOB.round_should_check_for_win = FALSE
	var/datum/powernet/PN = new() // we create our own powernet, with tetris and vodka
	PN.powernet_name = "rostock"
	GLOB.powernets += PN
	GLOB.powernets_by_name["rostock"] = PN
	var/datum/map_template/template = SSmapping.map_templates[upp_ship]
	if(!template)
		return

	log_debug("Attempting load of template [template.name] as new event Z-Level as requested by [name]")
	var/datum/space_level/loaded = template.load_new_z(traits = ZTRAITS_GROUND)
	if(!loaded?.z_value)
		log_debug("Failed to load the template to a Z-Level!")

	var/center_x = floor(loaded.bounds[MAP_MAXX] / 2) // Technically off by 0.5 due to above +1. Whatever
	var/center_y = floor(loaded.bounds[MAP_MAXY] / 2)

	// Now notify the staff of the load - this goes in addition to the generic template load game log
	message_admins("Successfully loaded template as new Z-Level, template name: [template.name]", center_x, center_y, loaded.z_value)
	makepowernets()
	. = ..()


/datum/game_mode/extended/faction_clash/cm_vs_upp/get_roles_list()
	return GLOB.ROLES_CM_VS_UPP

/datum/game_mode/extended/faction_clash/cm_vs_upp/post_setup()
	. = ..()
	SSweather.force_weather_holder(/datum/weather_ss_map_holder/faction_clash)
	for(var/area/area in GLOB.all_areas)
		area.base_lighting_alpha = 150
		area.update_base_lighting()

/datum/game_mode/extended/faction_clash/cm_vs_upp/process()
	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.
	. = ..()
	if(!round_finished)
		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			if(GLOB.round_should_check_for_win)
				check_win()
			round_checkwin = 0


/datum/game_mode/extended/faction_clash/cm_vs_upp/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return

	var/no_upp_left = TRUE
	var/no_uscm_left = TRUE
	var/list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND))
	for(var/mob/M in GLOB.player_list)
		if(M.z && (M.z in z_levels) && M.stat != DEAD && !istype(M.loc, /turf/open/space))
			if(ishuman(M) && !isyautja(M) && !(M.status_flags & XENO_HOST) && !iszombie(M))
				var/mob/living/carbon/human/H = M
				if(!H.handcuffed)
					if(H.faction == FACTION_UPP)
						no_upp_left = FALSE
					if(H.faction == FACTION_MARINE)
						no_uscm_left = FALSE
					if(!no_upp_left && !no_uscm_left)
						return

	if(no_upp_left)
		round_finished = MODE_INFESTATION_M_MAJOR

	if(no_uscm_left)
		round_finished = MODE_FACTION_CLASH_UPP_MAJOR

/datum/game_mode/extended/faction_clash/cm_vs_upp/check_finished()
	if(round_finished)
		return TRUE

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
		else
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
	var/sound/theme = sound(musical_track, channel = SOUND_CHANNEL_LOBBY)
	theme.status = SOUND_STREAM
	sound_to(world, theme)

	calculate_end_statistics()
	show_end_statistics(end_icon)

	declare_completion_announce_fallen_soldiers()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	declare_fun_facts()

	return TRUE

/datum/game_mode/extended/faction_clash/cm_vs_upp/ds_first_landed(obj/docking_port/stationary/marine_dropship)
	.=..()
	marine_announcement("First troops have landed on the colony! Five minute long cease fire is in effect to allow evacuation of civilians.", "ARES 3.2", 'sound/AI/commandreport.ogg', FACTION_MARINE)
	marine_announcement("First troops have landed on the colony! Five minute long cease fire is in effect to allow evacuation of civilians.", "1VAN/3", 'sound/AI/commandreport.ogg', FACTION_UPP)
	addtimer(VARSET_CALLBACK(GLOB, round_should_check_for_win, TRUE), 15 MINUTES)


/datum/game_mode/extended/faction_clash/cm_vs_upp/announce()
	. = ..()
	marine_announcement("An automated distress call has been received from the local colony.\n\nAlert! Sensors have detected a Union of Progressive People's warship in orbit of colony. Enemy Vessel has refused automated hails and is entering lower-planetary orbit. High likelihood enemy vessel is preparing to deploy dropships to local colony. Authorization to interdict and repel hostile force from allied territory has been granted. Automated thawing of cryostasis marine reserves in progress.", "ARES 3.2", 'sound/AI/commandreport.ogg', FACTION_MARINE)
	marine_announcement("Alert! Sensors have detected encroaching USCM vessel on an intercept course with local colony.\n\nIntelligence suggests this is the [MAIN_SHIP_NAME]. Confidence is high that USCM force is acting counter to Union interests in this area. Authorization to deploy ground forces to disrupt foreign power attempt to encroach on Union interests has been granted. Emergency awakening of cryostasis troop reserves in progress.", "1VAN/3", 'sound/AI/commandreport.ogg', FACTION_UPP)
