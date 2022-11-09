/*
This is a collection of procs related to CM and spawning aliens/predators/survivors. With this centralized system,
you can spawn them at round start in any game mode. You can also add additional categories, and they will be supported
at round start with no conflict. Individual game modes may override these settings to have their own unique
spawns for the various factions. It's also a bit more robust with some added parameters. For example, if xeno_required_num
is 0, you don't need aliens at the start of the game. If aliens are required for win conditions, tick it to 1 or more.

This is a basic outline of how things should function in code.
You can see a working example in the Colonial Marines game mode.

	//Minds are not transferred/made at this point, so we have to check for them so we don't double dip.
	can_start() //This should have the following in order:
		initialize_special_clamps()
		initialize_starting_predator_list()
		if(!initialize_starting_xenomorph_list()) //If we don't have the right amount of xenos, we can't start.
			return
		initialize_starting_survivor_list()

		return 1

	pre_setup()
		//Other things can take place, such as game mode specific setups.

		return 1

	post_setup()
		initialize_post_xenomorph_list()
		initialize_post_survivor_list()
		initialize_post_predator_list()

		return 1


//Flags defined in setup.dm
MODE_INFESTATION
MODE_PREDATOR

Additional game mode variables.
*/

/datum/game_mode
	var/list/datum/mind/xenomorphs[] = list() //These are our basic lists to keep track of who is in the game.
	var/list/datum/mind/picked_queens = list()
	var/datum/mind/survivors[] = list()
	var/datum/mind/synth_survivor = null
	var/datum/mind/hellhounds[] = list() //Hellhound spawning is not supported at round start.
	var/list/dead_queens // A list of messages listing the dead queens
	var/predators = list()

	var/xeno_required_num 	= 0 //We need at least one. You can turn this off in case we don't care if we spawn or don't spawn xenos.
	var/xeno_starting_num 	= 0 //To clamp starting xenos.
	var/xeno_bypass_timer 	= 0 //Bypass the five minute timer before respawning.
	var/xeno_queen_deaths 	= 0 //How many times the alien queen died.
	var/surv_starting_num 	= 0 //To clamp starting survivors.
	var/merc_starting_num 	= 0 //PMC clamp.
	var/marine_starting_num = 0 //number of players not in something special
	var/pred_current_num 	= 0 //How many are there now?
	var/pred_per_players 	= 40 //Preds per player
	var/pred_start_count	= 4 //The initial count of predators

	var/pred_additional_max = 0
	var/pred_round_chance 	= 20 //%
	var/pred_leader_count 	= 0 //How many Leader preds are active
	var/pred_leader_max 	= 1 //How many Leader preds are permitted. Currently fixed to 1. May add admin verb to adjust this later.

	//Some gameplay variables.
	var/round_checkwin 		= 0
	var/round_finished
	var/round_started  		= 5 //This is a simple timer so we don't accidently check win conditions right in post-game
	var/list/round_fog = list()				//List of the fog locations.
	var/list/round_toxic_river = list()		//List of all toxic river locations
	var/round_time_lobby 		//Base time for the lobby, for fog dispersal.
	var/round_time_river
	var/monkey_amount		= 0 //How many monkeys do we spawn on this map ?
	var/list/monkey_types	= list() //What type of monkeys do we spawn
	var/latejoin_tally		= 0 //How many people latejoined Marines
	var/latejoin_larva_drop = LATEJOIN_MARINES_PER_LATEJOIN_LARVA //A larva will spawn in once the tally reaches this level. If set to 0, no latejoin larva drop

	//Role Authority set up.
	/// List of role titles to override to different roles when starting game
	var/list/role_mappings

	//Bioscan related.
	var/bioscan_current_interval = 5 MINUTES//5 minutes in
	var/bioscan_ongoing_interval = 1 MINUTES//every 1 minute

	var/lz_selection_timer = 25 MINUTES //25 minutes in
	var/round_time_pooled_cutoff = 25 MINUTES	//Time for when free pooled larvae stop spawning.

	var/round_time_resin = 40 MINUTES	//Time for when resin placing is allowed close to LZs

	var/round_time_evolution_ovipositor = 5 MINUTES //Time for when ovipositor becomes necessary for evolution to progress.
	var/evolution_ovipositor_threshold = FALSE

	var/flags_round_type = NO_FLAGS
	var/toggleable_flags = NO_FLAGS


/datum/game_mode/proc/get_roles_list()
	return ROLES_REGULAR_ALL

//===================================================\\

				//GAME MODE INITIATLIZE\\

//===================================================\\

