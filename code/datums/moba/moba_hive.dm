/datum/hive_status/moba
	latejoin_burrowed = FALSE
	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	evolution_without_ovipositor = FALSE

// We're not really a full-on hive, so we can just override return a bunch of procs that might mess with stuff
/datum/hive_status/moba/set_living_xeno_queen(mob/living/carbon/xenomorph/queen/queen)
	return

/datum/hive_status/moba/announce_evolve_available(list/datum/caste_datum/available_castes)
	return

/datum/hive_status/moba/add_hive_leader(mob/living/carbon/xenomorph/xeno)
	return

/datum/hive_status/moba/get_tier_slots()
	return list()

/datum/hive_status/moba/do_buried_larva_spawn(mob/xeno_candidate)
	return

/datum/hive_status/moba/left
	name = "Left Hive"
	reporting_id = "moba_left"
	hivenumber = XENO_HIVE_MOBA_LEFT
	prefix = "Left "
	color = "#8DA059"
	ui_color = "#8DA059"

/datum/hive_status/moba/right
	name = "Right Hive"
	reporting_id = "moba_right"
	hivenumber = XENO_HIVE_MOBA_RIGHT
	prefix = "Right "
	color = "#3F7087"
	ui_color = "#3F7087"
