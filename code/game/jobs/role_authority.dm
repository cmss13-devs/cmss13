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
GLOBAL_DATUM(RoleAuthority, /datum/authority/branch/role)

#define GET_RANDOM_JOB 0
#define BE_MARINE 1
#define RETURN_TO_LOBBY 2
#define BE_XENOMORPH 3

#define NEVER_PRIORITY 0
#define HIGH_PRIORITY 1
#define MED_PRIORITY 2
#define LOW_PRIORITY 3

#define SHIPSIDE_ROLE_WEIGHT 0.25

GLOBAL_VAR_INIT(players_preassigned, 0)

/proc/guest_jobbans(job)
	return (job in GLOB.ROLES_COMMAND)

/datum/authority/branch/role
	var/name = "Role Authority"

	var/list/roles_by_path //Master list generated when role aithority is created, listing every role by path, including variable roles. Great for manually equipping with.
	var/list/roles_by_name //Master list generated when role authority is created, listing every default role by name, including those that may not be regularly selected.
	var/list/roles_for_mode //Derived list of roles only for the game mode, generated when the round starts.
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

//#undef FACTION_TO_JOIN

/*
Consolidated into a better collection of procs. It was also calling too many loops, and I tried to fix that as well.
I hope it's easier to tell what the heck this proc is even doing, unlike previously.
 */


/datum/authority/branch/role/proc/setup_candidates_and_roles(list/overwritten_roles_for_mode)
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
	GLOB.players_preassigned = assign_roles(temp_roles_for_mode.Copy(), unassigned_players.Copy(), TRUE)

	// Even though we pass a copy of temp_roles_for_mode, job counters still change, so we reset them here.
	for(var/title in temp_roles_for_mode)
		var/datum/job/J = temp_roles_for_mode[title]
		J.current_positions = 0

	// Set up limits for other roles based on our balancing weight number.
	// Set the xeno starting amount based on marines assigned
	var/datum/job/antag/xenos/XJ = temp_roles_for_mode[JOB_XENOMORPH]
	if(istype(XJ))
		XJ.set_spawn_positions(GLOB.players_preassigned)

	// Limit the number of SQUAD MARINE roles players can roll initially
	var/datum/job/SMJ = GET_MAPPED_ROLE(JOB_SQUAD_MARINE)
	if(istype(SMJ))
		SMJ.set_spawn_positions(GLOB.players_preassigned)

	// Set survivor starting amount based on marines assigned
	var/datum/job/SJ = temp_roles_for_mode[JOB_SURVIVOR]
	if(istype(SJ))
		SJ.set_spawn_positions(GLOB.players_preassigned)

	var/datum/job/CO_surv_job = temp_roles_for_mode[JOB_CO_SURVIVOR]
	if(istype(CO_surv_job))
		CO_surv_job.set_spawn_positions(GLOB.players_preassigned)

	if(SSnightmare.get_scenario_value("predator_round") && MODE_HAS_FLAG(MODE_FOG_ACTIVATED))
		SSticker.mode.flags_round_type |= MODE_PREDATOR
		send2chat("Predator round!", CONFIG_GET(string/new_round_alert_channel))
		// Set predators starting amount based on marines assigned
		var/datum/job/PJ = temp_roles_for_mode[JOB_PREDATOR]
		if(istype(PJ))
			PJ.set_spawn_positions(GLOB.players_preassigned)
		REDIS_PUBLISH("byond.round", "type" = "predator-round", "map" = SSmapping.configs[GROUND_MAP].map_name)

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
/datum/authority/branch/role/proc/assign_roles(list/roles_for_mode, list/unassigned_players, count = FALSE)
	var/list/roles_left = list()
	var/assigned = 0
	for(var/priority in HIGH_PRIORITY to LOW_PRIORITY)
		// Assigning xenos first.
		assigned += assign_initial_roles(priority, roles_for_mode & GLOB.ROLES_XENO, unassigned_players)
		// Assigning special roles second. (survivor, predator)
		assigned += assign_initial_roles(priority, roles_for_mode & (GLOB.ROLES_WHITELISTED|GLOB.ROLES_SPECIAL), unassigned_players)
		// Assigning command third.
		assigned += assign_initial_roles(priority, roles_for_mode & GLOB.ROLES_COMMAND, unassigned_players)
		// Assigning the rest
		var/rest_roles_for_mode = roles_for_mode - (roles_for_mode & GLOB.ROLES_XENO) - (roles_for_mode & GLOB.ROLES_COMMAND) - (roles_for_mode & (GLOB.ROLES_WHITELISTED|GLOB.ROLES_SPECIAL))
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
/datum/authority/branch/role/proc/calculate_role_weight(datum/job/J)
	if(!J)
		return 0
	if(GLOB.ROLES_MARINES.Find(J.title))
		return 1
	if(GLOB.ROLES_XENO.Find(J.title))
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
	if(!J.check_whitelist_status(M))
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