/datum/game_mode/proc/initialize_special_clamps()
	xeno_starting_num = clamp((readied_players/CONFIG_GET(number/xeno_number_divider)), xeno_required_num, INFINITY) //(n, minimum, maximum)
	surv_starting_num = clamp((readied_players/CONFIG_GET(number/surv_number_divider)), 2, 8) //this doesnt run
	marine_starting_num = GLOB.player_list.len - xeno_starting_num - surv_starting_num
	for(var/datum/squad/sq in RoleAuthority.squads)
		if(sq)
			sq.max_engineers = engi_slot_formula(marine_starting_num)
			sq.max_medics = medic_slot_formula(marine_starting_num)

	for(var/i in RoleAuthority.roles_by_name)
		var/datum/job/J = RoleAuthority.roles_by_name[i]
		if(J.scaled)
			J.set_spawn_positions(marine_starting_num)


//===================================================\\

				//PREDATOR INITIATLIZE\\

//===================================================\\

/datum/game_mode/proc/initialize_predator(mob/living/carbon/human/new_predator, var/ignore_pred_num = FALSE)
	predators[new_predator.ckey] = list("Name" = new_predator.real_name, "Status" = "Alive")
	if(!ignore_pred_num)
		pred_current_num++

/datum/game_mode/proc/get_whitelisted_predators(readied = 1)
	// Assemble a list of active players who are whitelisted.
	var/players[] = new

	var/mob/new_player/new_pred
	for(var/mob/player in GLOB.player_list)
		if(!player.client) continue //No client. DCed.
		if(isYautja(player)) continue //Already a predator. Might be dead, who knows.
		if(readied) //Ready check for new players.
			new_pred = player
			if(!istype(new_pred)) continue //Have to be a new player here.
			if(!new_pred.ready) continue //Have to be ready.
		else
			if(!istype(player,/mob/dead)) continue //Otherwise we just want to grab the ghosts.

		if(RoleAuthority.roles_whitelist[player.ckey] & WHITELIST_PREDATOR)  //Are they whitelisted?
			if(!player.client.prefs)
				player.client.prefs = new /datum/preferences(player.client) //Somehow they don't have one.

			if(player.client.prefs.get_job_priority(JOB_PREDATOR) > 0) //Are their prefs turned on?
				if(!player.mind) //They have to have a key if they have a client.
					player.mind_initialize() //Will work on ghosts too, but won't add them to active minds.
				player.mind.setup_human_stats()
				player.faction = FACTION_YAUTJA
				players += player.mind
	return players

/datum/game_mode/proc/attempt_to_join_as_predator(mob/pred_candidate)
	var/mob/living/carbon/human/new_predator = transform_predator(pred_candidate) //Initialized and ready.
	if(!new_predator) return

	msg_admin_niche("([new_predator.key]) joined as Yautja, [new_predator.real_name].")

	if(pred_candidate) pred_candidate.moveToNullspace() //Nullspace it for garbage collection later.

#define calculate_pred_max (Floor(length(GLOB.player_list) / pred_per_players) + pred_additional_max + pred_start_count)

/datum/game_mode/proc/check_predator_late_join(mob/pred_candidate, show_warning = 1)

	if(!pred_candidate.client)
		return

	var/datum/job/J = RoleAuthority.roles_by_name[JOB_PREDATOR]

	if(!J)
		if(show_warning) to_chat(pred_candidate, SPAN_WARNING("Something went wrong!"))
		return

	if(show_warning && alert(pred_candidate, "Confirm joining the hunt. You will join as \a [lowertext(J.get_whitelist_status(RoleAuthority.roles_whitelist, pred_candidate.client))] predator", "Confirmation", "Yes", "No") == "No")
		return

	if(!(RoleAuthority.roles_whitelist[pred_candidate.ckey] & WHITELIST_PREDATOR))
		if(show_warning) to_chat(pred_candidate, SPAN_WARNING("You are not whitelisted! You may apply on the forums to be whitelisted as a predator."))
		return

	if(!(flags_round_type & MODE_PREDATOR))
		if(show_warning) to_chat(pred_candidate, SPAN_WARNING("There is no Hunt this round! Maybe the next one."))
		return

	if(pred_candidate.ckey in predators)
		if(show_warning)
			to_chat(pred_candidate, SPAN_WARNING("You already were a Yautja! Give someone else a chance."))
		return

	if(J.get_whitelist_status(RoleAuthority.roles_whitelist, pred_candidate.client) == WHITELIST_NORMAL)
		var/pred_max = calculate_pred_max
		if(pred_current_num >= pred_max)
			if(show_warning) to_chat(pred_candidate, SPAN_WARNING("Only [pred_max] predators may spawn this round, but Elders and Leaders do not count."))
			return

	return 1

#undef calculate_pred_max

