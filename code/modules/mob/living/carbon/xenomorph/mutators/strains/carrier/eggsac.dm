/datum/xeno_mutator/eggsac
	name = "STRAIN: Carrier - Eggsac"
	description = "In exchange for your ability to store huggers, you gain the ability to form new eggs by sacrificing your plasma stores."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_CARRIER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/retrieve_egg, // readding it so it gets at the end of the ability list
		/datum/action/xeno_action/onclick/set_hugger_reserve,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/generate_egg,
		/datum/action/xeno_action/activable/retrieve_egg // readding it so it gets at the end of the ability list
	)
	keystone = TRUE

/datum/xeno_mutator/eggsac/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (!.)
		return
	var/mob/living/carbon/Xenomorph/Carrier/carrier = mutator_set.xeno
	if(!istype(carrier))
		return FALSE
	carrier.mutation_type = CARRIER_EGGSAC
	carrier.plasma_types = list(PLASMA_EGG)
	carrier.phero_modifier += XENO_PHERO_MOD_LARGE // praetorian level pheremones
	carrier.plasmapool_modifier = 1.5
	mutator_update_actions(carrier)
	mutator_set.recalculate_actions(description, flavor_description)
	carrier.recalculate_pheromones()
	carrier.recalculate_plasma()
	if(carrier.huggers_cur > 0)
		playsound(carrier.loc, 'sound/voice/alien_facehugger_dies.ogg', 25, 1)
	carrier.huggers_cur = 0
	carrier.huggers_max = 0
	carrier.eggs_max = 12
	carrier.extra_build_dist = 1
	return TRUE

/datum/action/xeno_action/onclick/generate_egg
	name = "Generate Egg (50)"
	action_icon_state = "lay_egg"
	ability_name = "generate egg"
	action_type = XENO_ACTION_CLICK
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/onclick/generate_egg/can_use_action()
	if(!owner)
		return FALSE
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(xeno && !xeno.is_mob_incapacitated() && !xeno.dazed && !xeno.lying && !xeno.buckled && xeno.plasma_stored >= plasma_cost)
		return TRUE

/datum/action/xeno_action/onclick/generate_egg/give_to(mob/living/living_mob)
	. = ..()
	var/mob/living/carbon/Xenomorph/Hivelord/xeno = owner
	if(xeno.egg_generation_activated)
		button.icon_state = "template_active"
