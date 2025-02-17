//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
 * GAMEMODES (by Rastaf0)
 *
 * In the new mode system all special roles are fully supported.
 * You can have proper wizards/traitors/changelings/cultists during any mode.
 * Only two things really depends on gamemode:
 * 1. Starting roles, equipment and preparations
 * 2. Conditions of finishing the round.
 *
 */

GLOBAL_DATUM(round_statistics, /datum/entity/statistic/round)
GLOBAL_LIST_INIT_TYPED(player_entities, /datum/entity/player_entity, list())
GLOBAL_VAR_INIT(cas_tracking_id_increment, 0) //this var used to assign unique tracking_ids to tacbinos and signal flares
/datum/game_mode
	var/name = "invalid"
	var/config_tag = null
	var/votable = TRUE
	var/vote_cycle = null
	var/probability = 0
	var/list/datum/mind/modePlayer = new
	var/required_players = 0
	var/required_players_secret = 0 //Minimum number of players for that game mode to be chose in Secret
	var/ert_disabled = 0
	var/force_end_at = 0
	var/xeno_evo_speed = 0 // if not 0 - gives xeno an evo boost/nerf
	var/is_in_endgame = FALSE //Set it to TRUE when we trigger DELTA alert or dropship crashes
	/// When set and this gamemode is selected, the taskbar icon will change to the png selected here
	var/taskbar_icon = 'icons/taskbar/gml_distress.png'
	var/static_comms_amount = 0
	var/obj/structure/machinery/computer/shuttle/dropship/flight/active_lz = null

	var/datum/entity/statistic/round/round_stats = null

	var/list/roles_to_roll

	var/corpses_to_spawn = 0

	var/hardcore = FALSE

	///Whether or not the fax response station has loaded.
	var/loaded_fax_base = FALSE

/datum/game_mode/New()
	..()
	if(taskbar_icon)
		GLOB.available_taskbar_icons |= taskbar_icon

/datum/game_mode/proc/announce() //to be calles when round starts
	to_world("<B>Notice</B>: [src] did not define announce()")

///can_start()
///Checks to see if the game can be setup and ran with the current number of players or whatnot.
/datum/game_mode/proc/can_start(bypass_checks = FALSE)
	if(bypass_checks)
		return TRUE
	var/players = 0
	for(var/mob/new_player/player in GLOB.new_player_list)
		if(player.client && player.ready)
			players++
	if(GLOB.master_mode == "secret")
		if(players >= required_players_secret)
			return TRUE
	else
		if(players >= required_players)
			return TRUE
	return FALSE


///pre_setup()
///Attempts to select players for special roles the mode might have.
/datum/game_mode/proc/pre_setup()
	SHOULD_CALL_PARENT(TRUE)
	setup_structures()
	if(static_comms_amount)
		spawn_static_comms()
	if(corpses_to_spawn)
		generate_corpses()
	initialize_gamemode_modifiers()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MODE_PRESETUP)
	return 1

///Triggered partway through the first drop, based on DROPSHIP_DROP_MSG_DELAY. Marines are underway but haven't yet landed.
/datum/game_mode/proc/ds_first_drop(obj/docking_port/mobile/marine_dropship)
	return

///Triggered when the dropship first lands.
/datum/game_mode/proc/ds_first_landed(obj/docking_port/stationary/marine_dropship)
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_DS_FIRST_LANDED)
	return

/// Spawn structures relevant to the game mode setup, done before actual game setup. By default try to setup everything.
/datum/game_mode/proc/setup_structures()
	for(var/obj/effect/landmark/structure_spawner/setup/SS in GLOB.structure_spawners)
		SS.apply()

///post_setup()
///Everyone should now be on the station and have their normal gear.  This is the place to give the special roles extra things
/datum/game_mode/proc/post_setup()
	SHOULD_CALL_PARENT(TRUE)
	for(var/obj/effect/landmark/structure_spawner/SS in GLOB.structure_spawners)
		SS.post_setup()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MODE_POSTSETUP)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(display_roundstart_logout_report)), ROUNDSTART_LOGOUT_REPORT_TIME)
	adjust_ammo_values()
	round_time_lobby = world.time
	log_game("Round started at [time2text(world.realtime)]")
	log_game("Operation time at round start is [worldtime2text()]")
	if(SSticker.mode)
		log_game("Game mode set to [SSticker.mode] on the [SSmapping.configs[GROUND_MAP].map_name] map")
	log_game("Server IP: [world.internet_address]:[world.port]")
	return TRUE

