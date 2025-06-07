/// How many smallhosts to preassigned players to spawn?
#define MONKEYS_TO_TOTAL_RATIO 1/32
/// When to start opening the podlocks identified as "map_lockdown" (takes 30s)
#define PODLOCKS_OPEN_WAIT (45 MINUTES) // CORSAT pod doors drop at 12:45
/// How many pipes explode at a time during hijack?
#define HIJACK_EXPLOSION_COUNT 5
/// What percent do we consider a 'majority?' to win
#define MAJORITY 0.5
/// How long to delay the round completion (command is immediately notified)
#define MARINE_MAJOR_ROUND_END_DELAY (3 MINUTES)
/// The ratio of forsaken to groundside humans before calling more forsaken xenos
#define GROUNDSIDE_XENO_MULTIPLIER 1.0

/datum/game_mode/colonialmarines
	name = "Distress Signal"
	config_tag = "Distress Signal"
	required_players = 1 //Need at least one player, but really we need 2.
	xeno_required_num = 1 //Need at least one xeno.
	monkey_amount = 5
	corpses_to_spawn = 0
	flags_round_type = MODE_INFESTATION|MODE_FOG_ACTIVATED|MODE_NEW_SPAWN
	static_comms_amount = 1
	var/round_status_flags
	var/next_stat_check = 0
	var/list/running_round_stats = list()
	var/list/lz_smoke = list()

	/**
	 * How long, after first drop, should the resin protection in proximity to the selected LZ last
	 */
	var/near_lz_protection_delay = 8 MINUTES

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Pre-pre-startup */
/datum/game_mode/colonialmarines/can_start(bypass_checks = FALSE)
	initialize_special_clamps()
	return TRUE

/datum/game_mode/colonialmarines/announce()
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("The current map is - [SSmapping.configs[GROUND_MAP].map_name]!"))

/datum/game_mode/colonialmarines/get_roles_list()
	return GLOB.ROLES_DISTRESS_SIGNAL

////////////////////////////////////////////////////////////////////////////////////////
//Temporary, until we sort this out properly.
/obj/effect/landmark/lv624
	icon = 'icons/landmarks.dmi'

/obj/effect/landmark/lv624/fog_blocker
	name = "fog blocker"
	icon_state = "fog"

	var/time_to_dispel = 25 MINUTES

/obj/effect/landmark/lv624/fog_blocker/short
	time_to_dispel = 15 MINUTES

/obj/effect/landmark/lv624/fog_blocker/Initialize(mapload, ...)
	. = ..()

	return INITIALIZE_HINT_ROUNDSTART

/obj/effect/landmark/lv624/fog_blocker/LateInitialize()
	if(!(SSticker.mode.flags_round_type & MODE_FOG_ACTIVATED) || !SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_FOG])
		return

	new /obj/structure/blocker/fog(loc, time_to_dispel)
	qdel(src)

/obj/effect/landmark/lv624/xeno_tunnel
	name = "xeno tunnel"
	icon_state = "xeno_tunnel"

/obj/effect/landmark/lv624/xeno_tunnel/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_tunnels += src

/obj/effect/landmark/lv624/xeno_tunnel/Destroy()
	GLOB.xeno_tunnels -= src
	return ..()

////////////////////////////////////////////////////////////////////////////////////////

/* Pre-setup */
/datum/game_mode/colonialmarines/pre_setup()
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

	var/obj/structure/tunnel/T
	var/i = 0
	var/turf/t
	while(length(GLOB.xeno_tunnels) && i++ < 3)
		t = get_turf(pick_n_take(GLOB.xeno_tunnels))
		T = new(t)
		T.id = "hole[i]"
	return TRUE

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Post-setup */
//This happens after create_character, so our mob SHOULD be valid and built by now, but without job data.
//We move it later with transform_survivor but they might flicker at any start_loc spawn landmark effects then disappear.
//Xenos and survivors should not spawn anywhere until we transform them.
/datum/game_mode/colonialmarines/post_setup()
	initialize_post_marine_gear_list()
	spawn_smallhosts()

	if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_BASIC_RT])
		flags_round_type |= MODE_BASIC_RT

	addtimer(CALLBACK(src, PROC_REF(ares_online)), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(map_announcement)), 20 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(start_lz_hazards)), DISTRESS_LZ_HAZARD_START)
	addtimer(CALLBACK(src, PROC_REF(ares_command_check)), 2 MINUTES)
	addtimer(CALLBACK(SSentity_manager, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, select), /datum/entity/survivor_survival), 7 MINUTES)
	GLOB.chemical_data.reroll_chemicals()

	return ..()