/datum/game_mode/proc/transform_predator(mob/pred_candidate)
	set waitfor = FALSE

	if(!pred_candidate.client) // Legacy - probably due to spawn code sync sleeps
		log_debug("Null client attempted to transform_predator")
		return

	var/clan_id = CLAN_SHIP_PUBLIC
	var/datum/entity/clan_player/clan_info = pred_candidate?.client?.clan_info
	clan_info?.sync()
	SSpredships.load_new(clan_id)
	var/turf/spawn_point = SAFEPICK(SSpredships.get_clan_spawnpoints(clan_id))
	if(!isturf(spawn_point))
		log_debug("Failed to find spawn point for pred ship in transform_predator - clan_id=[clan_id]")
		to_chat(pred_candidate, SPAN_WARNING("Unable to setup spawn location - you might want to tell someone about this."))
		return
	if(!pred_candidate?.mind) // Legacy check
		log_debug("Tried to spawn invalid pred player in transform_predator - new_player name=[pred_candidate]")
		to_chat(pred_candidate, SPAN_WARNING("Could not setup character - you might want to tell someone about this."))
		return

	var/mob/living/carbon/human/yautja/new_predator = new(spawn_point)
	pred_candidate.mind.transfer_to(new_predator, TRUE)
	new_predator.client = pred_candidate.client

	var/datum/job/J = RoleAuthority.roles_by_name[JOB_PREDATOR]

	if(!J)
		qdel(new_predator)
		return

	RoleAuthority.equip_role(new_predator, J, new_predator.loc)

	return new_predator


//===================================================\\

			//XENOMORPH INITIATLIZE\\

//===================================================\\

//If we are selecting xenomorphs, we NEED them to play the round. This is the expected behavior.
//If this is an optional behavior, just override this proc or make an override here.
/datum/game_mode/proc/initialize_starting_xenomorph_list(var/list/hives = list(XENO_HIVE_NORMAL), var/force_xenos = FALSE)
	var/list/datum/mind/possible_xenomorphs = get_players_for_role(JOB_XENOMORPH)
	var/list/datum/mind/possible_queens = get_players_for_role(JOB_XENOMORPH_QUEEN)
	if(possible_xenomorphs.len < xeno_required_num) //We don't have enough aliens, we don't consider people rolling for only Queen.
		to_world("<h2 style=\"color:red\">Not enough players have chosen to be a xenomorph in their character setup. <b>Aborting</b>.</h2>")
		return

	//Minds are not transferred at this point, so we have to clean out those who may be already picked to play.
	for(var/datum/mind/A in possible_queens)
		var/mob/living/original = A.current
		var/client/client = GLOB.directory[A.ckey]
		if(jobban_isbanned(original, XENO_CASTE_QUEEN) || !can_play_special_job(client, XENO_CASTE_QUEEN))
			LAZYREMOVE(possible_queens, A)

	if(LAZYLEN(possible_queens)) // Pink one of the people who want to be Queen and put them in
		for(var/hive in hives)
			var/new_queen = pick(possible_queens)
			if(new_queen)
				setup_new_xeno(new_queen)
				picked_queens += list(GLOB.hive_datum[hive] = new_queen)
				LAZYREMOVE(possible_xenomorphs, new_queen)

	for(var/datum/mind/A in possible_xenomorphs)
		if(A.roundstart_picked)
			LAZYREMOVE(possible_xenomorphs, A)

	for(var/hive in hives)
		xenomorphs[GLOB.hive_datum[hive]] = list()

	var/datum/mind/new_xeno
	var/current_index = 1
	var/remaining_slots = 0
	for(var/i in 1 to xeno_starting_num) //While we can still pick someone for the role.
		if(current_index > LAZYLEN(hives))
			current_index = 1

		var/datum/hive_status/hive = GLOB.hive_datum[hives[current_index]]
		if(LAZYLEN(possible_xenomorphs)) //We still have candidates
			new_xeno = pick(possible_xenomorphs)
			LAZYREMOVE(possible_xenomorphs, new_xeno)

			if(!new_xeno)
				hive.stored_larva++
				hive.hive_ui.update_pooled_larva()
				continue  //Looks like we didn't get anyone. Keep going.

			setup_new_xeno(new_xeno)

			xenomorphs[hive] += new_xeno
		else //Out of candidates, fill the xeno hive with pooled larva
			remaining_slots = round((xeno_starting_num - i))
			break

		current_index++


	if(remaining_slots)
		var/larva_per_hive = round(remaining_slots / LAZYLEN(hives))
		for(var/hivenumb in hives)
			var/datum/hive_status/hive = GLOB.hive_datum[hivenumb]
			hive.stored_larva = larva_per_hive

	/*
	Our list is empty. This can happen if we had someone ready as alien and predator, and predators are picked first.
	So they may have been removed from the list, oh well.
	*/
	if(LAZYLEN(xenomorphs) < xeno_required_num && LAZYLEN(picked_queens) != LAZYLEN(hives))
		to_world("<h2 style=\"color:red\">Could not find any candidates after initial alien list pass. <b>Aborting</b>.</h2>")
		return

	return 1

