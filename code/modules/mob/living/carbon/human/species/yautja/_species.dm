/datum/species/yautja
	group = SPECIES_YAUTJA
	name = "Yautja"
	name_plural = "Yautja"
	brute_mod = 0.28 //Beefy!
	burn_mod = 0.65
	reagent_tag = IS_YAUTJA
	mob_flags = KNOWS_TECHNOLOGY
	uses_ethnicity = TRUE
	flags = IS_WHITELISTED|HAS_SKIN_COLOR|NO_CLONE_LOSS|NO_POISON|NO_NEURO|SPECIAL_BONEBREAK|NO_SHRAPNEL|HAS_HARDCRIT
	mob_inherent_traits = list(
		TRAIT_YAUTJA_TECH,
		TRAIT_SUPER_STRONG,
		TRAIT_FOREIGN_BIO,
		TRAIT_DEXTROUS,
		TRAIT_EMOTE_CD_EXEMPT,
	)
	unarmed_type = /datum/unarmed_attack/punch/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	pain_type = /datum/pain/yautja
	stamina_type = /datum/stamina/none
	blood_color = BLOOD_COLOR_YAUTJA
	flesh_color = "#907E4A"
	speech_sounds = list('sound/voice/pred_click1.ogg', 'sound/voice/pred_click2.ogg')
	speech_chance = 100
	death_message = "clicks in agony and falls still, motionless and completely lifeless..."
	darksight = 5
	default_lighting_alpha = LIGHTING_PLANE_ALPHA_YAUTJA
	flags_sight = SEE_MOBS
	slowdown = -0.5
	total_health = 175 //more health than regular humans
	timed_hug = FALSE

	bloodsplatter_type = /obj/effect/temp_visual/dir_setting/bloodsplatter/yautjasplatter

	heat_level_1 = 500
	heat_level_2 = 700
	heat_level_3 = 1000

	inherent_verbs = list(
		/mob/living/carbon/human/proc/pred_buy,
		/mob/living/carbon/human/proc/butcher,
		/mob/living/carbon/human/proc/mark_for_hunt,
		/mob/living/carbon/human/proc/remove_from_hunt,
		/mob/living/carbon/human/proc/mark_gear,
		/mob/living/carbon/human/proc/unmark_gear,
		/mob/living/carbon/human/proc/mark_honored,
		/mob/living/carbon/human/proc/unmark_honored,
		/mob/living/carbon/human/proc/mark_dishonored,
		/mob/living/carbon/human/proc/unmark_dishonored,
		/mob/living/carbon/human/proc/mark_thralled,
		/mob/living/carbon/human/proc/unmark_thralled,
		/mob/living/carbon/human/proc/mark_panel,
	)

	knock_down_reduction = 4
	stun_reduction = 4
	weed_slowdown_mult = 0 // no slowdown!

	icobase = 'icons/mob/humans/species/r_predator.dmi'
	deform = 'icons/mob/humans/species/r_predator.dmi'

	acid_blood_dodge_chance = 70

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
		WEAR_L_EAR,\
		WEAR_R_EAR,\
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

	ignores_stripdrag_flag = TRUE

/datum/species/yautja/larva_impregnated(obj/item/alien_embryo/embryo)
	var/datum/hive_status/hive = GLOB.hive_datum[embryo.hivenumber]

	if(!istype(hive))
		return

	if(!(XENO_STRUCTURE_NEST in hive.hive_structure_types))
		hive.hive_structure_types.Add(XENO_STRUCTURE_NEST)

	if(!(XENO_STRUCTURE_NEST in hive.hive_structures_limit))
		hive.hive_structures_limit.Add(XENO_STRUCTURE_NEST)
		hive.hive_structures_limit[XENO_STRUCTURE_NEST] = 0

	hive.hive_structure_types[XENO_STRUCTURE_NEST] = /datum/construction_template/xenomorph/nest
	hive.hive_structures_limit[XENO_STRUCTURE_NEST]++

	xeno_message(SPAN_XENOANNOUNCE("The hive senses that a headhunter has been infected! The thick resin nest is now available in the special structures list!"),hivenumber = hive.hivenumber)

/datum/species/yautja/handle_death(mob/living/carbon/human/H, gibbed)
	if(gibbed)
		GLOB.yautja_mob_list -= H

	for(var/mob/living/carbon/M in H.hunter_data.dishonored_targets)
		M.hunter_data.dishonored_set = null
		H.hunter_data.dishonored_targets -= M
	for(var/mob/living/carbon/M in H.hunter_data.honored_targets)
		M.hunter_data.honored_set = null
		H.hunter_data.honored_targets -= M
	for(var/mob/living/carbon/M in H.hunter_data.gear_targets)
		M.hunter_data.gear_set = null
		H.hunter_data.gear_targets -= M

	if(H.hunter_data.prey)
		var/mob/living/carbon/M = H.hunter_data.prey
		H.hunter_data.prey = null
		M.hunter_data.hunter = null
		M.hud_set_hunter()

	set_predator_status(H, gibbed ? "Gibbed" : "Dead")

	// Notify all yautja so they start the gear recovery
	message_all_yautja("[H.real_name] has died at \the [get_area_name(H)].")

	if(H.hunter_data.thrall)
		var/mob/living/carbon/T = H.hunter_data.thrall
		message_all_yautja("[H.real_name]'s Thrall, [T.real_name] is now masterless.")
		H.message_thrall("Your master has fallen!")
		H.hunter_data.thrall = null

