/datum/faction/xenomorph/forsaken
	name = "Forsaken Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_FORSAKEN

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/forsaken

	prefix = "Feral "
	color = "#828296"
	ui_color = "#828296"

	minimap_flag = MINIMAP_FLAG_XENO_FORSAKEN

/datum/faction/xenomorph/forsaken/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.dynamic_evolution = FALSE
	faction_module.allow_no_queen_actions = TRUE
	faction_module.allow_no_queen_evo = TRUE
	faction_module.allow_queen_evolve = FALSE
	faction_module.latejoin_burrowed = FALSE
