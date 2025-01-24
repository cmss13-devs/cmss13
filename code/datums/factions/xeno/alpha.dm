/datum/faction/xenomorph/alpha
	name = "Alpha Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_ALPHA

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/alpha

	prefix = "Alpha "
	color = "#ff4040"
	ui_color = "#992626"

	minimap_flag = MINIMAP_FLAG_XENO_ALPHA

/datum/faction/xenomorph/alpha/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.latejoin_burrowed = FALSE
	faction_module.dynamic_evolution = FALSE
