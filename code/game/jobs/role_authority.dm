/*
How this works:
jobs.dm contains the job defines that work on that level only. Things like equipping a character, creating IDs, and so forth, are handled there.
Role Authority handles the creation and assignment of roles. Roles can be things like regular marines, PMC response teams, aliens, and so forth.
Role Authority creates two master lists on New(), one for every role defined in the game, by path, and one only for roles that should appear
at round start, by name. The title of a role is important and is a unique identifier. Two roles can share the same title, but it's really
the same role, just with different equipment, spawn conditions, or something along those lines. The title is there to tell the job ban system
which roles to ban, and it does so through the roles_by_name master list.

When a round starts, the roles are assigned based on the round, from another list. This is done to make sure that both the master list of roles
by name can be kept for things like job bans, while the round may add or remove roles as needed.If you need to equip a mob for a job, always
use roles_by_path as it is an accurate account of every specific role path (with specific equipment).
*/
var/global/datum/authority/branch/role/RoleAuthority

#define GET_RANDOM_JOB 0
#define BE_MARINE 1
#define RETURN_TO_LOBBY 2
#define BE_XENOMORPH 3

#define CHANCE_OF_PRED_ROUND 20

#define NEVER_PRIORITY 	0
#define HIGH_PRIORITY 	1
#define MED_PRIORITY 	2
#define LOW_PRIORITY	3

var/global/marines_assigned = 0


/proc/guest_jobbans(var/job)
	return (job in ROLES_COMMAND)

/datum/authority/branch/role
	var/name = "Role Authority"

	var/list/roles_by_path //Master list generated when role aithority is created, listing every role by path, including variable roles. Great for manually equipping with.
	var/list/roles_by_name //Master list generated when role authority is created, listing every default role by name, including those that may not be regularly selected.
	var/list/roles_for_mode //Derived list of roles only for the game mode, generated when the round starts.
	var/list/roles_whitelist //Associated list of lists, by ckey. Checks to see if a person is whitelisted for a specific role.
	var/list/castes_by_path //Master list generated when role aithority is created, listing every caste by path.
	var/list/castes_by_name //Master list generated when role authority is created, listing every default caste by name.

	var/list/unassigned_players
	var/list/squads

//Whenever the controller is created, we want to set up the basic role lists.
/datum/authority/branch/role/New()
	var/roles_all[] = typesof(/datum/job) - list( //We want to prune all the parent types that are only variable holders.
											/datum/job,
											/datum/job/command,
											/datum/job/civilian,
											/datum/job/logistics,
											/datum/job/logistics/tech,
											/datum/job/marine,
											/datum/job/antag,
											/datum/job/distress,
											/datum/job/distress/provost
											)
	var/squads_all[] = typesof(/datum/squad) - /datum/squad
	var/castes_all[] = subtypesof(/datum/caste_datum)

	if(!length(roles_all))
		to_world(SPAN_DEBUG("Error setting up jobs, no job datums found."))
		log_debug("Error setting up jobs, no job datums found.")
		return //No real reason this should be length zero, so we'll just return instead.

	if(!length(squads_all))
		to_world(SPAN_DEBUG("Error setting up squads, no squad datums found."))
		log_debug("Error setting up squads, no squad datums found.")
		return

	if(!length(castes_all))
		to_world(SPAN_DEBUG("Error setting up castes, no caste datums found."))
		log_debug("Error setting up castes, no caste datums found.")
		return

	castes_by_path = list()
	castes_by_name = list()
	for(var/caste in castes_all) //Setting up our castes.
		var/datum/caste_datum/C = new caste()

		if(!C.caste_type) //In case you forget to subtract one of those variable holder jobs.
			to_world(SPAN_DEBUG("Error setting up castes, blank caste name: [C.type].</span>"))
			log_debug("Error setting up castes, blank caste name: [C.type].")
			continue

		castes_by_path[C.type] = C
		castes_by_name[C.caste_type] = C

	roles_by_path = list()
	roles_by_name = list()
	roles_for_mode = list()
	for(var/role in roles_all) //Setting up our roles.
		var/datum/job/J = new role()

		if(!J.title) //In case you forget to subtract one of those variable holder jobs.
			to_world(SPAN_DEBUG("Error setting up jobs, blank title job: [J.type]."))
			log_debug("Error setting up jobs, blank title job: [J.type].")
			continue

		roles_by_path[J.type] = J
		if(J.flags_startup_parameters & ROLE_ADD_TO_DEFAULT)
			roles_by_name[J.title] = J
		if(J.flags_startup_parameters & ROLE_ADD_TO_MODE)
			roles_for_mode[J.title] = J

	//TODO Come up with some dynamic method of doing this.
	//added exception for WO, so appropriate roles would appear in prefs for WO.
	var/list/MODE_ROLES = ROLES_REGULAR_ALL
	if(Check_WO())
		MODE_ROLES = ROLES_WO + ROLES_MARINES + JOB_XENOMORPH

	var/list/L = new()
	for(var/role in MODE_ROLES) //We're going to re-arrange the list for mode to look better, starting with the officers.
		var/datum/job/J = roles_for_mode[role]
		if(J)
			L[J.title] = J
	roles_for_mode = L

	squads = list()
	for(var/squad in squads_all) //Setting up our squads.
		var/datum/squad/S = new squad()
		squads += S

	load_whitelist()