/datum/game_mode/colonialmarines/ds_first_landed(obj/docking_port/stationary/marine_dropship)
	. = ..()
	clear_lz_hazards() // This shouldn't normally do anything, but is here just in case

	// Assumption: Shuttle origin is its center
	// Assumption: dwidth is atleast 2 and dheight is atleast 4 otherwise there will be overlap
	var/list/options = list()
	var/list/structures_to_break = list(/obj/structure/barricade, /obj/structure/surface/table, /obj/structure/bed)
	var/bottom = marine_dropship.y - marine_dropship.dheight - 2
	var/top = marine_dropship.y + marine_dropship.dheight + 2
	var/left = marine_dropship.x - marine_dropship.dwidth - 2
	var/right = marine_dropship.x + marine_dropship.dwidth + 2
	var/z = marine_dropship.z

	var/dropship_type = marine_dropship.type

	// Bottom left
	if(GLOB.sentry_spawns[dropship_type]?[SENTRY_BOTTOM_LEFT])
		options += GLOB.sentry_spawns[dropship_type][SENTRY_BOTTOM_LEFT]
	else
		options += get_valid_sentry_turfs(left, bottom, z, width=5, height=2, structures_to_ignore=structures_to_break)
		options += get_valid_sentry_turfs(left, bottom + 2, z, width=2, height=6, structures_to_ignore=structures_to_break)
	spawn_lz_sentry(pick(options), structures_to_break)

	// Bottom right
	options.Cut()
	if(GLOB.sentry_spawns[dropship_type]?[SENTRY_BOTTOM_RIGHT])
		options += GLOB.sentry_spawns[dropship_type][SENTRY_BOTTOM_RIGHT]
	else
		options += get_valid_sentry_turfs(right-4, bottom, z, width=5, height=2, structures_to_ignore=structures_to_break)
		options += get_valid_sentry_turfs(right-1, bottom + 2, z, width=2, height=6, structures_to_ignore=structures_to_break)
	spawn_lz_sentry(pick(options), structures_to_break)

	// Top left
	options.Cut()
	if(GLOB.sentry_spawns[dropship_type]?[SENTRY_TOP_LEFT])
		options += GLOB.sentry_spawns[dropship_type][SENTRY_TOP_LEFT]
	else
		options += get_valid_sentry_turfs(left, top-1, z, width=5, height=2, structures_to_ignore=structures_to_break)
		options += get_valid_sentry_turfs(left, top-7, z, width=2, height=6, structures_to_ignore=structures_to_break)
	spawn_lz_sentry(pick(options), structures_to_break)

	// Top right
	options.Cut()
	if(GLOB.sentry_spawns[dropship_type]?[SENTRY_TOP_RIGHT])
		options += GLOB.sentry_spawns[dropship_type][SENTRY_TOP_RIGHT]
	else
		options += get_valid_sentry_turfs(right-4, top-1, z, width=5, height=2, structures_to_ignore=structures_to_break)
		options += get_valid_sentry_turfs(right-1, top-7, z, width=2, height=6, structures_to_ignore=structures_to_break)
	spawn_lz_sentry(pick(options), structures_to_break)

///Returns a list of non-dense turfs using the given block arguments ignoring the provided structure types
/datum/game_mode/colonialmarines/proc/get_valid_sentry_turfs(left, bottom, z, width, height, list/structures_to_ignore)
	var/valid_turfs = list()
	for(var/turf/turf as anything in block(left, bottom, z, left+width-1, bottom+height-1))
		if(turf.density)
			continue
		var/structure_blocking = FALSE
		for(var/obj/structure/existing_structure in turf)
			if(!existing_structure.density)
				continue
			if(!is_type_in_list(existing_structure, structures_to_ignore))
				structure_blocking = TRUE
				break
		if(structure_blocking)
			continue
		valid_turfs += turf
	return valid_turfs

