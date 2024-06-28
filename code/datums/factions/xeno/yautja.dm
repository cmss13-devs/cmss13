/datum/faction/xenomorph/yautja
	name = NAME_FACTION_XENOMORPH_YAUTJA
	faction_name = FACTION_XENOMORPH_YAUTJA
	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/yautja

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_queen_evolve = FALSE
	ignore_slots = TRUE

	need_round_end_check = TRUE

/datum/faction/xenomorph/yautja/can_delay_round_end(mob/living/carbon/C)
	return FALSE
