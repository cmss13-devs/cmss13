#define is_hive_living(hive) (!hive.hardcore || hive.living_xeno_queen)

/datum/game_mode/xenovs
	name = GAMEMODE_HIVE_WARS
	config_tag = GAMEMODE_HIVE_WARS
	required_players = 4 //Need at least 4 players
	xeno_required_num = 4 //Need at least four xenos.
	monkey_amount = 0.2 // Amount of monkeys per player
	flags_round_type = MODE_NO_SPAWN|MODE_NO_LATEJOIN|MODE_XVX|MODE_RANDOM_HIVE

	var/list/structures_to_delete = list(/obj/effect/alien/weeds, /turf/closed/wall/resin, /obj/structure/mineral_door/resin, /obj/structure/bed/nest, /obj/item, /obj/structure/tunnel, /obj/structure/machinery/computer/shuttle_control, /obj/structure/machinery/defenses/sentry/premade)
	var/list/hives = list()
	var/list/hive_cores = list()

	var/sudden_death = FALSE
	var/time_until_sd = 90 MINUTES

	var/list/current_hives = list()

	var/hive_larva_interval_gain = 5 MINUTES

	var/round_time_larva_interval = 0
	var/round_time_sd = 0
	votable = FALSE // broken

/* Pre-pre-startup */
/datum/game_mode/xenovs/can_start(bypass_checks = FALSE)
	for(var/hivename in SSmapping.configs[GROUND_MAP].xvx_hives)
		if(GLOB.readied_players > SSmapping.configs[GROUND_MAP].xvx_hives[hivename])
			hives += hivename
	xeno_starting_num = GLOB.readied_players
	if(!initialize_starting_xenomorph_list(hives, bypass_checks))
		hives.Cut()
		return FALSE
	return TRUE

/datum/game_mode/xenovs/announce()
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("The current map is - [SSmapping.configs[GROUND_MAP].map_name]!"))

/datum/game_mode/xenovs/get_roles_list()
	return GLOB.ROLES_XENO

/* Pre-setup */
/datum/game_mode/xenovs/pre_setup()
	monkey_types = SSmapping.configs[GROUND_MAP].monkey_types
	if(monkey_amount)
		if(length(monkey_types))
			for(var/i = min(floor(monkey_amount*length(GLOB.clients)), length(GLOB.monkey_spawns)), i > 0, i--)

				var/turf/T = get_turf(pick_n_take(GLOB.monkey_spawns))
				var/monkey_to_spawn = pick(monkey_types)
				new monkey_to_spawn(T)


	for(var/atom/A in world)
		for(var/type in structures_to_delete)
			if(istype(A, type))
				if(istype(A, /turf))
					var/turf/T = A
					T.ScrapeAway()
				else
					qdel(A)

	round_time_sd = (time_until_sd + world.time)

	update_controllers()

	..()
	return TRUE

/datum/game_mode/xenovs/proc/update_controllers()
	//Update controllers while we're on this mode
	if(SSitem_cleanup)
		//Cleaning stuff more aggressively
		SSitem_cleanup.start_processing_time = 0
		SSitem_cleanup.percentage_of_garbage_to_delete = 1
		SSitem_cleanup.wait = 1 MINUTES
		SSitem_cleanup.next_fire = 1 MINUTES
		spawn(0)
			//Deleting Almayer, for performance!
			SSitem_cleanup.delete_almayer()

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Post-setup */
//This happens after create_character, so our mob SHOULD be valid and built by now, but without job data.
//We move it later with transform_survivor but they might flicker at any start_loc spawn landmark effects then disappear.
//Xenos and survivors should not spawn anywhere until we transform them.
/datum/game_mode/xenovs/post_setup()
	initialize_post_xenomorph_list(GLOB.xeno_hive_spawns)

	round_time_lobby = world.time
	for(var/area/A in GLOB.all_areas)
		if(!(A.is_resin_allowed))
			A.is_resin_allowed = TRUE

	open_podlocks("map_lockdown")

	..()

/datum/game_mode/xenovs/proc/initialize_post_xenomorph_list(list/hive_spawns = GLOB.xeno_spawns)
	var/list/hive_spots = list()
	for(var/hive in hives)
		var/turf/spot = get_turf(pick(hive_spawns))
		hive_spots[GLOB.hive_datum[hive]] = spot
		hive_spawns -= spot

		current_hives += GLOB.hive_datum[hive].name

	for(var/datum/hive_status/hive in xenomorphs) //Build and move the xenos.
		for(var/datum/mind/ghost_mind in xenomorphs[hive])
			transform_xeno(ghost_mind, hive_spots[hive], hive.hivenumber, FALSE)
			ghost_mind.current.close_spawn_windows()

	// Have to spawn the queen last or the mind will be added to xenomorphs and double spawned
	for(var/datum/hive_status/hive in picked_queens)
		transform_queen(picked_queens[hive], hive_spots[hive], hive.hivenumber)
		var/datum/mind/M = picked_queens[hive]
		M.current.close_spawn_windows()

	for(var/datum/hive_status/hive in hive_spots)
		var/obj/effect/alien/resin/special/pylon/core/C = new(hive_spots[hive], hive)
		C.hardcore = TRUE // This'll make losing the hive core more detrimental than losing a Queen
		hive_cores += C