///Spawns a droppod with a temporary defense sentry at the given turf
/datum/game_mode/colonialmarines/proc/spawn_lz_sentry(turf/target, list/structures_to_break)
	var/obj/structure/droppod/equipment/sentry_holder/droppod = new(target, /obj/structure/machinery/sentry_holder/landing_zone)
	droppod.special_structures_to_damage = structures_to_break
	droppod.special_structure_damage = 500
	droppod.drop_time = 0
	droppod.launch(target)

///Creates an OB warning at each LZ to warn of the miasma and then spawns the miasma
/datum/game_mode/colonialmarines/proc/start_lz_hazards()
	if(SSobjectives.first_drop_complete)
		return // Just for sanity
	if(!MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_roundstart_miasma))
		return

	log_game("Distress Signal LZ hazards active!")
	INVOKE_ASYNC(src, PROC_REF(warn_lz_hazard), locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1))
	INVOKE_ASYNC(src, PROC_REF(warn_lz_hazard), locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz2))
	addtimer(CALLBACK(src, PROC_REF(spawn_lz_hazards)), OB_TRAVEL_TIMING + 1 SECONDS)

///Creates an OB warning at each LZ to warn of the incoming miasma
/datum/game_mode/colonialmarines/proc/warn_lz_hazard(lz)
	if(!lz)
		return
	var/turf/target = get_turf(lz)
	if(!target)
		return
	var/obj/structure/ob_ammo/warhead/explosive/warhead = new
	warhead.name = "\improper CN20-X miasma warhead"
	warhead.clear_power = 0
	warhead.clear_falloff = 400
	warhead.standard_power = 0
	warhead.standard_falloff = 30
	warhead.clear_delay = 3
	warhead.double_explosion_delay = 6
	warhead.warhead_impact(target) // This is a blocking call
	playsound(target, 'sound/effects/smoke.ogg', vol=50, vary=1, sound_range=75)

///Spawns miasma smoke in landing zones
/datum/game_mode/colonialmarines/proc/spawn_lz_hazards()
	var/datum/cause_data/new_cause_data = create_cause_data("CN20-X miasma")
	for(var/area/area in GLOB.all_areas)
		if(!area.is_landing_zone)
			continue
		if(!is_ground_level(area.z))
			continue
		for(var/turf/turf in area)
			if(turf.density)
				if(!istype(turf, /turf/closed/wall))
					continue
				var/turf/closed/wall/wall = turf
				if(wall.turf_flags & TURF_HULL)
					continue
			lz_smoke += new /obj/effect/particle_effect/smoke/miasma(turf, null, new_cause_data)

///Clears miasma smoke in landing zones
/datum/game_mode/colonialmarines/proc/clear_lz_hazards()
	for(var/obj/effect/particle_effect/smoke/miasma/smoke as anything in lz_smoke)
		smoke.time_to_live = rand(1, 5)
	lz_smoke.Cut()

/// Called during the dropship flight, clears resin and indicates to those in flight that resin near the LZ has been cleared.
/datum/game_mode/colonialmarines/proc/warn_resin_clear(obj/docking_port/mobile/marine_dropship)
	if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_weeding))
		msg_admin_niche("Skipped weed killer event due to lz_weeding modifier already getting set")
		return

	clear_proximity_resin()

	var/list/announcement_mobs = list()
	for(var/area/area in marine_dropship.shuttle_areas)
		for(var/mob/mob in area)
			shake_camera(mob, steps = 3, strength = 1)
			announcement_mobs += mob

	announcement_helper("Dropship [marine_dropship.name] dispersing [/obj/effect/particle_effect/smoke/weedkiller::name] due to potential biological infestation.", MAIN_AI_SYSTEM, announcement_mobs, 'sound/effects/rocketpod_fire.ogg')

/**
 * Clears any built resin in the areas around the landing zone,
 * when the dropship first deploys.
 */
