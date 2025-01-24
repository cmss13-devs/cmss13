/datum/faction/xenomorph/mutated
	name = "Mutated Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_MUTATED

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/mutated

	prefix = "Mutated "
	color = "#6abd99"
	ui_color = "#6abd99"

	hive_inherant_traits = list(TRAIT_XENONID)

	minimap_flag = MINIMAP_FLAG_XENO_MUTATED

/datum/faction/xenomorph/mutated/New()
	. = ..()
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	faction_module.latejoin_burrowed = FALSE
