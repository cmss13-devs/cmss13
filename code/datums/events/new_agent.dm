/datum/round_event/new_agent
	name = "New Faction Agent"
	tickets = 5
	var/list/possible_candidates
	var/list/agent_approved_jobs = list(JOB_CORPORATE_LIAISON, JOB_CARGO_TECH, JOB_RESEARCHER, JOB_MAINT_TECH, JOB_MESS_SERGEANT, JOB_NURSE)

/datum/round_event/new_agent/check_prerequisite()
	if(!RoleAuthority)
		return FALSE

	var/amount_of_MPs = 0
	var/datum/job/MP = RoleAuthority.roles_for_mode[JOB_POLICE]
	if(istype(MP))
		amount_of_MPs += MP.current_positions

	var/datum/job/CMP = RoleAuthority.roles_for_mode[JOB_CHIEF_POLICE]
	if(istype(CMP))
		amount_of_MPs += CMP.current_positions

	// Check how many antags we have
	if(length(GLOB.human_agent_list) < (amount_of_MPs * AGENT_TO_MP_RATIO))
		return TRUE

	return FALSE

/datum/round_event/new_agent/activate()
	LAZYCLEARLIST(possible_candidates)

	for(var/i in GLOB.alive_human_list)
		var/mob/living/carbon/human/H = i
		if(H.agent_holder || !(H.job in agent_approved_jobs))
			continue

		if(!H.client || !H.client.prefs || !(H.client.prefs.be_special & BE_AGENT))
			continue

		var/datum/entity/player/P = get_player_from_key(H.ckey)
		if(jobban_isbanned(H, "Agent", P))
			continue

		LAZYADD(possible_candidates, H)

	if(!length(possible_candidates))
		return

	var/mob/living/carbon/human/candidate = pick(possible_candidates)
	var/datum/agent/A = new(candidate)
	A.give_objective()

	LAZYCLEARLIST(possible_candidates)

	return


/datum/round_event/new_agent/incoming_ship
	name = "New Incoming Ship Agent"
	tickets = 1

/datum/round_event/new_agent/incoming_ship/activate()
	var/datum/emergency_call/agent/agent_call = new()
	agent_call.activate(FALSE)
	return