/datum/game_mode/colonialmarines/proc/clear_proximity_resin()
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

	addtimer(CALLBACK(src, PROC_REF(allow_proximity_resin)), near_lz_protection_delay)

/**
 * If the area was previously weedable, and this was disabled by the
 * LZ proximity, re-enable the weedability
 */
/datum/game_mode/colonialmarines/proc/allow_proximity_resin()
	for(var/area/near_area as anything in GLOB.all_areas)
		var/area_lz = near_area.linked_lz
		if(!area_lz)
			continue

		if(area_lz != active_lz.linked_lz)
			continue

		if(initial(near_area.is_resin_allowed) == FALSE)
			continue

		near_area.is_resin_allowed = TRUE

/datum/game_mode/colonialmarines/proc/spawn_smallhosts()
	if(!GLOB.players_preassigned)
		return

	monkey_types = SSmapping.configs[GROUND_MAP].monkey_types

	if(!length(monkey_types))
		return

	var/amount_to_spawn = floor(GLOB.players_preassigned * MONKEYS_TO_TOTAL_RATIO)

	for(var/i in 0 to min(amount_to_spawn, length(GLOB.monkey_spawns)))
		var/turf/T = get_turf(pick_n_take(GLOB.monkey_spawns))
		var/monkey_to_spawn = pick(monkey_types)
		new monkey_to_spawn(T)

/datum/game_mode/colonialmarines/proc/map_announcement()
	if(SSmapping.configs[GROUND_MAP].announce_text)
		var/rendered_announce_text = replacetext(SSmapping.configs[GROUND_MAP].announce_text, "###SHIPNAME###", MAIN_SHIP_NAME)
		marine_announcement(rendered_announce_text, "[MAIN_SHIP_NAME]")

/datum/game_mode/proc/ares_command_check()
	var/role_in_charge
	var/mob/living/carbon/human/person_in_charge

	var/list/role_needs_id = list(JOB_SO, JOB_CHIEF_ENGINEER, JOB_DROPSHIP_PILOT, JOB_CAS_PILOT, JOB_INTEL)
	var/list/role_needs_comms = list(JOB_CHIEF_POLICE, JOB_CMO, JOB_CHIEF_ENGINEER, JOB_DROPSHIP_PILOT, JOB_CAS_PILOT, JOB_INTEL)
	var/announce_addendum

	var/datum/squad/intel_squad = GLOB.RoleAuthority.squads_by_type[/datum/squad/marine/intel]
	var/list/intel_officers = intel_squad.marines_list

	//Basically this follows the list of command staff in order of CoC,
	//then if the role lacks senior command access it gives the person that access

	if(GLOB.marine_leaders[JOB_CO] || GLOB.marine_leaders[JOB_XO])
		return
	//If we have a CO or XO, we're good no need to announce anything.

	for(var/job_by_chain in CHAIN_OF_COMMAND_ROLES)
		role_in_charge = job_by_chain

		if(job_by_chain == JOB_SO && GLOB.marine_leaders[JOB_SO])
			person_in_charge = pick(GLOB.marine_leaders[JOB_SO])
			break
		if(job_by_chain == JOB_INTEL && !!length(intel_officers))
			person_in_charge = pick(intel_officers)
			break
		//If the job is a list we have to stop here
		if(person_in_charge)
			continue

		var/datum/job/job_datum = GLOB.RoleAuthority.roles_for_mode[job_by_chain]
		person_in_charge = job_datum.get_active_player_on_job()
		if(!isnull(person_in_charge))
			break

	if(isnull(person_in_charge))
		return

	if(LAZYFIND(role_needs_comms, role_in_charge))
		//If the role needs comms we let them know about the headset.
		announce_addendum += "\nA Command headset is availible in the CIC Command Tablet cabinet."

	if(LAZYFIND(role_needs_id, role_in_charge))
		//If the role needs senior command access, we need to add it to the ID card.
		var/obj/item/card/id/card = person_in_charge.get_idcard()
		if(card)
			var/list/access = card.access
			access.Add(ACCESS_MARINE_SENIOR)
			announce_addendum += "\nSenior Command access added to ID."

	//does an announcement to the crew about the commander & alerts admins to that change for logs.
	shipwide_ai_announcement("Due to the absence of command staff, commander authority now falls to [role_in_charge] [person_in_charge], who will assume command until further notice. Please direct all inquiries and follow instructions accordingly. [announce_addendum]", MAIN_AI_SYSTEM, 'sound/misc/interference.ogg')
	message_admins("[key_name(person_in_charge, 1)] [ADMIN_JMP_USER(person_in_charge)] has been designated the operation commander.")
	return


