/// How many smallhosts to preassigned players to spawn?
#define MONKEYS_TO_TOTAL_RATIO 1/32
/// When to start opening the podlocks identified as "map_lockdown" (takes 30s)
#define PODLOCKS_OPEN_WAIT (45 MINUTES) // CORSAT pod doors drop at 12:45
/// What percent do we consider a 'majority?' to win
#define MAJORITY 0.5

/datum/game_mode/survive
	name = GAMEMODE_SURVIVE
	config_tag = GAMEMODE_SURVIVE
	required_players = 1 //Need at least one player, but really we need 2.
	max_players = 50
	corpses_to_spawn = 0
	flags_round_type = MODE_SURVIVE|MODE_INFESTATION|MODE_FOG_ACTIVATED|MODE_NEW_SPAWN
	static_comms_amount = 1
	role_mappings = list(/datum/job/civilian/survivor/unlimited = JOB_SURVIVOR)
	survivors_by_insert_type_amounts = list()
	var/round_status_flags
	var/next_stat_check = 0
	var/list/running_round_stats = list()
	/// The shuttle (if any) spawned by initiate_evacuation
	var/obj/docking_port/mobile/emergency_response/shuttle
	/// Whether the queen has been released
	var/is_queen_released = FALSE

/datum/game_mode/survive/announce()
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("The current map is - [SSmapping.configs[GROUND_MAP].map_name]!"))

/datum/game_mode/survive/get_roles_list()
	return GLOB.ROLES_SURVIVE

/* Pre-setup */
/datum/game_mode/survive/pre_setup()
	QDEL_LIST(GLOB.hunter_primaries)
	QDEL_LIST(GLOB.hunter_secondaries)
	QDEL_LIST(GLOB.crap_items)
	QDEL_LIST(GLOB.good_items)

	// Spawn gamemode-specific map items
	if(SSmapping.configs[GROUND_MAP].map_item_type)
		var/type_to_spawn = SSmapping.configs[GROUND_MAP].map_item_type
		for(var/i in GLOB.map_items)
			var/turf/T = get_turf(i)
			qdel(i)
			new type_to_spawn(T)

	//desert river test
	if(!length(round_toxic_river))
		round_toxic_river = null //No tiles?
	else
		round_time_river = rand(-100,100)
		flags_round_type |= MODE_FOG_ACTIVATED

	..()

	if(!length(GLOB.observer_starts))
		var/obj/comms_poi = locate(/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms)
		var/turf/comms_turf = get_turf(comms_poi)
		if(comms_turf)
			new /obj/effect/landmark/observer_start(comms_turf)

	var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	main_hive.allow_queen_evolve = FALSE
	main_hive.evolution_without_ovipositor = TRUE
	main_hive.allow_no_queen_actions = TRUE
	main_hive.allow_no_queen_evo = TRUE

	var/obj/structure/tunnel/tunnel
	var/i = 0
	var/turf/location
	while(length(GLOB.xeno_tunnels) && i++ < 3)
		location = get_turf(pick_n_take(GLOB.xeno_tunnels))
		tunnel = new(location)
		tunnel.id = "hole[i]"
	return TRUE

/datum/game_mode/survive/spawn_static_comms()
	var/list/options = GLOB.comm_tower_landmarks_survivor
	if(!length(options))
		options = GLOB.comm_tower_landmarks_net_one + GLOB.comm_tower_landmarks_net_two
	for(var/i = 1 to static_comms_amount)
		var/obj/effect/landmark/static_comms/tower = pick_n_take(options)
		if(!tower)
			continue
		tower.spawn_tower()
	QDEL_LIST(GLOB.comm_tower_landmarks_net_one)
	QDEL_LIST(GLOB.comm_tower_landmarks_net_two)
	QDEL_LIST(GLOB.comm_tower_landmarks_survivor)

/datum/game_mode/survive/transform_queen(datum/mind/ghost_mind, turf/xeno_turf, hivenumber)
	var/turf/origin = locate(xeno_turf.x-3, xeno_turf.y-3, xeno_turf.z)
	var/turf/tunnel_spot = get_step(xeno_turf, EAST)
	var/datum/map_template/template = SSmapping.map_templates["Queen_Resin.dmm"]

	// Edgecase: Move any living mobs out of the way of the template while it loads
	var/turf/safe_spot = get_step(origin, WEST)
	var/list/existing_mobs = list()
	for(var/turf/current as anything in CORNER_BLOCK(origin, template.width, template.height))
		for(var/mob/living/obstruction in current)
			existing_mobs[obstruction] = current
			obstruction.forceMove(safe_spot)

	if(!template?.load(origin, centered=FALSE, delete=TRUE))
		stack_trace("Queen resin template failed to load!")

	// Move those mobs back
	for(var/mob/living/obstruction as anything in existing_mobs)
		obstruction.forceMove(existing_mobs[obstruction])

	// Make a tunnel
	var/obj/structure/tunnel/tunnel = new(tunnel_spot)
	tunnel.id = "queencave"

	return ..()

