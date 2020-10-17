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

var/global/datum/entity/round_stats/round_statistics
var/global/list/datum/entity/player_entity/player_entities = list()
var/global/cas_tracking_id_increment = 0	//this var used to assign unique tracking_ids to tacbinos and signal flares

/datum/game_mode
	var/name = "invalid"
	var/config_tag = null
	var/votable = 1
	var/probability = 0
	var/list/datum/mind/modePlayer = new
	var/required_players = 0
	var/required_players_secret = 0 //Minimum number of players for that game mode to be chose in Secret
	var/ert_disabled = 0
	var/force_end_at = 0
	var/xeno_evo_speed = 0 // if not 0 - gives xeno an evo boost/nerf
	var/is_in_endgame = FALSE //Set it to TRUE when we trigger DELTA alert or dropship crashes
	var/obj/structure/machinery/computer/shuttle_control/active_lz = null

	var/datum/entity/round_stats/round_stats = null

	var/list/roles_to_roll

/datum/game_mode/proc/announce() //to be calles when round starts
	to_world("<B>Notice</B>: [src] did not define announce()")

///can_start()
///Checks to see if the game can be setup and ran with the current number of players or whatnot.
/datum/game_mode/proc/can_start()
	var/playerC = 0
	for(var/mob/new_player/player in GLOB.new_player_list)
		if((player.client)&&(player.ready))
			playerC++

	if(master_mode=="secret")
		if(playerC >= required_players_secret)
			return 1
	else
		if(playerC >= required_players)
			return 1
	return 0


///pre_setup()
///Attempts to select players for special roles the mode might have.
/datum/game_mode/proc/pre_setup()
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MODE_PRESETUP)
	setup_round_stats()
	return 1


///post_setup()
///Everyone should now be on the station and have their normal gear.  This is the place to give the special roles extra things
/datum/game_mode/proc/post_setup()
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MODE_POSTSETUP)
	spawn (ROUNDSTART_LOGOUT_REPORT_TIME)
		display_roundstart_logout_report()

	for(var/mob/new_player/np in GLOB.new_player_list)
		np.new_player_panel_proc()
	log_game("Round started at [time2text(world.realtime)]")
	if(ticker && ticker.mode)
		log_game("Game mode set to [ticker.mode]")
	log_game("Server IP: [world.internet_address]:[world.port]")
	return 1


///process()
///Called by the gameticker
/datum/game_mode/process()
	return 0


/datum/game_mode/proc/check_finished() //to be called by ticker
	if(EvacuationAuthority.dest_status == NUKE_EXPLOSION_FINISHED || EvacuationAuthority.dest_status == NUKE_EXPLOSION_GROUND_FINISHED )
		return TRUE

/datum/game_mode/proc/cleanup()	//This is called when the round has ended but not the game, if any cleanup would be necessary in that case.
	return

/datum/game_mode/proc/announce_ending()
	if(round_statistics)
		round_statistics.track_round_end()
	log_game("Round end result: [round_finished]")
	to_world("<span class='round_header'>|Round Complete|</span>")

	to_world(SPAN_ROUNDBODY("Thus ends the story of the brave men and women of the [MAIN_SHIP_NAME] and their struggle on [map_tag]."))
	to_world(SPAN_ROUNDBODY("The game-mode was: [master_mode]!"))
	to_world(SPAN_ROUNDBODY("End of Round Grief (EORG) is an IMMEDIATE 3 hour ban with no warnings, see rule #3 for more details."))


/datum/game_mode/proc/declare_completion()
	if(round_statistics)
		round_statistics.track_round_end()
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
	for(var/mob/M in living_mob_list)
		M.life_time_total = world.time - M.life_time_start
		M.track_death_calculations()
		M.statistic_exempt = TRUE

/datum/game_mode/proc/show_end_statistics(var/icon_state)
	round_statistics.update_panel_data()
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			var/datum/action/show_round_statistics/Sability = new(null, icon_state)
			Sability.give_action(M)

/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0

/datum/game_mode/proc/get_players_for_role(var/role, override_jobbans = 0)
	var/list/players = list()
	var/list/candidates = list()

	var/ban_check = role
	switch(role)
		if(JOB_XENOMORPH)
			ban_check = "Alien"
		if(JOB_XENOMORPH_QUEEN)
			ban_check = "Queen"

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

	return candidates		//Returns:	The number of people who had the antagonist role set to yes


///////////////////////////////////
//Keeps track of all living heads//
///////////////////////////////////
/datum/game_mode/proc/get_living_heads()
	var/list/heads = list()
	for(var/mob/living/carbon/human/player in living_human_list)
		if(player.stat!=2 && player.mind && (player.job in ROLES_COMMAND ))
			heads += player.mind
	return heads


////////////////////////////
//Keeps track of all heads//
////////////////////////////
/datum/game_mode/proc/get_all_heads()
	var/list/heads = list()
	for(var/mob/player in mob_list)
		if(player.mind && (player.job in ROLES_COMMAND ))
			heads += player.mind
	return heads

/datum/game_mode/New()
	if(!map_tag)
		to_world("MT001: No mapping tag set, tell a coder. [map_tag]")

//////////////////////////
//Reports player logouts//
//////////////////////////
proc/display_roundstart_logout_report()
	var/msg = SPAN_NOTICE("<b>Roundstart logout report\n\n")
	for(var/mob/living/L in mob_list)

		if(L.ckey)
			var/found = 0
			for(var/client/C in GLOB.clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				msg += "<b>[key_name(L)]</b>, the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"


		if(L.ckey && L.client)
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2))	//Connected, but inactive (alt+tabbed or something)
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
		for(var/mob/dead/observer/D in mob_list)
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

	for(var/mob/M in mob_list)
		if(M.client && M.client.admin_holder && (M.client.admin_holder.rights & R_MOD))
			to_chat(M, msg)

//Announces objectives/generic antag text.
/proc/show_generic_antag_text(var/datum/mind/player)
	if(player.current)
		player.current << \
		"You are an antagonist! <font color=blue>Within the rules,</font> \
		try to act as an opposing force to the crew. Further RP and try to make sure \
		other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to antagonists.</b>"

/datum/game_mode/proc/setup_round_stats()
	if(!round_stats)
		var/operation_name
		operation_name = "[pick(operation_titles)]"
		operation_name += " [pick(operation_prefixes)]"
		operation_name += "-[pick(operation_postfixes)]"
		round_stats = new()
		round_stats.name = operation_name
		round_stats.real_time_start = world.realtime
		var/datum/entity/map_stats/new_map = new()
		new_map.name = map_tag
		new_map.linked_round = round_stats
		new_map.death_stats_list = round_stats.death_stats_list
		round_stats.game_mode = name
		round_stats.current_map = new_map
		round_statistics = round_stats