/datum/authority/branch/role/proc/replace_jobs(var/list/jobs)
	//Replaces one set of jobs with another - used for WO
	for(var/i in jobs)
		var/datum/job/J = new i
		roles_for_mode[J.title] = J
		roles_by_name[J.title] = J


/datum/authority/branch/role/proc/load_whitelist(filename = "config/role_whitelist.txt")
	var/L[] = file2list(filename)
	var/P[]
	var/W[] = new //We want a temporary whitelist list, in case we need to reload.

	var/i
	var/r
	var/ckey
	var/role
	roles_whitelist = list()
	for(i in L)
		if(!i)	continue
		i = trim(i)
		if(!length(i)) continue
		else if (copytext(i, 1, 2) == "#") continue

		P = splittext(i, "+")
		if(!P.len) continue
		ckey = ckey(P[1]) //Converting their key to canonical form. ckey() does this by stripping all spaces, underscores and converting to lower case.

		role = NO_FLAGS
		r = 1
		while(++r <= P.len)
			switch(ckey(P[r]))
				if("yautja") 						role |= WHITELIST_YAUTJA
				if("yautjacouncil")					role |= WHITELIST_YAUTJA_COUNCIL
				if("yautjaleader")					role |= WHITELIST_YAUTJA_LEADER
				if("commander") 					role |= WHITELIST_COMMANDER
				if("commandercouncil")				role |= WHITELIST_COMMANDER_COUNCIL
				if("commanderleader")				role |= WHITELIST_COMMANDER_LEADER
				if("synthetic") 					role |= WHITELIST_SYNTHETIC
				if("syntheticcouncil")				role |= WHITELIST_SYNTHETIC_COUNCIL
				if("syntheticleader")				role |= WHITELIST_SYNTHETIC_LEADER
				if("allgeneral")					role |= WHITELISTS_GENERAL
				if("allcouncil")					role |= (WHITELISTS_COUNCIL|WHITELISTS_GENERAL)
				if("everything", "allleader") 		role |= WHITELIST_EVERYTHING

		W[ckey] = role

	roles_whitelist = W

//#undef FACTION_TO_JOIN

 /*
 Consolidated into a better collection of procs. It was also calling too many loops, and I tried to fix that as well.
 I hope it's easier to tell what the heck this proc is even doing, unlike previously.
 */


