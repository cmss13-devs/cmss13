/datum/faction/xenomorph/delta
	name = "Delta Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_DELTA

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/delta

	prefix = "Delta "
	color = "#8080ff"
	ui_color = "#4d4d99"

	minimap_flag = MINIMAP_FLAG_XENO_DELTA

/datum/faction/xenomorph/delta/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.latejoin_burrowed = FALSE
	faction_module.dynamic_evolution = FALSE