/datum/species/yautja/handle_dead_death(mob/living/carbon/human/H, gibbed)
	set_predator_status(H, gibbed ? "Gibbed" : "Dead")

/datum/species/yautja/handle_cryo(mob/living/carbon/human/H)
	set_predator_status(H, "Cryo")

/datum/species/yautja/proc/set_predator_status(mob/living/carbon/human/H, status = "Alive")
	if(!H.persistent_ckey)
		return
	var/datum/game_mode/GM
	if(SSticker?.mode)
		GM = SSticker.mode
		if(H.persistent_ckey in GM.predators)
			GM.predators[H.persistent_ckey]["Status"] = status
		else
			GM.predators[H.persistent_ckey] = list("Name" = H.real_name, "Status" = status)

/datum/species/yautja/post_species_loss(mob/living/carbon/human/H)
	..()
	var/datum/mob_hud/medical/advanced/A = huds[MOB_HUD_MEDICAL_ADVANCED]
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

/datum/species/yautja/handle_post_spawn(mob/living/carbon/human/hunter)
	GLOB.alive_human_list -= hunter
	hunter.universal_understand = 1

	hunter.blood_type = "Y*"
	hunter.h_style = "Standard"
	#ifndef UNIT_TESTS // Since this is a hard ref, we shouldn't confuse create_and_destroy
	GLOB.yautja_mob_list += hunter
	#endif
	for(var/obj/limb/limb in hunter.limbs)
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

	hunter.set_languages(list(LANGUAGE_YAUTJA))
	give_action(hunter, /datum/action/yautja_emote_panel)
	return ..()

/datum/species/yautja/get_hairstyle(style)
	return GLOB.yautja_hair_styles_list[style]

/datum/species/yautja/handle_on_fire(humanoidmob)
	. = ..()
	INVOKE_ASYNC(humanoidmob, TYPE_PROC_REF(/mob, emote), pick("pain", "scream"))

/datum/species/yautja/handle_paygrades()
	return ""

/// Open the Yautja emote panel, which allows them to use their emotes easier.
/datum/species/yautja/open_emote_panel()
	var/datum/yautja_emote_panel/ui = new(usr)
	ui.ui_interact(usr)

/datum/action/yautja_emote_panel
	name = "Open Emote Panel"
	action_icon_state = "looc_toggle"

/datum/action/yautja_emote_panel/can_use_action()
	. = ..()
	if(!.)
		return FALSE

	if(!isyautja(owner))
		return FALSE

	return TRUE

/datum/action/yautja_emote_panel/action_activate()
	if(!can_use_action())
		return

	var/mob/living/carbon/human/human_owner = owner
	var/datum/species/yautja/yautja_species = human_owner.species
	yautja_species.open_emote_panel()

/datum/yautja_emote_panel
	/// Static dict ("category" : (emotes)) of every yautja emote typepath
	var/static/list/yautja_emotes
	/// Static list of categories
	var/static/list/yautja_categories = list()
	/// Panel allows you to spam, so a manual CD is added here
	COOLDOWN_DECLARE(panel_emote_cooldown)

/datum/yautja_emote_panel/New()
	if(!length(yautja_emotes))
		var/list/emotes_to_add = list()
		for(var/datum/emote/living/carbon/human/yautja/emote as anything in subtypesof(/datum/emote/living/carbon/human/yautja))
			if(!initial(emote.key) || initial(emote.no_panel))
				continue

			if(!(initial(emote.category) in yautja_categories))
				yautja_categories += initial(emote.category)
			emotes_to_add += emote
		yautja_emotes = emotes_to_add

/datum/yautja_emote_panel/proc/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "YautjaEmotes")
		ui.open()

/datum/yautja_emote_panel/ui_data(mob/user)
	var/list/data = list()

	data["on_cooldown"] = !COOLDOWN_FINISHED(src, panel_emote_cooldown)

	return data

/datum/yautja_emote_panel/ui_state(mob/user)
	return GLOB.conscious_state

/datum/yautja_emote_panel/ui_static_data(mob/user)
	var/list/data = list()

	data["categories"] = yautja_categories
	data["emotes"] = list()

	for(var/datum/emote/living/carbon/human/yautja/emote as anything in yautja_emotes)
		data["emotes"] += list(list(
			"id" = initial(emote.key),
			"text" = (initial(emote.override_say) || initial(emote.say_message) || initial(emote.key)),
			"category" = initial(emote.category),
			"path" = "[emote]",
		))

	return data

/datum/yautja_emote_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("emote")
			var/datum/emote/living/carbon/human/yautja/path
			if(!params["emotePath"])
				return FALSE

			path = text2path(params["emotePath"])

			if(!path || !COOLDOWN_FINISHED(src, panel_emote_cooldown))
				return

			if(!(path in subtypesof(/datum/emote/living/carbon/human/yautja)))
				return FALSE

			COOLDOWN_START(src, panel_emote_cooldown, 2.5 SECONDS)
			usr.emote(initial(path.key))
			return TRUE
