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

#define NEVER_PRIORITY 	0
#define HIGH_PRIORITY 	1
#define MED_PRIORITY 	2
#define LOW_PRIORITY	3

#define SHIPSIDE_ROLE_WEIGHT 0.5

var/global/players_preassigned = 0


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

	/// List of mapped roles that should be used in place of usual ones
	var/list/role_mappings
	var/list/default_roles

	var/list/unassigned_players
	var/list/squads
	var/list/squads_by_type

//Whenever the controller is created, we want to set up the basic role lists.
/datum/authority/branch/role/New()
	var/roles_all[] = typesof(/datum/job) - list( //We want to prune all the parent types that are only variable holders.
											/datum/job,
											/datum/job/command,
											/datum/job/civilian,
											/datum/job/logistics,
											/datum/job/marine,
											/datum/job/antag,
											/datum/job/special
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
		roles_by_name[J.title] = J

	squads = list()
	squads_by_type = list()
	for(var/squad in squads_all) //Setting up our squads.
		var/datum/squad/S = new squad()
		squads += S
		squads_by_type[S.type] = S

	load_whitelist()


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
				if("yautjalegacy") 					role |= WHITELIST_YAUTJA_LEGACY
				if("yautjacouncil")					role |= WHITELIST_YAUTJA_COUNCIL
				if("yautjacouncillegacy")			role |= WHITELIST_YAUTJA_COUNCIL_LEGACY
				if("yautjaleader")					role |= WHITELIST_YAUTJA_LEADER
				if("commander") 					role |= WHITELIST_COMMANDER
				if("commandercouncil")				role |= WHITELIST_COMMANDER_COUNCIL
				if("commandercouncillegacy")		role |= WHITELIST_COMMANDER_COUNCIL_LEGACY
				if("commanderleader")				role |= WHITELIST_COMMANDER_LEADER
				if("synthetic") 					role |= WHITELIST_SYNTHETIC
				if("syntheticcouncil")				role |= WHITELIST_SYNTHETIC_COUNCIL
				if("syntheticcouncillegacy")		role |= WHITELIST_SYNTHETIC_COUNCIL_LEGACY
				if("syntheticleader")				role |= WHITELIST_SYNTHETIC_LEADER
				if("advisor")						role |= WHITELIST_MENTOR
				if("allgeneral")					role |= WHITELISTS_GENERAL
				if("allcouncil")					role |= (WHITELISTS_COUNCIL|WHITELISTS_GENERAL)
				if("alllegacycouncil")				role |= (WHITELISTS_LEGACY_COUNCIL|WHITELISTS_GENERAL)
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
	//PART I: Get roles relevant to the mode

	var/datum/game_mode/G = SSticker.mode
	roles_for_mode = list()
	for(var/role_name in G.get_roles_list())
		var/datum/job/J = roles_by_name[role_name]
		if(!J)
			continue
		roles_for_mode[role_name] = J

	// Also register game mode specific mappings to standard roles
	role_mappings = list()
	default_roles = list()
	if(G.role_mappings)
		for(var/role_path in G.role_mappings)
			var/mapped_title = G.role_mappings[role_path]
			var/datum/job/J = roles_by_path[role_path]
			if(!J || !roles_by_name[mapped_title])
				continue
			role_mappings[mapped_title] = J
			default_roles[J.title] = mapped_title

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

	var/list/temp_roles_for_mode = roles_for_mode
	if(length(overwritten_roles_for_mode))
		temp_roles_for_mode = overwritten_roles_for_mode

	// Get balancing weight for the readied players.
	// Squad marine roles have a weight of 1, and shipside roles have a lower weight of SHIPSIDE_ROLE_WEIGHT.
	players_preassigned = assign_roles(temp_roles_for_mode.Copy(), unassigned_players.Copy(), TRUE)

	// Even though we pass a copy of temp_roles_for_mode, job counters still change, so we reset them here.
	for(var/title in temp_roles_for_mode)
		var/datum/job/J = temp_roles_for_mode[title]
		J.current_positions = 0

    // Set up limits for other roles based on our balancing weight number.
	// Set the xeno starting amount based on marines assigned
	var/datum/job/antag/xenos/XJ = temp_roles_for_mode[JOB_XENOMORPH]
	if(istype(XJ))
		XJ.set_spawn_positions(players_preassigned)

	// Limit the number of SQUAD MARINE roles players can roll initially
	var/datum/job/SMJ = GET_MAPPED_ROLE(JOB_SQUAD_MARINE)
	if(istype(SMJ))
		SMJ.set_spawn_positions(players_preassigned)

	// Set survivor starting amount based on marines assigned
	var/datum/job/SJ = temp_roles_for_mode[JOB_SURVIVOR]
	if(istype(SJ))
		SJ.set_spawn_positions(players_preassigned)

	if(prob(SSticker.mode.pred_round_chance))
		SSticker.mode.flags_round_type |= MODE_PREDATOR
		// Set predators starting amount based on marines assigned
		var/datum/job/PJ = temp_roles_for_mode[JOB_PREDATOR]
		if(istype(PJ))
			PJ.set_spawn_positions(players_preassigned)

	// Assign the roles, this time for real, respecting limits we have established.
	var/list/roles_left = assign_roles(temp_roles_for_mode, unassigned_players)

	var/alternate_option_assigned = 0;
	for(var/mob/new_player/M in unassigned_players)
		switch(M.client.prefs.alternate_option)
			if(GET_RANDOM_JOB)
				roles_left = assign_random_role(M, roles_left) //We want to keep the list between assignments.
				alternate_option_assigned++
			if(BE_MARINE)
				var/datum/job/marine_job = GET_MAPPED_ROLE(JOB_SQUAD_MARINE)
				assign_role(M, marine_job) //Should always be available, in all game modes, as a candidate. Even if it may not be a marine.
				alternate_option_assigned++
			if(BE_XENOMORPH)
				assign_role(M, temp_roles_for_mode[JOB_XENOMORPH])
			if(RETURN_TO_LOBBY)
				M.ready = 0
		unassigned_players -= M

	if(length(unassigned_players))
		to_world(SPAN_DEBUG("Error setting up jobs, unassigned_players still has players left. Length of: [length(unassigned_players)]."))
		log_debug("Error setting up jobs, unassigned_players still has players left. Length of: [length(unassigned_players)].")

	unassigned_players = null

	// Now we take spare unfilled xeno slots and make them larva NEW
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	if(istype(hive) && istype(XJ))
		hive.stored_larva += max(0, (XJ.total_positions - XJ.current_positions) \
		+ (XJ.calculate_extra_spawn_positions(alternate_option_assigned)))

	/*===============================================================*/

/**
* Assign roles to the players. Return roles that are still avialable.
* If count is true, return role balancing weight instead.
*/
/datum/authority/branch/role/proc/assign_roles(var/list/roles_for_mode, var/list/unassigned_players, count = FALSE)
	var/list/roles_left = list()
	var/assigned = 0
	for(var/priority in HIGH_PRIORITY to LOW_PRIORITY)
		// Assigning xenos first.
		assigned += assign_initial_roles(priority, roles_for_mode & ROLES_XENO, unassigned_players)
		// Assigning special roles second. (survivor, predator)
		assigned += assign_initial_roles(priority, roles_for_mode & (ROLES_WHITELISTED|ROLES_SPECIAL), unassigned_players)
		// Assigning command third.
		assigned += assign_initial_roles(priority, roles_for_mode & ROLES_COMMAND, unassigned_players)
		// Assigning the rest
		var/rest_roles_for_mode = roles_for_mode - (roles_for_mode & ROLES_XENO) - (roles_for_mode & ROLES_COMMAND) - (roles_for_mode & (ROLES_WHITELISTED|ROLES_SPECIAL))
		if(count)
			assigned += assign_initial_roles(priority, rest_roles_for_mode, unassigned_players)
		else
			roles_left= assign_initial_roles(priority, rest_roles_for_mode, unassigned_players, FALSE)
	if(count)
		return assigned
	return roles_left

/datum/authority/branch/role/proc/assign_initial_roles(var/priority, var/list/roles_to_iterate, var/list/unassigned_players, count = TRUE)
	var/assigned = 0
	if(!length(roles_to_iterate) || !length(unassigned_players))
		return

	for(var/job in roles_to_iterate)
		var/datum/job/J = roles_to_iterate[job]
		if(!istype(J)) //Shouldn't happen, but who knows.
			to_world(SPAN_DEBUG("Error setting up jobs, no job datum set for: [job]."))
			log_debug("Error setting up jobs, no job datum set for: [job].")
			continue

		var/role_weight = calculate_role_weight(J)
		for(var/M in unassigned_players)
			var/mob/new_player/NP = M
			if(!(NP.client.prefs.get_job_priority(J.title) == priority))
				continue //If they don't want the job. //TODO Change the name of the prefs proc?

			if(assign_role(NP, J))
				assigned += role_weight
				unassigned_players -= NP
				// -1 check is not strictly needed here, since standard marines are
				// supposed to have an actual spawn_positions number at this point
				if(J.spawn_positions != -1 && J.current_positions >= J.spawn_positions)
					roles_to_iterate -= job //Remove the position, since we no longer need it.
					break //Maximum position is reached?

		if(!length(unassigned_players))
			break //No players left to assign? Break.
	if(count)
		return assigned
	return roles_to_iterate

/**
* Calculate role balance weight for one person joining as that role. This weight is used
* when calculating the number of xenos both roundstart and burrowed larva they get for
* people late joining. This weight also controls the size of local wildlife population,
* survivors and the number of roundstart Squad Rifleman slots.
*/
/datum/authority/branch/role/proc/calculate_role_weight(var/datum/job/J)
	if(ROLES_MARINES.Find(J.title))
		return 1
	if(ROLES_XENO.Find(J.title))
		return 1
	if(J.title == JOB_SURVIVOR)
		return 1
	return SHIPSIDE_ROLE_WEIGHT

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
	var/datum/job/marine_job = GET_MAPPED_ROLE(JOB_SQUAD_MARINE)
	assign_role(M, marine_job)

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
	if(amount < J.current_positions) //we should be able to slot everyone
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

	if(Check_WO() && job_squad_roles.Find(GET_DEFAULT_ROLE(H.job)))	//activates self setting proc for marine headsets for WO
		var/datum/game_mode/whiskey_outpost/WO = SSticker.mode
		WO.self_set_headset(H)

	var/assigned_squad
	if(ishuman(H))
		var/mob/living/carbon/human/human = H
		if(human.assigned_squad)
			assigned_squad = human.assigned_squad.name

	if(isturf(late_join))
		H.forceMove(late_join)
	else if(late_join)
		var/turf/late_join_turf
		if(GLOB.latejoin_by_squad[assigned_squad])
			late_join_turf = get_turf(pick(GLOB.latejoin_by_squad[assigned_squad]))
		else
			late_join_turf = get_turf(pick(GLOB.latejoin))
		H.forceMove(late_join_turf)
	else
		var/turf/join_turf
		if(assigned_squad && GLOB.spawns_by_squad_and_job[assigned_squad] && GLOB.spawns_by_squad_and_job[assigned_squad][J.type])
			join_turf = get_turf(pick(GLOB.spawns_by_squad_and_job[assigned_squad][J.type]))
		else if(GLOB.spawns_by_job[J.type])
			join_turf = get_turf(pick(GLOB.spawns_by_job[J.type]))
		else if(assigned_squad && GLOB.latejoin_by_squad[assigned_squad])
			join_turf = get_turf(pick(GLOB.latejoin_by_squad[assigned_squad]))
		else
			join_turf = get_turf(pick(GLOB.latejoin))
		H.forceMove(join_turf)

	for(var/cardinal in GLOB.cardinals)
		var/obj/structure/machinery/cryopod/pod = locate() in get_step(H, cardinal)
		if(pod)
			pod.go_in_cryopod(H, silent = TRUE)
			break

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
		if (S.roundstart && S.usable && S.faction == H.faction && S.name != "Root")
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
		if (S.roundstart && S.usable && S.faction == H.faction && S.name != "Root")
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
			if(JOB_SQUAD_ENGI)
				for(var/datum/squad/S in mixed_squads)
					if(S.usable && S.roundstart)
						if(!skip_limit && S.num_engineers >= S.max_engineers) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us, no more searching needed.
							return

						if(!lowest)
							lowest = S
						else if(S.num_engineers < lowest.num_engineers)
							lowest = S

			if(JOB_SQUAD_MEDIC)
				for(var/datum/squad/S in mixed_squads)
					if(S.usable && S.roundstart)
						if(!skip_limit && S.num_medics >= S.max_medics) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = S
						else if(S.num_medics < lowest.num_medics)
							lowest = S

			if(JOB_SQUAD_LEADER)
				for(var/datum/squad/S in mixed_squads)
					if(S.usable && S.roundstart)
						if(!skip_limit && S.num_leaders >= S.max_leaders) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = S
						else if(S.num_leaders < lowest.num_leaders)
							lowest = S

			if(JOB_SQUAD_SPECIALIST)
				for(var/datum/squad/S in mixed_squads)
					if(S.usable && S.roundstart)
						if(!skip_limit && S.num_specialists >= S.max_specialists) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = S
						else if(S.num_specialists < lowest.num_specialists)
							lowest = S

			if(JOB_SQUAD_RTO)
				for(var/datum/squad/S in mixed_squads)
					if(S.usable && S.roundstart)
						if(!skip_limit && S.num_rto >= S.max_rto) continue
						if(pref_squad_name && S.name == pref_squad_name)
							S.put_marine_in_squad(H) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = S
						else if(S.num_rto < lowest.num_rto)
							lowest = S

			if(JOB_SQUAD_SMARTGUN)
				for(var/datum/squad/S in mixed_squads)
					if(S.usable && S.roundstart)
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

/datum/authority/branch/role/proc/get_caste_by_text(var/name)
	var/mob/living/carbon/Xenomorph/M
	switch(name) //ADD NEW CASTES HERE!
		if(XENO_CASTE_LARVA)
			M = /mob/living/carbon/Xenomorph/Larva
		if(XENO_CASTE_PREDALIEN_LARVA)
			M = /mob/living/carbon/Xenomorph/Larva/predalien
		if(XENO_CASTE_FACEHUGGER)
			M = /mob/living/carbon/Xenomorph/Facehugger
		if(XENO_CASTE_RUNNER)
			M = /mob/living/carbon/Xenomorph/Runner
		if(XENO_CASTE_DRONE)
			M = /mob/living/carbon/Xenomorph/Drone
		if(XENO_CASTE_CARRIER)
			M = /mob/living/carbon/Xenomorph/Carrier
		if(XENO_CASTE_HIVELORD)
			M = /mob/living/carbon/Xenomorph/Hivelord
		if(XENO_CASTE_BURROWER)
			M = /mob/living/carbon/Xenomorph/Burrower
		if(XENO_CASTE_PRAETORIAN)
			M = /mob/living/carbon/Xenomorph/Praetorian
		if(XENO_CASTE_RAVAGER)
			M = /mob/living/carbon/Xenomorph/Ravager
		if(XENO_CASTE_SENTINEL)
			M = /mob/living/carbon/Xenomorph/Sentinel
		if(XENO_CASTE_SPITTER)
			M = /mob/living/carbon/Xenomorph/Spitter
		if(XENO_CASTE_LURKER)
			M = /mob/living/carbon/Xenomorph/Lurker
		if(XENO_CASTE_WARRIOR)
			M = /mob/living/carbon/Xenomorph/Warrior
		if(XENO_CASTE_DEFENDER)
			M = /mob/living/carbon/Xenomorph/Defender
		if(XENO_CASTE_QUEEN)
			M = /mob/living/carbon/Xenomorph/Queen
		if(XENO_CASTE_CRUSHER)
			M = /mob/living/carbon/Xenomorph/Crusher
		if(XENO_CASTE_BOILER)
			M = /mob/living/carbon/Xenomorph/Boiler
		if(XENO_CASTE_PREDALIEN)
			M =	/mob/living/carbon/Xenomorph/Predalien
		if(XENO_CASTE_HELLHOUND)
			M =	/mob/living/carbon/Xenomorph/Hellhound
	return M


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

/proc/transfer_marine_to_squad(var/mob/living/carbon/human/transfer_marine, var/datum/squad/new_squad, var/datum/squad/old_squad, var/obj/item/card/id/ID)
	if(old_squad)
		if(transfer_marine.assigned_fireteam)
			if(old_squad.fireteam_leaders["FT[transfer_marine.assigned_fireteam]"] == transfer_marine)
				old_squad.unassign_ft_leader(transfer_marine.assigned_fireteam, TRUE, FALSE)
			old_squad.unassign_fireteam(transfer_marine, TRUE)	//reset fireteam assignment
		old_squad.remove_marine_from_squad(transfer_marine, ID)
		old_squad.update_free_mar()
		old_squad.update_squad_ui()
	. = new_squad.put_marine_in_squad(transfer_marine, ID)
	if(.)
		new_squad.update_free_mar()
		new_squad.update_squad_ui()

		var/marine_ref = WEAKREF(transfer_marine)
		for(var/datum/data/record/t in GLOB.data_core.general) //we update the crew manifest
			if(t.fields["ref"] == marine_ref)
				t.fields["squad"] = new_squad.name
				break

		transfer_marine.hud_set_squad()

// returns TRUE if transfer_marine's role is at max capacity in the new squad
/datum/authority/branch/role/proc/check_squad_capacity(var/mob/living/carbon/human/transfer_marine, var/datum/squad/new_squad)
	switch(transfer_marine.job)
		if(JOB_SQUAD_LEADER)
			if(new_squad.num_leaders >= new_squad.max_leaders)
				return TRUE
		if(JOB_SQUAD_SPECIALIST)
			if(new_squad.num_specialists >= new_squad.max_specialists)
				return TRUE
		if(JOB_SQUAD_ENGI)
			if(new_squad.num_engineers >= new_squad.max_engineers)
				return TRUE
		if(JOB_SQUAD_MEDIC)
			if(new_squad.num_medics >= new_squad.max_medics)
				return TRUE
		if(JOB_SQUAD_SMARTGUN)
			if(new_squad.num_smartgun >= new_squad.max_smartgun)
				return TRUE
		if(JOB_SQUAD_RTO)
			if(new_squad.num_rto >= new_squad.max_rto)
				return TRUE
	return FALSE
