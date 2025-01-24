/datum/faction/xenomorph/charlie
	name = "Charlie Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_CHARLIE

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/charlie

	prefix = "Charlie "
	color = "#bb40ff"
	ui_color = "#702699"

	minimap_flag = MINIMAP_FLAG_XENO_CHARLIE

/datum/faction/xenomorph/charlie/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.latejoin_burrowed = FALSE
	faction_module.dynamic_evolution = FALSE
