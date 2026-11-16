/datum/game_mode/bug_hunt
	name = GAMEMODE_BUG_HUNT
	config_tag = GAMEMODE_BUG_HUNT
	required_players = 1
	votable = FALSE
	flags_round_type = MODE_NEW_SPAWN
	latejoin_larva_drop = 0
	latejoin_larva_drop_early = 0
	var/hive_core_count = 3
	xeno_respawn_delay = 60 SECONDS
	var/xeno_join_pending = FALSE
	role_mappings = list(
		/datum/job/command/commander/bug_hunt = JOB_CO,
		/datum/job/command/executive/bug_hunt = JOB_XO,
		/datum/job/marine/leader/bug_hunt = JOB_SQUAD_LEADER,
		/datum/job/marine/tl/bug_hunt = JOB_SQUAD_TEAM_LEADER,
		/datum/job/marine/medic/bug_hunt = JOB_SQUAD_MEDIC,
		/datum/job/marine/engineer/bug_hunt = JOB_SQUAD_ENGI,
		/datum/job/command/tank_crew/bug_hunt = JOB_TANK_CREW,
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
	recon.prepend_squad_name_to_assignment = FALSE
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
	hive.allow_core_larva_spawning = FALSE
	hive.hive_structure_types -= XENO_STRUCTURE_CORE
	LAZYADD(hive.blacklisted_castes, XENO_CASTE_QUEEN)
	setup_hive_cores()
	SSradio.update_cache()

/datum/game_mode/bug_hunt/proc/setup_hive_cores()
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	hive.hive_structures_limit[XENO_STRUCTURE_CORE] = hive_core_count
	for(var/list/spawn_pool as anything in list(GLOB.objective_landmarks_medium, GLOB.objective_landmarks_far, GLOB.queen_spawns))
		var/turf/core_turf = get_turf(pick(spawn_pool))
		for(var/obj/obstacle in core_turf)
			if(obstacle.density)
				qdel(obstacle)
		new /obj/effect/alien/resin/special/pylon/core/bug_hunt(core_turf, hive)
		var/list/pillar_turfs = list()
		for(var/turf/open/pillar_turf in oview(2, core_turf))
			var/area/pillar_area = get_area(pillar_turf)
			if(!pillar_area.is_resin_allowed || istype(pillar_turf, /turf/open/space) || is_blocked_turf(pillar_turf) || (locate(/obj/effect/landmark/queen_spawn) in pillar_turf) || (locate(/obj/structure/machinery/door) in pillar_turf) || (locate(/obj/effect/alien/resin) in pillar_turf))
				continue
			pillar_turfs += pillar_turf
		for(var/pillar_index in 1 to min(2, length(pillar_turfs)))
			new /obj/effect/alien/resin/acid_pillar/strong/bug_hunt(pick_n_take(pillar_turfs), hive.hivenumber)

	hive.hive_structures_limit[XENO_STRUCTURE_CORE] = 0

/datum/game_mode/bug_hunt/ds_first_landed(obj/docking_port/stationary/marine_dropship/dropship)
	. = ..()
	xeno_announcement("The tallhosts have landed. Defend the hive and drive them from this world!", XENO_HIVE_NORMAL, QUEEN_MOTHER_ANNOUNCE)
	for(var/mob/living/carbon/xenomorph/xeno as anything in GLOB.xeno_mob_list)
		qdel(get_action(xeno, /datum/action/xeno_action/onclick/plant_weeds/predrop))
		qdel(get_action(xeno, /datum/action/xeno_action/onclick/choose_resin/predrop))
		qdel(get_action(xeno, /datum/action/xeno_action/activable/secrete_resin/predrop))
		for(var/datum/action/xeno_action/action in xeno.actions)
			if(istype(action, /datum/action/xeno_action/onclick/plant_weeds) || istype(action, /datum/action/xeno_action/activable/secrete_resin))
				action.plasma_cost = initial(action.plasma_cost)

/datum/game_mode/bug_hunt/check_xeno_late_join(mob/xeno_candidate, check_population = FALSE)
	if(SSticker.current_state != GAME_STATE_PLAYING || !xeno_candidate?.client || !..() || round_finished)
		return FALSE
	if(check_population)
		var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
		var/marine_count = count_marines()
		var/xeno_count = hive.get_real_total_xeno_count()
		var/xeno_limit = max(2, floor(marine_count / 3))
		if(xeno_count >= xeno_limit)
			to_chat(xeno_candidate, SPAN_WARNING("The hive has reached its population limit of ([xeno_limit] xenomorphs for [marine_count] living marines)."))
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
	var/time_left = last_activity + xeno_respawn_delay - world.time
	if(last_activity && time_left > 0)
		to_chat(xeno_candidate, SPAN_WARNING("You must wait [DisplayTimeText(time_left)] before joining as a xenomorph."))
		return FALSE
	return TRUE

/datum/game_mode/bug_hunt/attempt_to_join_as_xeno(mob/xeno_candidate, instant_join = FALSE)
	if(!isobserver(xeno_candidate))
		return FALSE
	var/mob/dead/observer/observer = xeno_candidate
	observer.client.prefs.be_special |= BE_ALIEN
	observer.admin_larva_protection = FALSE
	message_alien_candidate_observer(observer)
	return TRUE

/datum/game_mode/bug_hunt/process()
	set waitfor = FALSE
	. = ..()
	if(round_finished || xeno_join_pending)
		return
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	if(!hive.has_structure(XENO_STRUCTURE_CORE) || hive.get_real_total_xeno_count() >= max(2, floor(count_marines() / 3)))
		return
	var/list/candidates = get_alien_candidates(hive)
	if(!length(candidates))
		return
	message_alien_candidates(candidates, dequeued = 0, cache_only = TRUE)
	for(var/mob/dead/observer/xeno_candidate as anything in candidates)
		var/last_activity = max(xeno_candidate.timeofdeath, xeno_candidate.client.player_details.larva_pool_time)
		if(last_activity && last_activity + xeno_respawn_delay > world.time)
			continue
		if(!check_xeno_late_join(xeno_candidate))
			continue
		xeno_join_pending = TRUE
		spawn_xeno_from_pool(xeno_candidate)
		xeno_join_pending = FALSE
		return

/datum/game_mode/bug_hunt/proc/spawn_xeno_from_pool(mob/dead/observer/xeno_candidate)
	if(!check_xeno_late_join(xeno_candidate, check_population = TRUE))
		return FALSE
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	var/list/castes = XENO_T1_CASTES
	castes -= hive.blacklisted_castes
	for(var/caste_name in castes)
		var/datum/caste_datum/caste = GLOB.xeno_datum_list[caste_name]
		if(caste.minimum_evolve_time > ROUND_TIME || !caste.can_play_caste(xeno_candidate.client))
			castes -= caste_name
	if(!length(castes))
		return FALSE
	var/caste_choice = tgui_input_list(xeno_candidate, "Choose a caste.", "Join as Xeno", castes, timeout = 30 SECONDS, theme = "hive_status")
	if(!caste_choice)
		if(xeno_candidate.client)
			xeno_candidate.client.prefs.be_special &= ~BE_ALIEN
		return FALSE

	var/list/cores = hive.hive_structures[XENO_STRUCTURE_CORE]
	if(!length(cores))
		return FALSE
	var/list/core_choices = list()
	var/list/area_name_counts = list()
	for(var/obj/effect/alien/resin/special/pylon/core/spawn_core as anything in cores)
		core_choices[avoid_assoc_duplicate_keys(get_area_name(spawn_core), area_name_counts)] = spawn_core
	var/core_choice = tgui_input_list(xeno_candidate, "Choose a hive core to spawn at.", "Join as Xeno", core_choices, timeout = 30 SECONDS, theme = "hive_status")
	if(!core_choice)
		if(xeno_candidate.client)
			xeno_candidate.client.prefs.be_special &= ~BE_ALIEN
		return FALSE
	var/obj/effect/alien/resin/special/pylon/core/core = core_choices[core_choice]
	if(QDELETED(core) || !check_xeno_late_join(xeno_candidate, check_population = TRUE))
		return FALSE
	var/xeno_type = GLOB.RoleAuthority.get_caste_by_text(caste_choice)
	var/mob/living/carbon/xenomorph/new_xeno = new xeno_type(get_turf(core), null, hive.hivenumber)
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

/datum/game_mode/bug_hunt/proc/setup_auto_queen()
	var/turf/queen_turf = locate(1, 1, SSmapping.levels_by_trait(ZTRAIT_GROUND)[1])
	for(var/turf/wall_turf as anything in RANGE_TURFS(1, queen_turf))
		if(wall_turf != queen_turf)
			wall_turf.ChangeTurf(/turf/closed/wall/indestructible)
	queen_turf = queen_turf.ChangeTurf(/turf/open/floor/plating)

	var/mob/living/carbon/xenomorph/queen/queen = new(queen_turf, null, XENO_HIVE_NORMAL)
	queen.counts_for_slots = FALSE
	queen.status_flags |= GODMODE
	var/obj/effect/alien/weeds/node/queen_weeds = new(queen_turf, null, queen)
	queen_weeds.explo_proof = TRUE
	queen.mount_ovipositor()
	queen.auto_queen = TRUE

/datum/game_mode/bug_hunt/post_setup()
	initialize_post_marine_gear_list()
	for(var/obj/structure/machinery/cm_vending/sorted/cargo_guns/vendor in GLOB.cm_vending_vendors)
		for(var/list/product as anything in vendor.listed_products)
			if(product[3] == /obj/item/storage/box/nade_box)
				vendor.listed_products -= list(product)
				break
	setup_auto_queen()
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	hive.stored_larva = 0
	hive.hive_ui.update_all_data()
	addtimer(CALLBACK(src, PROC_REF(ares_online)), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(ares_command_check)), 5 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(mission_briefing)), 2 MINUTES)
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
	var/xeno_briefing = "The tallhosts will soon descend upon this world to destroy our hive. Our [hive_core_count] hive cores must be defended, if every core is destroyed, the hive is lost."
	xeno_briefing += "\n\nEvery sister can summon weeds and walls prior to the talls arrival for free. Prepare your killing grounds."
	xeno_announcement(xeno_briefing, XENO_HIVE_NORMAL, QUEEN_MOTHER_ANNOUNCE)

/datum/game_mode/bug_hunt/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING || round_finished)
		return
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	if(!hive.has_structure(XENO_STRUCTURE_CORE))
		round_finished = MODE_INFESTATION_M_MAJOR
		return
	if(!SSobjectives.first_drop_complete)
		return
	for(var/mob/living/carbon/human/marine as anything in GLOB.alive_human_list)
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