/datum/game_mode/proc/adjust_ammo_values()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		for(var/ammo in GLOB.ammo_list)
			GLOB.ammo_list[ammo].setup_faction_clash_values()

/datum/game_mode/proc/get_affected_zlevels()
	if(is_in_endgame)
		. = SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP))
		return

///process()
///Called by the gameticker
/datum/game_mode/process()
	return FALSE


/datum/game_mode/proc/check_finished() //to be called by ticker
	return

/datum/game_mode/proc/cleanup() //This is called when the round has ended but not the game, if any cleanup would be necessary in that case.
	return

/datum/game_mode/proc/announce_ending()
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_round_end()
	log_game("Round end result: [round_finished]")
	to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("|Round Complete|"))
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDBODY("Thus ends the story of the brave men and women of the [MAIN_SHIP_NAME] and their struggle on [SSmapping.configs[GROUND_MAP].map_name].\nThe game-mode was: [GLOB.master_mode]!\n[CONFIG_GET(string/endofroundblurb)]"))

/datum/game_mode/proc/declare_completion()
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_round_end()
	var/clients = 0
	var/surviving_humans = 0
	var/surviving_total = 0
	var/ghosts = 0

	for(var/mob/M in GLOB.player_list)
		if(M.client)
			clients++
			if(ishuman(M))
				if(!M.stat)
					surviving_humans++
			if(!M.stat)
				surviving_total++

			if(isobserver(M))
				ghosts++

	if(clients > 0)
		log_game("Round end - clients: [clients]")
	if(ghosts > 0)
		log_game("Round end - ghosts: [ghosts]")
	if(surviving_humans > 0)
		log_game("Round end - humans: [surviving_humans]")
	if(surviving_total > 0)
		log_game("Round end - total: [surviving_total]")


	return 0

/datum/game_mode/proc/calculate_end_statistics()
	for(var/i in GLOB.alive_mob_list)
		var/mob/M = i
		M.life_time_total = world.time - M.life_time_start
		M.track_death_calculations()
		M.statistic_exempt = TRUE

		if(M.client && M.client.player_data)
			if(M.stat == DEAD)
				record_playtime(M.client.player_data, JOB_OBSERVER, type)
			else
				record_playtime(M.client.player_data, M.job, type)

/datum/game_mode/proc/show_end_statistics(icon_state)
	GLOB.round_statistics.update_panel_data()
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			give_action(M, /datum/action/show_round_statistics, null, icon_state)

/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0

/datum/game_mode/proc/get_players_for_role(role, override_jobbans = 0)
	var/list/players = list()
	var/list/candidates = list()

	var/ban_check = role
	switch(role)
		if(JOB_XENOMORPH)
			ban_check = JOB_XENOMORPH
		if(JOB_XENOMORPH_QUEEN)
			ban_check = JOB_XENOMORPH_QUEEN

	//Assemble a list of active players without jobbans.
	for(var/mob/new_player/player in GLOB.player_list)
		if(player.client && player.ready)
			if(!jobban_isbanned(player, ban_check))
				players += player

	//Shuffle the players list so that it becomes ping-independent.
	players = shuffle(players)

	//Get a list of all the people who want to be the antagonist for this round
	for(var/mob/new_player/player in players)
		if(player.client.prefs.get_job_priority(role) > 0)
			log_debug("[player.key] had [role] enabled, so we are drafting them.")
			candidates += player.mind
			players -= player

	return candidates //Returns: The number of people who had the antagonist role set to yes


///////////////////////////////////
//Keeps track of all living heads//
///////////////////////////////////
/datum/game_mode/proc/get_living_heads()
	var/list/heads = list()
	for(var/i in GLOB.alive_human_list)
		var/mob/living/carbon/human/player = i
		if(player.stat!=2 && player.mind && (player.job in GLOB.ROLES_COMMAND ))
			heads += player.mind
	return heads