/datum/authority/branch/role/proc/setup_candidates_and_roles(var/list/overwritten_roles_for_mode)
	//===============================================================\\
	//PART I: Initializing starting lists and such.
	if(!roles_for_mode && !overwritten_roles_for_mode || !length(roles_for_mode) && !length(overwritten_roles_for_mode))
		return //Can't start if this doesn't exist.

	var/datum/game_mode/G = SSticker.mode
	switch(G.role_instruction)
		if(1) //Replacing the entire list.
			roles_for_mode = new
			for(var/i in G.roles_for_mode)
				var/datum/job/J = roles_by_path[i]
				roles_for_mode[J.title] = J
		if(2) //Adding a role, or multiple roles, to the list.
			for(var/i in G.roles_for_mode)
				var/datum/job/J = roles_by_path[i]
				roles_for_mode[J.title] = J
		if(3) //Subtracting from the list.
			for(var/i in G.roles_for_mode)
				var/datum/job/J = roles_by_path[i]
				roles_for_mode -= J.title

	/*===============================================================*/

	//===============================================================\\
	//PART II: Setting up our player variables and lists, to see if we have anyone to destribute.

	unassigned_players = list()
	for(var/mob/new_player/M in GLOB.player_list) //Get all players who are ready.
		if(!M.ready || M.job)
			continue

		unassigned_players += M

	if(!length(unassigned_players)) //If we don't have any players, the round can't start.
		unassigned_players = null
		return

	unassigned_players = shuffle(unassigned_players, 1) //Shuffle the players.


	// How many positions do we open based on total pop
	for(var/i in roles_by_name)
		var/datum/job/J = roles_by_name[i]
		if(J.scaled)
			J.set_spawn_positions(length(unassigned_players))

	/*===============================================================*/

	//===============================================================\\
	//PART III: Here we're doing the main body of the loop and assigning everyone.

	var/temp_roles_for_mode = roles_for_mode
	if(length(overwritten_roles_for_mode))
		temp_roles_for_mode = overwritten_roles_for_mode

	marines_assigned = do_assignment_count(temp_roles_for_mode - (temp_roles_for_mode & ROLES_XENO), unassigned_players)

	// Set the xeno starting amount based on marines assigned
	var/datum/job/XJ = temp_roles_for_mode[JOB_XENOMORPH]
	if(istype(XJ))
		XJ.set_spawn_positions(marines_assigned)

	// Set survivor starting amount based on marines assigned
	var/datum/job/SJ = temp_roles_for_mode[JOB_SURVIVOR]
	if(istype(SJ))
		SJ.set_spawn_positions(marines_assigned)

	if(prob(CHANCE_OF_PRED_ROUND))
		SSticker?.mode?.flags_round_type |= MODE_PREDATOR
		// Set predators starting amount based on marines assigned
		var/datum/job/PJ = temp_roles_for_mode[JOB_PREDATOR]
		if(istype(PJ))
			PJ.set_spawn_positions(marines_assigned)

	var/list/roles_left = list()
	for(var/priority in HIGH_PRIORITY to LOW_PRIORITY)
		// Assigning xenos first.
		assign_initial_roles(priority, temp_roles_for_mode & ROLES_XENO)
		// Assigning special roles second. (survivor, predator)
		assign_initial_roles(priority, temp_roles_for_mode & (ROLES_WHITELISTED|ROLES_SPECIAL))
		// Assigning command third.
		assign_initial_roles(priority, temp_roles_for_mode & ROLES_COMMAND)
		// Assigning the rest
		var/rest_roles_for_mode = temp_roles_for_mode - (temp_roles_for_mode & ROLES_XENO) - (temp_roles_for_mode & ROLES_COMMAND) - (temp_roles_for_mode & (ROLES_WHITELISTED|ROLES_SPECIAL))
		roles_left = assign_initial_roles(priority, rest_roles_for_mode)

	for(var/mob/new_player/M in unassigned_players)
		switch(M.client.prefs.alternate_option)
			if(GET_RANDOM_JOB)
				roles_left = assign_random_role(M, roles_left) //We want to keep the list between assignments.
			if(BE_MARINE)
				assign_role(M, temp_roles_for_mode[JOB_SQUAD_MARINE]) //Should always be available, in all game modes, as a candidate. Even if it may not be a marine.
			if(BE_XENOMORPH)
				assign_role(M, temp_roles_for_mode[JOB_XENOMORPH])
			if(RETURN_TO_LOBBY)
				M.ready = 0
		unassigned_players -= M

	if(length(unassigned_players))
		to_world(SPAN_DEBUG("Error setting up jobs, unassigned_players still has players left. Length of: [length(unassigned_players)]."))
		log_debug("Error setting up jobs, unassigned_players still has players left. Length of: [length(unassigned_players)].")

	unassigned_players = null

	// Now we take spare unfilled xeno slots and make them larva
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	if(istype(hive) && istype(XJ))
		hive.stored_larva += max(0, (XJ.total_positions - XJ.current_positions))

	/*===============================================================*/