/* Post-setup */
/datum/game_mode/survive/post_setup()
	initialize_post_marine_gear_list()
	spawn_smallhosts()

	if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_BASIC_RT])
		flags_round_type |= MODE_BASIC_RT

	addtimer(CALLBACK(src, PROC_REF(mode_announcement)), 10 DECISECONDS)
	addtimer(CALLBACK(src, PROC_REF(map_announcement)), 20 SECONDS)
	addtimer(CALLBACK(SSentity_manager, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, select), /datum/entity/survivor_survival), 7 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(release_the_queen)), 30 MINUTES)

	. = ..()

	var/datum/job/antag/xenos/queen/queen_job = GLOB.RoleAuthority.roles_for_mode[JOB_XENOMORPH_QUEEN]
	if(queen_job && queen_job.current_positions)
		return .

	#ifdef RUNTIME_MAP
	return . // No queen spawns
	#endif

	// No roundstart queen so lets make a claimable one that does some basics
	var/obj/effect/landmark/queen_spawn/queen_spawn = SAFEPICK(GLOB.queen_spawns)
	var/turf/queen_location
	if(queen_spawn)
		queen_location = get_turf(queen_spawn)
	if(!queen_spawn)
		queen_location = get_turf(pick(GLOB.xeno_spawns))
	var/mob/living/carbon/xenomorph/queen/new_queen = transform_queen(null, queen_location)
	new_queen.auto_queen = TRUE
	addtimer(CALLBACK(src, PROC_REF(offer_to_ghosts), new_queen), 30 SECONDS)
	return .

/datum/game_mode/survive/proc/offer_to_ghosts(mob/living/carbon/xenomorph/queen/new_queen)
	if(!new_queen.client)
		new_queen.free_for_ghosts(TRUE, 'sound/effects/xeno_newlarva.ogg')

/datum/game_mode/survive/proc/spawn_smallhosts()
	if(!GLOB.players_preassigned)
		return

	monkey_types = SSmapping.configs[GROUND_MAP].monkey_types

	if(!length(monkey_types))
		return

	var/amount_to_spawn = ceil(GLOB.players_preassigned * MONKEYS_TO_TOTAL_RATIO)

	for(var/i in 0 to min(amount_to_spawn, length(GLOB.monkey_spawns)))
		var/turf/T = get_turf(pick_n_take(GLOB.monkey_spawns))
		var/monkey_to_spawn = pick(monkey_types)
		new monkey_to_spawn(T)

/datum/game_mode/survive/proc/mode_announcement()
	to_world(SPAN_ROUNDHEADER("The current game mode is - SURVIVAL!"))
	to_world(SPAN_ROUNDBODY("The colony on [SSmapping.configs[GROUND_MAP].map_name] has come under attack from alien forces."))
	to_world(SPAN_ROUNDBODY("Most survivors have already fled or perished, but maybe those left can manage to call for help."))
	to_world(SPAN_ROUNDBODY("Maybe if communications remain online long enough someone will receive the distress signal."))

/datum/game_mode/survive/proc/map_announcement()
	var/rendered_announce_text = SSmapping.configs[GROUND_MAP].survive_announce_text || "Attention. Attention. Evacuation order is in effect."
	survivor_announcement(rendered_announce_text, sound_to_play='sound/effects/siren.ogg')
	play_sfx_for_groundside_xenos('sound/effects/siren.ogg')
	lore_announcement()

/// A proc that will queue up announcements for the lore of the map.
/datum/game_mode/survive/proc/lore_announcement()
	switch(SSmapping.configs[GROUND_MAP].map_name)
		if(MAP_TYRARGO_RIFT)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_announcement), "My children. A great battle rages across this world, a world slathered in hosts for our taking! However, these hosts fight back with great ferocity. I have directed your sub-hive to this area, you will create a mighty cordon here to cover our western flank whilst another sub-hive overtakes a stronghold to your east that is filled with thousands of hosts!\n\nIn order to aid you, I have dispatched a legion of disposable drones ahead of you, they are far less intelligent than you, but will suffice in waylaying any remaining hostile hosts to your west until you have secured yourselves.", "everything", QUEEN_MOTHER_ANNOUNCE), 20 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_announcement), "Be on guard my children. I have sensed that the petrid sewers of this so called city could be flooded by the hosts at a moments notice if the hosts restore power to the area. The button to release this putrid water is found in the metal structure the hosts call the sewer treatement plant.", "everything", QUEEN_MOTHER_ANNOUNCE), 15 MINUTES)
		if(MAP_WHITE_ANTRE_RESEARCH_FACILITY)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(survivor_announcement), "Attention! The site is experiencing a massive containment breach! Full site lockdown initiated.", "White Antre Central Announcement", 'sound/ambience/containment_breach1.ogg'), 30 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(survivor_announcement), "Attention! We think Azure-15 has lured the bulk of the K-Series off site, but we are experiencing massive power failures, the Prime hive containment zone is at risk. All surviving personnel prepa%^@!&*------", "White Antre Central Announcement", 'sound/AI/commandreport.ogg'), 65 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(survivor_announcement), "Prime hive containment blastdoor failure imminent.", "Automated Facility Announcement", 'sound/AI/commandreport.ogg'), 165 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_lore_announcement), "Something is happening. Be on guard.", "everything", QUEEN_MOTHER_ANNOUNCE, 'sound/ambience/containment_breach1.ogg'), 30 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_announcement), "Another, hostile, hive is making an escape from this metal cage, prepare yourselves as a chance to escape may occur soon.", "everything", QUEEN_MOTHER_ANNOUNCE), 1.5 MINUTES)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_announcement), "My children. I sense the hostile, putrid, hive has fled this area, but some of the hosts that entrapped you remain alive within this metal complex. Defeat these hosts to showcase your supremacy!", "everything", QUEEN_MOTHER_ANNOUNCE), 165 SECONDS)

