/datum/species/yautja
	name = "Yautja"
	name_plural = "Yautja"
	brute_mod = 0.33 //Beefy!
	burn_mod = 0.65
	reagent_tag = IS_YAUTJA
	mob_flags = KNOWS_TECHNOLOGY
	flags = IS_WHITELISTED|HAS_SKIN_COLOR|NO_CLONE_LOSS|NO_POISON|NO_NEURO|SPECIAL_BONEBREAK|NO_SHRAPNEL|HAS_HARDCRIT
	unarmed_type = /datum/unarmed_attack/punch/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	pain_type = /datum/pain/yautja
	stamina_type = /datum/stamina/none
	blood_color = "#20d450"
	flesh_color = "#907E4A"
	speech_sounds = list('sound/voice/pred_click1.ogg', 'sound/voice/pred_click2.ogg')
	speech_chance = 100
	death_message = "clicks in agony and falls still, motionless and completely lifeless..."
	darksight = 5
	slowdown = -0.5
	total_health = 150 //more health than regular humans, makes up for hardcrit reintroduction
	timed_hug = FALSE

	heat_level_1 = 500
	heat_level_2 = 700
	heat_level_3 = 1000

	inherent_verbs = list(
		/mob/living/carbon/human/proc/pred_buy,
		/mob/living/carbon/human/proc/butcher,
		/mob/living/carbon/human/proc/mark_for_hunt,
		/mob/living/carbon/human/proc/remove_from_hunt
		)

	knock_down_reduction = 4
	stun_reduction = 4

		//Set their special slot priority

	slot_equipment_priority= list( \
		WEAR_BACK,\
		WEAR_ID,\
		WEAR_BODY,\
		WEAR_JACKET,\
		WEAR_HEAD,\
		WEAR_FEET,\
		WEAR_IN_SHOES,\
		WEAR_FACE,\
		WEAR_HANDS,\
		WEAR_EAR,\
		WEAR_EYES,\
		WEAR_IN_SCABBARD,\
		WEAR_WAIST,\
		WEAR_IN_J_STORE,\
		WEAR_IN_L_STORE,\
		WEAR_IN_R_STORE,\
		WEAR_J_STORE,\
		WEAR_IN_ACCESSORY,\
		WEAR_IN_JACKET,\
		WEAR_L_STORE,\
		WEAR_R_STORE,\
		WEAR_IN_BELT,\
		WEAR_IN_BACK\
	)

/datum/species/yautja/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, .proc/setup_yautja_icons)

/datum/species/yautja/proc/setup_yautja_icons()
	SIGNAL_HANDLER

	icobase_source = CONFIG_GET(string/species_hunter)
	deform_source = CONFIG_GET(string/species_hunter)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, .proc/setup_yautja_icons)

/datum/species/yautja/larva_impregnated(var/obj/item/alien_embryo/embryo)
	var/datum/hive_status/hive = GLOB.hive_datum[embryo.hivenumber]

	if(!istype(hive))
		return

	if(!(XENO_STRUCTURE_NEST in hive.hive_structure_types))
		hive.hive_structure_types.Add(XENO_STRUCTURE_NEST)

	if(!(XENO_STRUCTURE_NEST in hive.hive_structures_limit))
		hive.hive_structures_limit.Add(XENO_STRUCTURE_NEST)
		hive.hive_structures_limit[XENO_STRUCTURE_NEST] = 0

	hive.hive_structure_types[XENO_STRUCTURE_NEST] = /datum/construction_template/xenomorph/nest
	hive.hive_structures_limit[XENO_STRUCTURE_NEST] += 1

/datum/species/yautja/handle_death(var/mob/living/carbon/human/H, gibbed)
	if(gibbed)
		GLOB.yautja_mob_list -= H

	if(H.yautja_hunted_prey)
		H.yautja_hunted_prey = null

	// Notify all yautja so they start the gear recovery
	message_all_yautja("[H] has died at \the [get_area_name(H)].")

/datum/species/yautja/post_species_loss(mob/living/carbon/human/H)
	var/datum/mob_hud/medical/advanced/A = huds[MOB_HUD_MEDICAL_ADVANCED]
	A.add_to_hud(H)
	H.blood_type = pick("A+","A-","B+","B-","O-","O+","AB+","AB-")
	GLOB.yautja_mob_list -= H
	for(var/obj/limb/L in H.limbs)
		switch(L.name)
			if("groin","chest")
				L.min_broken_damage = 40
				L.max_damage = 200
			if("head")
				L.min_broken_damage = 40
				L.max_damage = 60
			if("l_hand","r_hand","r_foot","l_foot")
				L.min_broken_damage = 25
				L.max_damage = 30
			if("r_leg","r_arm","l_leg","l_arm")
				L.min_broken_damage = 30
				L.max_damage = 35
		L.time_to_knit = -1

/datum/species/yautja/handle_post_spawn(var/mob/living/carbon/human/H)
	GLOB.alive_human_list -= H
	H.universal_understand = 1

	H.blood_type = "Y*"
	GLOB.yautja_mob_list += H
	for(var/obj/limb/L in H.limbs)
		switch(L.name)
			if("groin","chest")
				L.min_broken_damage = 140
				L.max_damage = 140
				L.time_to_knit = 1200 // 2 minutes, time is in tenths of a second
			if("head")
				L.min_broken_damage = 80
				L.max_damage = 80
				L.time_to_knit = 1200 // 2 minutes, time is in tenths of a second
			if("l_hand","r_hand","r_foot","l_foot")
				L.min_broken_damage = 55
				L.max_damage = 55
				L.time_to_knit = 600 // 1 minute, time is in tenths of a second
			if("r_leg","r_arm","l_leg","l_arm")
				L.min_broken_damage = 75
				L.max_damage = 75
				L.time_to_knit = 600 // 1 minute, time is in tenths of a second


	var/datum/mob_hud/medical/advanced/A = huds[MOB_HUD_MEDICAL_ADVANCED]
	A.remove_from_hud(H)
	H.set_languages(list("Sainja"))
	return ..()