/datum/game_mode/colonialmarines/proc/ares_conclude()
	ai_silent_announcement("Bioscan complete. No unknown lifeform signature detected.", ".V")
	ai_silent_announcement("Saving operational report to archive.", ".V")
	ai_silent_announcement("Commencing final systems scan in 3 minutes.", ".V")

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/colonialmarines/process()
	. = ..()
	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if(is_in_endgame)
		check_hijack_explosions()
		check_ground_humans()

	if(GLOB.chemical_data.next_reroll < world.time)
		GLOB.chemical_data.reroll_chemicals()

	if(!round_finished)
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!hive.xeno_queen_timer)
				continue

			if(!hive.living_xeno_queen && hive.xeno_queen_timer < world.time)
				xeno_message("The Hive is ready for a new Queen to evolve.", 3, hive.hivenumber)

		if(!active_lz && world.time > lz_selection_timer)
			select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1))

		// Automated bioscan / Queen Mother message
		if(world.time > bioscan_current_interval) //If world time is greater than required bioscan time.
			announce_bioscans() //Announce the results of the bioscan to both sides.
			bioscan_current_interval += bioscan_ongoing_interval //Add to the interval based on our set interval time.

		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			if(!(round_status_flags & ROUNDSTATUS_PODDOORS_OPEN))
				if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_LOCKDOWN])
					if(world.time >= (PODLOCKS_OPEN_WAIT + round_time_lobby))

						round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN

						var/input = "Security lockdown will be lifting in 30 seconds per automated lockdown protocol."
						var/name = "Automated Security Authority Announcement"
						marine_announcement(input, name, 'sound/AI/commandreport.ogg')
						for(var/i in GLOB.living_xeno_list)
							var/mob/M = i
							sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
							to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
							to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in 30 seconds."))
						addtimer(CALLBACK(src, PROC_REF(open_podlocks), "map_lockdown"), 300)

			if(GLOB.round_should_check_for_win)
				check_win()
			round_checkwin = 0

		if(!evolution_ovipositor_threshold && world.time >= SSticker.round_start_time + round_time_evolution_ovipositor)
			for(var/hivenumber in GLOB.hive_datum)
				hive = GLOB.hive_datum[hivenumber]
				hive.evolution_without_ovipositor = FALSE
				if(hive.living_xeno_queen && !hive.living_xeno_queen.ovipositor)
					to_chat(hive.living_xeno_queen, SPAN_XENODANGER("It is time to settle down and let your children grow."))
			evolution_ovipositor_threshold = TRUE
			msg_admin_niche("Xenomorphs now require the queen's ovipositor for evolution progress.")

		if(!MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_weeding) && world.time >= SSticker.round_start_time + round_time_resin)
			MODE_SET_MODIFIER(/datum/gamemode_modifier/lz_weeding, TRUE)

		if(next_stat_check <= world.time)
			add_current_round_status_to_end_results((next_stat_check ? "" : "Round Start"))
			next_stat_check = world.time + 10 MINUTES

/**
 * Primes and fires off the explodey-pipes during hijack.
 */
/datum/game_mode/colonialmarines/proc/check_hijack_explosions()
	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_HIJACK_BARRAGE))
		return

	var/list/shortly_exploding_pipes = list()
	for(var/i = 1 to HIJACK_EXPLOSION_COUNT)
		shortly_exploding_pipes += pick(GLOB.mainship_pipes)

	for(var/obj/structure/pipes/exploding_pipe as anything in shortly_exploding_pipes)
		exploding_pipe.warning_explode(5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(shake_ship)), 5 SECONDS)
	TIMER_COOLDOWN_START(src, COOLDOWN_HIJACK_BARRAGE, 15 SECONDS)

