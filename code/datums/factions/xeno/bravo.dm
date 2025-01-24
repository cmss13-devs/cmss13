/datum/faction/xenomorph/bravo
	name = "Bravo Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_BRAVO

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/bravo

	prefix = "Bravo "
	color = "#ffff80"
	ui_color = "#99994d"

	minimap_flag = MINIMAP_FLAG_XENO_BRAVO

/datum/faction/xenomorph/bravo/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.latejoin_burrowed = FALSE
	faction_module.dynamic_evolution = FALSE