// Helper proc to set some constants
/proc/setup_new_xeno(var/datum/mind/new_xeno)
	new_xeno.roundstart_picked = TRUE
	new_xeno.setup_xeno_stats()

/datum/game_mode/proc/check_xeno_late_join(mob/xeno_candidate)
	if(jobban_isbanned(xeno_candidate, JOB_XENOMORPH)) // User is jobbanned
		to_chat(xeno_candidate, SPAN_WARNING("You are banned from playing aliens and cannot spawn as a xenomorph."))
		return
	return 1

/datum/game_mode/proc/attempt_to_join_as_xeno(mob/xeno_candidate, instant_join = 0)
	var/list/available_xenos = list()
	var/list/available_xenos_non_ssd = list()

	for(var/mob/living/carbon/Xenomorph/X in GLOB.living_xeno_list)
		var/area/A = get_area(X)
		if(is_admin_level(X.z) && (!A || !(A.flags_area & AREA_ALLOW_XENO_JOIN)) || X.aghosted)
			continue //xenos on admin z level and aghosted ones don't count
		if(istype(X) && ((!isXenoLarva(X) && (XENO_LEAVE_TIMER - X.away_timer < XENO_AVAILABLE_TIMER)) || (isXenoLarva(X) && (XENO_LEAVE_TIMER_LARVA - X.away_timer < XENO_AVAILABLE_TIMER))))
			if(!X.client)
				available_xenos += X
			else
				available_xenos_non_ssd += X


	var/datum/hive_status/hive
	for(var/hivenumber in GLOB.hive_datum)
		hive = GLOB.hive_datum[hivenumber]
		var/obj/effect/alien/resin/special/pool/SP = hive.spawn_pool
		if(!isnull(SP) && SP.can_spawn_larva())
			if(SSticker.mode && (SSticker.mode.flags_round_type & MODE_RANDOM_HIVE))
				available_xenos |= "pooled larva"
				LAZYADD(available_xenos["pooled larva"], hive)
			else
				var/larva_option = "pooled larva ([hive])"
				available_xenos += larva_option
				available_xenos[larva_option] = list(hive)

	if(!available_xenos.len || (instant_join && !available_xenos_non_ssd.len))
		to_chat(xeno_candidate, SPAN_WARNING("There aren't any available xenomorphs or pooled larvae. You can try getting spawned as a chestburster larva by toggling your Xenomorph candidacy in Preferences -> Toggle SpecialRole Candidacy."))
		return FALSE

	var/mob/living/carbon/Xenomorph/new_xeno
	if(!instant_join)
		var/userInput = tgui_input_list(usr, "Available Xenomorphs", "Join as Xeno", available_xenos, theme="hive_status")

		if(available_xenos[userInput]) //Free xeno mobs have no associated value and skip this. "Pooled larva" strings have a list of hives.
			var/datum/hive_status/H = pick(available_xenos[userInput]) //The list contains all available hives if we are to choose at random, only one element if we already chose a hive by its name.
			var/obj/effect/alien/resin/special/pool/SP = H.spawn_pool
			if(!isnull(SP) && SP.can_spawn_larva()) //isnull() is checked here, in case the spawn pool gets destroyed while the menu is open.
				if(!xeno_bypass_timer)
					var/deathtime = world.time - xeno_candidate.timeofdeath
					if(isnewplayer(xeno_candidate))
						deathtime = 2.5 MINUTES //so new players don't have to wait to latejoin as xeno in the round's first 5 mins.
					if(deathtime < 2.5 MINUTES && !check_client_rights(xeno_candidate.client, R_ADMIN, FALSE))
						var/message = SPAN_WARNING("You have been dead for [DisplayTimeText(deathtime)].")
						to_chat(xeno_candidate, message)
						to_chat(xeno_candidate, SPAN_WARNING("You must wait 2.5 minutes before rejoining the game!"))
						return FALSE

				for(var/mob_name in SP.linked_hive.banished_ckeys)
					if(SP.linked_hive.banished_ckeys[mob_name] == xeno_candidate.ckey)
						to_chat(xeno_candidate, SPAN_WARNING("You are banished from this hive, You may not rejoin unless the Queen re-admits you or dies."))
						return
				if(isnewplayer(xeno_candidate))
					var/mob/new_player/N = xeno_candidate
					N.close_spawn_windows()
				SP.spawn_pooled_larva(xeno_candidate)
				return TRUE
			else
				to_chat(xeno_candidate, SPAN_WARNING("Seems like something went wrong. Try again"))
				return FALSE

		if(!isXeno(userInput) || !xeno_candidate)
			return FALSE
		new_xeno = userInput

		if(!xeno_candidate)
			return FALSE

		if(!(new_xeno in GLOB.living_xeno_list) || new_xeno.stat == DEAD)
			to_chat(xeno_candidate, SPAN_WARNING("You cannot join if the xenomorph is dead."))
			return FALSE

		if(!xeno_bypass_timer)
			var/deathtime = world.time - xeno_candidate.timeofdeath
			if(istype(xeno_candidate, /mob/new_player))
				deathtime = 5 MINUTES //so new players don't have to wait to latejoin as xeno in the round's first 5 mins.
			if(deathtime < 5 MINUTES && !check_client_rights(xeno_candidate.client, R_ADMIN, FALSE))
				var/message = "You have been dead for [DisplayTimeText(deathtime)]."
				message = SPAN_WARNING("[message]")
				to_chat(xeno_candidate, message)
				to_chat(xeno_candidate, SPAN_WARNING("You must wait 5 minutes before rejoining the game!"))
				return FALSE
			if((!isXenoLarva(new_xeno) && new_xeno.away_timer < XENO_LEAVE_TIMER) || (isXenoLarva(new_xeno) && new_xeno.away_timer < XENO_LEAVE_TIMER_LARVA))
				var/to_wait = XENO_LEAVE_TIMER - new_xeno.away_timer
				if(isXenoLarva(new_xeno))
					to_wait = XENO_LEAVE_TIMER_LARVA - new_xeno.away_timer
				to_chat(xeno_candidate, SPAN_WARNING("That player hasn't been away long enough. Please wait [to_wait] second\s longer."))
				return FALSE

		if(alert(xeno_candidate, "Everything checks out. Are you sure you want to transfer yourself into [new_xeno]?", "Confirm Transfer", "Yes", "No") == "Yes")
			if(((!isXenoLarva(new_xeno) && new_xeno.away_timer < XENO_LEAVE_TIMER) || (isXenoLarva(new_xeno) && new_xeno.away_timer < XENO_LEAVE_TIMER_LARVA)) || !(new_xeno in GLOB.living_xeno_list) || new_xeno.stat == DEAD || !xeno_candidate) // Do it again, just in case
				to_chat(xeno_candidate, SPAN_WARNING("That xenomorph can no longer be controlled. Please try another."))
				return FALSE
		else return FALSE
	else new_xeno = pick(available_xenos_non_ssd) //Just picks something at random.
	if(istype(new_xeno) && xeno_candidate && xeno_candidate.client)
		if(isnewplayer(xeno_candidate))
			var/mob/new_player/N = xeno_candidate
			N.close_spawn_windows()
		for(var/mob_name in new_xeno.hive.banished_ckeys)
			if(new_xeno.hive.banished_ckeys[mob_name] == xeno_candidate.ckey)
				to_chat(xeno_candidate, SPAN_WARNING("You are banished from this hive, You may not rejoin unless the Queen re-admits you or dies."))
				return
		if(transfer_xeno(xeno_candidate, new_xeno))
			return 1
	to_chat(xeno_candidate, "JAS01: Something went wrong, tell a coder.")