///Checks for humans groundside after hijack, spawns forsaken if requirements met
/datum/game_mode/colonialmarines/proc/check_ground_humans()
	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_HIJACK_GROUND_CHECK))
		return

	var/groundside_humans = 0
	var/groundside_xenos = 0

	for(var/mob/current_mob in GLOB.player_list)
		if(!is_ground_level(current_mob.z) || !current_mob.client || current_mob.stat == DEAD)
			continue

		if(ishuman_strict(current_mob))
			groundside_humans++
			continue

		if(isxeno(current_mob))
			groundside_xenos++
			continue

	if(groundside_humans > (groundside_xenos * GROUNDSIDE_XENO_MULTIPLIER))
		SSticker.mode.get_specific_call(/datum/emergency_call/forsaken_xenos, TRUE, FALSE) // "Xenomorphs Groundside (Forsaken)"

	TIMER_COOLDOWN_START(src, COOLDOWN_HIJACK_GROUND_CHECK, 1 MINUTES)

/**
 * Makes the mainship shake, along with playing a klaxon sound effect.
 */
/datum/game_mode/colonialmarines/proc/shake_ship()
	for(var/mob/current_mob in GLOB.living_mob_list)
		if(!is_mainship_level(current_mob.z))
			continue
		shake_camera(current_mob, 3, 1)

	playsound_z(SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP)), 'sound/effects/double_klaxon.ogg', volume = 10)

// Resource Towers

/datum/game_mode/colonialmarines/ds_first_drop(obj/docking_port/mobile/marine_dropship)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_blurb_uscm)), DROPSHIP_DROP_MSG_DELAY)
	addtimer(CALLBACK(src, PROC_REF(warn_resin_clear), marine_dropship), DROPSHIP_DROP_FIRE_DELAY)
	DB_ENTITY(/datum/entity/survivor_survival) // Record surv survival right now
	addtimer(CALLBACK(SSentity_manager, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, select), /datum/entity/survivor_survival), 7 MINUTES) // And 7 minutes after drop. By then, marines will have found them, most likely

	add_current_round_status_to_end_results("First Drop")
	clear_lz_hazards()

///////////////////////////
//Checks to see who won///
//////////////////////////
/datum/game_mode/colonialmarines/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return
	if(ROUND_TIME < 10 MINUTES)
		return
	var/living_player_list[] = count_humans_and_xenos(get_affected_zlevels())
	var/num_humans = living_player_list[1]
	var/num_xenos = living_player_list[2]

	if(force_end_at && world.time > force_end_at)
		round_finished = MODE_INFESTATION_X_MINOR

	if(!num_humans && num_xenos) //No humans remain alive.
		round_finished = MODE_INFESTATION_X_MAJOR //Evacuation did not take place. Everyone died.
	else if(num_humans && !num_xenos)
		if(SSticker.mode && SSticker.mode.is_in_endgame)
			round_finished = MODE_INFESTATION_X_MINOR //Evacuation successfully took place.
		else
			SSticker.roundend_check_paused = TRUE
			round_finished = MODE_INFESTATION_M_MAJOR //Humans destroyed the xenomorphs.
			ares_conclude()
			addtimer(VARSET_CALLBACK(SSticker, roundend_check_paused, FALSE), MARINE_MAJOR_ROUND_END_DELAY)
	else if(!num_humans && !num_xenos)
		round_finished = MODE_INFESTATION_DRAW_DEATH //Both were somehow destroyed.

/datum/game_mode/colonialmarines/count_humans_and_xenos(list/z_levels)
	. = ..()
	if(.[2] != 0) // index 2 = num_xenos
		return .

	// Ensure there is no queen
	var/datum/hive_status/hive
	for(var/cur_number in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_number]
		if(hive.need_round_end_check && !hive.can_delay_round_end())
			continue
		if(hive.living_xeno_queen && !should_block_game_interaction(hive.living_xeno_queen.loc))
			//Some Queen is alive, we shouldn't end the game yet
			.[2]++
	return .

