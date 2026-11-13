/datum/game_mode/bug_hunt
	name = GAMEMODE_BUG_HUNT
	config_tag = GAMEMODE_BUG_HUNT
	required_players = 1
	votable = FALSE
	flags_round_type = MODE_NEW_SPAWN
	latejoin_larva_drop = 0
	latejoin_larva_drop_early = 0
	var/hive_core_count = 3
	role_mappings = list(
		/datum/job/command/commander/bug_hunt = JOB_CO,
		/datum/job/command/executive/bug_hunt = JOB_XO,
		/datum/job/marine/leader/bug_hunt = JOB_SQUAD_LEADER,
		/datum/job/marine/tl/bug_hunt = JOB_SQUAD_TEAM_LEADER,
		/datum/job/marine/medic/bug_hunt = JOB_SQUAD_MEDIC,
		/datum/job/marine/engineer/bug_hunt = JOB_SQUAD_ENGI,
		/datum/job/marine/smartgunner/bug_hunt = JOB_SQUAD_SMARTGUN,
		/datum/job/marine/standard/bug_hunt = JOB_SQUAD_MARINE,
		/datum/job/civilian/synthetic/bug_hunt = JOB_SYNTH,
	)

/datum/game_mode/bug_hunt/get_roles_list()
	return GLOB.ROLES_BUG_HUNT

/datum/game_mode/bug_hunt/pre_setup()
	for(var/datum/squad/marine/squad in GLOB.RoleAuthority.squads)
		squad.lock_squad(TRUE)
		squad.roundstart = FALSE
	var/datum/squad/recon = GLOB.RoleAuthority.squads_by_type[/datum/squad/marine/alpha]
	var/datum/squad/forecon = GLOB.RoleAuthority.squads_by_type[/datum/squad/marine/forecon]
	recon.name = "Recon"
	recon.radio_freq = SOF_FREQ
	recon.equipment_color = initial(forecon.equipment_color)
	recon.chat_color = initial(forecon.chat_color)
	recon.minimap_color = initial(forecon.minimap_color)
	recon.background_icon = initial(forecon.background_icon)
	recon.omni_squad_vendor = TRUE
	recon.roles_cap[JOB_SQUAD_SMARTGUN] = 2
	recon.roundstart = TRUE
	recon.engage_squad(TRUE)
	. = ..()
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	hive.allow_no_queen_actions = TRUE
	hive.allow_no_queen_evo = TRUE
	hive.allow_queen_evolve = FALSE
	hive.tacmap_requires_queen_ovi = FALSE
	hive.tier_limits = list(TIER_2 = -1, TIER_3 = 3)
	hive.allow_core_larva_spawning = FALSE
	LAZYADD(hive.blacklisted_castes, XENO_CASTE_QUEEN)
	hive.hive_stat_modifier_multiplier["health"] = XENO_HIVE_STATMOD_MULT_MED
	hive.hive_stat_modifier_multiplier["plasmagain"] = XENO_HIVE_STATMOD_MULT_MED
	if(!setup_hive_cores())
		return FALSE
	SSradio.update_cache()

/datum/game_mode/bug_hunt/proc/setup_hive_cores()
	var/list/core_turfs = list()
	for(var/obj/effect/landmark/queen_spawn/queen_spawn in GLOB.queen_spawns)
		core_turfs |= get_turf(queen_spawn)

	if(length(core_turfs) < hive_core_count)
		var/list/fallback_turfs = list()
		for(var/ground_z in SSmapping.levels_by_trait(ZTRAIT_GROUND))
			for(var/area/area as anything in SSmapping.areas_in_z["[ground_z]"])
				if(!CEILING_IS_PROTECTED(area.ceiling, CEILING_PROTECTION_TIER_4))
					continue
				for(var/turf/open/spawn_turf in area)
					CHECK_TICK
					if(spawn_turf.z != ground_z || istype(spawn_turf, /turf/open/space) || is_blocked_turf(spawn_turf) || (spawn_turf in core_turfs))
						continue
					fallback_turfs += spawn_turf
		while(length(fallback_turfs) && length(core_turfs) < hive_core_count)
			core_turfs += pick_n_take(fallback_turfs)

	if(length(core_turfs) < hive_core_count)
		return FALSE

	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	hive.hive_structures_limit[XENO_STRUCTURE_CORE] = hive_core_count
	for(var/i in 1 to hive_core_count)
		new /obj/effect/alien/resin/special/pylon/core(pick_n_take(core_turfs), hive)
	return TRUE