/datum/authority/branch/role/proc/free_role_admin(datum/job/job, latejoin = TRUE, user) //Specific proc that used for admin "Free Job Slots" verb (round tab)
	if(!istype(job) || job.total_positions == -1)
		return
	if(job.current_positions < 1) //this should be filtered earlier, but we still check just in case
		to_chat(user, "There are no [job] job slots occupied.")
		return

//here is the main reason this proc exists - to remove freed squad jobs from squad,
//so latejoining person ends in the squad which's job was freed and not random one
	var/datum/squad/squad = null
	if(GLOB.job_squad_roles.Find(job.title))
		var/list/squad_list = list()
		for(squad in GLOB.RoleAuthority.squads)
			if(squad.roundstart && squad.usable && squad.name != "Root")
				squad_list += squad
		squad = null
		squad = tgui_input_list(user, "Select squad you want to free [job.title] slot from.", "Squad Selection", squad_list)
		if(!squad)
			return
		var/slot_check
		switch(job.title)
			if(JOB_SQUAD_TEAM_LEADER)
				slot_check = "leaders"
			if(JOB_SQUAD_SPECIALIST)
				slot_check = "specialists"
			if(JOB_SQUAD_SMARTGUN)
				slot_check = "smartgun"
			if(JOB_SQUAD_TEAM_LEADER)
				slot_check = "tl"
			if(JOB_SQUAD_MEDIC)
				slot_check = "medics"
			if(JOB_SQUAD_ENGI)
				slot_check = "engineers"

		if(squad.vars["num_[slot_check]"] > 0)
			squad.vars["num_[slot_check]"]--
		else
			to_chat(user, "There are no [job.title] slots occupied in [squad.name] Squad.")
			return
	job.current_positions--
	message_admins("[key_name(user)] freed the [job.title] job slot[squad ? " in [squad.name] Squad" : ""].")
	return TRUE

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


