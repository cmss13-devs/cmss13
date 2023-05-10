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

#define NEVER_PRIORITY 0
#define HIGH_PRIORITY 1
#define MED_PRIORITY 2
#define LOW_PRIORITY 3

#define SHIPSIDE_ROLE_WEIGHT 0.5

var/global/players_preassigned = 0


/proc/guest_jobbans(job)
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
											/datum/job/special,
											/datum/job/special/provost,
											/datum/job/special/uaac,
											/datum/job/special/uaac/tis,
											/datum/job/special/uscm,
											/datum/job/command/tank_crew //Rip VC
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
		var/datum/caste_datum/current_caste = new caste()

		if(!current_caste.caste_type) //In case you forget to subtract one of those variable holder jobs.
			to_world(SPAN_DEBUG("Error setting up castes, blank caste name: [current_caste.type].</span>"))
			log_debug("Error setting up castes, blank caste name: [current_caste.type].")
			continue

		castes_by_path[current_caste.type] = current_caste
		castes_by_name[current_caste.caste_type] = current_caste

	roles_by_path = list()
	roles_by_name = list()
	roles_for_mode = list()
	for(var/role in roles_all) //Setting up our roles.
		var/datum/job/current_job = new role()

		if(!current_job.title) //In case you forget to subtract one of those variable holder jobs.
			to_world(SPAN_DEBUG("Error setting up jobs, blank title job: [current_job.type]."))
			log_debug("Error setting up jobs, blank title job: [current_job.type].")
			continue

		roles_by_path[current_job.type] = current_job
		roles_by_name[current_job.title] = current_job

	squads = list()
	squads_by_type = list()
	for(var/squad in squads_all) //Setting up our squads.
		var/datum/squad/current_squad = new squad()
		squads += current_squad
		squads_by_type[current_squad.type] = current_squad

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
		if(!i) continue
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
				if("workingjoe")					role |= WHITELIST_JOE
				if("synthetic") 					role |= (WHITELIST_SYNTHETIC|WHITELIST_JOE)
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


/datum/authority/branch/role/proc/setup_candidates_and_roles(list/overwritten_roles_for_mode)
	//===============================================================\\
	//PART I: Get roles relevant to the mode

	var/datum/game_mode/mode = SSticker.mode
	roles_for_mode = list()
	for(var/role_name in mode.get_roles_list())
		var/datum/job/current_job = roles_by_name[role_name]
		if(!current_job)
			continue
		roles_for_mode[role_name] = current_job

	// Also register game mode specific mappings to standard roles
	role_mappings = list()
	default_roles = list()
	if(mode.role_mappings)
		for(var/role_path in mode.role_mappings)
			var/mapped_title = mode.role_mappings[role_path]
			var/datum/job/current_job = roles_by_path[role_path]
			if(!current_job || !roles_by_name[mapped_title])
				continue
			role_mappings[mapped_title] = current_job
			default_roles[current_job.title] = mapped_title

	/*===============================================================*/

	//===============================================================\\
	//PART II: Setting up our player variables and lists, to see if we have anyone to destribute.

	unassigned_players = list()
	for(var/mob/new_player/current_player in GLOB.player_list) //Get all players who are ready.
		if(!current_player.ready || current_player.job)
			continue

		unassigned_players += current_player

	if(!length(unassigned_players)) //If we don't have any players, the round can't start.
		unassigned_players = null
		return

	unassigned_players = shuffle(unassigned_players, 1) //Shuffle the players.


	// How many positions do we open based on total pop
	for(var/i in roles_by_name)
		var/datum/job/current_job = roles_by_name[i]
		if(current_job.scaled)
			current_job.set_spawn_positions(length(unassigned_players))

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
		var/datum/job/current_job = temp_roles_for_mode[title]
		current_job.current_positions = 0

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

	var/datum/job/CO_surv_job = temp_roles_for_mode[JOB_CO_SURVIVOR]
	if(istype(CO_surv_job))
		CO_surv_job.set_spawn_positions(players_preassigned)

	if(SSnightmare.get_scenario_value("predator_round"))
		SSticker.mode.flags_round_type |= MODE_PREDATOR
		// Set predators starting amount based on marines assigned
		var/datum/job/PJ = temp_roles_for_mode[JOB_PREDATOR]
		if(istype(PJ))
			PJ.set_spawn_positions(players_preassigned)

	// Assign the roles, this time for real, respecting limits we have established.
	var/list/roles_left = assign_roles(temp_roles_for_mode, unassigned_players)

	var/alternate_option_assigned = 0;
	for(var/mob/new_player/current_player in unassigned_players)
		switch(current_player.client.prefs.alternate_option)
			if(GET_RANDOM_JOB)
				roles_left = assign_random_role(current_player, roles_left) //We want to keep the list between assignments.
				alternate_option_assigned++
			if(BE_MARINE)
				var/datum/job/marine_job = GET_MAPPED_ROLE(JOB_SQUAD_MARINE)
				assign_role(current_player, marine_job) //Should always be available, in all game modes, as a candidate. Even if it may not be a marine.
				alternate_option_assigned++
			if(BE_XENOMORPH)
				assign_role(current_player, temp_roles_for_mode[JOB_XENOMORPH])
			if(RETURN_TO_LOBBY)
				current_player.ready = 0
		unassigned_players -= current_player

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
/datum/authority/branch/role/proc/assign_roles(list/roles_for_mode, list/unassigned_players, count = FALSE)
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

