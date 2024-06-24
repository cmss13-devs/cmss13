/datum/squad
	max_engineers = 6
	max_medics = 8

	var/active_at = null

/datum/squad/marine/bravo
	active_at = 40

/datum/squad/marine/charlie
	active_at = 60

/datum/squad/marine/delta
	active_at = 20

//Straight-up insert a marine into a squad.
//This sets their ID, increments the total count, and so on. Everything else is done in job_controller.dm.
//So it does not check if the squad is too full already, or randomize it, etc.
/datum/squad/proc/put_marine_in_squad(mob/living/carbon/human/M, obj/item/card/id/id_card)
	if(!istype(M))
		return FALSE //Logic
	if(!usable)
		return FALSE
	if(!M.job)
		return FALSE //Not yet
	if(M.assigned_squad)
		return FALSE //already in a squad

	if(!id_card)
		id_card = M.wear_id
		if(!id_card)
			id_card = M.get_active_hand()

	if(!istype(id_card))
		return FALSE //No ID found

	var/assignment = M.job
	var/paygrade

	var/list/extra_access = list()

	var/affected_slot
	switch(GET_DEFAULT_ROLE(M.job))
		if(JOB_SQUAD_ENGI)
			affected_slot = "engineers"
			id_card.claimedgear = FALSE
		if(JOB_SQUAD_MEDIC)
			affected_slot = "medics"
			id_card.claimedgear = FALSE
		if(JOB_SQUAD_TEAM_LEADER)
			affected_slot = "tl"
		if(JOB_SQUAD_SMARTGUN)
			affected_slot = "smartgun"
		if(JOB_SQUAD_SPECIALIST)
			affected_slot = "specialists"
		if(JOB_SQUAD_LEADER)
			if(squad_leader && GET_DEFAULT_ROLE(squad_leader.job) != JOB_SQUAD_LEADER) //field promoted SL
				var/old_lead = squad_leader
				demote_squad_leader() //replaced by the real one
				SStracking.start_tracking(tracking_id, old_lead)
			assignment = squad_type + " Leader"
			squad_leader = M
			SStracking.set_leader(tracking_id, M)
			SStracking.start_tracking("marine_sl", M)

			if(GET_DEFAULT_ROLE(M.job) == JOB_SQUAD_LEADER) //field promoted SL don't count as real ones
				affected_slot = "leaders"
		if(JOB_MARINE_RAIDER)
			assignment = JOB_MARINE_RAIDER
			if(name == JOB_MARINE_RAIDER)
				assignment = "Special Operator"
		if(JOB_MARINE_RAIDER_SL)
			assignment = JOB_MARINE_RAIDER_SL
			if(name == JOB_MARINE_RAIDER)
				if(squad_leader && GET_DEFAULT_ROLE(squad_leader.job) != JOB_MARINE_RAIDER_SL) //field promoted SL
					var/old_lead = squad_leader
					demote_squad_leader() //replaced by the real one
					SStracking.start_tracking(tracking_id, old_lead)
				assignment = squad_type + " Leader"
				squad_leader = M
				SStracking.set_leader(tracking_id, M)
				SStracking.start_tracking("marine_sl", M)
				if(GET_DEFAULT_ROLE(M.job) == JOB_MARINE_RAIDER_SL) //field promoted SL don't count as real ones
					affected_slot = "leaders"
		if(JOB_MARINE_RAIDER_CMD)
			assignment = JOB_MARINE_RAIDER_CMD
			if(name == JOB_MARINE_RAIDER)
				assignment = "Officer"

	if(affected_slot)
		vars["num_[affected_slot]"]++

	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(personnel_deleted), override = TRUE)
	if(assignment != JOB_SQUAD_LEADER)
		SStracking.start_tracking(tracking_id, M)

	count++ //Add up the tally. This is important in even squad distribution.

	if(GET_DEFAULT_ROLE(M.job) != JOB_SQUAD_MARINE)
		log_admin("[key_name(M)] has been assigned as [name] [M.job]") // we don't want to spam squad marines but the others are useful

	marines_list += M
	M.assigned_squad = src //Add them to the squad
	id_card.access += (src.access + extra_access) //Add their squad access to their ID
	if(prepend_squad_name_to_assignment)
		id_card.assignment = "[name] [assignment]"
	else
		id_card.assignment = assignment

	SEND_SIGNAL(M, COMSIG_SET_SQUAD)

	if(paygrade)
		id_card.paygrade = paygrade
	id_card.name = "[id_card.registered_name]'s ID Card ([id_card.assignment])"

	var/obj/item/device/radio/headset/almayer/marine/headset = locate() in list(M.wear_l_ear, M.wear_r_ear)
	if(headset && radio_freq)
		headset.set_frequency(radio_freq)
	M.update_inv_head()
	M.update_inv_wear_suit()
	M.update_inv_gloves()
	return TRUE

//proc used by the overwatch console to transfer marine to another squad
/datum/squad/proc/remove_marine_from_squad(mob/living/carbon/human/M, obj/item/card/id/id_card)
	if(M.assigned_squad != src)
		return //not assigned to the correct squad
	if(!istype(id_card))
		id_card = M.wear_id
	if(!istype(id_card))
		return FALSE //Abort, no ID found

	id_card.access -= src.access
	id_card.assignment = M.job
	id_card.name = "[id_card.registered_name]'s ID Card ([id_card.assignment])"

	forget_marine_in_squad(M)
