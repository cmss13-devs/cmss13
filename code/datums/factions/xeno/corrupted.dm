/datum/faction/xenomorph/corrupted
	name = "Corrupted Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_CORRUPTED

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/corrupted

	prefix = "Corrupted "
	color = "#80ff80"
	ui_color ="#4d994d"

	minimap_flag = MINIMAP_FLAG_XENO_CORRUPTED

/datum/faction/xenomorph/corrupted/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.latejoin_burrowed = FALSE
	faction_module.dynamic_evolution = FALSE

/datum/faction/xenomorph/corrupted/add_mob(mob/living/carbon/xenomorph/X)
	. = ..()
	X.add_language(LANGUAGE_ENGLISH)

/datum/faction/xenomorph/corrupted/remove_mob(mob/living/carbon/xenomorph/X, hard)
	. = ..()
	X.remove_language(LANGUAGE_ENGLISH)


/datum/faction/xenomorph/corrupted/tamed
	name = "Tamed Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_TAMED

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/tamed

	prefix = "Tamed "
	color = "#80ff80"

	minimap_flag = MINIMAP_FLAG_XENO_TAMED

/datum/faction/xenomorph/corrupted/tamed/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.dynamic_evolution = FALSE
	faction_module.allow_no_queen_actions = TRUE
	faction_module.allow_no_queen_evo = TRUE
	faction_module.allow_queen_evolve = FALSE
	faction_module.latejoin_burrowed = FALSE
	faction_module.hive_structures_limit[XENO_STRUCTURE_EGGMORPH] = 0