/datum/authority/branch/role/proc/assign_initial_roles(priority, list/roles_to_iterate, list/unassigned_players, count = TRUE)
	var/assigned = 0
	if(!length(roles_to_iterate) || !length(unassigned_players))
		return

	for(var/job in roles_to_iterate)
		var/datum/job/current_job = roles_to_iterate[job]
		if(!istype(current_job)) //Shouldn't happen, but who knows.
			to_world(SPAN_DEBUG("Error setting up jobs, no job datum set for: [job]."))
			log_debug("Error setting up jobs, no job datum set for: [job].")
			continue

		var/role_weight = calculate_role_weight(current_job)
		for(var/current_player in unassigned_players)
			var/mob/new_player/NP = current_player
			if(!(NP.client.prefs.get_job_priority(current_job.title) == priority))
				continue //If they don't want the job. //TODO Change the name of the prefs proc?

			if(assign_role(NP, current_job))
				assigned += role_weight
				unassigned_players -= NP
				// -1 check is not strictly needed here, since standard marines are
				// supposed to have an actual spawn_positions number at this point
				if(current_job.spawn_positions != -1 && current_job.current_positions >= current_job.spawn_positions)
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
/datum/authority/branch/role/proc/calculate_role_weight(datum/job/current_job)
	if(ROLES_MARINES.Find(current_job.title))
		return 1
	if(ROLES_XENO.Find(current_job.title))
		return 1
	if(current_job.title == JOB_SURVIVOR)
		return 1
	return SHIPSIDE_ROLE_WEIGHT

/datum/authority/branch/role/proc/assign_random_role(mob/new_player/current_player, list/roles_to_iterate) //In case we want to pass on a list.
	. = roles_to_iterate
	if(length(roles_to_iterate))
		var/datum/job/current_job
		var/i = 0
		var/j
		while(++i < 3) //Get two passes.
			if(!roles_to_iterate.len || prob(65)) break //Base chance to become a marine when being assigned randomly, or there are no roles available.
			j = pick(roles_to_iterate)
			current_job = roles_to_iterate[j]

			if(!istype(current_job))
				to_world(SPAN_DEBUG("Error setting up jobs, no job datum set for: [j]."))
				log_debug("Error setting up jobs, no job datum set for: [j].")
				continue

			if(assign_role(current_player, current_job)) //Check to see if they can actually get it.
				if(current_job.current_positions >= current_job.spawn_positions) roles_to_iterate -= j
				return roles_to_iterate

	//If they fail the two passes, or no regular roles are available, they become a marine regardless.
	var/datum/job/marine_job = GET_MAPPED_ROLE(JOB_SQUAD_MARINE)
	assign_role(current_player, marine_job)