/datum/authority/branch/role/proc/equip_role(mob/living/new_mob, datum/job/new_job, turf/late_join)
	if(!istype(new_mob) || !istype(new_job))
		return

	. = TRUE

	if(!ishuman(new_mob))
		return

	var/mob/living/carbon/human/new_human = new_mob

	if(new_job.job_options && new_human?.client?.prefs?.pref_special_job_options[new_job.title])
		new_job.handle_job_options(new_human.client.prefs.pref_special_job_options[new_job.title])

	var/job_whitelist = new_job.title
	var/whitelist_status = new_job.get_whitelist_status(new_human.client)

	if(whitelist_status)
		job_whitelist = "[new_job.title][whitelist_status]"

	new_human.job = new_job.title //TODO Why is this a mob variable at all?

	if(new_job.gear_preset_whitelist[job_whitelist])
		arm_equipment(new_human, new_job.gear_preset_whitelist[job_whitelist], FALSE, TRUE)
		var/generated_account = new_job.generate_money_account(new_human)
		new_job.announce_entry_message(new_human, generated_account, whitelist_status) //Tell them their spawn info.
		new_job.generate_entry_conditions(new_human, whitelist_status) //Do any other thing that relates to their spawn.
	else
		arm_equipment(new_human, new_job.gear_preset, FALSE, TRUE) //After we move them, we want to equip anything else they should have.
		var/generated_account = new_job.generate_money_account(new_human)
		new_job.announce_entry_message(new_human, generated_account) //Tell them their spawn info.
		new_job.generate_entry_conditions(new_human) //Do any other thing that relates to their spawn.

	if(new_job.flags_startup_parameters & ROLE_ADD_TO_SQUAD) //Are we a muhreen? Randomize our squad. This should go AFTER IDs. //TODO Robust this later.
		randomize_squad(new_human)

	if(check_wo() && GLOB.job_squad_roles.Find(GET_DEFAULT_ROLE(new_human.job))) //activates self setting proc for marine headsets for WO
		var/datum/game_mode/whiskey_outpost/WO = SSticker.mode
		WO.self_set_headset(new_human)

	var/assigned_squad
	if(ishuman(new_human))
		var/mob/living/carbon/human/human = new_human
		if(human.assigned_squad)
			assigned_squad = human.assigned_squad.name

	if(isturf(late_join))
		new_human.forceMove(late_join)
	else if(late_join)
		var/turf/late_join_turf
		if(GLOB.latejoin_by_squad[assigned_squad])
			late_join_turf = get_turf(pick(GLOB.latejoin_by_squad[assigned_squad]))
		else if(GLOB.latejoin_by_job[new_job.title])
			late_join_turf = get_turf(pick(GLOB.latejoin_by_job[new_job.title]))
		else
			late_join_turf = get_turf(pick(GLOB.latejoin))
		new_human.forceMove(late_join_turf)
	else
		var/turf/join_turf
		if(assigned_squad && GLOB.spawns_by_squad_and_job[assigned_squad] && GLOB.spawns_by_squad_and_job[assigned_squad][new_job.type])
			join_turf = get_turf(pick(GLOB.spawns_by_squad_and_job[assigned_squad][new_job.type]))
		else if(GLOB.spawns_by_job[new_job.type])
			join_turf = get_turf(pick(GLOB.spawns_by_job[new_job.type]))
		else if(assigned_squad && GLOB.latejoin_by_squad[assigned_squad])
			join_turf = get_turf(pick(GLOB.latejoin_by_squad[assigned_squad]))
		else
			join_turf = get_turf(pick(GLOB.latejoin))
		new_human.forceMove(join_turf)

	for(var/cardinal in GLOB.cardinals)
		var/obj/structure/machinery/cryopod/pod = locate() in get_step(new_human, cardinal)
		if(pod)
			pod.go_in_cryopod(new_human, silent = TRUE)
			break

	new_human.sec_hud_set_ID()
	new_human.hud_set_squad()

	SEND_SIGNAL(new_human, COMSIG_POST_SPAWN_UPDATE)
	SSround_recording.recorder.track_player(new_human)

//This proc is a bit of a misnomer, since there's no actual randomization going on.
/datum/authority/branch/role/proc/randomize_squad(mob/living/carbon/human/human, skip_limit = FALSE)
	if(!human)
		return

	if(!length(squads))
		to_chat(human, "Something went wrong with your squad randomizer! Tell a coder!")
		return //Shit, where's our squad data

	if(human.assigned_squad) //Wait, we already have a squad. Get outta here!
		return

	//Deal with IOs first
	if(human.job == JOB_INTEL)
		var/datum/squad/intel_squad = get_squad_by_name(SQUAD_MARINE_INTEL)
		if(!intel_squad || !istype(intel_squad)) //Something went horribly wrong!
			to_chat(human, "Something went wrong with randomize_squad()! Tell a coder!")
			return
		intel_squad.put_marine_in_squad(human)
		return

	//dirty mess with code, sorry guidelines
	var/slot_check
	if(human.job != "Reinforcements")
		switch(GET_DEFAULT_ROLE(human.job))
			if(JOB_SQUAD_ENGI)
				slot_check = "engineers"
			if(JOB_SQUAD_MEDIC)
				slot_check = "medics"
			if(JOB_SQUAD_TEAM_LEADER)
				slot_check = "tl"
			if(JOB_SQUAD_SMARTGUN)
				slot_check = "smartgun"
			if(JOB_SQUAD_SPECIALIST)
				slot_check = "specialists"
			if(JOB_SQUAD_LEADER)
				slot_check = "leaders"

	//we make a list of squad that is randomized so alpha isn't always lowest squad.
	var/list/mixed_squads = list()
	for(var/datum/squad/squad in squads)
		if(squad.roundstart && squad.usable && squad.faction == human.faction && squad.name != "Root")
			mixed_squads += squad

	var/preferred_squad
	if(human?.client?.prefs?.preferred_squad)
		preferred_squad = human.client.prefs.preferred_squad

	var/datum/squad/lowest
	for(var/datum/squad/squad in mixed_squads)
		if(slot_check && !skip_limit)
			if(squad.vars["num_[slot_check]"] >= squad.vars["max_[slot_check]"])
				continue

		if(preferred_squad == "None")
			if(squad.put_marine_in_squad(human))
				return

		else if(squad.name == preferred_squad) //fav squad has a spot for us, no more searching needed.
			if(squad.put_marine_in_squad(human))
				return

		if(!lowest)
			lowest = squad

		else if(slot_check)
			if(squad.vars["num_[slot_check]"] < lowest.vars["num_[slot_check]"])
				lowest = squad

	if(!lowest || !lowest.put_marine_in_squad(human))
		to_world("Warning! Bug in get_random_squad()!")
		return
	return