/// Plays the passed sfx for any xenos groundside
/datum/game_mode/survive/proc/play_sfx_for_groundside_xenos(sound/soundin, vol=45)
	for(var/mob/living/carbon/xenomorph as anything in GLOB.xeno_mob_list)
		var/turf/xeno_turf = get_turf(xenomorph)
		if(!xeno_turf || !is_ground_level(xeno_turf.z))
			continue
		playsound_client(xenomorph.client, soundin, vol=vol)

/datum/game_mode/survive/proc/initiate_evacuation()
	set waitfor = FALSE

	if(is_in_endgame)
		return

	is_in_endgame = TRUE
	force_end_at = world.time + 15 MINUTES
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_SURVIVOR_EVAC)

	release_the_queen()

	var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	main_hive.attempt_apply_hivebuff_admin(/datum/hivebuff/survival_evac_surge)

	var/hostile = SSnightmare.get_scenario_is_hostile_survivor() // ASSUMPTION: Only hostile type is CLF

	var/shuttle_id = hostile ? MOBILE_SHUTTLE_ID_ERT1 : MOBILE_SHUTTLE_ID_ERT_ALAMO
	var/datum/map_template/shuttle/new_shuttle = SSmapping.shuttle_templates[shuttle_id]
	shuttle = SSshuttle.load_template_to_transit(new_shuttle)
	shuttle.control_doors("force-lock", force=TRUE, external_only=TRUE)

	var/dock_options = list()
	for(var/obj/docking_port/stationary/dock as anything in SSshuttle.stationary)
		if(!is_ground_level(dock.z))
			continue
		if(shuttle.canDock(dock) != SHUTTLE_CAN_DOCK)
			continue
		dock_options += dock

	// Fallback: Try to convert dropship sized pads to ert pads
	if(!length(dock_options))
		for(var/obj/docking_port/stationary/dock as anything in SSshuttle.stationary)
			if(dock.dwidth != 0 && (dock.id == DROPSHIP_LZ1 || dock.id == DROPSHIP_LZ2))
				dock.dwidth = 0
				dock.width = 7
				dock.dheight = 0
				dock.height = 13
				switch(dock.dir)
					if(NORTH)
						dock.forceMove(locate(dock.x-3, dock.y-6, dock.z))
					if(EAST)
						dock.forceMove(locate(dock.x-6, dock.y+3, dock.z))
					if(SOUTH)
						dock.forceMove(locate(dock.x+3, dock.y+6, dock.z))
					if(WEST)
						dock.forceMove(locate(dock.x+6, dock.y-3, dock.z))
				if(shuttle.canDock(dock) == SHUTTLE_CAN_DOCK)
					dock_options += dock

	if(!length(dock_options))
		message_admins("Auto shuttle has no lzs available.")
		return

	var/obj/docking_port/stationary/dock = pick(dock_options)
	RegisterSignal(dock, COMSIG_SHUTTLE_PREARRIVAL, PROC_REF(on_shuttle_prearrival))
	RegisterSignal(dock, COMSIG_SHUTTLE_ARRIVAL, PROC_REF(on_shuttle_arrival))
	SSshuttle.moveShuttleToDock(shuttle, dock, TRUE)

	var/ert_type = hostile ? /datum/emergency_call/clf/survivor_response : /datum/emergency_call/solar_devils/survivor_response
	var/datum/emergency_call/ert = SSticker.mode.get_specific_call(ert_type, TRUE, FALSE)
	shuttle.distress_beacon = ert
	survivor_announcement("[ert.arrival_message] We are enroute to [dock].")

