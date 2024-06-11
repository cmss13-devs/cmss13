/datum/species/synthetic
	group = SPECIES_SYNTHETIC
	name = SYNTH_GEN_THREE
	name_plural = "synthetics"
	uses_skin_color = TRUE //Uses skin color presets
	special_body_types = TRUE

	unarmed_type = /datum/unarmed_attack/punch/synthetic
	pain_type = /datum/pain/synthetic
	stamina_type = /datum/stamina/none
	mob_inherent_traits = list(TRAIT_SUPER_STRONG)
	rarity_value = 2
	insulated = TRUE

	bloodsplatter_type = /obj/effect/temp_visual/dir_setting/bloodsplatter/synthsplatter

	total_health = 150 //more health than regular humans

	brute_mod = 0.5
	burn_mod = 0.9 //a small bit of resistance

	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500
	heat_level_2 = 1000
	heat_level_3 = 2000

	body_temperature = 350

	mob_flags = KNOWS_TECHNOLOGY
	flags = IS_WHITELISTED|NO_BREATHE|NO_CLONE_LOSS|NO_BLOOD|NO_POISON|IS_SYNTHETIC|NO_CHEM_METABOLIZATION|NO_NEURO|HAS_UNDERWEAR

	blood_color = BLOOD_COLOR_SYNTHETIC

	has_organ = list(
		"heart" = /datum/internal_organ/heart/prosthetic,
		"brain" = /datum/internal_organ/brain/prosthetic,
		)

	knock_down_reduction = 5
	stun_reduction = 5
	acid_blood_dodge_chance = 25

	inherent_verbs = list(
		/mob/living/carbon/human/synthetic/proc/toggle_HUD,
		/mob/living/carbon/human/proc/toggle_inherent_nightvison,
	)

/datum/species/synthetic/handle_post_spawn(mob/living/carbon/human/H)
	H.set_languages(ALL_SYNTH_LANGUAGES)
	GLOB.alive_human_list -= H
	return ..()

/datum/species/synthetic/apply_signals(mob/living/carbon/human/H)
	RegisterSignal(H, COMSIG_HUMAN_IMPREGNATE, PROC_REF(cancel_impregnate), TRUE)

/datum/species/synthetic/proc/cancel_impregnate(datum/source)
	SIGNAL_HANDLER
	return COMPONENT_NO_IMPREGNATE

/datum/species/synthetic/gen_one
	name = SYNTH_GEN_ONE
	uses_skin_color = FALSE
	special_body_types = FALSE
	mob_inherent_traits = list(TRAIT_SUPER_STRONG, TRAIT_INTENT_EYES)

	hair_color = "#000000"
	icobase = 'icons/mob/humans/species/r_synthetic.dmi'
	deform = 'icons/mob/humans/species/r_synthetic.dmi'

/datum/species/synthetic/gen_two
	name = SYNTH_GEN_TWO
	uses_skin_color = FALSE //2nd gen uses generic human look
	special_body_types = FALSE

/datum/species/synthetic/colonial
	name = SYNTH_COLONY
	name_plural = "Colonial Synthetics"
	uses_skin_color = TRUE
	special_body_types = TRUE
	burn_mod = 0.8
	mob_inherent_traits = list(TRAIT_SUPER_STRONG)

	pain_type = /datum/pain/synthetic/colonial
	rarity_value = 1.5
	slowdown = 0.2
	total_health = 200 //But more durable

	default_lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE

	knock_down_reduction = 3.5
	stun_reduction = 3.5


/datum/species/synthetic/colonial/colonial_gen_two
	name = SYNTH_COLONY_GEN_TWO
	uses_skin_color = FALSE //2nd gen uses generic human look
	special_body_types = FALSE

/datum/species/synthetic/colonial/colonial_gen_one
	name = SYNTH_COLONY_GEN_ONE
	uses_skin_color = FALSE
	special_body_types = FALSE
	mob_inherent_traits = list(TRAIT_SUPER_STRONG, TRAIT_INTENT_EYES)
	//sets colonial_gen_one synth's hair to black
	hair_color = "#000000"
	//sets colonial_gen_one synth's icon to WJ sprite
	icobase = 'icons/mob/humans/species/r_synthetic.dmi'
	deform = 'icons/mob/humans/species/r_synthetic.dmi'

// Synth used for W-Y Deathsquads
/datum/species/synthetic/colonial/combat
	name = SYNTH_COMBAT
	name_plural = "Combat Synthetics"
	uses_skin_color = FALSE
	special_body_types = FALSE
	mob_inherent_traits = list(TRAIT_SUPER_STRONG, TRAIT_INTENT_EYES)

	burn_mod = 0.6 //made for combat
	total_health = 250 //made for combat

	hair_color = "#000000"
	icobase = 'icons/mob/humans/species/r_synthetic.dmi'
	deform = 'icons/mob/humans/species/r_synthetic.dmi'

	default_lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE // we don't want combat synths to run around in the dark

	knock_down_reduction = 5
	stun_reduction = 5

	inherent_verbs = null

// Synth used for synths posing as humans
/datum/species/synthetic/infiltrator
	name = SYNTH_INFILTRATOR
	name_plural = "Infiltrator Synthetics"
	uses_skin_color = TRUE
	mob_inherent_traits = list(TRAIT_SUPER_STRONG, TRAIT_INFILTRATOR_SYNTH)

	bloodsplatter_type = /obj/effect/temp_visual/dir_setting/bloodsplatter/human

	blood_color = BLOOD_COLOR_HUMAN
