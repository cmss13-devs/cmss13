/datum/species/guardian
	group = SPECIES_HUMAN
	name = SPECIES_GUARDIAN
	name_plural = "Guardians"
	icobase = 'icons/mob/humans/species/t_guardian.dmi'
	deform = 'icons/mob/humans/species/t_guardian.dmi'
	eyes = "blank_s"
	mob_flags = KNOWS_TECHNOLOGY
	flags = IS_WHITELISTED|NO_CLONE_LOSS|NO_POISON|NO_NEURO|NO_SHRAPNEL|HAS_HARDCRIT
	darksight = 5

/datum/species/guardian/handle_post_spawn(mob/living/carbon/human/human)
	new/obj/item/alien_embryo/dormant(human)