/// SIGNAL_HANDLER for COMSIG_SHUTTLE_PREARRIVAL to handle weedkiller smoke
/datum/game_mode/survive/proc/on_shuttle_prearrival(obj/docking_port/stationary/port, obj/docking_port/mobile/arriving_shuttle)
	SIGNAL_HANDLER

	var/hostile = SSnightmare.get_scenario_is_hostile_survivor() // ASSUMPTION: Only hostile type is CLF
	var/list/announcement_mobs = list()
	for(var/area/area as anything in arriving_shuttle.shuttle_areas)
		for(var/mob/mob in area)
			shake_camera(mob, steps = 3, strength = 1)
			announcement_mobs += mob
	announcement_helper("Dropship dispersing [/obj/effect/particle_effect/smoke/weedkiller::name] due to potential biological infestation.", hostile ? CLF_COMMAND_ANNOUNCE : MAIN_AI_SYSTEM, announcement_mobs, 'sound/effects/rocketpod_fire.ogg')

	var/obj/structure/machinery/computer/shuttle/console
	if(port.id == /obj/structure/machinery/computer/shuttle/dropship/flight/lz1::linked_lz)
		console = locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1)
	else if(port.id == /obj/structure/machinery/computer/shuttle/dropship/flight/lz2::linked_lz)
		console = locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz2)
	clear_proximity_resin(console)

/// SIGNAL_HANDLER for COMSIG_SHUTTLE_ARRIVAL to handle announcement to xenos and allow LZ weeding
/datum/game_mode/survive/proc/on_shuttle_arrival(obj/docking_port/stationary/port, obj/docking_port/mobile/arriving_shuttle)
	SIGNAL_HANDLER

	xeno_announcement(SPAN_XENOANNOUNCE("A dropship has landed. The tallhosts are escaping!"), "everything", QUEEN_MOTHER_ANNOUNCE)
	MODE_SET_MODIFIER(/datum/gamemode_modifier/lz_weeding, TRUE)
	RegisterSignal(port, COMSIG_SHUTTLE_DEPARTURE, PROC_REF(on_shuttle_depart))

	// Force LZ1 shutters to open on chances claim in case theres no responders to open it
	if(port.id == DROPSHIP_LZ1 && SSmapping.configs[GROUND_MAP].map_name == MAP_LV522_CHANCES_CLAIM)
		for(var/obj/structure/machinery/door/poddoor/shutter in GLOB.machines)
			if(shutter.id == "LZ1_Lockdown_Lo" && shutter.density)
				INVOKE_ASYNC(shutter, TYPE_PROC_REF(/obj/structure/machinery/door, open))

/// SIGNAL_HANDLER for COMSIG_SHUTTLE_DEPARTURE to handle antidelay
/datum/game_mode/survive/proc/on_shuttle_depart(obj/docking_port/stationary/port, obj/docking_port/mobile/arriving_shuttle)
	SIGNAL_HANDLER

	var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	main_hive?.check_antidelay(force=TRUE)

/datum/game_mode/survive/proc/clear_proximity_resin(obj/structure/machinery/computer/shuttle/dropship/flight/active_lz)
	if(!active_lz)
		return FALSE

	if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_weeding))
		msg_admin_niche("Skipped weed killer event due to lz_weeding modifier already getting set")
		return FALSE

	var/datum/cause_data/cause_data = create_cause_data(/obj/effect/particle_effect/smoke/weedkiller::name)

	for(var/area/near_area as anything in GLOB.all_areas)
		var/area_lz = near_area.linked_lz
		if(!area_lz)
			continue

		if(islist(area_lz))
			if(!(active_lz.linked_lz in area_lz))
				continue
		else if(area_lz != active_lz.linked_lz)
			continue

		for(var/turf/turf in near_area)
			if(turf.density)
				if(!istype(turf, /turf/closed/wall))
					continue
				var/turf/closed/wall/wall = turf
				if(wall.turf_flags & TURF_HULL)
					continue
			new /obj/effect/particle_effect/smoke/weedkiller(turf, null, cause_data)

		near_area.purge_weeds()

	return TRUE

/datum/game_mode/survive/proc/release_the_queen()
	is_queen_released = TRUE

	if(!length(GLOB.marked_atoms_by_id["queen_bubble"]))
		return

	for(var/obj/effect/marked_atom/marker as anything in GLOB.marked_atoms_by_id["queen_bubble"])
		addtimer(CALLBACK(src, PROC_REF(crumble_wall), marker.loc), rand(2 SECONDS))
		qdel(marker)

/datum/game_mode/survive/proc/crumble_wall(turf/wall)
	if(prob(50))
		playsound(wall, 'sound/effects/rock_creaking.ogg', 25, TRUE)
		wall.visible_message(SPAN_WARNING("[wall] crumbles apart!"))
	wall.ChangeTurf(/turf/open/auto_turf/hybrisa_auto_turf/layer1)

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/survive/process()
	. = ..()
	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if(!round_finished)
		// Automated bioscan / Queen Mother message
		if(world.time > bioscan_current_interval) //If world time is greater than required bioscan time.
			announce_bioscans() //Announce the results of the bioscan to both sides.
			bioscan_current_interval += bioscan_ongoing_interval //Add to the interval based on our set interval time.

		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			if(!(round_status_flags & ROUNDSTATUS_PODDOORS_OPEN))
				if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_LOCKDOWN])
					if(world.time >= (PODLOCKS_OPEN_WAIT + round_time_lobby))

						round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN

						for(var/i in GLOB.living_xeno_list)
							var/mob/M = i
							sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
							to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
							to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in 30 seconds."))
						addtimer(CALLBACK(src, PROC_REF(open_podlocks), "map_lockdown"), 300)

			if(GLOB.round_should_check_for_win)
				check_win()
			round_checkwin = 0

		if(!MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_weeding) && world.time >= SSticker.round_start_time + round_time_resin)
			MODE_SET_MODIFIER(/datum/gamemode_modifier/lz_weeding, TRUE)

		if(next_stat_check <= world.time)
			add_current_round_status_to_end_results((next_stat_check ? "" : "Round Start"))
			next_stat_check = world.time + 10 MINUTES

