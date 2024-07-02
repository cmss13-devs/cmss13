/datum/faction/xenomorph/corrupted
	name = NAME_FACTION_XENOMORPH_CORRUPTED
	faction_name = FACTION_XENOMORPH_CORRUPTED
	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/corrupted

	prefix = "Corrupted "
	color = "#80ff80"
	ui_color ="#4d994d"

/datum/faction/xenomorph/corrupted/add_mob(mob/living/carbon/xenomorph/X)
	. = ..()
	X.add_language(LANGUAGE_ENGLISH)

/datum/faction/xenomorph/corrupted/remove_mob(mob/living/carbon/xenomorph/X, hard)
	. = ..()
	X.remove_language(LANGUAGE_ENGLISH)


/datum/faction/xenomorph/corrupted/tamed
	name = NAME_FACTION_XENOMORPH_TAMED
	faction_name = FACTION_XENOMORPH_TAMED
	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/tamed

	prefix = "Tamed "
	color = "#80ff80"

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_queen_evolve = FALSE
	ignore_slots = TRUE

/datum/faction/xenomorph/corrupted/tamed/New()
	. = ..()
	faction_structures_limit[XENO_STRUCTURE_EGGMORPH] = 0
	faction_structures_limit[XENO_STRUCTURE_EVOPOD] = 0

/datum/faction/xenomorph/corrupted/tamed/add_mob(mob/living/carbon/xenomorph/xenomorph)
	. = ..()
	if(faction_leader)
		xenomorph.faction = faction_leader.faction