/datum/authority/branch/role/proc/assign_role(mob/new_player/current_player, datum/job/current_job, latejoin = FALSE)
	if(ismob(current_player) && istype(current_job))
		if(check_role_entry(current_player, current_job, latejoin))
			current_player.job = current_job.title
			current_job.current_positions++
			return TRUE

/datum/authority/branch/role/proc/check_role_entry(mob/new_player/current_player, datum/job/current_job, latejoin = FALSE)
	if(jobban_isbanned(current_player, current_job.title))
		return FALSE
	if(current_job.role_ban_alternative && jobban_isbanned(current_player, current_job.role_ban_alternative))
		return FALSE
	if(!current_job.can_play_role(current_player.client))
		return FALSE
	if(current_job.flags_startup_parameters & ROLE_WHITELISTED && !(roles_whitelist[current_player.ckey] & current_job.flags_whitelist))
		return FALSE
	if(current_job.total_positions != -1 && current_job.get_total_positions(latejoin) <= current_job.current_positions)
		return FALSE
	if(latejoin && !current_job.late_joinable)
		return FALSE
	return TRUE

/datum/authority/branch/role/proc/free_role(datum/job/current_job, latejoin = 1) //Want to make sure it's a job, and nothing like a MODE or special role.
	if(istype(current_job) && current_job.total_positions != -1 && current_job.get_total_positions(latejoin) >= current_job.current_positions)
		current_job.current_positions--
		return 1

/datum/authority/branch/role/proc/free_role_admin(datum/job/current_job, latejoin = 1, user) //Specific proc that used for admin "Free Job Slots" verb (round tab)
	if(!istype(current_job) || current_job.total_positions == -1)
		return
	if(current_job.current_positions < 1) //this should be filtered earlier, but we still check just in case
		to_chat(user, "There are no [current_job] job slots occupied.")
		return

