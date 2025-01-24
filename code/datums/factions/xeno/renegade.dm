/datum/faction/xenomorph/renegade
	name = "Renegade Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_RENEGADE

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/renegade

	need_round_end_check = TRUE

	minimap_flag = MINIMAP_FLAG_XENO_RENEGADE

/datum/faction/xenomorph/renegade/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.dynamic_evolution = FALSE
	faction_module.allow_queen_evolve = FALSE
	faction_module.allow_no_queen_evo = TRUE
	faction_module.latejoin_burrowed = FALSE

/datum/faction/xenomorph/renegade/can_delay_round_end(mob/living/carbon/C)
	return FALSE
