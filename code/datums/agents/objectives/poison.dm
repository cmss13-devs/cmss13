/datum/agent_objective/poison
	description = ""
	var/obj/item/reagent_container/food/snacks/agent/poisoned_food
	var/jobs_to_eat = ROLES_OFFICERS
	var/ate_it = FALSE

/datum/agent_objective/poison/New(datum/agent/A)
	poisoned_food = new()

	. = ..()

	var/mob/living/carbon/human/H = belonging_to_agent.source_human
	if(!H.equip_to_slot_if_possible(poisoned_food, WEAR_IN_BACK))
		if(!H.equip_to_slot_if_possible(poisoned_food, WEAR_L_HAND))
			if(!H.equip_to_slot_if_possible(poisoned_food, WEAR_R_HAND))
				poisoned_food.loc = H.loc

	registerListener(GLOBAL_EVENT, EVENT_POISON_EATEN + "\ref[poisoned_food]", "\ref[src]_\ref[poisoned_food]", CALLBACK(src, .proc/ate_poison))

/datum/agent_objective/poison/generate_objective_body_message()
	return "[SPAN_BOLD("[SPAN_BLUE("Poison")]")] an officer with the special [SPAN_BOLD("[SPAN_RED("[poisoned_food.name]")]")] to weaken command."

/datum/agent_objective/poison/generate_description()
	description = "Poison an officer with the special [poisoned_food.name] to weaken command."

/datum/agent_objective/poison/proc/ate_poison(var/job_of_eater)
	if(ate_it)
		return

	if(job_of_eater in jobs_to_eat)
		ate_it = TRUE

/datum/agent_objective/poison/check_completion_round_end()
	. = ..()
	if(!.)
		return FALSE

	if(ate_it)
		return TRUE

	return FALSE


/obj/item/reagent_container/food/snacks/agent/Initialize()
	. = ..()

	var/obj/O = pick(subtypesof(/obj/item/reagent_container/food/snacks) - /obj/item/reagent_container/food/snacks/monkeycube)
	name = initial(O.name)
	desc = initial(O.desc)
	icon = initial(O.icon)
	icon_state = initial(O.icon_state)
	
	reagents.add_reagent("nutriment", 8)
	bitesize = 3

/obj/item/reagent_container/food/snacks/agent/On_Consume(var/mob/M)
	raiseEvent(GLOBAL_EVENT, EVENT_POISON_EATEN + "\ref[src]", M.job)

	..()
	