/datum/authority/branch/role/proc/assign_to_xenomorph(var/mob/M)
	var/datum/mind/P = M.mind
	var/datum/game_mode/G = SSticker.mode
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	// if we don't have at least one thing - abort
	if(!P || !G || !hive)
		return

	if(hive.stored_larva)
		hive.stored_larva--
		G.transform_xeno(P)

	return

/datum/authority/branch/role/proc/assign_initial_roles(var/priority, var/list/roles_to_iterate)
	if(!length(roles_to_iterate) || !length(unassigned_players))
		return

	for(var/job in roles_to_iterate)
		var/datum/job/J = roles_to_iterate[job]
		if(!istype(J)) //Shouldn't happen, but who knows.
			to_world(SPAN_DEBUG("Error setting up jobs, no job datum set for: [job]."))
			log_debug("Error setting up jobs, no job datum set for: [job].")
			continue

		for(var/M in unassigned_players)
			var/mob/new_player/NP = M
			if(!(NP.client.prefs.get_job_priority(J.title) == priority))
				continue //If they don't want the job. //TODO Change the name of the prefs proc?

			if(assign_role(NP, J))
				unassigned_players -= NP
				if(J.current_positions >= J.spawn_positions)
					roles_to_iterate -= job //Remove the position, since we no longer need it.
					break //Maximum position is reached?

		if(!length(unassigned_players))
			break //No players left to assign? Break.

/datum/authority/branch/role/proc/do_assignment_count(var/list/roles_to_iterate)
	var/list/fake_assigned_players = unassigned_players.Copy()
	var/people_assigned = 0
	for(var/priority in HIGH_PRIORITY to LOW_PRIORITY)
		for(var/job in roles_to_iterate)
			var/datum/job/J = roles_to_iterate[job]
			if(!istype(J))
				continue

			for(var/M in fake_assigned_players)
				var/mob/new_player/NP = M
				if(!(NP.client.prefs.get_job_priority(J.title) == priority))
					continue

				J.fake_positions++
				people_assigned++
				fake_assigned_players -= NP

				if(J.fake_positions >= J.spawn_positions)
					roles_to_iterate -= job //Remove the position, since we no longer need it.
					break //Maximum position is reached?

			if(!length(fake_assigned_players))
				break //No players left to assign? Break.

	return people_assigned

/datum/authority/branch/role/proc/assign_random_role(mob/new_player/M, list/roles_to_iterate) //In case we want to pass on a list.
	. = roles_to_iterate
	if(length(roles_to_iterate))
		var/datum/job/J
		var/i = 0
		var/j
		while(++i < 3) //Get two passes.
			if(!roles_to_iterate.len || prob(65)) break //Base chance to become a marine when being assigned randomly, or there are no roles available.
			j = pick(roles_to_iterate)
			J = roles_to_iterate[j]

			if(!istype(J))
				to_world(SPAN_DEBUG("Error setting up jobs, no job datum set for: [j]."))
				log_debug("Error setting up jobs, no job datum set for: [j].")
				continue

			if(assign_role(M, J)) //Check to see if they can actually get it.
				if(J.current_positions >= J.spawn_positions) roles_to_iterate -= j
				return roles_to_iterate

	//If they fail the two passes, or no regular roles are available, they become a marine regardless.
	assign_role(M,roles_for_mode[JOB_SQUAD_MARINE])

/datum/authority/branch/role/proc/assign_role(mob/new_player/M, datum/job/J, latejoin = FALSE)
	if(ismob(M) && istype(J))
		if(check_role_entry(M, J, latejoin))
			M.job = J.title
			J.current_positions++
			return TRUE