/datum/game_mode/proc/transfer_xeno(var/xeno_candidate, mob/living/new_xeno)
	if(!xeno_candidate || !isXeno(new_xeno) || QDELETED(new_xeno))
		return FALSE
	var/datum/mind/xeno_candidate_mind
	if(ismind(xeno_candidate))
		xeno_candidate_mind = xeno_candidate
	else if(ismob(xeno_candidate))
		var/mob/M = xeno_candidate
		if(M.mind)
			xeno_candidate_mind = M.mind
		else
			xeno_candidate_mind = new /datum/mind(M.key, M.ckey)
			xeno_candidate_mind.active = TRUE
			xeno_candidate_mind.current = new_xeno
	else if(isclient(xeno_candidate))
		var/client/C = xeno_candidate
		xeno_candidate_mind = new /datum/mind(C.key, C.ckey)
		xeno_candidate_mind.active = TRUE
		xeno_candidate_mind.current = new_xeno
	else
		CRASH("ERROR: transfer_xeno called without mob or mind input: [xeno_candidate]")

	new_xeno.ghostize(FALSE) //Make sure they're not getting a free respawn.
	xeno_candidate_mind.transfer_to(new_xeno, TRUE)

	new_xeno.mind_initialize()
	new_xeno.mind.player_entity = setup_player_entity(xeno_candidate_mind.ckey)
	new_xeno.statistic_tracked = FALSE

	// Let the round recorder know that the key has changed
	SSround_recording.recorder.update_key(new_xeno)
	if(new_xeno.client)
		new_xeno.client.change_view(world_view_size)

	msg_admin_niche("[new_xeno.key] has joined as [new_xeno].")
	if(isXeno(new_xeno)) //Dear lord
		var/mob/living/carbon/Xenomorph/X = new_xeno
		X.generate_name()
		if(X.is_ventcrawling)
			X.update_pipe_icons(X.loc) //If we are in a vent, fetch a fresh vent map
	return TRUE

