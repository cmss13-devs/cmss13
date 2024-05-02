/proc/check_crash()
	if(SSticker.mode == "Crash" || GLOB.master_mode == "Crash")
		return TRUE
	return FALSE

/datum/game_mode/crash
	name = "Crash"
	config_tag = "Crash"
	required_players = 2
	xeno_required_num = 1
	flags_round_type = MODE_NEW_SPAWN|MODE_NO_SHIP_MAP|MODE_INFESTATION
	role_mappings = list(
		/datum/job/command/commander/crash = JOB_CO,
		/datum/job/civilian/synthetic/crash = JOB_SYNTH,
		/datum/job/logistics/engineering/crash = JOB_CHIEF_ENGINEER,
		/datum/job/civilian/professor/crash = JOB_CMO,
		/datum/job/marine/leader/crash = JOB_SQUAD_LEADER,
		/datum/job/marine/specialist/crash = JOB_SQUAD_SPECIALIST,
		/datum/job/marine/smartgunner/crash = JOB_SQUAD_SMARTGUN,
		/datum/job/marine/medic/crash = JOB_SQUAD_MEDIC,
		/datum/job/marine/engineer/crash = JOB_SQUAD_ENGI,
		/datum/job/marine/standard/crash = JOB_SQUAD_MARINE
	)

	population_min = 0
	population_max = 30

	// Round end conditions
	var/shuttle_landed = FALSE
	var/marines_evac = CRASH_EVAC_NONE

	// Shuttle details
	var/shuttle_id = DROPSHIP_CRASH
	var/obj/docking_port/mobile/crashmode/shuttle

	var/bioscan_interval = INFINITY

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/datum/game_mode/crash/get_roles_list()
	return GLOB.ROLES_CRASH + JOB_XENOMORPH

/* Pre-pre-startup */
/datum/game_mode/crash/can_start(bypass_checks = FALSE)
	if(!bypass_checks)
		var/list/datum/mind/possible_xenomorphs = get_players_for_role(JOB_XENOMORPH)
		if(possible_xenomorphs.len < xeno_required_num) //We don't have enough aliens, we don't consider people rolling for only Queen.
			to_world("Not enough players have chosen to be a xenomorph in their character setup. <b>Aborting</b>.")
			return FALSE

		var/players = 0
		for(var/mob/new_player/player in GLOB.new_player_list)
			if(player.client && player.ready)
				players++

		if(players < required_players)
			return FALSE

	initialize_special_clamps()

	var/datum/map_template/shuttle/ST = SSmapping.shuttle_templates[shuttle_id]
	shuttle = SSshuttle.load_template_to_transit(ST)

	return TRUE

/obj/effect/landmark/crash/nuclear_spawn
	name = "nuclear spawn"

/obj/effect/landmark/crash/nuclear_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.nuke_spawn_locs += src

/obj/effect/landmark/crash/nuclear_spawn/Destroy()
	GLOB.nuke_spawn_locs -= src
	return ..()

/obj/effect/landmark/crash/resin_silo_spawn
	name = "resin silo spawn"

/obj/effect/landmark/crash/resin_silo_spawn/Initialize(mapload, ...)
	. = ..()
	GLOB.resin_silo_spawn_locs += src

/obj/effect/landmark/crash/resin_silo_spawn/Destroy()
	GLOB.resin_silo_spawn_locs -= src
	return ..()


////////////////////////////////////////////////////////////////////////////////////////