/datum/authority/branch/role/proc/check_role_entry(mob/new_player/M, datum/job/J, latejoin = FALSE)
	if(jobban_isbanned(M, J.title))
		return FALSE
	if(J.role_ban_alternative && jobban_isbanned(M, J.role_ban_alternative))
		return FALSE
	if(!J.can_play_role(M.client))
		return FALSE
	if(J.flags_startup_parameters & ROLE_WHITELISTED && !(roles_whitelist[M.ckey] & J.flags_whitelist))
		return FALSE
	if(J.total_positions != -1 && J.get_total_positions(latejoin) <= J.current_positions)
		return FALSE
	if(latejoin && !J.late_joinable)
		return FALSE
	return TRUE

/datum/authority/branch/role/proc/free_role(datum/job/J, latejoin = 1) //Want to make sure it's a job, and nothing like a MODE or special role.
	if(istype(J) && J.total_positions != -1 && J.get_total_positions(latejoin) >= J.current_positions)
		J.current_positions--
		return 1

/datum/authority/branch/role/proc/free_role_admin(var/datum/job/J, var/latejoin = 1, var/user) //Specific proc that used for admin "Free Job Slots" verb (round tab)
	if(!istype(J) || J.total_positions == -1)
		return
	if(J.current_positions < 1)	//this should be filtered earlier, but we still check just in case
		to_chat(user, "There are no [J] job slots occupied.")
		return

