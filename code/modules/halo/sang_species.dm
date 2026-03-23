/datum/species/sangheili
	group = SPECIES_SANGHEILI
	name = "Sangheili"
	name_plural = "Sangheili"
	mob_flags = KNOWS_TECHNOLOGY
	flags = HAS_HARDCRIT|HAS_SKIN_COLOR|SPECIAL_BONEBREAK|NO_SHRAPNEL
	mob_inherent_traits = list(
		TRAIT_COV_TECH,
		TRAIT_SUPER_STRONG,
		TRAIT_FOREIGN_BIO,
		TRAIT_DEXTROUS,
		TRAIT_IRON_TEETH,
	)
	unarmed_type = /datum/unarmed_attack/punch/sangheili
	pain_type = /datum/pain/sangheili
	blood_color = BLOOD_COLOR_SANGHEILI
	flesh_color = "#4d4b46"

	total_health = 300
	burn_mod = 0.8
	brute_mod = 0.8
	slowdown = -0.2

	dodge_pool = 20
	dodge_pool_max = 20
	dodge_pool_regen = 1
	dodge_pool_regen_max = 1
	dodge_pool_regen_restoration = 0.1
	dp_regen_base_reactivation_time = 20

	heat_level_1 = 500
	heat_level_2 = 700
	heat_level_3 = 1000

	knock_down_reduction = 1.5
	stun_reduction = 1.5
	knock_out_reduction = 1.5

	icobase = 'icons/halo/mob/humans/species/sangheili/r_sangheili.dmi'
	deform = 'icons/halo/mob/humans/species/sangheili/r_sangheili.dmi'
	eye_icon = 'icons/halo/mob/humans/species/sangheili/eyes.dmi'
	dam_icon = 'icons/halo/mob/humans/species/sangheili/dam_sangheili.dmi'
	blood_mask = 'icons/halo/mob/humans/species/sangheili/blood_mask.dmi'
	icon_template = 'icons/mob/humans/template_64.dmi'

	has_organ = list(
		"heart" = /datum/internal_organ/heart/sangheili,
		"secondary_heart" = /datum/internal_organ/heart/sangheili/secondary,
		"lungs" = /datum/internal_organ/lungs/sangheili,
		"liver" = /datum/internal_organ/liver/sangheili,
		"kidneys" =  /datum/internal_organ/kidneys/sangheili,
		"brain" = /datum/internal_organ/brain/sangheili,
		"eyes" =  /datum/internal_organ/eyes
		)

/datum/species/sangheili/New()
	equip_adjust = list(
		WEAR_R_HAND = list("[NORTH]" = list("x" = 5, "y" = 6), "[EAST]" = list("x" = 0, "y" = 6), "[SOUTH]" = list("x" = -5, "y" = 6), "[WEST]" = list("x" = 2, "y" = 6)),
		WEAR_L_HAND = list("[NORTH]" = list("x" = -5, "y" = 6), "[EAST]" = list("x" = -2, "y" = 6), "[SOUTH]" = list("x" = 5, "y" = 6), "[WEST]" = list("x" = 0, "y" = 6))
	)
	..()

/datum/species/sangheili/post_species_loss(mob/living/carbon/human/H)
	..()
	var/datum/mob_hud/medical/advanced/A = GLOB.huds[MOB_HUD_MEDICAL_ADVANCED]
	A.add_to_hud(H)
	H.blood_type = pick("A+","A-","B+","B-","O-","O+","AB+","AB-")
	H.h_style = "Bald"
	GLOB.yautja_mob_list -= H
	for(var/obj/limb/limb in H.limbs)
		switch(limb.name)
			if("groin","chest")
				limb.min_broken_damage = 40
				limb.max_damage = 200
			if("head")
				limb.min_broken_damage = 40
				limb.max_damage = 60
			if("l_hand","r_hand","r_foot","l_foot")
				limb.min_broken_damage = 25
				limb.max_damage = 30
			if("r_leg","r_arm","l_leg","l_arm")
				limb.min_broken_damage = 30
				limb.max_damage = 35
		limb.time_to_knit = -1

/datum/species/sangheili/handle_post_spawn(mob/living/carbon/human/sangheili)
	GLOB.alive_human_list -= sangheili

	sangheili.blood_type = "S*"
	sangheili.h_style = "Bald"
	#ifndef UNIT_TESTS // Since this is a hard ref, we shouldn't confuse create_and_destroy
	GLOB.sangheili_mob_list += sangheili
	#endif
	for(var/obj/limb/limb in sangheili.limbs)
		switch(limb.name)
			if("groin","chest")
				limb.min_broken_damage = 120
				limb.max_damage = 150
				limb.time_to_knit = 2 MINUTES // 2 minutes to self heal bone break, time is in tenths of a second to auto heal this
			if("head")
				limb.min_broken_damage = 120
				limb.max_damage = 150
				limb.time_to_knit = 1 MINUTES // 1 minute to self heal bone break, time is in tenths of a second
			if("l_hand","r_hand","r_foot","l_foot")
				limb.min_broken_damage = 120
				limb.max_damage = 150
				limb.time_to_knit = 1 MINUTES // 1 minute to self heal bone break, time is in tenths of a second
			if("r_leg","r_arm","l_leg","l_arm")
				limb.min_broken_damage = 120
				limb.max_damage = 150
				limb.time_to_knit = 1 MINUTES // 1 minute to self heal bone break, time is in tenths of a second

	give_action(sangheili, /datum/action/human_action/activable/covenant/sangheili_kick)

	sangheili.set_languages(list(LANGUAGE_SANGHEILI))
	return ..()