/datum/game_mode/xenovs/proc/transform_xeno(datum/mind/ghost_mind, turf/xeno_turf, hivenumber = XENO_HIVE_NORMAL, should_spawn_nest = TRUE)
	if(should_spawn_nest)
		var/mob/living/carbon/human/original = ghost_mind.current

		original.first_xeno = TRUE
		original.set_stat(UNCONSCIOUS)
		transform_survivor(ghost_mind, xeno_turf = xeno_turf) //Create a new host
		original.apply_damage(50, BRUTE)
		original.spawned_corpse = TRUE

		for(var/obj/item/device/radio/radio in original.contents_recursive())
			radio.listening = FALSE

		var/obj/structure/bed/nest/start_nest = new /obj/structure/bed/nest(original.loc) //Create a new nest for the host
		original.statistic_exempt = TRUE
		original.buckled = start_nest
		original.setDir(start_nest.dir)
		start_nest.buckled_mob = original
		start_nest.afterbuckle(original)

		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(original) //Put the initial larva in a host
		embryo.stage = 5 //Give the embryo a head-start (make the larva burst instantly)
		embryo.hivenumber = hivenumber

		if(original && !original.first_xeno)
			qdel(original)
	else
		var/mob/living/carbon/xenomorph/larva/L = new(xeno_turf, null, hivenumber)
		ghost_mind.transfer_to(L)

/datum/game_mode/xenovs/pick_queen_spawn(mob/player, hivenumber = XENO_HIVE_NORMAL)
	. = ..()
	if(!.) return
	// Spawn additional hive structures
	var/turf/T  = .
	var/area/AR = get_area(T)
	if(!AR) return
	for(var/obj/effect/landmark/structure_spawner/xvx_hive/SS in AR)
		SS.apply()
		qdel(SS)

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/xenovs/process()
	. = ..()
	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.



	if(!round_finished)
		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			if(world.time > round_time_larva_interval)
				for(var/hive in hives)
					GLOB.hive_datum[hive].stored_larva++
					GLOB.hive_datum[hive].hive_ui.update_burrowed_larva()

				round_time_larva_interval = world.time + hive_larva_interval_gain

			if(!sudden_death && world.time > round_time_sd)
				sudden_death = TRUE
				xeno_announcement("The hives have entered sudden death mode. No more respawns, no more Queens", "everything", HIGHER_FORCE_ANNOUNCE)
				for(var/obj/effect/alien/resin/special/pylon/core/C in hive_cores)
					qdel(C)
				hive_cores = list()

			if(GLOB.round_should_check_for_win)
				check_win()
			round_checkwin = 0


/datum/game_mode/xenovs/proc/get_xenos_hive(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED, ZTRAIT_MARINE_MAIN_SHIP)))
	var/list/list/hivenumbers = list()
	var/datum/hive_status/HS
	for(var/hivenumber in GLOB.hive_datum)
		HS = GLOB.hive_datum[hivenumber]
		hivenumbers += list(HS.name = list())

	for(var/mob/M in GLOB.player_list)
		if(M.z && (M.z in z_levels) && M.stat != DEAD && !istype(M.loc, /turf/open/space)) //If they have a z var, they are on a turf.
			var/mob/living/carbon/xenomorph/X = M
			var/datum/hive_status/hive = GLOB.hive_datum[X.hivenumber]
			if(!hive)
				continue

			if(istype(X) && is_hive_living(hive))
				hivenumbers[hive.name].Add(X)


	return hivenumbers

///////////////////////////
//Checks to see who won///
//////////////////////////
/datum/game_mode/xenovs/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return

	var/list/living_player_list = get_xenos_hive()

	var/last_living_hive
	var/living_hives = 0

	for(var/H in living_player_list)
		if(length(living_player_list[H]) > 0)
			living_hives++
			last_living_hive = H
		else if (H in current_hives)
			xeno_announcement("\The [H] has been eliminated from the world", "everything", HIGHER_FORCE_ANNOUNCE)
			current_hives -= H


	if(!living_hives)
		round_finished = "No one has won."
	else if (living_hives == 1)
		round_finished = "The [last_living_hive] has won."


///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/xenovs/check_finished()
	if(round_finished)
		return TRUE

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/xenovs/declare_completion()
	announce_ending()
	var/musical_track
	musical_track = pick('sound/theme/neutral_melancholy1.ogg', 'sound/theme/neutral_melancholy2.ogg')

	var/sound/S = sound(musical_track, channel = SOUND_CHANNEL_LOBBY)
	S.status = SOUND_STREAM
	sound_to(world, S)
	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.end_round_player_population = length(GLOB.clients)

		GLOB.round_statistics.log_round_statistics()

	declare_completion_announce_xenomorphs()
	calculate_end_statistics()
	declare_fun_facts()


	return TRUE

/datum/game_mode/xenovs/announce_ending()
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_round_end()
	log_game("Round end result: [round_finished]")
	to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("|Round Complete|"))
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDBODY("Thus ends the story of the battling hives on [SSmapping.configs[GROUND_MAP].map_name]. [round_finished]\nThe game-mode was: [GLOB.master_mode]!\n[CONFIG_GET(string/endofroundblurb)]"))

// for the toolbox
/datum/game_mode/xenovs/end_round_message()
	if(round_finished)
		return "Hive Wars Round has ended. [round_finished]"
	return "Hive Wars Round has ended. No one has won"