/datum/game_mode/bug_hunt/check_xeno_late_join(mob/xeno_candidate)
	if(!..() || round_finished)
		return FALSE
	var/mob/living/original_body = xeno_candidate.mind?.original
	if(istype(original_body) && original_body.stat != DEAD)
		to_chat(xeno_candidate, SPAN_WARNING("You cannot join while your original body is alive."))
		return FALSE
	var/mob/living/carbon/human/original_human = original_body
	if(istype(original_human) && original_human.check_tod() && original_human.is_revivable())
		to_chat(xeno_candidate, SPAN_WARNING("You cannot join while your human body can still be revived."))
		return FALSE
	var/last_activity = max(xeno_candidate.timeofdeath, xeno_candidate.client.player_details.larva_pool_time)
	var/time_left = last_activity + 30 SECONDS - world.time
	if(last_activity && time_left > 0)
		to_chat(xeno_candidate, SPAN_WARNING("You must wait [DisplayTimeText(time_left)] before joining as a xenomorph."))
		return FALSE
	return TRUE

/datum/game_mode/bug_hunt/attempt_to_join_as_xeno(mob/xeno_candidate, instant_join = FALSE)
	if(!check_xeno_late_join(xeno_candidate))
		return FALSE
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	var/list/castes = XENO_T1_CASTES + XENO_T2_CASTES
	for(var/caste_name in castes)
		var/datum/caste_datum/caste = GLOB.xeno_datum_list[caste_name]
		if(caste.minimum_evolve_time > ROUND_TIME || !caste.can_play_caste(xeno_candidate.client))
			castes -= caste_name
	if(!length(castes))
		to_chat(xeno_candidate, SPAN_WARNING("The hive cannot support any available castes yet."))
		return FALSE
	var/caste_choice = tgui_input_list(xeno_candidate, "Choose a caste.", "Join as Xeno", castes, theme = "hive_status")
	if(!caste_choice || !check_xeno_late_join(xeno_candidate))
		return FALSE

	var/list/cores = hive.hive_structures[XENO_STRUCTURE_CORE]
	if(!length(cores))
		return FALSE
	var/obj/effect/alien/resin/special/pylon/core/core = pick(cores)
	var/xeno_type = GLOB.RoleAuthority.get_caste_by_text(caste_choice)
	var/mob/living/carbon/xenomorph/new_xeno = new xeno_type(get_turf(core), null, hive.hivenumber)
	if(isnewplayer(xeno_candidate))
		var/mob/new_player/lobby_player = xeno_candidate
		lobby_player.close_spawn_windows()
		lobby_player.spawning = TRUE
	if(!transfer_xeno(xeno_candidate, new_xeno))
		qdel(new_xeno)
		return FALSE
	return new_xeno


/datum/game_mode/bug_hunt/announce()
	to_world(SPAN_ROUNDHEADER("The current game mode is - BUG HUNT!"))
	to_world(SPAN_ROUNDBODY("A USCM Force Reconnaissance platoon has been deployed to [SSmapping.configs[GROUND_MAP].map_name] to eradicate a confirmed Xenomorph infestation."))

/datum/game_mode/bug_hunt/check_predator_late_join(mob/pred_candidate, show_warning = TRUE)
	return FALSE

/datum/game_mode/bug_hunt/check_fax_responder_late_join(mob/responder, show_warning = TRUE)
	return FALSE

