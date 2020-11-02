/*
Objectives for agents:

The datum/agent handles giving out objectives, and passes along itself to the created objective.

Objective item,
	An objective creates an objective item, a paper with information, something the Agent must have on them at round end to COMPLETE.

Completion,
	To complete the objective, check_completion_round_end() must return TRUE at round end. 
	check_completion_now() can be called whenever and setting completed = TRUE, will ensure that round_end check also returns TRUE.

Objective message,
	generate_objective_message() contains the layout of an objective message,
	generate_objective_body_message() is what the actual message should be,

	generate_description() is used for the round end text, so it prints nicely plain and also for the objective item paper.
*/

/datum/agent_objective
	var/description = ""
	var/belonging_to_faction = ""
	var/completed = FALSE
	var/terminated = FALSE

	var/datum/agent/belonging_to_agent = null
	var/obj/item/objective_item = null

/datum/agent_objective/New(var/datum/agent/A)
	. = ..()
	
	if(istype(A))
		belonging_to_agent = A
	else
		qdel(src)
		return

	belonging_to_faction = belonging_to_agent.faction

	generate_objective_message()

	generate_description()

	create_objective_item()

/datum/agent_objective/proc/generate_objective_message()
	var/text = {"
		[SPAN_ROLE_BODY("|______________________|")]
		[SPAN_ROLE_HEADER("New objective transmission recieved.")]
		[SPAN_ROLE_BODY("[generate_objective_body_message()]")]
		[SPAN_ROLE_BODY("|______________________|")]
		"}
	to_chat(belonging_to_agent.source_human, text)

/datum/agent_objective/proc/generate_objective_body_message()
	return "You have no task."

/datum/agent_objective/proc/generate_description()
	description = "You have no task."

/datum/agent_objective/proc/create_objective_item()
	return

/datum/agent_objective/proc/check_completion_now()
	if(terminated)
		return FALSE

	if(completed)
		return TRUE

	return FALSE

/datum/agent_objective/proc/check_completion_round_end()
	if(terminated)
		return FALSE

	if(completed)
		return TRUE

	return TRUE

/datum/agent_objective/Destroy()
	. = ..()
	
	if(belonging_to_agent)
		LAZYREMOVE(belonging_to_agent.objectives_list, src)

	if(objective_item)
		qdel(objective_item)
		objective_item = null


/obj/item/paper/antag
	name = "suspicious paper"
	var/datum/agent_objective/objective

/obj/item/paper/antag/New(var/datum/agent_objective/O)
	if(!istype(O))
		qdel(src)
		return

	objective = O

	var/mob/living/carbon/human/H = objective.belonging_to_agent.source_human
	var/agent_id = add_zero(num2hex(H.gid), 6)

	var/signed_by = "V. K."
	switch(objective.belonging_to_faction)
		if(FACTION_WY)
			// Peter Jackson
			signed_by = "P. J."
		if(FACTION_UPP)
			// Viktor Zhukov
			signed_by = "V. Z."
		if(FACTION_RESS)
			// Hiroto Jameson
			signed_by = "H. J."
		if(FACTION_CLF)
			// Shiro Fox
			signed_by = "S. F."

	var/objective_id = rand(10, 55000)

	info = {"\[hr\]
			\[center\]\[large\]\[b\] Objective ID #[objective_id]\[/b\]\[/large\]

			\[hr\]
			Agent ID: [agent_id]

			\[hr\]
			Description: [objective.description]

			Signed, \[i\][signed_by]\[/i\]

			\[hr\]\[small\] This documentation is stricly for REDACTED only. The acquisition, copying and distribution of this file is strictly forbidden to person/s or entity/s outside of REDACTED. The person violating these regulations may find themselves in prison or permanently disappearing.
			"}

	..()

/obj/item/paper/antag/burnpaper(obj/item/P, mob/user)
	to_chat(user, SPAN_DANGER("This looks too important to burn!"))
	return

/obj/item/paper/antag/Destroy()
	. = ..()
	
	if(objective)
		objective.objective_item = null
		objective = null