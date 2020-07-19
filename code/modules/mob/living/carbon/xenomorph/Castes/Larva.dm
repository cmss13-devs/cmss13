/datum/caste_datum/larva
	caste_name = "Bloody Larva"
	tier = 0
	plasma_gain = 0.1
	plasma_max = 10
	melee_damage_lower = 0
	melee_damage_upper = 0
	max_health = XENO_HEALTH_LARVA
	caste_desc = "D'awwwww, so cute!"
	speed = XENO_SPEED_TIER_10
	innate_healing = TRUE //heals even outside weeds so you're not stuck unable to evolve when hiding on the ship wounded.
	evolves_to = list("Drone", "Runner", "Sentinel", "Defender") //Add sentinel etc here

/datum/caste_datum/larva/predalien
	caste_name = "Predalien Larva"
	evolves_to = list("Predalien")

/mob/living/carbon/Xenomorph/Larva
	name = "Bloody Larva"
	icon = 'icons/mob/xenos/larva.dmi'
	caste_name = "Bloody Larva"
	speak_emote = list("hisses")
	icon_state = "Bloody Larva"
	icon_size = 32
	layer = MOB_LAYER
	amount_grown = 0
	max_grown = 60
	see_in_dark = 8
	flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
	flags_can_pass_all = PASS_ALL & ~PASS_OVER_THROW_ITEM
	away_timer = 300
	tier = 0  //Larva's don't count towards Pop limits
	age = -1
	crit_health = -25
	gib_chance = 25
	mob_size = 0
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/xenohide,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl
		)
	mutation_type = "Normal"

/mob/living/carbon/Xenomorph/Larva/Corrupted
	hivenumber = XENO_HIVE_CORRUPTED

/mob/living/carbon/Xenomorph/Larva/Alpha
	hivenumber = XENO_HIVE_ALPHA

/mob/living/carbon/Xenomorph/Larva/Beta
	hivenumber = XENO_HIVE_BETA

/mob/living/carbon/Xenomorph/Larva/Zeta
	hivenumber = XENO_HIVE_ZETA


/mob/living/carbon/Xenomorph/Larva/predalien
	icon = 'icons/mob/xenos_old/1x1_Xenos.dmi'
	icon_state = "Predalien Larva"
	caste_name = "Predalien Larva"

/mob/living/carbon/Xenomorph/Larva/UnarmedAttack(atom/A)
	a_intent = "help" //Forces help intent for all interactions.
	. = ..()

//Larva Progression.. Most of this stuff is obsolete.
/mob/living/carbon/Xenomorph/Larva/update_progression()
	var/progress_amount = 1

	if(hive)
		progress_amount += (0.2 * hive.has_special_structure(XENO_STRUCTURE_EVOPOD))

	if(amount_grown < max_grown)
		amount_grown = min(max_grown, amount_grown + progress_amount)

	if(amount_grown >= max_grown)	// to avoid spam
		if(age < 0)
			to_chat(src, SPAN_XENODANGER("Strength ripples through your small form. You are ready to be shaped to the Queen's will."))
			src << sound('sound/effects/xeno_evolveready.ogg')
			age++

//Larva code is just a mess, so let's get it over with
/mob/living/carbon/Xenomorph/Larva/update_icons()
	var/progress = "" //Naming convention, three different names
	var/state = "" //Icon convention, two different sprite sets

	var/name_prefix = ""

	if(hive)
		name_prefix = hive.prefix
		color = hive.color
	if(hivenumber == XENO_HIVE_CORRUPTED)
		add_language("English")

	if(amount_grown < max_grown/2) //We're still bloody
		progress = "Bloody "
		state = "Bloody "
	if(amount_grown >= max_grown/2)
		progress = ""
		state = ""
	if(amount_grown >= max_grown)
		progress = "Mature "

	name = "\improper [name_prefix][progress]Larva ([nicknumber])"

	if(istype(src,/mob/living/carbon/Xenomorph/Larva/predalien)) state = "Predalien " //Sort of a hack.

	//Update linked data so they show up properly
	change_real_name(src, name)

	if(stat == DEAD)
		icon_state = "[state]Larva Dead"
	else if(handcuffed || legcuffed)
		icon_state = "[state]Larva Cuff"

	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[state]Larva Sleeping"
		else
			icon_state = "[state]Larva Stunned"
	else
		icon_state = "[state]Larva"

/mob/living/carbon/Xenomorph/Larva/start_pulling(atom/movable/AM)
	return

/mob/living/carbon/Xenomorph/Larva/pull_response(mob/puller)
	return TRUE

/proc/spawn_hivenumber_larva(var/atom/A, var/hivenumber)
	if(!hive_datum[hivenumber])
		return

	var/mob/living/carbon/Xenomorph/Larva/L = new /mob/living/carbon/Xenomorph/Larva(A)

	L.set_hive_and_update(hivenumber, hive_datum[hivenumber].name)

	return L
			