/datum/game_mode/survive/get_affected_zlevels()
	if(is_in_endgame)
		return SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED))
	return SSmapping.levels_by_trait(ZTRAIT_GROUND)

/**
 * Checks to see who won
 */
/datum/game_mode/survive/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return
	if(ROUND_TIME < 10 MINUTES)
		return

	if(SShijack?.sd_detonated)
		round_finished = MODE_SURVIVE_DRAW_DEATH // Self destruction.
		return

	var/list/living_player_list = count_humans_and_xenos(get_affected_zlevels())
	var/num_humans = living_player_list[1]
	var/num_xenos = living_player_list[2]

	if(!num_humans && num_xenos)
		round_finished = MODE_SURVIVE_X_MAJOR //No humans remain alive.
	else if(num_humans && !num_xenos)
		round_finished = MODE_SURVIVE_S_MAJOR //Humans destroyed the xenomorphs.
	else if(!num_humans && !num_xenos)
		round_finished = MODE_SURVIVE_DRAW_DEATH //Both were somehow destroyed.
	else if(force_end_at && world.time > force_end_at)
		round_finished = MODE_SURVIVE_X_MINOR // Times up.
	else if(is_in_endgame)
		var/list/ground_list = count_humans_and_xenos(SSmapping.levels_by_trait(ZTRAIT_GROUND))
		var/num_humans_ground = ground_list[1]
		//var/num_xenos_ground = ground_list[2]
		if(!num_humans_ground)
			round_finished = MODE_SURVIVE_S_EXTRACT //Evacuation successfully took place.

/datum/game_mode/survive/count_humans_and_xenos(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED, ZTRAIT_MARINE_MAIN_SHIP)))
	. = ..()
	if(.[2] != 0) // index 2 = num_xenos
		return .

	// Ensure there is no queen
	var/datum/hive_status/hive
	for(var/cur_number in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_number]
		if(hive.need_round_end_check && !hive.can_delay_round_end())
			continue
		if(hive.living_xeno_queen)
			var/turf/queen_turf = get_turf(hive.living_xeno_queen)
			var/in_z_levels = (queen_turf?.z in z_levels) && !should_block_game_interaction(queen_turf)
			if(!in_z_levels && queen_turf && SSinterior.in_interior(queen_turf))
				var/datum/interior/current_interior = SSinterior.get_interior_by_coords(queen_turf.x, queen_turf.y, queen_turf.z)
				if(current_interior?.exterior?.loc)
					queen_turf = current_interior.exterior.loc
					in_z_levels = (queen_turf.z in z_levels) && !should_block_game_interaction(queen_turf)
			if(in_z_levels)
				//Some Queen is alive, we shouldn't end the game yet
				.[2]++
	return .

/**
 * Checks if the round is over
 */
/datum/game_mode/survive/check_finished()
	if(round_finished)
		return TRUE
	return FALSE

/**
 * Announces the end of the game with all relevant information stated
 */
