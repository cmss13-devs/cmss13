/datum/caste_datum/larva
	caste_type = XENO_CASTE_LARVA
	tier = 0
	plasma_gain = 0.1
	plasma_max = 10
	melee_damage_lower = 0
	melee_damage_upper = 0
	melee_vehicle_damage = 0
	max_health = XENO_HEALTH_LARVA
	caste_desc = "D'awwwww, so cute!"
	speed = XENO_SPEED_TIER_10
	innate_healing = TRUE //heals even outside weeds so you're not stuck unable to evolve when hiding on the ship wounded.
	evolves_to = XENO_T1_CASTES

	evolve_without_queen = TRUE
	can_be_revived = FALSE

	minimap_icon = "larva"

/datum/caste_datum/larva/predalien
	caste_type = XENO_CASTE_PREDALIEN_LARVA
	evolves_to = list(XENO_CASTE_PREDALIEN)

	minimap_icon = "predalien_larva"
	minimum_evolve_time = 0

/mob/living/carbon/xenomorph/larva
	AUTOWIKI_SKIP(TRUE)

	name = "Bloody Larva"
	caste_type = XENO_CASTE_LARVA
	speak_emote = list("hisses")
	icon_state = "Bloody Larva"
	icon_size = 32
	layer = MOB_LAYER
	see_in_dark = 8
	tier = 0  //Larva's don't count towards Pop limits
	age = XENO_NO_AGE
	crit_health = -25
	gib_chance = 25
	mob_size = MOB_SIZE_SMALL
	speaking_noise = "larva_talk"
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)

	var/burrowable = TRUE //Can it be safely burrowed if it has no player?
	var/state_override
	/// Whether we're bloody, normal, or mature
	var/larva_state = LARVA_STATE_BLOODY

	icon_xeno = 'icons/mob/xenos/castes/tier_0/larva.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_0/larva.dmi'

/mob/living/carbon/xenomorph/larva/Life()
	// Check if no longer bloody or mature
	if(larva_state == LARVA_STATE_BLOODY && evolution_stored >= evolution_threshold / 2)
		larva_state = LARVA_STATE_NORMAL
		generate_name()
	else if(larva_state == LARVA_STATE_NORMAL && evolution_stored >= evolution_threshold)
		larva_state = LARVA_STATE_MATURE
		generate_name()
	return ..()

/mob/living/carbon/xenomorph/larva/initialize_pass_flags(datum/pass_flags_container/pass_flags)
	..()
	if (pass_flags)
		pass_flags.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		pass_flags.flags_can_pass_all = PASS_ALL^PASS_OVER_THROW_ITEM

/mob/living/carbon/xenomorph/larva/corrupted
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_CORRUPTED

/mob/living/carbon/xenomorph/larva/alpha
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_ALPHA

/mob/living/carbon/xenomorph/larva/bravo
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_BRAVO

/mob/living/carbon/xenomorph/larva/charlie
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_CHARLIE

/mob/living/carbon/xenomorph/larva/delta
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_DELTA

/mob/living/carbon/xenomorph/larva/mutated
	AUTOWIKI_SKIP(TRUE)

	hivenumber = XENO_HIVE_MUTATED

/mob/living/carbon/xenomorph/larva/predalien
	AUTOWIKI_SKIP(TRUE)

	icon_xeno = 'icons/mob/xenos/castes/tier_0/predalien_larva.dmi'
	icon_state = "Predalien Larva"
	caste_type = XENO_CASTE_PREDALIEN_LARVA
	burrowable = FALSE //Not interchangeable with regular larvas in the hive core.
	state_override = "Predalien "

/mob/living/carbon/xenomorph/larva/predalien/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	hunter_data.dishonored = TRUE
	hunter_data.dishonored_reason = "An abomination upon the honor of us all!"
	hunter_data.dishonored_set = src
	hud_set_hunter()