////////////////////////////
//Keeps track of all heads//
////////////////////////////
/datum/game_mode/proc/get_all_heads()
	var/list/heads = list()
	for(var/mob/player in GLOB.mob_list)
		if(player.mind && (player.job in GLOB.ROLES_COMMAND ))
			heads += player.mind
	return heads


/datum/game_mode/proc/generate_corpses()
	var/list/obj/effect/landmark/corpsespawner/gamemode_spawn_corpse = GLOB.corpse_spawns.Copy()
	while(corpses_to_spawn--)
		if(!length(gamemode_spawn_corpse))
			break
		var/obj/effect/landmark/corpsespawner/spawner = pick(gamemode_spawn_corpse)
		var/turf/spawnpoint = get_turf(spawner)
		if(spawnpoint)
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(spawnpoint)
			M.create_hud() //Need to generate hud before we can equip anything apparently...
			arm_equipment(M, spawner.equip_path, TRUE, FALSE)
			for(var/obj/structure/bed/nest/found_nest in spawnpoint)
				for(var/turf/the_turf in list(get_step(found_nest, NORTH),get_step(found_nest, EAST),get_step(found_nest, WEST)))
					if(the_turf.density)
						found_nest.dir = get_dir(found_nest, the_turf)
						found_nest.pixel_x = found_nest.buckling_x["[found_nest.dir]"]
						found_nest.pixel_y = found_nest.buckling_y["[found_nest.dir]"]
						M.dir = get_dir(the_turf,found_nest)
				if(!found_nest.buckled_mob)
					found_nest.do_buckle(M,M)
		gamemode_spawn_corpse.Remove(spawner)

/datum/game_mode/proc/spawn_static_comms()
	for(var/i = 1 to static_comms_amount)
		var/obj/effect/landmark/static_comms/SCO = pick_n_take(GLOB.comm_tower_landmarks_net_one)
		var/obj/effect/landmark/static_comms/SCT = pick_n_take(GLOB.comm_tower_landmarks_net_two)
		if(!SCO)
			break
		SCO.spawn_tower()
		if(!SCT)
			break
		SCT.spawn_tower()
	QDEL_NULL_LIST(GLOB.comm_tower_landmarks_net_one)
	QDEL_NULL_LIST(GLOB.comm_tower_landmarks_net_two)

//////////////////////////
//Reports player logouts//
//////////////////////////
/proc/display_roundstart_logout_report()
	var/msg = FONT_SIZE_LARGE("<b>Roundstart logout report\n\n")
	for(var/i in GLOB.living_mob_list)
		var/mob/living/L = i

		if(L.ckey)
			var/found = 0
			for(var/client/C in GLOB.clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				msg += "<b>[key_name(L)]</b>, the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"


		if(L.ckey && L.client)
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME * 0.5)) //Connected, but inactive (alt+tabbed or something)
				msg += "<b>[key_name(L)]</b>, the [L.job] (<font color='#ffcc00'><b>Connected, Inactive</b></font>)\n"
				continue //AFK client
			if(L.stat)
				if(L.stat == UNCONSCIOUS)
					msg += "<b>[key_name(L)]</b>, the [L.job] (Dying)\n"
					continue //Unconscious
				if(L.stat == DEAD)
					msg += "<b>[key_name(L)]</b>, the [L.job] (Dead)\n"
					continue //Dead

			continue //Happy connected client
		for(var/mob/dead/observer/D in GLOB.observer_list)
			if(D.mind && (D.mind.original == L || D.mind.current == L))
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
					continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>This shouldn't appear.</b></font>)\n"
						continue //Lolwhat
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Ghosted</b></font>)\n"
						continue //Ghosted while alive

	for(var/mob/M in GLOB.player_list)
		if(M.client.admin_holder && (M.client.admin_holder.rights & R_MOD))
			to_chat_spaced(M, html = msg)

//Announces objectives/generic antag text.
/proc/show_generic_antag_text(datum/mind/player)
	if(player.current)
		player.current << \
		"You are an antagonist! <font color=blue>Within the rules,</font> \
		try to act as an opposing force to the crew. Further RP and try to make sure \
		other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to antagonists.</b>"