/datum/game_mode/survive/declare_completion()
	announce_ending()
	var/musical_track
	var/end_icon = "draw"
	switch(round_finished)
		if(MODE_SURVIVE_X_MAJOR)
			musical_track = pick('sound/theme/sad_loss1.ogg','sound/theme/sad_loss2.ogg')
			end_icon = "xeno_major"
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_xeno_slaughters++
				GLOB.round_statistics.current_map.total_xeno_slaughter_majors++
		if(MODE_SURVIVE_S_MAJOR)
			musical_track = pick('sound/theme/winning_triumph1.ogg','sound/theme/winning_triumph2.ogg','sound/theme/winning_triumph3.ogg')
			end_icon = "marine_major"
			var/static/list/faction_victories = list(
				"WY_headcount" = list(
					"musical_track" = 'sound/theme/lastmanstanding_wy.ogg',
					"end_icon" = "wy_major",
					"name" = "Weyland-Yutani",
				),
				"UPP_headcount" = list(
					"musical_track" = 'sound/theme/lastmanstanding_upp.ogg',
					"end_icon" = "upp_major",
					"name" = "Union of Progressive Peoples",
				),
				"CLF_headcount" = list(
					"musical_track" = 'sound/theme/lastmanstanding_clf.ogg',
					"end_icon" = "clf_major",
					"name" = "Colonial Liberation Front",
				),
				"TWE_headcount" = list(
					"musical_track" = 'sound/theme/lastmanstanding_twe.ogg',
					"end_icon" = "twe_major",
					"name" = "Three World Empire",
				),
				"marine_headcount" = list(
					"musical_track" = pick('sound/theme/winning_triumph1.ogg','sound/theme/winning_triumph2.ogg','sound/theme/winning_triumph3.ogg'),
					"end_icon" = "marine_major",
				),
			)
			var/list/headcount = count_per_faction()
			var/living = headcount["total_headcount"]
			for(var/faction in faction_victories)
				if((headcount[faction] / living) <= MAJORITY)
					continue
				var/list/victory = faction_victories[faction]
				musical_track = victory["musical_track"]
				end_icon = victory["end_icon"]
				var/faction_name = victory["name"]
				if(faction_name)
					var/victory_message = "3rd party victory: [faction_name]"
					log_game(victory_message)
					message_admins(victory_message)
				break
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_survivor_victories++
				GLOB.round_statistics.current_map.total_survivor_majors++
		if(MODE_SURVIVE_X_MINOR)
			var/list/living_player_list = count_humans_and_xenos(get_affected_zlevels())
			musical_track = 'sound/theme/neutral_melancholy1.ogg'
			end_icon = "xeno_minor"
			if(living_player_list[1] && !living_player_list[2]) // If Xeno Minor but Xenos are dead and Humans are alive, see which faction is the last standing
				var/static/list/faction_timeouts = list(
					"WY_headcount" = list(
						"musical_track" = 'sound/theme/lastmanstanding_wy.ogg',
						"end_icon" = "wy_major",
						"name" = "Weyland-Yutani",
					),
					"UPP_headcount" = list(
						"musical_track" = 'sound/theme/lastmanstanding_upp.ogg',
						"end_icon" = "upp_major",
						"name" = "Union of Progressive Peoples",
					),
					"CLF_headcount" = list(
						"musical_track" = 'sound/theme/lastmanstanding_clf.ogg',
						"end_icon" = "clf_major",
						"name" = "Colonial Liberation Front",
					),
					"TWE_headcount" = list(
						"musical_track" = 'sound/theme/lastmanstanding_twe.ogg',
						"end_icon" = "twe_major",
						"name" = "Three World Empire",
					),
					"marine_headcount" = list(
						"musical_track" = 'sound/theme/neutral_melancholy2.ogg', // This is the theme song for Colonial Marines the game, fitting
						"end_icon" = "xeno_minor",
					),
				)
				var/list/headcount = count_per_faction()
				var/living = headcount["total_headcount"]
				for(var/faction in faction_timeouts)
					if((headcount[faction] / living) <= MAJORITY)
						continue
					var/list/victory = faction_timeouts[faction]
					musical_track = victory["musical_track"]
					end_icon = victory["end_icon"]
					var/faction_name = victory["name"]
					if(faction_name)
						var/victory_message = "3rd party victory: [faction_name]"
						log_game(victory_message)
						message_admins(victory_message)
					break
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_xeno_slaughters++
		if(MODE_SURVIVE_S_EXTRACT)
			musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
			end_icon = "marine_minor"
			var/static/list/faction_extracts = list(
				"WY_headcount" = list(
					"musical_track" = 'sound/theme/lastmanstanding_wy.ogg',
					"end_icon" = "wy_major",
					"name" = "Weyland-Yutani",
				),
				"UPP_headcount" = list(
					"musical_track" = 'sound/theme/lastmanstanding_upp.ogg',
					"end_icon" = "upp_major",
					"name" = "Union of Progressive Peoples",
				),
				"CLF_headcount" = list(
					"musical_track" = 'sound/theme/lastmanstanding_clf.ogg',
					"end_icon" = "clf_major",
					"name" = "Colonial Liberation Front",
				),
				"TWE_headcount" = list(
					"musical_track" = 'sound/theme/lastmanstanding_twe.ogg',
					"end_icon" = "twe_major",
					"name" = "Three World Empire",
				),
				"marine_headcount" = list(
					"musical_track" = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg'),
					"end_icon" = "marine_minor",
				),
			)
			var/list/headcount = count_per_faction()
			var/living = headcount["total_headcount"]
			for(var/faction in faction_extracts)
				if((headcount[faction] / living) <= MAJORITY)
					continue
				var/list/victory = faction_extracts[faction]
				musical_track = victory["musical_track"]
				end_icon = victory["end_icon"]
				var/faction_name = victory["name"]
				if(faction_name)
					var/victory_message = "3rd party victory: [faction_name]"
					log_game(victory_message)
					message_admins(victory_message)
				break
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_survivor_victories++
		if(MODE_SURVIVE_DRAW_DEATH)
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_survivor_draws++
		else
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
	send_end_round_music(musical_track)
	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.round_result = round_finished
		GLOB.round_statistics.end_round_player_population = length(GLOB.clients)

		GLOB.round_statistics.log_round_statistics()

	for(var/mob/mob as anything in GLOB.alive_human_list)
		SEND_SIGNAL(mob, COMSIG_HUMAN_FINISHED_ROUND)

	calculate_end_statistics()
	show_end_statistics(end_icon)

	declare_completion_announce_xenomorphs()
	declare_completion_announce_predators()
	addtimer(CALLBACK(src, PROC_REF(declare_completion_announce_colony_joes)), 2 SECONDS)
	declare_completion_announce_medal_awards()
	declare_fun_facts()


	add_current_round_status_to_end_results("Round End")
	handle_round_results_statistics_output()

	GLOB.round_statistics?.save()

	return 1