//here is the main reason this proc exists - to remove freed squad jobs from squad,
//so latejoining person ends in the squad which's job was freed and not random one
	var/datum/squad/sq = null
	if(job_squad_roles.Find(current_job.title))
		var/list/squad_list = list()
		for(sq in RoleAuthority.squads)
			if(sq.usable)
				squad_list += sq
		sq = null
		sq = input(user, "Select squad you want to free [current_job.title] slot from.", "Squad Selection")  as null|anything in squad_list
		if(!sq)
			return
		switch(current_job.title)
			if(JOB_SQUAD_ENGI)
				if(sq.num_engineers > 0)
					sq.num_engineers--
				else
					to_chat(user, "There are no [current_job.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_MEDIC)
				if(sq.num_medics > 0)
					sq.num_medics--
				else
					to_chat(user, "There are no [current_job.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_SPECIALIST)
				if(sq.num_specialists > 0)
					sq.num_specialists--
				else
					to_chat(user, "There are no [current_job.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_SMARTGUN)
				if(sq.num_smartgun > 0)
					sq.num_smartgun--
				else
					to_chat(user, "There are no [current_job.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_TEAM_LEADER)
				if(sq.num_tl > 0)
					sq.num_tl--
				else
					to_chat(user, "There are no [current_job.title] slots occupied in [sq.name] Squad.")
					return
			if(JOB_SQUAD_LEADER)
				if(sq.num_leaders > 0)
					sq.num_leaders--
				else
					to_chat(user, "There are no [current_job.title] slots occupied in [sq.name] Squad.")
					return
	current_job.current_positions--
	message_admins("[key_name(user)] freed the [current_job.title] job slot[sq ? " in [sq.name] Squad" : ""].")
	return 1

/datum/authority/branch/role/proc/modify_role(datum/job/current_job, amount)
	if(!istype(current_job))
		return 0
	if(amount < current_job.current_positions) //we should be able to slot everyone
		return 0
	current_job.total_positions = amount
	current_job.total_positions_so_far = amount
	return 1

//I'm not entirely sure why this proc exists. //TODO Figure this out.
/datum/authority/branch/role/proc/reset_roles()
	for(var/mob/new_player/current_player in GLOB.new_player_list)
		current_player.job = null


/datum/authority/branch/role/proc/equip_role(mob/living/current_player, datum/job/current_job, turf/late_join)
	if(!istype(current_player) || !istype(current_job))
		return

	. = TRUE

	if(!ishuman(current_player))
		return

	var/mob/living/carbon/human/current_human = current_player

	if(current_job.job_options && current_human?.client?.prefs?.pref_special_job_options[current_job.title])
		current_job.handle_job_options(current_human.client.prefs.pref_special_job_options[current_job.title])

	var/job_whitelist = current_job.title
	var/whitelist_status = current_job.get_whitelist_status(roles_whitelist, current_human.client)

	if(whitelist_status)
		job_whitelist = "[current_job.title][whitelist_status]"

	current_human.job = current_job.title //TODO Why is this a mob variable at all?

	if(current_job.gear_preset_whitelist[job_whitelist])
		arm_equipment(current_human, current_job.gear_preset_whitelist[job_whitelist], FALSE, TRUE)
		var/generated_account = current_job.generate_money_account(current_human)
		current_job.announce_entry_message(current_human, generated_account, whitelist_status) //Tell them their spawn info.
		current_job.generate_entry_conditions(current_human, whitelist_status) //Do any other thing that relates to their spawn.
	else
		arm_equipment(current_human, current_job.gear_preset, FALSE, TRUE) //After we move them, we want to equip anything else they should have.
		var/generated_account = current_job.generate_money_account(current_human)
		current_job.announce_entry_message(current_human, generated_account) //Tell them their spawn info.
		current_job.generate_entry_conditions(current_human) //Do any other thing that relates to their spawn.

	if(current_job.flags_startup_parameters & ROLE_ADD_TO_SQUAD) //Are we a muhreen? Randomize our squad. This should go AFTER IDs. //TODO Robust this later.
		randomize_squad(current_human)

	if(Check_WO() && job_squad_roles.Find(GET_DEFAULT_ROLE(current_human.job))) //activates self setting proc for marine headsets for WO
		var/datum/game_mode/whiskey_outpost/WO = SSticker.mode
		WO.self_set_headset(current_human)

	var/assigned_squad
	if(ishuman(current_human))
		var/mob/living/carbon/human/human = current_human
		if(human.assigned_squad)
			assigned_squad = human.assigned_squad.name

	if(isturf(late_join))
		current_human.forceMove(late_join)
	else if(late_join)
		var/turf/late_join_turf
		if(GLOB.latejoin_by_squad[assigned_squad])
			late_join_turf = get_turf(pick(GLOB.latejoin_by_squad[assigned_squad]))
		else
			late_join_turf = get_turf(pick(GLOB.latejoin))
		current_human.forceMove(late_join_turf)
	else
		var/turf/join_turf
		if(assigned_squad && GLOB.spawns_by_squad_and_job[assigned_squad] && GLOB.spawns_by_squad_and_job[assigned_squad][current_job.type])
			join_turf = get_turf(pick(GLOB.spawns_by_squad_and_job[assigned_squad][current_job.type]))
		else if(GLOB.spawns_by_job[current_job.type])
			join_turf = get_turf(pick(GLOB.spawns_by_job[current_job.type]))
		else if(assigned_squad && GLOB.latejoin_by_squad[assigned_squad])
			join_turf = get_turf(pick(GLOB.latejoin_by_squad[assigned_squad]))
		else
			join_turf = get_turf(pick(GLOB.latejoin))
		current_human.forceMove(join_turf)

	for(var/cardinal in GLOB.cardinals)
		var/obj/structure/machinery/cryopod/pod = locate() in get_step(current_human, cardinal)
		if(pod)
			pod.go_in_cryopod(current_human, silent = TRUE)
			break

	current_human.sec_hud_set_ID()
	current_human.hud_set_squad()

	SSround_recording.recorder.track_player(current_human)

//Find which squad has the least population. If all 4 squads are equal it should just use a random one
/datum/authority/branch/role/proc/get_lowest_squad(mob/living/carbon/human/current_human)
	if(!squads.len) //Something went wrong, our squads aren't set up.
		to_world("Warning, something messed up in get_lowest_squad(). No squads set up!")
		return null


	//we make a list of squad that is randomized so alpha isn't always lowest squad.
	var/list/squads_copy = squads.Copy()
	var/list/mixed_squads = list()

	for(var/i= 1 to squads_copy.len)
		var/datum/squad/current_squad = pick_n_take(squads_copy)
		if (current_squad.roundstart && current_squad.usable && current_squad.faction == current_human.faction && current_squad.name != "Root")
			mixed_squads += current_squad

	var/datum/squad/lowest = pick(mixed_squads)

	var/datum/pref_squad_name
	if(current_human && current_human.client && current_human.client.prefs.preferred_squad && current_human.client.prefs.preferred_squad != "None")
		pref_squad_name = current_human.client.prefs.preferred_squad

	for(var/datum/squad/lowest_squad in mixed_squads)
		if(lowest_squad.usable)
			if(pref_squad_name && lowest_squad.name == pref_squad_name)
				lowest = lowest_squad
				break


	if(!lowest)
		to_world("Warning! Bug in get_random_squad()!")
		return null

	var/lowest_count = lowest.count
	var/current_count = 0

	if(!pref_squad_name)
		//Loop through squads.
		for(var/datum/squad/current_squad in mixed_squads)
			if(!current_squad)
				to_world("Warning: Null squad in get_lowest_squad. Call a coder!")
				break //null squad somehow, let's just abort
			current_count = current_squad.count //Grab our current squad's #
			if(current_count >= (lowest_count - 2)) //Current squad count is not much lower than the chosen one. Skip it.
				continue
			lowest_count = current_count //We found a winner! This squad is much lower than our default. Make it the new default.
			lowest = current_squad //'Select' this squad.

	return lowest //Return whichever squad won the competition.

//This proc is a bit of a misnomer, since there's no actual randomization going on.
/datum/authority/branch/role/proc/randomize_squad(mob/living/carbon/human/current_human, skip_limit = FALSE)
	if(!current_human)
		return

	if(!squads.len)
		to_chat(current_human, "Something went wrong with your squad randomizer! Tell a coder!")
		return //Shit, where's our squad data

	if(current_human.assigned_squad) //Wait, we already have a squad. Get outta here!
		return

	//we make a list of squad that is randomized so alpha isn't always lowest squad.
	var/list/squads_copy = squads.Copy()
	var/list/mixed_squads = list()
	// The following code removes non useable squads from the lists of squads we assign marines too.
	for(var/i= 1 to squads_copy.len)
		var/datum/squad/current_squad = pick_n_take(squads_copy)
		if (current_squad.roundstart && current_squad.usable && current_squad.faction == current_human.faction && current_squad.name != "Root")
			mixed_squads += current_squad

	//Deal with non-standards first.
	//Non-standards are distributed regardless of squad population.
	//If the number of available positions for the job are more than max_whatever, it will break.
	//Ie. 8 squad medic jobs should be available, and total medics in squads should be 8.
	if(current_human.job != JOB_SQUAD_MARINE && current_human.job != "Reinforcements")
		var/pref_squad_name
		if(current_human && current_human.client && current_human.client.prefs.preferred_squad && current_human.client.prefs.preferred_squad != "None")
			pref_squad_name = current_human.client.prefs.preferred_squad

		var/datum/squad/lowest

		switch(current_human.job)
			if(JOB_SQUAD_ENGI)
				for(var/datum/squad/current_squad in mixed_squads)
					if(current_squad.usable && current_squad.roundstart)
						if(!skip_limit && current_squad.num_engineers >= current_squad.max_engineers) continue
						if(pref_squad_name && current_squad.name == pref_squad_name)
							current_squad.put_marine_in_squad(current_human) //fav squad has a spot for us, no more searching needed.
							return

						if(!lowest)
							lowest = current_squad
						else if(current_squad.num_engineers < lowest.num_engineers)
							lowest = current_squad

			if(JOB_SQUAD_MEDIC)
				for(var/datum/squad/current_squad in mixed_squads)
					if(current_squad.usable && current_squad.roundstart)
						if(!skip_limit && current_squad.num_medics >= current_squad.max_medics) continue
						if(pref_squad_name && current_squad.name == pref_squad_name)
							current_squad.put_marine_in_squad(current_human) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = current_squad
						else if(current_squad.num_medics < lowest.num_medics)
							lowest = current_squad

			if(JOB_SQUAD_LEADER)
				for(var/datum/squad/current_squad in mixed_squads)
					if(current_squad.usable && current_squad.roundstart)
						if(!skip_limit && current_squad.num_leaders >= current_squad.max_leaders) continue
						if(pref_squad_name && current_squad.name == pref_squad_name)
							current_squad.put_marine_in_squad(current_human) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = current_squad
						else if(current_squad.num_leaders < lowest.num_leaders)
							lowest = current_squad

			if(JOB_SQUAD_SPECIALIST)
				for(var/datum/squad/current_squad in mixed_squads)
					if(current_squad.usable && current_squad.roundstart)
						if(!skip_limit && current_squad.num_specialists >= current_squad.max_specialists) continue
						if(pref_squad_name && current_squad.name == pref_squad_name)
							current_squad.put_marine_in_squad(current_human) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = current_squad
						else if(current_squad.num_specialists < lowest.num_specialists)
							lowest = current_squad

			if(JOB_SQUAD_TEAM_LEADER)
				for(var/datum/squad/current_squad in mixed_squads)
					if(current_squad.usable && current_squad.roundstart)
						if(!skip_limit && current_squad.num_tl >= current_squad.max_tl) continue
						if(pref_squad_name && current_squad.name == pref_squad_name)
							current_squad.put_marine_in_squad(current_human) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = current_squad
						else if(current_squad.num_tl < lowest.num_tl)
							lowest = current_squad

			if(JOB_SQUAD_SMARTGUN)
				for(var/datum/squad/current_squad in mixed_squads)
					if(current_squad.usable && current_squad.roundstart)
						if(!skip_limit && current_squad.num_smartgun >= current_squad.max_smartgun) continue
						if(pref_squad_name && current_squad.name == pref_squad_name)
							current_squad.put_marine_in_squad(current_human) //fav squad has a spot for us.
							return

						if(!lowest)
							lowest = current_squad
						else if(current_squad.num_smartgun < lowest.num_smartgun)
							lowest = current_squad
		if(!lowest)
			var/ranpick = rand(1,4)
			lowest = mixed_squads[ranpick]
		if(lowest) lowest.put_marine_in_squad(current_human)
		else to_chat(current_human, "Something went badly with randomize_squad()! Tell a coder!")

	else
		//Deal with marines. They get distributed to the lowest populated squad.
		var/datum/squad/given_squad = get_lowest_squad(current_human)
		if(!given_squad || !istype(given_squad)) //Something went horribly wrong!
			to_chat(current_human, "Something went wrong with randomize_squad()! Tell a coder!")
			return
		given_squad.put_marine_in_squad(current_human) //Found one, finish up

/datum/authority/branch/role/proc/get_caste_by_text(name)
	var/mob/living/carbon/xenomorph/current_player
	switch(name) //ADD NEW CASTES HERE!
		if(XENO_CASTE_LARVA)
			current_player = /mob/living/carbon/xenomorph/larva
		if(XENO_CASTE_PREDALIEN_LARVA)
			current_player = /mob/living/carbon/xenomorph/larva/predalien
		if(XENO_CASTE_FACEHUGGER)
			current_player = /mob/living/carbon/xenomorph/facehugger
		if(XENO_CASTE_RUNNER)
			current_player = /mob/living/carbon/xenomorph/runner
		if(XENO_CASTE_DRONE)
			current_player = /mob/living/carbon/xenomorph/drone
		if(XENO_CASTE_CARRIER)
			current_player = /mob/living/carbon/xenomorph/carrier
		if(XENO_CASTE_HIVELORD)
			current_player = /mob/living/carbon/xenomorph/hivelord
		if(XENO_CASTE_BURROWER)
			current_player = /mob/living/carbon/xenomorph/burrower
		if(XENO_CASTE_PRAETORIAN)
			current_player = /mob/living/carbon/xenomorph/praetorian
		if(XENO_CASTE_RAVAGER)
			current_player = /mob/living/carbon/xenomorph/ravager
		if(XENO_CASTE_SENTINEL)
			current_player = /mob/living/carbon/xenomorph/sentinel
		if(XENO_CASTE_SPITTER)
			current_player = /mob/living/carbon/xenomorph/spitter
		if(XENO_CASTE_LURKER)
			current_player = /mob/living/carbon/xenomorph/lurker
		if(XENO_CASTE_WARRIOR)
			current_player = /mob/living/carbon/xenomorph/warrior
		if(XENO_CASTE_DEFENDER)
			current_player = /mob/living/carbon/xenomorph/defender
		if(XENO_CASTE_QUEEN)
			current_player = /mob/living/carbon/xenomorph/queen
		if(XENO_CASTE_CRUSHER)
			current_player = /mob/living/carbon/xenomorph/crusher
		if(XENO_CASTE_BOILER)
			current_player = /mob/living/carbon/xenomorph/boiler
		if(XENO_CASTE_PREDALIEN)
			current_player = /mob/living/carbon/xenomorph/predalien
		if(XENO_CASTE_HELLHOUND)
			current_player = /mob/living/carbon/xenomorph/hellhound
	return current_player


/proc/get_desired_status(desired_status, status_limit)
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

/proc/transfer_marine_to_squad(mob/living/carbon/human/transfer_marine, datum/squad/new_squad, datum/squad/old_squad, obj/item/card/id/ID)
	if(old_squad)
		if(transfer_marine.assigned_fireteam)
			if(old_squad.fireteam_leaders["FT[transfer_marine.assigned_fireteam]"] == transfer_marine)
				old_squad.unassign_ft_leader(transfer_marine.assigned_fireteam, TRUE, FALSE)
			old_squad.unassign_fireteam(transfer_marine, TRUE) //reset fireteam assignment
		old_squad.remove_marine_from_squad(transfer_marine, ID)
		old_squad.update_free_mar()
	. = new_squad.put_marine_in_squad(transfer_marine, ID)
	if(.)
		new_squad.update_free_mar()

		var/marine_ref = WEAKREF(transfer_marine)
		for(var/datum/data/record/manifest in GLOB.data_core.general) //we update the crew manifest
			if(manifest.fields["ref"] == marine_ref)
				manifest.fields["squad"] = new_squad.name
				break

		transfer_marine.hud_set_squad()

// returns TRUE if transfer_marine's role is at max capacity in the new squad
/datum/authority/branch/role/proc/check_squad_capacity(mob/living/carbon/human/transfer_marine, datum/squad/new_squad)
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
		if(JOB_SQUAD_TEAM_LEADER)
			if(new_squad.num_tl >= new_squad.max_tl)
				return TRUE
	return FALSE
