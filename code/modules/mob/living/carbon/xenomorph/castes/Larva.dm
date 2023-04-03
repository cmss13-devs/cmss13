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
	name = XENO_CASTE_LARVA
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
	mob_size = 0
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/xenohide,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	mutation_type = "Normal"

	var/burrowable = TRUE //Can it be safely burrowed if it has no player?
	var/state_override

	icon_xeno = 'icons/mob/xenos/larva.dmi'
	icon_xenonid = 'icons/mob/xenonids/larva.dmi'

/mob/living/carbon/xenomorph/larva/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		PF.flags_can_pass_all = PASS_ALL^PASS_OVER_THROW_ITEM

/mob/living/carbon/xenomorph/larva/corrupted
	hivenumber = XENO_HIVE_CORRUPTED

/mob/living/carbon/xenomorph/larva/alpha
	hivenumber = XENO_HIVE_ALPHA

/mob/living/carbon/xenomorph/larva/bravo
	hivenumber = XENO_HIVE_BRAVO

/mob/living/carbon/xenomorph/larva/charlie
	hivenumber = XENO_HIVE_CHARLIE

/mob/living/carbon/xenomorph/larva/delta
	hivenumber = XENO_HIVE_DELTA

/mob/living/carbon/xenomorph/larva/mutated
	hivenumber = XENO_HIVE_MUTATED

/mob/living/carbon/xenomorph/larva/predalien
	icon_xeno = 'icons/mob/xenos/predalien_larva.dmi'
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
	to_chat(src, SPAN_XENODANGER("Strength ripples through your small form. You are ready to be shaped to the Queen's will. <a href='?src=\ref[src];evolve=1;'>Evolve</a>"))
	playsound_client(client, sound('sound/effects/xeno_evolveready.ogg'))

	var/datum/action/xeno_action/onclick/evolve/evolve_action = new()
	evolve_action.give_to(src)

//Larva code is just a mess, so let's get it over with
/mob/living/carbon/xenomorph/larva/update_icons()
	var/progress = "" //Naming convention, three different names
	var/state = "" //Icon convention, two different sprite sets

	var/name_prefix = ""

	if(hive)
		name_prefix = hive.prefix
		color = hive.color

	if(evolution_stored >= evolution_threshold)
		progress = "Mature "
	else if(evolution_stored < evolution_threshold / 2) //We're still bloody
		progress = "Bloody "
		state = "Bloody "
	else
		progress = ""

	name = "[name_prefix][progress]Larva ([nicknumber])"

	if(istype(src,/mob/living/carbon/xenomorph/larva/predalien)) state = "Predalien " //Sort of a hack.

	//Update linked data so they show up properly
	change_real_name(src, name)

	if(stat == DEAD)
		icon_state = "[state_override || state]Larva Dead"
	else if(handcuffed || legcuffed)
		icon_state = "[state_override || state]Larva Cuff"

	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[state_override || state]Larva Sleeping"
		else
			icon_state = "[state_override || state]Larva Stunned"
	else
		icon_state = "[state_override || state]Larva"

/mob/living/carbon/xenomorph/larva/handle_name()
	return

/mob/living/carbon/xenomorph/larva/start_pulling(atom/movable/AM)
	return

/mob/living/carbon/xenomorph/larva/pull_response(mob/puller)
	return TRUE

/mob/living/carbon/xenomorph/larva/UnarmedAttack(atom/A, proximity, click_parameters, tile_attack)
	a_intent = INTENT_HELP //Forces help intent for all interactions.
	if(!caste)
		return FALSE

	if(lying) //No attacks while laying down
		return FALSE

	A.attack_larva(src)
	xeno_attack_delay(src) //Adds some lag to the 'attack'

/proc/spawn_hivenumber_larva(atom/A, hivenumber)
	if(!GLOB.hive_datum[hivenumber] || isnull(A))
		return

	var/mob/living/carbon/xenomorph/larva/L = new /mob/living/carbon/xenomorph/larva(A)

	L.set_hive_and_update(hivenumber)

	return L

/mob/living/carbon/xenomorph/larva/emote(act, m_type, message, intentional, force_silence)
	playsound(loc, "alien_roar_larva", 15)