/datum/game_mode/bug_hunt/ds_first_landed(obj/docking_port/stationary/marine_dropship)
	. = ..()
	for(var/mob/living/carbon/xenomorph/xeno in GLOB.xeno_mob_list)
		qdel(get_action(xeno, /datum/action/xeno_action/onclick/choose_resin/predrop))
		qdel(get_action(xeno, /datum/action/xeno_action/activable/secrete_resin/predrop))

/datum/game_mode/bug_hunt/post_setup()
	initialize_post_marine_gear_list()
	round_time_lobby = world.time
	addtimer(CALLBACK(src, PROC_REF(ares_online)), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(mission_briefing)), 2 MINUTES)
	var/xeno_briefing = "The tallhosts will soon descending upon this world to destroy our hive. Our [hive_core_count] hive cores must be defended, if every core is destroyed, the hive is lost."
	xeno_briefing += "\n\nBuild now and prepare your killing grounds. Even those unable to spread strong weeds may plant frail weeds to sustain the brood."
	xeno_announcement(xeno_briefing, XENO_HIVE_NORMAL, QUEEN_MOTHER_ANNOUNCE)
	return ..()

/datum/game_mode/bug_hunt/ares_online()
	var/area/golden_arrow/ship = GLOB.areas_by_type[/area/golden_arrow]
	if(ship)
		ship.lightswitch = TRUE
		ship.power_change()
	shipwide_ai_announcement("[MAIN_AI_SYSTEM]. Online. Good morning, marines.", "[MAIN_AI_SYSTEM] Online", 'sound/AI/ares_online.ogg')

/datum/game_mode/bug_hunt/proc/mission_briefing()
	var/briefing = "Snake Eaters, this is SOCOM Actual. Intelligence confirms a Class IV xenomorph infestation on [SSmapping.configs[GROUND_MAP].map_name], due to that, Special Operations Command has authorized a full extermination operation."
	briefing += "\n\nYour platoon will conduct an insertion deep into infested territory. There is no civilian presence in the AO, as such, all surface movement is to be considered hostile. Expect contact from the moment you touch down."
	briefing += "\n\nThe infestation has grown too extensive to eradicate through direct combat alone. As long as the hive cores remain intact, the enemy will continue to replenish its numbers. Locate and destroy all hive cores and return to the USS Golden Arrow."
	briefing += "\n\nGood hunting, Snake Eaters. SOCOM Actual out."
	marine_announcement(briefing, "USCM Special Operations Command", 'sound/AI/commandreport.ogg')

/datum/game_mode/bug_hunt/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING || round_finished)
		return
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	if(!hive.has_structure(XENO_STRUCTURE_CORE))
		round_finished = MODE_INFESTATION_M_MAJOR
		return
	if(!SSobjectives.first_drop_complete)
		return
	for(var/mob/living/carbon/human/marine in GLOB.alive_mob_list)
		if(marine.faction != FACTION_MARINE || iszombie(marine) || marine.hivenumber)
			continue
		var/turf/location = get_turf(marine)
		if(!location)
			continue
		if(SSinterior.in_interior(location))
			var/datum/interior/interior = SSinterior.get_interior_by_coords(location.x, location.y, location.z)
			location = get_turf(interior?.exterior)
		if(is_ground_level(location?.z))
			return
	round_finished = MODE_INFESTATION_X_MAJOR

/datum/game_mode/bug_hunt/check_finished()
	check_win()
	return !!round_finished

/datum/game_mode/bug_hunt/declare_completion()
	announce_ending()
	var/marine_victory = round_finished == MODE_INFESTATION_M_MAJOR
	send_end_round_music(marine_victory ? 'sound/theme/winning_triumph1.ogg' : 'sound/theme/sad_loss1.ogg')
	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.round_result = round_finished
		GLOB.round_statistics.end_round_player_population = length(GLOB.clients)
		GLOB.round_statistics.log_round_statistics()
	calculate_end_statistics()
	show_end_statistics(marine_victory ? "marine_major" : "xeno_major")
	GLOB.round_statistics?.save()

/datum/game_mode/bug_hunt/end_round_message()
	return "Round has ended. [round_finished]."

