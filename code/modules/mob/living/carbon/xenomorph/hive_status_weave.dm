/datum/hive_status/mutated/weave
	name = "The Weave Nexus"
	hivenumber = XENO_HIVE_WEAVE
	prefix = "Weave "
	allow_no_queen_actions = TRUE
	allow_no_queen_evo = TRUE
	allow_queen_evolve = FALSE
	hive_inherant_traits = list(TRAIT_XENONID, TRAIT_NO_COLOR, TRAIT_NO_PREFIX, TRAIT_WEAVE_SENSITIVE)

	var/bioscan_time = 0
	var/weave_energy = 1000
	var/weave_energy_max = 5000
	var/granted_pool = FALSE

	free_slots = list(
		/datum/caste_datum/weaver = 5,
		/datum/caste_datum/weaveguard = 3
	)

/datum/hive_status/mutated/weave/set_hive_location(obj/effect/alien/resin/special/pylon/core/C)
	if(!C || C == hive_location)
		return
	var/area/A = get_area(C)
	xeno_message(SPAN_XENOANNOUNCE("The Prime Weaver has created a nexus at \the [A]."), 3, hivenumber)
	hive_location = C
	hive_ui.update_hive_location()

/datum/hive_status/mutated/weave/proc/give_pool()
	if(!(XENO_STRUCTURE_WEAVE_POOL in hive_structure_types))
		hive_structure_types.Add(XENO_STRUCTURE_WEAVE_POOL)

	if(!(XENO_STRUCTURE_WEAVE_POOL in hive_structures_limit))
		hive_structures_limit.Add(XENO_STRUCTURE_WEAVE_POOL)
		hive_structures_limit[XENO_STRUCTURE_WEAVE_POOL] = 1

	hive_structure_types[XENO_STRUCTURE_WEAVE_POOL] = /datum/construction_template/xenomorph/weave_pool
	granted_pool = TRUE
	xeno_message(SPAN_XENOANNOUNCE("The Weave has grown strong enough to form a pool!"), 2, XENO_HIVE_WEAVE)
	return TRUE

/datum/hive_status/mutated/weave/proc/can_use_energy(cost)
	if((weave_energy - cost) < 0)
		return FALSE
	else
		return TRUE

/datum/hive_status/mutated/weave/proc/use_energy(cost)
	if((weave_energy - cost) < 0)
		return FALSE

	weave_energy -= cost
	return TRUE

/datum/hive_status/mutated/weave/proc/feed_weave(amount)
	weave_energy += amount
	if(!granted_pool && (weave_energy >= weave_energy_max * 0.4))
		give_pool()

/datum/hive_status/mutated/weave/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	if(!faction_is_ally(FACTION_MARINE, TRUE))
		return TRUE
	return FALSE