/datum/game_mode/survive/announce_ending()
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_round_end()
	log_game("Round end result: [round_finished]")
	to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("|Round Complete:[round_finished]|"))
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDBODY("Thus ends the story of the brave men and women on [SSmapping.configs[GROUND_MAP].map_name].\nThe game-mode was: [GLOB.master_mode]!\n[CONFIG_GET(string/endofroundblurb)]"))

/datum/game_mode/survive/end_round_message()
	switch(round_finished)
		if(MODE_SURVIVE_X_MAJOR)
			return "Round has ended. Xeno Major Victory."
		if(MODE_SURVIVE_S_MAJOR)
			return "Round has ended. Survivor Major Victory."
		if(MODE_SURVIVE_X_MINOR)
			return "Round has ended. Xeno Minor Victory."
		if(MODE_SURVIVE_S_EXTRACT)
			return "Round has ended. Survivor Extraction Victory."
		if(MODE_SURVIVE_DRAW_DEATH)
			return "Round has ended. Draw."
	return "Round has ended in a strange way."

/datum/game_mode/survive/proc/add_current_round_status_to_end_results(special_round_status as text)
	var/players = GLOB.clients
	var/list/counted_humans = list()

	//organize our jobs in a readable and standard way
	for(var/job in GLOB.ROLES_SPECIAL)
		counted_humans[job] = 0

	var/list/counted_xenos = list()

	//organize our hives and castes in a readable and standard way | don't forget our pooled larva
	for(var/hive in ALL_XENO_HIVES)
		counted_xenos[hive] = list()
		for(var/caste in ALL_XENO_CASTES)
			counted_xenos[hive][caste] = 0
		counted_xenos[hive]["Pooled Larva"] = GLOB.hive_datum[hive].stored_larva

	//Run through all our clients
	//add up our marines by job type, surv numbers, and non-standard humans we don't care too much about
	//add up our xenos by hive and caste
	for(var/client/player_client in players)
		if(player_client.mob && player_client.mob.stat != DEAD)
			if(ishuman(player_client.mob))
				counted_humans[player_client.mob.job]++
			else if(isxeno(player_client.mob))
				var/mob/living/carbon/xenomorph/xeno = player_client.mob
				counted_xenos[xeno.hivenumber][xeno.caste_type]++

	var/list/total_data = list("special round status" = special_round_status, "round time" = duration2text(), "counted humans" = counted_humans, "counted xenos" = counted_xenos)
	running_round_stats = running_round_stats + list(total_data)

/datum/game_mode/survive/proc/handle_round_results_statistics_output()
	var/webhook = CONFIG_GET(string/round_results_webhook_url)

	if(!webhook)
		return

	var/datum/discord_embed/embed = new()
	embed.title = "[SSperf_logging.round?.id]"
	embed.description = "[round_stats.round_name]\n[round_stats.map_name]\n[end_round_message()]"

	var/list/webhook_info = list()
	webhook_info["embeds"] = list(embed.convert_to_list())

	var/list/headers = list()
	headers["Content-Type"] = "application/json"

	var/list/requests = list()

	var/datum/http_request/beginning_request = new()
	beginning_request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(webhook_info), headers, "tmp/response.json")

	requests += beginning_request

	for(var/list/round_status_report in running_round_stats)
		var/special_status = round_status_report["special round status"]
		var/round_time = round_status_report["round time"]

		var/field_name = "[special_status ? "[round_time] - [special_status]" : "[round_time]"]"

		var/total_non_standard = 0
		var/non_standard_job_text = ""
		var/incrementer = 0
		var/list/non_standard_job_report = round_status_report["counted humans"]
		for(var/job_type in non_standard_job_report)
			non_standard_job_text += "[job_type]: [non_standard_job_report[job_type]]"
			total_non_standard += non_standard_job_report[job_type]
			incrementer++
			if(incrementer < length(non_standard_job_report))
				non_standard_job_text += ", "

		var/list/hive_xeno_numbers = list()
		var/list/hive_caste_texts = list()
		for(var/hive in round_status_report["counted xenos"])
			var/hive_amount = 0
			var/hive_caste_text = ""
			incrementer = 0
			var/list/per_hive_status = round_status_report["counted xenos"][hive]
			for(var/hive_caste in per_hive_status)
				hive_caste_text += "[hive_caste]: [per_hive_status[hive_caste]]"
				hive_amount += per_hive_status[hive_caste]
				incrementer++
				if(incrementer < length(per_hive_status))
					hive_caste_text += ", "
			if(hive_amount)
				hive_xeno_numbers[hive] = hive_amount
				hive_caste_texts[hive] = hive_caste_text

		var/final_text = ""

		if(total_non_standard)
			final_text += "Non-standard jobs:\n[non_standard_job_text]\n\n"

		for(var/hive in hive_xeno_numbers)
			final_text += "[hive]\nXenos: [hive_xeno_numbers[hive]]\n\n"
			final_text += "Xeno castes:\n[hive_caste_texts[hive]]\n"

		var/datum/discord_embed/per_report_embed = new()
		per_report_embed.title = "[field_name]"
		per_report_embed.description = "[final_text]"

		var/list/per_report_webhook_info = list()
		per_report_webhook_info["embeds"] = list(per_report_embed.convert_to_list())

		var/datum/http_request/per_report_request = new()
		per_report_request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(per_report_webhook_info), headers, "tmp/response.json")
		requests += per_report_request

	var/incrementer = 1
	for(var/datum/http_request/request in requests)
		addtimer(CALLBACK(request, TYPE_PROC_REF(/datum/http_request, begin_async)), (2 * incrementer) SECONDS)
		incrementer++