/// Pick and setup a queen spawn from landmarks, then spawns the player there alongside any required setup
/datum/game_mode/proc/pick_queen_spawn(datum/mind/ghost_mind, var/hivenumber = XENO_HIVE_NORMAL)
	RETURN_TYPE(/turf)

	var/mob/living/original = ghost_mind.current
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(hive.living_xeno_queen || !original || !original.client)
		return

	if(!length(GLOB.queen_spawns))
		transform_queen(ghost_mind, get_turf(pick(GLOB.xeno_spawns)), hivenumber)
		return

	// Make the list pretty
	var/list/spawn_list_map = list()
	for(var/obj/effect/landmark/queen_spawn/T as anything in GLOB.queen_spawns)
		var/area_name = get_area_name(T)
		var/spawn_name = area_name
		var/spawn_counter = 1
		while(spawn_list_map[spawn_name])
			spawn_name = "[area_name] [++spawn_counter]"
		spawn_list_map[spawn_name] = T

	var/selected_spawn = tgui_input_list(original, "Where do you want to spawn?", "Queen Spawn", spawn_list_map, QUEEN_SPAWN_TIMEOUT, theme="hive_status")

	var/turf/QS
	var/obj/effect/landmark/queen_spawn/QSI
	if(selected_spawn)
		QSI = spawn_list_map[selected_spawn]
		QS = get_turf(QSI)

	// Pick a random one if nothing was picked
	if(isnull(QS))
		QSI = pick(GLOB.queen_spawns)
		QS = get_turf(QSI)
		// Support maps without queen spawns
		if(isnull(QS))
			QS = get_turf(pick(GLOB.xeno_spawns))
	transform_queen(ghost_mind, QS, hivenumber)
	return QS

/datum/game_mode/proc/transform_queen(datum/mind/ghost_mind, var/turf/xeno_turf, var/hivenumber = XENO_HIVE_NORMAL)
	var/mob/living/original = ghost_mind.current
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(hive.living_xeno_queen || !original || !original.client)
		return

	var/mob/living/carbon/Xenomorph/new_queen = new /mob/living/carbon/Xenomorph/Queen(xeno_turf, null, hivenumber)
	ghost_mind.transfer_to(new_queen) //The mind is fine, since we already labeled them as a xeno. Away they go.
	ghost_mind.name = ghost_mind.current.name

	new_queen.generate_name()

	SSround_recording.recorder.track_player(new_queen)

	to_chat(new_queen, "<B>You are now the alien queen!</B>")
	to_chat(new_queen, "<B>Your job is to spread the hive.</B>")
	to_chat(new_queen, "<B>You should start by building a hive core.</B>")
	to_chat(new_queen, "Talk in Hivemind using <strong>;</strong> (e.g. ';Hello my children!')")

	// Xeno ressource collection
	//new_queen.crystal_stored = XENO_STARTING_CRYSTAL
	new_queen.update_icons()

//===================================================\\

			//SURVIVOR INITIATLIZE\\

//===================================================\\


// Used by XvX and Infection
//Start the Survivor players. This must go post-setup so we already have a body.
//No need to transfer their mind as they begin as a human.
/datum/game_mode/proc/transform_survivor(var/datum/mind/ghost, var/is_synth = FALSE, var/turf/xeno_turf)
	var/picked_spawn = null
	if(istype(ghost.current, /mob/living) && ghost.current.first_xeno)
		picked_spawn = xeno_turf
	else
		picked_spawn = pick(GLOB.survivor_spawns)
	if(istype(picked_spawn, /obj/effect/landmark/survivor_spawner))
		return survivor_event_transform(ghost.current, picked_spawn, is_synth)
	else
		return survivor_non_event_transform(ghost.current, picked_spawn, is_synth)

