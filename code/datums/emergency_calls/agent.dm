/datum/emergency_call/agent
	name = "Agent"
	mob_max = 1
	mob_min = 1
	arrival_message = null
	probability = 0
	shuttle_id = null
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_agent
	ert_message = "An Agent is spawning in, this is a shipside roleplay role"
	var/list/possible_agents = list(JOB_STOWAWAY)
	var/picked_agent

/datum/emergency_call/agent/New()
	. = ..()

	picked_agent = pick(possible_agents)
	ert_message = "A [SPAN_BOLD("[picked_agent]")] is spawning in, this is a shipside roleplay role"

/datum/emergency_call/agent/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, picked_agent, TRUE, TRUE)

	var/faction
	switch(picked_agent)
		if(JOB_UPP_REPRESENTATIVE)
			faction = FACTION_UPP
		if(JOB_RESS_REPRESENTATIVE)
			faction = FACTION_RESS

	if(faction)
		new /datum/agent(H, faction)
	else
		new /datum/agent(H)

	print_backstory(H)

/datum/emergency_call/agent/print_backstory(mob/living/carbon/human/H)
	var/backstory_message = ""
	backstory_message += SPAN_ROLE_BODY("______________________")
	switch(picked_agent)
		if(JOB_STOWAWAY)
			backstory_message += SPAN_ROLE_BODY("You wake up with a killing headache. Your clothes are dirty and filled with dust, \
			you remember drifting in this small craft for what feels like an eternity.\
			You dont know how you got here, but it might be best if the Captain of this ship doesn't know you're here.")
		if(JOB_UPP_REPRESENTATIVE)
			backstory_message += SPAN_ROLE_BODY("You arrive as the UPP Representative. Your mission is not to make war or create tension, \
			but rather to keep an eye on USCM and be as elusive as possible. You have no real power within your faction, but no one needs to know that.")
		if(JOB_RESS_REPRESENTATIVE)
			backstory_message += SPAN_ROLE_BODY("You arrive as the RESS Representative. Your mission is not to make war or create tension, \
			but rather to keep an eye on USCM and be as elusive as possible. You have no real power within your faction, but no one needs to know that.")
	backstory_message += SPAN_ROLE_BODY("______________________")
	to_chat(H, backstory_message)

/obj/effect/landmark/ert_spawns/distress_agent
	name = "Distress_Agent"
