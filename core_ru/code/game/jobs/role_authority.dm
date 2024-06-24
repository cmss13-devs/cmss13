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
