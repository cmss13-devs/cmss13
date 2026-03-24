/datum/species/unggoy
	group = SPECIES_UNGGOY
	name = "Unggoy"
	name_plural = "Unggoy"
	mob_flags = KNOWS_TECHNOLOGY
	flags = HAS_HARDCRIT|HAS_SKIN_COLOR|SPECIAL_BONEBREAK|NO_SHRAPNEL
	mob_inherent_traits = list(
		TRAIT_COV_TECH,
		TRAIT_SUPER_STRONG,
		TRAIT_FOREIGN_BIO,
		TRAIT_DEXTROUS,
		TRAIT_IRON_TEETH,
	)
	unarmed_type = /datum/unarmed_attack/punch/unggoy
	pain_type = /datum/pain/unggoy
	blood_color = BLOOD_COLOR_UNGGOY
	flesh_color = "#317986"

	total_health = 125
	burn_mod = 1
	brute_mod = 1
	slowdown = 0.1

	dodge_pool = 5
	dodge_pool_max = 5
	dodge_pool_regen = 1
	dodge_pool_regen_max = 1
	dodge_pool_regen_restoration = 0.2
	dp_regen_base_reactivation_time = 35

	icobase = 'icons/halo/mob/humans/species/unggoy/r_unggoy.dmi'
	deform = 'icons/halo/mob/humans/species/unggoy/r_unggoy.dmi'
	eye_icon = 'icons/halo/mob/humans/species/unggoy/eyes.dmi'
	dam_icon = 'icons/halo/mob/humans/species/unggoy/dam_unggoy.dmi'
	blood_mask = 'icons/halo/mob/humans/species/unggoy/blood_mask.dmi'

	has_organ = list(
		"heart" = /datum/internal_organ/heart/unggoy,
		"lungs" = /datum/internal_organ/lungs/unggoy,
		"liver" = /datum/internal_organ/liver/unggoy,
		"kidneys" =  /datum/internal_organ/kidneys/unggoy,
		"brain" = /datum/internal_organ/brain/unggoy,
		"eyes" =  /datum/internal_organ/eyes
		)

/datum/species/unggoy/New()
	equip_adjust = list(
		WEAR_R_HAND = list("[NORTH]" = list("x" = 5, "y" = -5), "[EAST]" = list("x" = 7, "y" = -5), "[SOUTH]" = list("x" = -4, "y" = -5), "[WEST]" = list("x" = 0, "y" = -5)),
		WEAR_L_HAND = list("[NORTH]" = list("x" = -4, "y" = -5), "[EAST]" = list("x" = 0, "y" = -5), "[SOUTH]" = list("x" = 5, "y" = -5), "[WEST]" = list("x" = -7, "y" = -5))
	)
	..()

/datum/species/unggoy/post_species_loss(mob/living/carbon/human/H)
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

/datum/species/unggoy/handle_post_spawn(mob/living/carbon/human/unggoy)
	GLOB.alive_human_list -= unggoy

	unggoy.blood_type = "S*"
	unggoy.h_style = "Bald"
	#ifndef UNIT_TESTS // Since this is a hard ref, we shouldn't confuse create_and_destroy
	GLOB.unggoy_mob_list += unggoy
	#endif
	for(var/obj/limb/limb in unggoy.limbs)
		switch(limb.name)
			if("groin","chest")
				limb.min_broken_damage = 100
				limb.max_damage = 150 // 2 minutes to self heal bone break, time is in tenths of a second to auto heal this
			if("head")
				limb.min_broken_damage = 100
				limb.max_damage = 150 // 1 minute to self heal bone break, time is in tenths of a second
			if("l_hand","r_hand","r_foot","l_foot")
				limb.min_broken_damage = 150
				limb.max_damage = 150 // 1 minute to self heal bone break, time is in tenths of a second
			if("r_leg","r_arm","l_leg","l_arm")
				limb.min_broken_damage = 150
				limb.max_damage = 150 // 1 minute to self heal bone break, time is in tenths of a second

	unggoy.set_languages(list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY))
	return ..()