/datum/game_mode/proc/survivor_old_equipment(var/mob/living/carbon/human/H, var/is_synth = FALSE)
	var/list/survivor_types = SSmapping.configs[GROUND_MAP].survivor_types

	if(is_synth)
		survivor_types = list(
			/datum/equipment_preset/synth/survivor, //to be expanded later
		)

	//Give them proper jobs and stuff here later
	var/randjob = pick(survivor_types)
	var/not_a_xenomorph = TRUE
	if(H.first_xeno)
		not_a_xenomorph = FALSE
	arm_equipment(H, randjob, FALSE, not_a_xenomorph)


/datum/game_mode/proc/survivor_event_transform(var/mob/living/carbon/human/H, var/obj/effect/landmark/survivor_spawner/spawner, var/is_synth = FALSE)
	H.forceMove(get_turf(spawner))
	var/not_a_xenomorph = TRUE
	if(H.first_xeno)
		not_a_xenomorph = FALSE
	if(!spawner.equipment || is_synth)
		survivor_old_equipment(H, is_synth)
	else
		if(arm_equipment(H, spawner.equipment, FALSE, not_a_xenomorph) == -1)
			to_chat(H, "SET02: Something went wrong, tell a coder. You may ask admin to spawn you as a survivor.")
			return
	if(spawner.roundstart_damage_max>0)
		while(spawner.roundstart_damage_times>0)
			H.take_limb_damage(rand(spawner.roundstart_damage_min,spawner.roundstart_damage_max), 0)
			spawner.roundstart_damage_times--
	H.name = H.get_visible_name()

	if(!H.first_xeno) //Only give objectives/back-stories to uninfected survivors
		if(spawner.intro_text && spawner.intro_text.len)
			spawn(4)
				for(var/line in spawner.intro_text)
					to_chat(H, line)
		else
			spawn(4)
				to_chat(H, "<h2>You are a survivor!</h2>")
				to_chat(H, SPAN_NOTICE(SSmapping.configs[GROUND_MAP].survivor_message))
				to_chat(H, SPAN_NOTICE("You are fully aware of the xenomorph threat and are able to use this knowledge as you see fit."))
				to_chat(H, SPAN_NOTICE("You are NOT aware of the marines or their intentions. "))
		if(spawner.story_text)
			. = 1
			spawn(6)
				var/temp_story = "<b>Your story thus far</b>: " + spawner.story_text
				to_chat(H, temp_story)
				H.mind.memory += temp_story
				//remove ourselves, so we don't get stuff generated for us
				survivors -= H.mind

/datum/game_mode/proc/survivor_non_event_transform(mob/living/carbon/human/H, obj/effect/landmark/spawn_point, is_synth = FALSE)
	H.forceMove(get_turf(spawn_point))
	survivor_old_equipment(H, is_synth)
	H.name = H.get_visible_name()

	//Give them some information
	if(!H.first_xeno) //Only give objectives/back-stories to uninfected survivors
		spawn(4)
			to_chat(H, "<h2>You are a survivor!</h2>")
			to_chat(H, SPAN_NOTICE(SSmapping.configs[GROUND_MAP].survivor_message))
			to_chat(H, SPAN_NOTICE("You are fully aware of the xenomorph threat and are able to use this knowledge as you see fit."))
			to_chat(H, SPAN_NOTICE("You are NOT aware of the marines or their intentions."))
		return 1

