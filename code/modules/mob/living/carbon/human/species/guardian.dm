/datum/species/guardian
	group = SPECIES_HUMAN
	name = SPECIES_GUARDIAN
	name_plural = "Guardians"
	icobase = 'icons/mob/humans/species/t_guardian.dmi'
	deform = 'icons/mob/humans/species/t_guardian.dmi'
	eyes = "blank_s"
	mob_flags = KNOWS_TECHNOLOGY
	flags = IS_WHITELISTED|NO_CLONE_LOSS|NO_POISON|NO_NEURO|NO_SHRAPNEL|HAS_HARDCRIT
	default_lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
	darksight = 20
	total_health = 150 //more health than regular humans
	brute_mod = 0.5
	burn_mod = 0.8
	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500
	heat_level_2 = 1000
	heat_level_3 = 2000 //a small bit of resistance

	has_organ = list(
		"brain" = /datum/internal_organ/brain, //human brain but synthetic hearth
		"heart" = /datum/internal_organ/heart/prosthetic,
	)

	knock_down_reduction = 2.5
	stun_reduction = 2.5
	acid_blood_dodge_chance = 100

/datum/species/guardian/handle_post_spawn(mob/living/carbon/human/human)
	new/obj/item/alien_embryo/dormant(human)
