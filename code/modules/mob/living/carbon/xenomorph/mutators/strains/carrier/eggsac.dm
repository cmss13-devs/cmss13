/datum/xeno_mutator/eggsac
	name = "STRAIN: Carrier - Eggsac"
	description = "In exchange for your ability to store huggers, you gain the ability to form new eggs by sacrificing your plasma stores."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_CARRIER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/onclick/place_trap
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/generate_egg
	)

/datum/xeno_mutator/eggsac/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (!.)
		return
	var/mob/living/carbon/Xenomorph/Carrier/C = MS.xeno
	if(!istype(C))
		return FALSE
	C.mutation_type = CARRIER_EGGSAC
	C.plasma_types = list(PLASMA_EGG)
	C.phero_modifier += XENO_PHERO_MOD_LARGE // praetorian level pheremones
	C.plasmapool_modifier = 1.25
	mutator_update_actions(C)
	MS.recalculate_actions(description, flavor_description)
	C.recalculate_pheromones()
	C.recalculate_plasma()
	C.huggers_cur = 0
	C.huggers_max = 0
	C.extra_build_dist = 1
	return TRUE

/datum/action/xeno_action/activable/generate_egg
	name = "Generate Egg (400)"
	action_icon_state = "lay_egg"
	ability_name = "generate egg"
	xeno_cooldown = 30 SECONDS
	cooldown_message = "You aren't ready to form another egg yet."
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = XENO_PLASMA_TIER_4

/datum/action/xeno_action/activable/generate_egg/can_use_action()
	if(!owner)
		return FALSE
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.is_mob_incapacitated() && !X.dazed && !X.lying && !X.buckled && X.plasma_stored >= plasma_cost)
		return TRUE

/datum/action/xeno_action/activable/generate_egg/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!istype(X))
		return FALSE
	if(X.eggs_cur >= X.eggs_max)
		to_chat(X, SPAN_XENOWARNING("You don't have any space to store a new egg!"))
		return FALSE
	to_chat(X, SPAN_NOTICE("You form a new egg inside your sac."))
	X.eggs_cur++
	X.use_plasma(XENO_PLASMA_TIER_4)
	apply_cooldown()
	return TRUE