/datum/game_mode/proc/tell_survivor_story()
	var/list/survivor_story = list(
								"You watched as a larva burst from the chest of your friend, {name}. You tried to capture the alien thing, but it escaped through the ventilation.",
								"{name} was attacked by a facehugging alien, which impregnated them with an alien lifeform. {name}'s chest exploded in gore as some creature escaped.",
								"You watched in horror as {name} got the alien lifeform's acid on their skin, melting away their flesh. You can still hear the screaming and panic.",
								"The Colony Marshal, {name}, made an announcement that the hostile lifeforms killed many, and that everyone should hide or stay behind closed doors.",
								"You were there when the alien lifeforms broke into the mess hall and dragged away the others. It was a terrible sight, and you have tried avoid large open areas since.",
								"It was horrible, as you watched your friend, {name}, get mauled by the horrible monsters. Their screams of agony hunt you in your dreams, leading to insomnia.",
								"You tried your best to hide, and you have seen the creatures travel through the underground tunnels and ventilation shafts. They seem to like the dark.",
								"When you woke up, it felt like you've slept for years. You don't recall much about your old life, except maybe your name. Just what the hell happened to you?",
								"You were on the front lines, trying to fight the aliens. You have seen them hatch more monsters from other humans, and you know better than to fight against death.",
								"You found something, something incredible. But your discovery was cut short when the monsters appeared and began taking people. Damn the beasts!",
								"{name} protected you when the aliens came. You don't know what happened to them, but that was some time ago, and you haven't seen them since. Maybe they are alive."
								)
	var/list/survivor_multi_story = list(
										"You were separated from your friend, {surv}. You hope they're still alive.",
										"You were having some drinks at the bar with {surv} and {name} when an alien crawled out of the vent and dragged {name} away. You and {surv} split up to find help.",
										"Something spooked you when you were out with {surv} scavenging. You took off in the opposite direction from them, and you haven't seen them since.",
										"When {name} became infected, you and {surv} argued over what to do with the afflicted. You nearly came to blows before walking away, leaving them behind.",
										"You ran into {surv} when out looking for supplies. After a tense stand off, you agreed to stay out of each other's way. They didn't seem so bad.",
										"A lunatic by the name of {name} was preaching doomsday to anyone who would listen. {surv} was there too, and you two shared a laugh before the creatures arrived.",
										"Your last decent memory before everything went to hell is of {surv}. They were generally a good person to have around, and they helped you through tough times.",
										"When {name} called for evacuation, {surv} came with you. The aliens appeared soon after and everyone scattered. You hope your friend {surv} is alright.",
										"You remember an explosion. Then everything went dark. You can only recall {name} and {surv}, who were there. Maybe they know what really happened?",
										"The aliens took your mutual friend, {name}. {surv} helped with the rescue. When you got to the alien hive, your friend was dead. You took different passages out.",
										"You were playing basketball with {surv} when the creatures descended. You bolted in opposite directions, and actually managed to lose the monsters, somehow."
										)

	var/current_survivors[] = survivors //These are the current survivors, so we can remove them once we tell a story.
	var/story //The actual story they will get to read.
	var/random_name
	var/datum/mind/survivor
	while(current_survivors.len)
		survivor = pick(current_survivors)
		if(!istype(survivor))
			current_survivors -= survivor
			continue //Not a mind? How did this happen?

		random_name = pick(random_name(FEMALE),random_name(MALE))

		if(istype(survivor.current, /mob/living) && survivor.current.first_xeno)
			current_survivors -= survivor
			continue

		if(current_survivors.len > 1) //If we have another survivor to pick from.
			if(survivor_multi_story.len) //Unlikely.
				var/datum/mind/another_survivor = pick(current_survivors - survivor) // We don't want them to be picked twice.
				current_survivors -= another_survivor
				if(!istype(another_survivor)) continue//If somehow this thing screwed up, we're going to run another pass.
				story = pick(survivor_multi_story)
				survivor_multi_story -= story
				story = replacetext(story, "{name}", "[random_name]")
				spawn(6)
					var/temp_story = "<b>Your story thus far</b>: " + replacetext(story, "{surv}", "[another_survivor.current.real_name]")
					to_chat(survivor.current, temp_story)
					survivor.memory += temp_story //Add it to their memories.
					temp_story = "<b>Your story thus far</b>: " + replacetext(story, "{surv}", "[survivor.current.real_name]")
					to_chat(another_survivor.current, temp_story)
					another_survivor.memory += temp_story
		else
			if(survivor_story.len) //Shouldn't happen, but technically possible.
				story = pick(survivor_story)
				survivor_story -= story
				spawn(6)
					var/temp_story = "<b>Your story thus far</b>: " + replacetext(story, "{name}", "[random_name]")
					to_chat(survivor.current, temp_story)
					survivor.memory += temp_story

		current_survivors -= survivor
	return 1

//===================================================\\

			//MARINE GEAR INITIATLIZE\\

//===================================================\\

//We do NOT want to initilialize the gear before everyone is properly spawned in
/datum/game_mode/proc/initialize_post_marine_gear_list()
	var/scale = get_scaling_value()

	//Set up attachment vendor contents related to Marine count
	for(var/i in GLOB.cm_vending_vendors)
		var/obj/structure/machinery/cm_vending/sorted/CVS = i
		CVS.populate_product_list(scale)

	//Scale the amount of cargo points through a direct multiplier
	supply_controller.points = round(supply_controller.points * scale)

/datum/game_mode/proc/get_scaling_value()
	//We take the number of marine players, deduced from other lists, and then get a scale multiplier from it, to be used in arbitrary manners to distribute equipment
	//This might count players who ready up but get kicked back to the lobby
	var/marine_pop_size = length(GLOB.alive_human_list)

	//This gives a decimal value representing a scaling multiplier. Cannot go below 1
	return max(marine_pop_size / MARINE_GEAR_SCALING_NORMAL, 1)

// for the toolbox
/datum/game_mode/proc/end_round_message()
	return "Extended round has ended."
