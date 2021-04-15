/datum/species/synthetic
	group = SPECIES_SYNTHETIC
	name = "Synthetic"
	name_plural = "synthetics"
	uses_ethnicity = TRUE //Uses ethnic presets

	unarmed_type = /datum/unarmed_attack/punch/strong
	pain_type = /datum/pain/synthetic
	stamina_type = /datum/stamina/none
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

	mob_flags = KNOWS_TECHNOLOGY
	flags = IS_WHITELISTED|NO_BREATHE|NO_CLONE_LOSS|NO_BLOOD|NO_POISON|IS_SYNTHETIC|NO_CHEM_METABOLIZATION|NO_NEURO

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
	H.set_languages(list("English", "Russian", "Japanese", "Spacendeutchen", "Spanish", "Sainja", "Xenomorph"))
	GLOB.alive_human_list -= H
	return ..()

/datum/species/synthetic/apply_signals(var/mob/living/carbon/human/H)
	RegisterSignal(H, COMSIG_HUMAN_IMPREGNATE, .proc/cancel_impregnate)

/datum/species/synthetic/proc/cancel_impregnate(datum/source)
	SIGNAL_HANDLER
	return COMPONENT_NO_IMPREGNATE

/datum/species/synthetic/second_gen_synthetic
	name = "Second Generation Synthetic"
	uses_ethnicity = FALSE //2nd gen uses generic human look

/datum/species/synthetic/early_synthetic
	name = "Early Synthetic"
	name_plural = "Early Synthetics"
	uses_ethnicity = FALSE
	burn_mod = 0.80 // a little bit of resistance

	icobase = 'icons/mob/humans/species/r_synthetic.dmi'
	deform = 'icons/mob/humans/species/r_synthetic.dmi'

	pain_type = /datum/pain/synthetic/early_synthetic
	rarity_value = 1.5
	slowdown = 0.45
	total_health = 200 //But more durable
	insulated = 1

	hair_color = "#000000"

	knock_down_reduction = 3.5
	stun_reduction = 3.5

	inherent_verbs = null
