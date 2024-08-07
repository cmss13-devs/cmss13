/datum/faction/xenomorph/yautja
	name = NAME_FACTION_XENOMORPH_YAUTJA
	faction_name = FACTION_XENOMORPH_YAUTJA

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_queen_evolve = FALSE
	ignore_slots = TRUE

	need_round_end_check = TRUE

/datum/faction/xenomorph/yautja/can_delay_round_end(mob/living/carbon/carbon)
	return FALSE
