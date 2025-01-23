/datum/faction/xenomorph/renegade
	name = "Renegade Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_RENEGADE

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/renegade

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_queen_evolve = FALSE
	ignore_slots = TRUE

	need_round_end_check = TRUE

/datum/faction/xenomorph/renegade/can_delay_round_end(mob/living/carbon/C)
	return FALSE