/datum/game_mode/crash/pre_setup()
	if(GLOB.RoleAuthority)
		for(var/datum/squad/squad as anything in GLOB.RoleAuthority.squads)
			if(squad.faction == FACTION_MARINE && squad.name != "Root" && squad.name != "Alpha")
				squad.roundstart = FALSE
				squad.usable = FALSE

	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	hive.allow_queen_evolve = FALSE
	hive.allow_no_queen_evo = TRUE
	hive.allow_no_queen_actions = TRUE

	var/obj/effect/landmark/crash/nuclear_spawn/NS = SAFEPICK(GLOB.nuke_spawn_locs)
	if(NS)
		GLOB.nuke_list += new /obj/structure/machinery/nuclearbomb/crash(NS.loc)
	qdel(NS)
	var/obj/effect/landmark/crash/resin_silo_spawn/RSS = SAFEPICK(GLOB.resin_silo_spawn_locs)
	if(RSS)
		var/obj/effect/alien/resin/special/pylon/core/core = new(RSS.loc, hive)
		core.surge_cooldown = 160 SECONDS
		core.surge_incremental_reduction = 2 SECONDS
		core.spawn_cooldown = 10 SECONDS
		core.crash_mode = TRUE
		GLOB.xeno_resin_silos += core
	qdel(RSS)

	for(var/obj/structure/machinery/computer/shuttle_control/computer_to_disable as anything in GLOB.shuttle_controls)
		if(istype(computer_to_disable, /obj/structure/machinery/computer/shuttle/shuttle_control/uss_crash))
			continue
		computer_to_disable.stat |= BROKEN
		computer_to_disable.update_icon()

	GLOB.xeno_join_dead_larva_time = 0
	GLOB.xeno_join_dead_time = 0

	QDEL_LIST(GLOB.hunter_primaries)
	QDEL_LIST(GLOB.hunter_secondaries)
	QDEL_LIST(GLOB.crap_items)
	QDEL_LIST(GLOB.good_items)

	//desert river test
	if(!length(round_toxic_river))
		round_toxic_river = null //No tiles?
	else
		round_time_river = rand(-100,100)
		flags_round_type |= MODE_FOG_ACTIVATED

	// Shuttle crash point creating
	var/obj/docking_port/stationary/crashmode/temp_crashable_port
	for(var/i = 1 to 20)
		var/list/all_ground_levels = SSmapping.levels_by_trait(ZTRAIT_GROUND)
		var/ground_z_level = all_ground_levels[1]

		var/list/area/potential_areas = SSmapping.areas_in_z["[ground_z_level]"]

		var/area/area_picked = pick(potential_areas)

		var/list/potential_turfs = list()

		for(var/turf/turf_in_area in area_picked)
			potential_turfs += turf_in_area

		if(!length(potential_turfs))
			continue

		var/turf/turf_picked = pick(potential_turfs)

		temp_crashable_port = new(turf_picked)

		if(!shuttle.check_crash_point(temp_crashable_port))
			qdel(temp_crashable_port)
			continue
		break

	shuttle.crashing = TRUE
	SSshuttle.moveShuttleToDock(shuttle, temp_crashable_port, TRUE)

	..()

	var/obj/structure/tunnel/T
	var/i = 0
	var/turf/t
	while(length(GLOB.xeno_tunnels) && i++ < 3)
		t = get_turf(pick_n_take(GLOB.xeno_tunnels))
		T = new(t)
		T.id = "hole[i]"
	return TRUE

/datum/game_mode/crash/post_setup()
	set waitfor = FALSE
	update_controllers()
	initialize_post_marine_gear_list()

	if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_BASIC_RT])
		flags_round_type |= MODE_BASIC_RT

	round_time_lobby = world.time

	for(var/area/A in GLOB.all_areas)
		if(!(A.is_resin_allowed))
			A.is_resin_allowed = TRUE

	open_podlocks("map_lockdown")

	return ..()

/datum/game_mode/crash/proc/update_controllers()
	if(SSitem_cleanup)
		SSitem_cleanup.start_processing_time = 0
		SSitem_cleanup.percentage_of_garbage_to_delete = 1.0
		SSitem_cleanup.wait = 1 MINUTES
		SSitem_cleanup.next_fire = 1 MINUTES
		spawn(0)
			SSitem_cleanup.delete_almayer()

/datum/game_mode/crash/announce()
	to_chat(world, SPAN_ROUNDHEADER("Your ship has crashed over - [SSmapping.configs[GROUND_MAP].map_name]! You know everything about the enemy, time for the final battle!"))
	marine_announcement("Scheduled for landing in T-10 Minutes. Prepare for landing. Known hostiles near LZ. Detonation Protocol Active, planet disposable. Marines disposable.")
	playsound(shuttle, 'sound/machines/warning-buzzer.ogg', 75, 0, 30)

#define XENO_FOG_DELAY_INTERVAL		(60 MINUTES)
#define FOG_DELAY_INTERVAL		(15 MINUTES)
#define PODLOCKS_OPEN_WAIT		(15 MINUTES) // CORSAT pod doors drop at 12:45

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/crash/process()
	. = ..()
	if(round_started > 0)
		round_started--
		return FALSE

	if(!round_finished)
		// Automated bioscan / Queen Mother message
		if(world.time > bioscan_current_interval) //If world time is greater than required bioscan time.
			announce_bioscans() //Announce the results of the bioscan to both sides.
			bioscan_current_interval += bioscan_ongoing_interval //Add to the interval based on our set interval time.


		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks..
			if(GLOB.round_should_check_for_win)
				check_win()
			round_checkwin = 0

		if(!GLOB.resin_lz_allowed && world.time >= SSticker.round_start_time + round_time_resin)
			set_lz_resin_allowed(TRUE)

#undef XENO_FOG_DELAY_INTERVAL
#undef FOG_DELAY_INTERVAL
#undef PODLOCKS_OPEN_WAIT

/datum/game_mode/crash/ds_first_landed()
	. = ..()

	shuttle_landed = TRUE
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_blurb_uscm)), DROPSHIP_DROP_MSG_DELAY)
	// We delay this a little because the shuttle takes some time to land, and we want to the xenos to know the position of the marines.
	bioscan_interval = world.time + 30 SECONDS

