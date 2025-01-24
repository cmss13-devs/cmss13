/datum/faction/xenomorph/yautja
	name = "Yautja Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_YAUTJA

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/yautja

	need_round_end_check = TRUE

	minimap_flag = MINIMAP_FLAG_YAUTJA

/datum/faction/xenomorph/yautja/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.dynamic_evolution = FALSE
	faction_module.allow_no_queen_actions = TRUE
	faction_module.allow_no_queen_evo = TRUE
	faction_module.allow_queen_evolve = FALSE
	faction_module.latejoin_burrowed = FALSE

/datum/faction/xenomorph/yautja/can_delay_round_end(mob/living/carbon/C)
	return FALSE
