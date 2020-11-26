/datum/species/synthetic
	name = "Synthetic"
	name_plural = "synthetics"
	uses_ethnicity = TRUE //Uses ethnic presets

	unarmed_type = /datum/unarmed_attack/punch/strong
	rarity_value = 2

	total_health = 150 //more health than regular humans

	brute_mod = 0.5
	burn_mod = 1

	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500
	heat_level_2 = 1000
	heat_level_3 = 2000

	body_temperature = 350

	flags = IS_WHITELISTED|NO_BREATHE|NO_SCAN|NO_BLOOD|NO_POISON|IS_SYNTHETIC|NO_CHEM_METABOLIZATION

	blood_color = "#EEEEEE"

	has_organ = list(
		"heart" =    /datum/internal_organ/heart/prosthetic,
		"brain" =    /datum/internal_organ/brain/prosthetic,
		)

	knock_down_reduction = 5
	stun_reduction = 5

	inherent_verbs = list(
		/mob/living/carbon/human/synthetic/verb/toggle_HUD
		)

/datum/species/synthetic/handle_post_spawn(mob/living/carbon/human/H)
	H.set_languages(list("English", "Russian", "Tradeband", "Sainja", "Xenomorph"))
	living_human_list -= H
	H.pain = new /datum/pain/synthetic(H) // Has to be here, cause of stupid spawn code
	H.stamina = new /datum/stamina/synthetic(H)
	return ..()

/datum/species/synthetic/second_gen_synthetic
	name = "Second Generation Synthetic"
	uses_ethnicity = FALSE //2nd gen uses generic human look

/datum/species/synthetic/early_synthetic
	name = "Early Synthetic"
	name_plural = "Early Synthetics"
	uses_ethnicity = FALSE

	icobase = 'icons/mob/humans/species/r_synthetic.dmi'
	deform = 'icons/mob/humans/species/r_synthetic.dmi'

	rarity_value = 1.5
	//slowdown = 1.3 //Slower than later synths
	total_health = 200 //But more durable
	insulated = 1

	hair_color = "#000000"

	knock_down_reduction = 2
	stun_reduction = 2

	inherent_verbs = null

/datum/species/synthetic/early_synthetic/handle_post_spawn(mob/living/carbon/human/H)
	. = ..()
	H.pain = new /datum/pain/synthetic/early_synthetic(H) // Has to be here, cause of stupid spawn code