///////////////////////////
//Checks to see who won///
//////////////////////////
/datum/game_mode/crash/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return

	if(!shuttle_landed && !force_end_at)
		return

	var/living_player_list[] = count_humans_and_xenos(SSmapping.levels_by_trait(ZTRAIT_GROUND))
	var/num_humans = living_player_list[1]
	var/num_xenos = living_player_list[2]

	if(force_end_at && world.time > force_end_at)
		round_finished = MODE_CRASH_X_MINOR
	if((planet_nuked == NUKE_NONE && marines_evac == CRASH_EVAC_NONE) && (!num_humans && !length(GLOB.xeno_resin_silos) && !num_xenos))
		round_finished = MODE_GENERIC_DRAW_NUKE
	if(planet_nuked == NUKE_NONE && length(GLOB.xeno_resin_silos) && (marines_evac == CRASH_EVAC_NONE && !num_humans) && !(GLOB.bomb_set))
		round_finished = MODE_CRASH_X_MAJOR
	if(planet_nuked == NUKE_NONE && !GLOB.bomb_set && !num_humans && (marines_evac != CRASH_EVAC_NONE || !length(GLOB.xeno_resin_silos)))
		round_finished = MODE_CRASH_X_MINOR
	if((planet_nuked == NUKE_COMPLETED && marines_evac == CRASH_EVAC_NONE) || (planet_nuked == NUKE_NONE && !length(GLOB.xeno_resin_silos) && !num_xenos && marines_evac != CRASH_EVAC_NONE))
		round_finished = MODE_CRASH_M_MINOR
	if((planet_nuked == NUKE_COMPLETED && marines_evac != CRASH_EVAC_NONE) || (planet_nuked == NUKE_NONE && !length(GLOB.xeno_resin_silos) && !num_xenos))
		round_finished = MODE_CRASH_M_MAJOR

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/crash/check_finished()
	if(round_finished)
		return TRUE

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/crash/declare_completion()
	. = ..()

	declare_completion_announce_fallen_soldiers()
	declare_completion_announce_xenomorphs()
	declare_completion_announce_medal_awards()
	declare_fun_facts()

/datum/game_mode/crash/on_nuclear_diffuse(obj/structure/machinery/nuclearbomb/bomb, mob/living/carbon/xenomorph/xenomorph)
	. = ..()
	var/living_player_list[] = count_humans_and_xenos(SSmapping.levels_by_trait(ZTRAIT_GROUND))
	var/num_humans = living_player_list[1]
	if(!num_humans)
		marine_announcement("WARNING. WARNING. Planetary Nuke Deactivated. WARNING. WARNING. Mission Failed. WARNING. WARNING.", "Priority Alert", "Everyone (-Yautja)")

/datum/game_mode/crash/declare_completion()
	announce_ending()
	var/musical_track
	var/end_icon = "draw"
	switch(round_finished)
		if(MODE_CRASH_M_MAJOR)
			musical_track = pick('sound/theme/winning_triumph1.ogg','sound/theme/winning_triumph2.ogg')
			end_icon = "marine_major"
			to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("|MARINE MAJOR SUCCESS|"))
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_marine_victories++
				GLOB.round_statistics.current_map.total_marine_majors++
		if(MODE_CRASH_M_MINOR)
			musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
			end_icon = "marine_minor"
			to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("|MARINE MINOR SUCCESS|"))
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_marine_victories++
		if(MODE_CRASH_X_MINOR)
			var/list/living_player_list = count_humans_and_xenos(SSmapping.levels_by_trait(ZTRAIT_GROUND))
			if(living_player_list[1] && !living_player_list[2]) // If Xeno Minor but Xenos are dead and Humans are alive, see which faction is the last standing
				musical_track = pick('sound/theme/neutral_melancholy2.ogg') //This is the theme song for Colonial Marines the game, fitting
			else
				musical_track = pick('sound/theme/neutral_melancholy1.ogg')
			to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("|XENOMORPH MINOR SUCCESS|"))
			end_icon = "xeno_minor"
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_xeno_victories++
		if(MODE_CRASH_X_MAJOR)
			musical_track = pick('sound/theme/sad_loss1.ogg','sound/theme/sad_loss2.ogg')
			end_icon = "xeno_major"
			to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("|XENOMORPH MAJOR SUCCESS|"))
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_xeno_victories++
				GLOB.round_statistics.current_map.total_xeno_majors++
		if(MODE_GENERIC_DRAW_NUKE)
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
			to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("|DRAW|"))
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_draws++
	var/sound/S = sound(musical_track, channel = SOUND_CHANNEL_LOBBY)
	S.status = SOUND_STREAM
	sound_to(world, S)
	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.round_result = round_finished
		GLOB.round_statistics.end_round_player_population = GLOB.clients.len

		GLOB.round_statistics.log_round_statistics()

	calculate_end_statistics()
	show_end_statistics(end_icon)

	declare_completion_announce_fallen_soldiers()
	declare_completion_announce_xenomorphs()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	declare_fun_facts()
	return TRUE

// for the toolbox
/datum/game_mode/crash/end_round_message()
	switch(round_finished)
		if(MODE_CRASH_M_MAJOR)
			return "Round has ended. Marine Major Success."
		if(MODE_CRASH_M_MINOR)
			return "Round has ended. Marine Minor Success."
		if(MODE_CRASH_X_MINOR)
			return "Round has ended. Xenomorph Minor Success."
		if(MODE_CRASH_X_MAJOR)
			return "Round has ended. Xenomorph Major Success."
		if(MODE_GENERIC_DRAW_NUKE)
			return "Round has ended. Draw."
	return "Round has ended in a strange way."