/datum/authority/branch/role/proc/get_caste_by_text(name)
	var/mob/living/carbon/xenomorph/M
	switch(name) //ADD NEW CASTES HERE!
		if(XENO_CASTE_LARVA)
			M = /mob/living/carbon/xenomorph/larva
		if(XENO_CASTE_PREDALIEN_LARVA)
			M = /mob/living/carbon/xenomorph/larva/predalien
		if(XENO_CASTE_FACEHUGGER)
			M = /mob/living/carbon/xenomorph/facehugger
		if(XENO_CASTE_LESSER_DRONE)
			M = /mob/living/carbon/xenomorph/lesser_drone
		if(XENO_CASTE_RUNNER)
			M = /mob/living/carbon/xenomorph/runner
		if(XENO_CASTE_DRONE)
			M = /mob/living/carbon/xenomorph/drone
		if(XENO_CASTE_CARRIER)
			M = /mob/living/carbon/xenomorph/carrier
		if(XENO_CASTE_HIVELORD)
			M = /mob/living/carbon/xenomorph/hivelord
		if(XENO_CASTE_BURROWER)
			M = /mob/living/carbon/xenomorph/burrower
		if(XENO_CASTE_PRAETORIAN)
			M = /mob/living/carbon/xenomorph/praetorian
		if(XENO_CASTE_RAVAGER)
			M = /mob/living/carbon/xenomorph/ravager
		if(XENO_CASTE_SENTINEL)
			M = /mob/living/carbon/xenomorph/sentinel
		if(XENO_CASTE_SPITTER)
			M = /mob/living/carbon/xenomorph/spitter
		if(XENO_CASTE_LURKER)
			M = /mob/living/carbon/xenomorph/lurker
		if(XENO_CASTE_WARRIOR)
			M = /mob/living/carbon/xenomorph/warrior
		if(XENO_CASTE_DEFENDER)
			M = /mob/living/carbon/xenomorph/defender
		if(XENO_CASTE_QUEEN)
			M = /mob/living/carbon/xenomorph/queen
		if(XENO_CASTE_CRUSHER)
			M = /mob/living/carbon/xenomorph/crusher
		if(XENO_CASTE_BOILER)
			M = /mob/living/carbon/xenomorph/boiler
		if(XENO_CASTE_PREDALIEN)
			M = /mob/living/carbon/xenomorph/predalien
		if(XENO_CASTE_HELLHOUND)
			M = /mob/living/carbon/xenomorph/hellhound
	return M


/proc/get_desired_status(desired_status, status_limit)
	var/found_desired = FALSE
	var/found_limit = FALSE

	for(var/status in GLOB.whitelist_hierarchy)
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
		for(var/datum/data/record/t in GLOB.data_core.general) //we update the crew manifest
			if(t.fields["ref"] == marine_ref)
				t.fields["squad"] = new_squad.name
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
