/datum/species/yautja_mutant
	group = SPECIES_YAUTJA
	name = SPECIES_YAUTJA_MUTANT
	name_plural = SPECIES_YAUTJA_MUTANT
	brute_mod = 0.25 //Beefy!
	burn_mod = 0.60
	reagent_tag = IS_YAUTJA
	mob_flags = KNOWS_TECHNOLOGY
	flags = IS_WHITELISTED|NO_CLONE_LOSS|NO_POISON|NO_NEURO|SPECIAL_BONEBREAK|NO_SHRAPNEL|HAS_HARDCRIT
	mob_inherent_traits = list(
		TRAIT_YAUTJA_TECH,
		TRAIT_SUPER_STRONG,
		TRAIT_FOREIGN_BIO,
		TRAIT_DEXTROUS,
		TRAIT_EMOTE_CD_EXEMPT,
		TRAIT_IRON_TEETH,
		TRAIT_UNSTRIPPABLE,
	)
	unarmed_type = /datum/unarmed_attack/punch/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	pain_type = /datum/pain/yautja
	stamina_type = /datum/stamina/none
	blood_color = BLOOD_COLOR_YAUTJA
	flesh_color = "#907E4A"
	speech_sounds = list('sound/voice/predalien_click.ogg')
	speech_chance = 100
	death_message = "lets out a final bellowing cry, falling motionless and lifeless soon after..."
	death_sound = 'sound/voice/pred_death2.ogg'
	darksight = 5
	default_lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
	flags_sight = SEE_MOBS
	slowdown = 0.5
	total_health = 200 //more health than regular humans
	timed_hug = FALSE

	bloodsplatter_type = /obj/effect/bloodsplatter/yautjasplatter

	burstscreams = list(MALE = "pred_preburst", FEMALE = "pred_preburst")

	heat_level_1 = 500
	heat_level_2 = 700
	heat_level_3 = 1000

	inherent_verbs = list()

	knock_down_reduction = 1.7
	stun_reduction = 1.7
	weed_slowdown_mult = 0 // no slowdown!

	icobase = 'icons/mob/humans/species/r_predator_mutant.dmi'
	deform = 'icons/mob/humans/species/r_predator_mutant.dmi'

	acid_blood_dodge_chance = 80

	ignores_stripdrag_flag = TRUE

// /datum/species/yautja_mutant/handle_death(mob/living/carbon/human/dead_yautja, gibbed)


/datum/species/yautja_mutant/post_species_loss(mob/living/carbon/human/human)
	..()
	var/datum/mob_hud/medical/advanced/adv_hud = GLOB.huds[MOB_HUD_MEDICAL_ADVANCED]
	adv_hud.add_to_hud(human)
	human.blood_type = pick("A+","A-","B+","B-","O-","O+","AB+","AB-")
	human.h_style = "Bald"
	human.huggable = initial(human.huggable)
	for(var/obj/limb/limb in human.limbs)
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

/datum/species/yautja_mutant/handle_post_spawn(mob/living/carbon/human/mutant)
	mutant.set_languages(list(LANGUAGE_PATHOGEN, LANGUAGE_PATHOGEN_MIND))

	mutant.faction = FACTION_PATHOGEN
	mutant.hivenumber = XENO_HIVE_PATHOGEN
	mutant.faction_group = list(FACTION_PATHOGEN)
	mutant.job = "Yautja Mutant"

	if(mutant.l_hand)
		mutant.drop_inv_item_on_ground(mutant.l_hand, FALSE, TRUE)
	if(mutant.r_hand)
		mutant.drop_inv_item_on_ground(mutant.r_hand, FALSE, TRUE)
	if(mutant.wear_id)
		mutant.drop_inv_item_on_ground(mutant.wear_id, FALSE, TRUE)
	if(mutant.gloves)
		mutant.drop_inv_item_on_ground(mutant.gloves, FALSE, TRUE)
	if(mutant.head)
		mutant.drop_inv_item_on_ground(mutant.head, FALSE, TRUE)
	if(mutant.glasses)
		mutant.drop_inv_item_on_ground(mutant.glasses, FALSE, TRUE)
	if(mutant.wear_mask)
		mutant.drop_inv_item_on_ground(mutant.wear_mask, FALSE, TRUE)
	if(mutant.back)
		mutant.drop_inv_item_on_ground(mutant.back, FALSE, TRUE)
	if(mutant.belt)
		mutant.drop_inv_item_on_ground(mutant.belt, FALSE, TRUE)
	if(mutant.wear_l_ear)
		mutant.drop_inv_item_on_ground(mutant.wear_l_ear, FALSE, TRUE)
	if(mutant.wear_r_ear)
		mutant.drop_inv_item_on_ground(mutant.wear_r_ear, FALSE, TRUE)


	mutant.huggable = FALSE
	mutant.blood_type = "Y*"
	mutant.h_style = "Standard"
	for(var/obj/limb/limb in mutant.limbs)
		switch(limb.name)
			if("groin","chest")
				limb.min_broken_damage = 145
				limb.max_damage = 150
				limb.time_to_knit = 1200 // 2 minutes to self heal bone break, time is in tenths of a second to auto heal this
			if("head")
				limb.min_broken_damage = 140
				limb.max_damage = 150
				limb.time_to_knit = 600 // 1 minute to self heal bone break, time is in tenths of a second
			if("l_hand","r_hand","r_foot","l_foot")
				limb.min_broken_damage = 145
				limb.max_damage = 150
				limb.time_to_knit = 600 // 1 minute to self heal bone break, time is in tenths of a second
			if("r_leg","r_arm","l_leg","l_arm")
				limb.min_broken_damage = 145
				limb.max_damage = 150
				limb.time_to_knit = 600 // 1 minute to self heal bone break, time is in tenths of a second
	return ..()

/datum/species/yautja_mutant/get_hairstyle(style)
	return GLOB.yautja_hair_styles_list[style]