/obj/effect/landmark/lv624/fog_blocker/survivor_evac/LateInitialize()
	if(!MODE_HAS_FLAG(MODE_SURVIVE))
		qdel(src)
		return

	new /obj/structure/blocker/fog/survivor_evac(loc, INFINITY)
	qdel(src)

/obj/effect/landmark/lv624/door_blocker/survivor_evac/LateInitialize()
	if(!MODE_HAS_FLAG(MODE_SURVIVE))
		qdel(src)
		return

	new /obj/structure/blocker/door/survivor_evac(loc, INFINITY)
	qdel(src)

//===================================================\\

			//SURVIVOR LATEJOIN INITIALIZE\\

//===================================================\\

/datum/game_mode/survive/proc/attempt_to_join_as_locker_survivor(mob/new_player/user)
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(user, SPAN_WARNING("The round is either not ready, or has already finished!"))
		return FALSE

	if(is_in_endgame)
		to_chat(user, SPAN_WARNING("It is too late to join this round. It will end in [DisplayTimeText(SSticker.mode.force_end_at - world.time, 1)]."))
		return FALSE

	if(ROUND_TIME > 15 MINUTES)
		to_chat(user, SPAN_WARNING("It is too late to join this round."))
		return FALSE

	if(!GLOB.enter_allowed)
		to_chat(user, SPAN_WARNING("There is an administrative lock on entering the game!"))
		return FALSE

	var/datum/job/civilian/survivor/unlimited/job = GLOB.RoleAuthority.roles_by_name[JOB_SURVIVOR_UNLIMITED]
	if(!job)
		return FALSE

	if(!user.client?.prefs.update_slot(job.title))
		return FALSE

	var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	if(main_hive.stored_larva > 0)
		to_chat(user, SPAN_WARNING("There are not enough xenomorph players to allow more survivors right now."))
		return FALSE

	if(!GLOB.RoleAuthority.assign_role(user, job, latejoin=TRUE)) // This updates current_positions so needs to be last
		if(GLOB.RoleAuthority.check_role_entry(user, job, latejoin=TRUE, ignore_positions=TRUE))
			to_chat(user, SPAN_WARNING("There are no more spawnpoints for late join available."))
		else
			to_chat(user, SPAN_WARNING("You are not elgible to play as a survivor."))
		return FALSE

	if(job.job_options && user.client?.prefs?.pref_special_job_options[job.title])
		job.handle_job_options(user.client.prefs.pref_special_job_options[job.title])
	var/mob/living/carbon/human/character = job.spawn_in_player(user, TRUE)
	if(istype(character))
		job.equip_job(character)
		if(character.client)
			var/client/client = character.client
			if(client.player_data && client.player_data.playtime_loaded && length(client.player_data.playtimes) == 0)
				msg_admin_niche("NEW PLAYER: <b>[key_name(user, 1, 1, 0)]</b>. IP: [user.lastKnownIP], CID: [user.computer_id]")
			send_tacmap_assets_latejoin(character)
			client.init_verbs()

	SSticker.mode.latejoin_update(job)

	var/latejoin_larva_drop = SSticker.mode.latejoin_larva_drop

	if(ROUND_TIME < XENO_ROUNDSTART_LATEJOIN_LARVA_TIME)
		latejoin_larva_drop = SSticker.mode.latejoin_larva_drop_early

	if(latejoin_larva_drop && SSticker.mode.latejoin_tally - SSticker.mode.latejoin_larva_used >= latejoin_larva_drop)
		SSticker.mode.latejoin_larva_used += latejoin_larva_drop
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(hive.latejoin_burrowed == TRUE)
				if(length(hive.totalXenos) && (hive.hive_location || ROUND_TIME < XENO_ROUNDSTART_LATEJOIN_LARVA_TIME))
					hive.stored_larva++
					hive.hive_ui.update_burrowed_larva()

	qdel(user)
	return TRUE

#undef MONKEYS_TO_TOTAL_RATIO
#undef PODLOCKS_OPEN_WAIT
#undef MAJORITY