//here is the main reason this proc exists - to remove freed squad jobs from squad,
//so latejoining person ends in the squad which's job was freed and not random one
	var/datum/squad/sq = null
	if(job_squad_roles.Find(J.title))
		var/list/squad_list = list()
		for(sq in RoleAuthority.squads)
			if(sq.usable)
				squad_list += sq
		sq = null
		sq = input(user, "Select squad you want to free [J.title] slot from.", "Squad Selection")  as null|anything in squad_list
		if(!sq)
			return
		switch(J.title)
			if(JOB_SQUAD_ENGI)
				if(sq.num_engineers > 0)
					sq.num_engineers--
				else
					to_chat(user, "There are no [J.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_MEDIC)
				if(sq.num_medics > 0)
					sq.num_medics--
				else
					to_chat(user, "There are no [J.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_SPECIALIST)
				if(sq.num_specialists > 0)
					sq.num_specialists--
				else
					to_chat(user, "There are no [J.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_SMARTGUN)
				if(sq.num_smartgun > 0)
					sq.num_smartgun--
				else
					to_chat(user, "There are no [J.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_RTO)
				if(sq.num_rto > 0)
					sq.num_rto--
				else
					to_chat(user, "There are no [J.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_LEADER)
				if(sq.num_leaders > 0)
					sq.num_leaders--
				else
					to_chat(user, "There are no [J.title] slots occupied in [sq.name] Squad.")
					return
	J.current_positions--
	message_staff("[key_name(user)] freed the [J.title] job slot[sq ? " in [sq.name] Squad" : ""].")
	return 1

/datum/authority/branch/role/proc/modify_role(datum/job/J, amount)
	if(!istype(J))
		return 0
	if(!J.allow_additional) //if job does not allow additional joins - cancel. Should be caught above
		return 0
	if(amount <= J.current_positions) //we should be able to slot everyone
		return 0
	J.total_positions = amount
	J.total_positions_so_far = amount
	return 1

//I'm not entirely sure why this proc exists. //TODO Figure this out.
/datum/authority/branch/role/proc/reset_roles()
	for(var/mob/new_player/M in GLOB.new_player_list)
		M.job = null


/datum/authority/branch/role/proc/equip_role(mob/living/M, datum/job/J, turf/late_join)
	if(!istype(M) || !istype(J))
		return
	//If they didn't join late, we want to move them to the start position for their role.
	if(late_join)
		M.forceMove(late_join) //If they late joined, we passed on the location from the parent proc.
	else //If they didn't, we need to find a suitable spawn location for them.
		if(!length(GLOB.spawns_by_job[J.type]))
			log_debug("Failed to find a spawn for [J.type]")
			return FALSE
		M.forceMove(get_turf(pick(GLOB.spawns_by_job[J.type])))

	. = TRUE

	if(!ishuman(M))
		return

	var/mob/living/carbon/H = M

	H.job = J.title //TODO Why is this a mob variable at all?

	var/datum/money_account/A

	//Give them an account in the database.
	if(!(J.flags_startup_parameters & ROLE_NO_ACCOUNT))
		A = create_account(H.real_name, rand(50,500)*10, null)
		if(H.mind)
			var/remembered_info = ""
			remembered_info += "<b>Your account number is:</b> #[A.account_number]<br>"
			remembered_info += "<b>Your account pin is:</b> [A.remote_access_pin]<br>"
			remembered_info += "<b>Your account funds are:</b> $[A.money]<br>"

			if(A.transaction_log.len)
				var/datum/transaction/T = A.transaction_log[1]
				remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
			H.mind.store_memory(remembered_info)
			H.mind.initial_account = A

	var/job_whitelist = J.title
	var/whitelist_status = J.get_whitelist_status(roles_whitelist, H.client)

	if(whitelist_status)
		job_whitelist = "[J.title][whitelist_status]"

	if(J.gear_preset_whitelist[job_whitelist])
		arm_equipment(H, J.gear_preset_whitelist[job_whitelist], FALSE, TRUE)
		J.announce_entry_message(H, A, whitelist_status) //Tell them their spawn info.
		J.generate_entry_conditions(H, whitelist_status) //Do any other thing that relates to their spawn.
	else
		arm_equipment(H, J.gear_preset, FALSE, TRUE) //After we move them, we want to equip anything else they should have.
		J.announce_entry_message(H, A) //Tell them their spawn info.
		J.generate_entry_conditions(H) //Do any other thing that relates to their spawn.

	if(J.flags_startup_parameters & ROLE_ADD_TO_SQUAD) //Are we a muhreen? Randomize our squad. This should go AFTER IDs. //TODO Robust this later.
		randomize_squad(H)

	if(Check_WO() && job_squad_roles.Find(H.job))	//activates self setting proc for marine headsets for WO
		var/datum/game_mode/whiskey_outpost/WO = SSticker.mode
		WO.self_set_headset(H)

	H.sec_hud_set_ID()
	H.hud_set_squad()

	SSround_recording.recorder.track_player(H)

//Find which squad has the least population. If all 4 squads are equal it should just use a random one
/datum/authority/branch/role/proc/get_lowest_squad(mob/living/carbon/human/H)
	if(!squads.len) //Something went wrong, our squads aren't set up.
		to_world("Warning, something messed up in get_lowest_squad(). No squads set up!")
		return null


	//we make a list of squad that is randomized so alpha isn't always lowest squad.
	var/list/squads_copy = squads.Copy()
	var/list/mixed_squads = list()

	for(var/i= 1 to squads_copy.len)
		var/datum/squad/S = pick_n_take(squads_copy)
		if (S.usable)
			mixed_squads += S

	var/datum/squad/lowest = pick(mixed_squads)

	var/datum/pref_squad_name
	if(H && H.client && H.client.prefs.preferred_squad && H.client.prefs.preferred_squad != "None")
		pref_squad_name = H.client.prefs.preferred_squad

	for(var/datum/squad/L in mixed_squads)
		if(L.usable)
			if(pref_squad_name && L.name == pref_squad_name)
				lowest = L
				break


	if(!lowest)
		to_world("Warning! Bug in get_random_squad()!")
		return null

	var/lowest_count = lowest.count
	var/current_count = 0

	if(!pref_squad_name)
		//Loop through squads.
		for(var/datum/squad/S in mixed_squads)
			if(!S)
				to_world("Warning: Null squad in get_lowest_squad. Call a coder!")
				break //null squad somehow, let's just abort
			current_count = S.count //Grab our current squad's #
			if(current_count >= (lowest_count - 2)) //Current squad count is not much lower than the chosen one. Skip it.
				continue
			lowest_count = current_count //We found a winner! This squad is much lower than our default. Make it the new default.
			lowest = S //'Select' this squad.

	return lowest //Return whichever squad won the competition.

//This proc is a bit of a misnomer, since there's no actual randomization going on.
/datum/authority/branch/role/proc/randomize_squad(var/mob/living/carbon/human/H, var/skip_limit = FALSE)
	if(!H)
		return

	if(!squads.len)
		to_chat(H, "Something went wrong with your squad randomizer! Tell a coder!")
		return //Shit, where's our squad data

	if(H.assigned_squad) //Wait, we already have a squad. Get outta here!
		return

	//we make a list of squad that is randomized so alpha isn't always lowest squad.
	var/list/squads_copy = squads.Copy()
	var/list/mixed_squads = list()
	// The following code removes non useable squads from the lists of squads we assign marines too.
	for(var/i= 1 to squads_copy.len)
		var/datum/squad/S = pick_n_take(squads_copy)
		if (S.usable)
			mixed_squads += S

	//Deal with non-standards first.
	//Non-standards are distributed regardless of squad population.
	//If the number of available positions for the job are more than max_whatever, it will break.
	//Ie. 8 squad medic jobs should be available, and total medics in squads should be 8.
	if(H.job != JOB_SQUAD_MARINE && H.job != "Reinforcements")
		var/pref_squad_name
		if(H && H.client && H.client.prefs.preferred_squad && H.client.prefs.preferred_squad != "None")
			pref_squad_name = H.client.prefs.preferred_squad

		var/datum/squad/lowest

		switch(H.job)
			if("Squad Engineer")
				for(var/datum/squad/S in mixed_squads)
					if(S.usable)
						if(!skip_limit && S.num_engineers >= S.max_engineers) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us, no more searching needed.
							return

						if(!lowest)
							lowest = S
						else if(S.num_engineers < lowest.num_engineers)
							lowest = S

			if("Squad Medic")
				for(var/datum/squad/S in mixed_squads)
					if(S.usable)
						if(!skip_limit && S.num_medics >= S.max_medics) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = S
						else if(S.num_medics < lowest.num_medics)
							lowest = S

			if("Squad Leader")
				for(var/datum/squad/S in mixed_squads)
					if(S.usable)
						if(!skip_limit && S.num_leaders >= S.max_leaders) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = S
						else if(S.num_leaders < lowest.num_leaders)
							lowest = S

			if("Squad Specialist")
				for(var/datum/squad/S in mixed_squads)
					if(S.usable)
						if(!skip_limit && S.num_specialists >= S.max_specialists) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = S
						else if(S.num_specialists < lowest.num_specialists)
							lowest = S

			if("Squad RT Operator")
				for(var/datum/squad/S in mixed_squads)
					if(S.usable)
						if(!skip_limit && S.num_rto >= S.max_rto) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = S
						else if(S.num_rto < lowest.num_rto)
							lowest = S

			if("Squad Smartgunner")
				for(var/datum/squad/S in mixed_squads)
					if(S.usable)
						if(!skip_limit && S.num_smartgun >= S.max_smartgun) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = S
						else if(S.num_smartgun < lowest.num_smartgun)
							lowest = S
		if(!lowest)
			var/ranpick = rand(1,4)
			lowest = mixed_squads[ranpick]
		if(lowest)	lowest.put_marine_in_squad(H)
		else to_chat(H, "Something went badly with randomize_squad()! Tell a coder!")

	else
		//Deal with marines. They get distributed to the lowest populated squad.
		var/datum/squad/given_squad = get_lowest_squad(H)
		if(!given_squad || !istype(given_squad)) //Something went horribly wrong!
			to_chat(H, "Something went wrong with randomize_squad()! Tell a coder!")
			return
		given_squad.put_marine_in_squad(H) //Found one, finish up

/proc/get_desired_status(var/desired_status, var/status_limit)
	var/found_desired = FALSE
	var/found_limit = FALSE

	for(var/status in whitelist_hierarchy)
		if(status == desired_status)
			found_desired = TRUE
			break
		if(status == status_limit)
			found_limit = TRUE
			break

	if(found_desired)
		return desired_status
	else if(found_limit)
		return status_limit

	return desired_status