/mob/living/carbon/xenomorph/larva/evolve_message()
	to_chat(src, SPAN_XENODANGER("Strength ripples through your small form. You are ready to be shaped to the Queen's will. <a href='byond://?src=\ref[src];evolve=1;'>Evolve</a>"))
	playsound_client(client, sound('sound/effects/xeno_evolveready.ogg'))

	var/datum/action/xeno_action/onclick/evolve/evolve_action = new()
	evolve_action.give_to(src)

//Larva code is just a mess, so let's get it over with
/mob/living/carbon/xenomorph/larva/update_icons()
	var/state = "" //Icon convention, two different sprite sets

	if(larva_state == LARVA_STATE_BLOODY)
		state = "Bloody "

	if(stat == DEAD)
		icon_state = "[state_override || state]Larva Dead"
	else if(handcuffed || legcuffed)
		icon_state = "[state_override || state]Larva Cuff"

	else if(body_position == LYING_DOWN)
		if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
			icon_state = "[state_override || state]Larva Sleeping"
		else
			icon_state = "[state_override || state]Larva Stunned"
	else
		icon_state = "[state_override || state]Larva"

/mob/living/carbon/xenomorph/larva/alter_ghost(mob/dead/observer/ghost)
	ghost.icon_state = "[caste.caste_type]"

/mob/living/carbon/xenomorph/larva/start_pulling(atom/movable/AM)
	return

/mob/living/carbon/xenomorph/larva/pull_response(mob/puller)
	return TRUE

/mob/living/carbon/xenomorph/larva/UnarmedAttack(atom/atom, proximity, click_parameters, tile_attack, ignores_resin = FALSE)
	a_intent = INTENT_HELP //Forces help intent for all interactions.
	if(!caste)
		return FALSE

	if(body_position) //No attacks while laying down
		return FALSE

	atom.attack_larva(src)
	xeno_attack_delay(src) //Adds some lag to the 'attack'

/proc/spawn_hivenumber_larva(atom/atom, hivenumber)
	if(!GLOB.hive_datum[hivenumber] || isnull(atom))
		return

	var/mob/living/carbon/xenomorph/larva/larva = new /mob/living/carbon/xenomorph/larva(atom)

	larva.set_hive_and_update(hivenumber)

	return larva

/mob/living/carbon/xenomorph/larva/emote(act, m_type, message, intentional, force_silence)
	// Custom emote
	if(act == "me")
		return ..()

	switch(stat)
		if(UNCONSCIOUS)
			to_chat(src, SPAN_WARNING("You cannot emote while unconscious!"))
			return FALSE
		if(DEAD)
			to_chat(src, SPAN_WARNING("You cannot emote while dead!"))
			return FALSE
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_DANGER("You cannot emote (muted)."))
			return FALSE
		if(!client.attempt_talking())
			return FALSE

	// Otherwise, ""roar""!
	playsound(loc, "alien_roar_larva", 15)
	return TRUE

/mob/living/carbon/xenomorph/larva/is_xeno_grabbable()
	return TRUE

/*
Larva name generation, set nicknumber = (number between 1 & 999) which isn't taken by any other xenos in GLOB.xeno_mob_list if doesn't already exist.
Also handles the "Mature / Bloody naming convention. Call this to update the name."
*/
/mob/living/carbon/xenomorph/larva/generate_name()
	if(!nicknumber)
		generate_and_set_nicknumber()

	var/progress = "" //Naming convention, three different names
	var/name_prefix = "" // Prefix for hive

	if(hive)
		name_prefix = hive.prefix
		color = hive.color

	if(larva_state == LARVA_STATE_MATURE)
		progress = "Mature "
	else if(larva_state == LARVA_STATE_BLOODY)
		progress = "Bloody "

	name = "[name_prefix][progress]Larva ([nicknumber])"

	//Update linked data so they show up properly
	change_real_name(src, name)
	//Update the hive status UI
	if(hive)
		var/datum/hive_status/hive_status = hive
		hive_status.hive_ui.update_xeno_info()