/datum/game_mode/colonialmarines/check_queen_status(hivenumber, immediately = FALSE)
	if(!(flags_round_type & MODE_INFESTATION))
		return

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(hive.need_round_end_check && !hive.can_delay_round_end())
		return

	if(!immediately)
		//We want to make sure that another queen didn't die in the interim.
		addtimer(CALLBACK(src, PROC_REF(check_queen_status), hivenumber, TRUE), QUEEN_DEATH_COUNTDOWN, TIMER_UNIQUE|TIMER_OVERRIDE)
		return

	if(round_finished)
		return

	for(var/cur_number in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_number]
		if(hive.need_round_end_check && !hive.can_delay_round_end())
			continue
		if(hive.living_xeno_queen && !should_block_game_interaction(hive.living_xeno_queen.loc))
			//Some Queen is alive, we shouldn't end the game yet
			return

	if(length(hive.totalXenos) <= 3)
		round_finished = MODE_INFESTATION_M_MAJOR
	else
		round_finished = MODE_INFESTATION_M_MINOR

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/colonialmarines/check_finished()
	if(round_finished)
		return 1

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////

/datum/game_mode/colonialmarines/declare_completion()
	announce_ending()
	var/musical_track
	var/end_icon = "draw"
	switch(round_finished)
		if(MODE_INFESTATION_X_MAJOR)
			musical_track = pick('sound/theme/sad_loss1.ogg','sound/theme/sad_loss2.ogg')
			end_icon = "xeno_major"
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_xeno_victories++
				GLOB.round_statistics.current_map.total_xeno_majors++
		if(MODE_INFESTATION_M_MAJOR)
			musical_track = pick('sound/theme/winning_triumph1.ogg','sound/theme/winning_triumph2.ogg')
			end_icon = "marine_major"
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_marine_victories++
				GLOB.round_statistics.current_map.total_marine_majors++
		if(MODE_INFESTATION_X_MINOR)
			var/list/living_player_list = count_humans_and_xenos(get_affected_zlevels())
			end_icon = "xeno_minor"
			if(living_player_list[1] && !living_player_list[2]) // If Xeno Minor but Xenos are dead and Humans are alive, see which faction is the last standing
				var/headcount = count_per_faction()
				var/living = headcount["total_headcount"]
				if ((headcount["WY_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/lastmanstanding_wy.ogg')
					end_icon = "wy_major"
					log_game("3rd party victory: Weyland-Yutani")
					message_admins("3rd party victory: Weyland-Yutani")
				else if ((headcount["UPP_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/lastmanstanding_upp.ogg')
					end_icon = "upp_major"
					log_game("3rd party victory: Union of Progressive Peoples")
					message_admins("3rd party victory: Union of Progressive Peoples")
				else if ((headcount["CLF_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/lastmanstanding_clf.ogg')
					end_icon = "upp_major"
					log_game("3rd party victory: Colonial Liberation Front")
					message_admins("3rd party victory: Colonial Liberation Front")
				else if ((headcount["marine_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/neutral_melancholy2.ogg') //This is the theme song for Colonial Marines the game, fitting
			else
				musical_track = pick('sound/theme/neutral_melancholy1.ogg')
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_xeno_victories++
		if(MODE_INFESTATION_M_MINOR)
			musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
			end_icon = "marine_minor"
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_marine_victories++
		if(MODE_INFESTATION_DRAW_DEATH)
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_draws++
		else
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
	var/sound/theme = sound(musical_track, channel = SOUND_CHANNEL_LOBBY)
	theme.status = SOUND_STREAM
	sound_to(world, theme)
	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.round_result = round_finished
		GLOB.round_statistics.end_round_player_population = length(GLOB.clients)

		GLOB.round_statistics.log_round_statistics()

	calculate_end_statistics()
	show_end_statistics(end_icon)

	declare_completion_announce_fallen_soldiers()
	declare_completion_announce_xenomorphs()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	declare_fun_facts()


	add_current_round_status_to_end_results("Round End")
	handle_round_results_statistics_output()

	GLOB.round_statistics?.save()

	return 1

// for the toolbox
/datum/game_mode/colonialmarines/end_round_message()
	switch(round_finished)
		if(MODE_INFESTATION_X_MAJOR)
			return "Round has ended. Xeno Major Victory."
		if(MODE_INFESTATION_M_MAJOR)
			return "Round has ended. Marine Major Victory."
		if(MODE_INFESTATION_X_MINOR)
			return "Round has ended. Xeno Minor Victory."
		if(MODE_INFESTATION_M_MINOR)
			return "Round has ended. Marine Minor Victory."
		if(MODE_INFESTATION_DRAW_DEATH)
			return "Round has ended. Draw."
	return "Round has ended in a strange way."

/datum/game_mode/colonialmarines/proc/add_current_round_status_to_end_results(special_round_status as text)
	var/players = GLOB.clients
	var/list/counted_humans = list(
		"Squad Marines" = list(),
		"Auxiliary Marines" = list(),
		"Non-Standard Humans" = list()
	)

	//organize our jobs in a readable and standard way
	for(var/job in GLOB.ROLES_MARINES)
		counted_humans["Squad Marines"][job] = 0
	for(var/job in GLOB.ROLES_USCM - GLOB.ROLES_MARINES)
		counted_humans["Auxiliary Marines"][job] = 0
	for(var/job in GLOB.ROLES_SPECIAL)
		counted_humans["Non-Standard Humans"][job] = 0

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
				if(player_client.mob.faction == FACTION_MARINE)
					if(player_client.mob.job in (GLOB.ROLES_MARINES))
						counted_humans["Squad Marines"][player_client.mob.job]++
					else
						counted_humans["Auxiliary Marines"][player_client.mob.job]++
				else
					counted_humans["Non-Standard Humans"][player_client.mob.job]++
			else if(isxeno(player_client.mob))
				var/mob/living/carbon/xenomorph/xeno = player_client.mob
				counted_xenos[xeno.hivenumber][xeno.caste_type]++

	var/list/total_data = list("special round status" = special_round_status, "round time" = duration2text(), "counted humans" = counted_humans, "counted xenos" = counted_xenos)
	running_round_stats = running_round_stats + list(total_data)

/datum/game_mode/colonialmarines/proc/handle_round_results_statistics_output()
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

		var/total_marines = 0
		var/total_squad_marines = 0

		var/squad_marine_job_text = ""
		var/list/squad_marines_job_report = round_status_report["counted humans"]["Squad Marines"]
		var/incrementer = 0
		for(var/job_type in squad_marines_job_report)
			squad_marine_job_text += "[job_type]: [squad_marines_job_report[job_type]]"
			total_marines += squad_marines_job_report[job_type]
			total_squad_marines += squad_marines_job_report[job_type]
			incrementer++
			if(incrementer < length(squad_marines_job_report))
				squad_marine_job_text += ", "

		var/auxiliary_marine_job_text = ""
		var/list/auxiliary_marines_job_report = round_status_report["counted humans"]["Auxiliary Marines"]
		incrementer = 0
		for(var/job_type in auxiliary_marines_job_report)
			auxiliary_marine_job_text += "[job_type]: [auxiliary_marines_job_report[job_type]]"
			total_marines += auxiliary_marines_job_report[job_type]
			incrementer++
			if(incrementer < length(auxiliary_marines_job_report))
				auxiliary_marine_job_text += ", "

		var/total_non_standard = 0
		var/non_standard_job_text = ""
		incrementer = 0
		var/list/non_standard_job_report = round_status_report["counted humans"]["Non-Standard Humans"]
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

		var/final_text = "Marines: [total_marines]\nSquad Marines: [total_squad_marines]\n\n"
		final_text += "Marine jobs:\n[auxiliary_marine_job_text], [squad_marine_job_text]\n\n"

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

#undef MONKEYS_TO_TOTAL_RATIO
#undef PODLOCKS_OPEN_WAIT
#undef HIJACK_EXPLOSION_COUNT
#undef MAJORITY
#undef MARINE_MAJOR_ROUND_END_DELAY
#undef GROUNDSIDE_XENO_MULTIPLIER
