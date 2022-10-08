/datum/caste_datum/facehugger
	caste_type = XENO_CASTE_FACEHUGGER
	tier = 0
	plasma_gain = 0.1
	plasma_max = 10
	melee_damage_lower = 5
	melee_damage_upper = 5
	max_health = XENO_HEALTH_LARVA
	caste_desc = "Ewwww, that's disgusting!"
	speed = XENO_SPEED_TIER_8

	evolution_allowed = FALSE
	can_be_revived = FALSE

/mob/living/carbon/Xenomorph/Facehugger
	name = XENO_CASTE_FACEHUGGER
	caste_type = XENO_CASTE_FACEHUGGER
	speak_emote = list("hisses")
	icon_state = "Facehugger"
	icon_size = 32
	layer = MOB_LAYER
	mob_flags = NOBIOSCAN
	see_in_dark = 8
	tier = 0  //Facehuggers don't count towards Pop limits
	acid_blood_damage = 5
	crit_health = 0
	crit_grace_time = 0
	gib_chance = 75
	mob_size = 0
	death_fontsize = 2
	life_value = 0
	default_honor_value = 0
	show_only_numbers = TRUE
	counts_for_slots = FALSE
	counts_for_roundend = FALSE
	refunds_larva_if_banished = FALSE
	shaman_interactive = FALSE
	can_hivemind_speak = FALSE
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/activable/pounce/facehugger
	)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl
	)
	mutation_type = "Normal"

	icon_xenonid = 'icons/mob/xenonids/xenonid_crab.dmi'

/mob/living/carbon/Xenomorph/Facehugger/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	icon_xeno = get_icon_from_source(CONFIG_GET(string/alien_hugger))
	return ..()

/mob/living/carbon/Xenomorph/Facehugger/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		PF.flags_can_pass_all = PASS_ALL^PASS_OVER_THROW_ITEM

/mob/living/carbon/Xenomorph/Facehugger/Life(delta_time)
	if(stat != DEAD && !lying)
		adjustBruteLoss(1)
	return ..()

/mob/living/carbon/Xenomorph/Facehugger/update_icons()
	if(!caste)
		return

	if(stat == DEAD)
		icon_state = "[mutation_type] [caste.caste_type] Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[mutation_type] [caste.caste_type] Sleeping"
		else
			icon_state = "[mutation_type] [caste.caste_type] Knocked Down"
	else if(throwing)
		icon_state = "[mutation_type] [caste.caste_type] Thrown"
	else
		icon_state = "[mutation_type] [caste.caste_type] Running"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
	update_wounds()

/mob/living/carbon/Xenomorph/Facehugger/start_pulling(atom/movable/AM)
	return

/mob/living/carbon/Xenomorph/Facehugger/pull_response(mob/puller)
	return TRUE

/mob/living/carbon/Xenomorph/Facehugger/UnarmedAttack(atom/A, proximity, click_parameters, tile_attack)
	a_intent = INTENT_HELP //Forces help intent for all interactions.
	if(!caste)
		return FALSE

	if(lying) //No attacks while laying down
		return FALSE

	if(istype(A, /obj/effect/alien/resin/special/eggmorph))
		var/obj/effect/alien/resin/special/eggmorph/morpher = A
		if(time_of_birth + 3 SECONDS > world.time)
			return
		if(morpher.linked_hive.hivenumber != hivenumber)
			to_chat(src, SPAN_XENOWARNING("This isn't your hive's eggmorpher!"))
			return
		if(morpher.stored_huggers >= morpher.huggers_to_grow_max)
			to_chat(src, SPAN_XENOWARNING("\The [morpher] is already full of children."))
			return
		visible_message(SPAN_WARNING("\The [src] climbs back into \the [morpher]."), SPAN_XENONOTICE("You climb into \the [morpher]."))
		morpher.stored_huggers++
		qdel(src)
		return

	if(ishuman(A))
		var/mob/living/carbon/human/human = A
		if(!human.lying)
			to_chat(src, SPAN_WARNING("You can't reach \the [human], they need to be lying down."))
			return
		if(!can_hug(human, hivenumber))
			to_chat(src, SPAN_WARNING("You can't infect \the [human]..."))
			return
		visible_message(SPAN_WARNING("\The [src] starts climbing onto \the [human]'s face..."), SPAN_XENONOTICE("You start climbing onto \the [human]'s face..."))
		if(!do_after(src, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, human, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return
		if(!human.lying)
			to_chat(src, SPAN_WARNING("You can't reach \the [human], they need to be lying down."))
			return
		if(!can_hug(human, hivenumber))
			to_chat(src, SPAN_WARNING("You can't infect \the [human]..."))
			return
		handle_hug(human)
		return

	A.attack_larva(src)
	xeno_attack_delay(src) //Adds some lag to the 'attack'

/mob/living/carbon/Xenomorph/Facehugger/proc/handle_hug(var/mob/living/carbon/human/human)
	var/obj/item/clothing/mask/facehugger/hugger = new /obj/item/clothing/mask/facehugger(loc, hivenumber)
	var/did_hug = hugger.attach(human, TRUE, 0.5)
	if(client)
		client?.player_data?.adjust_stat(PLAYER_STAT_FACEHUGS, STAT_CATEGORY_XENO, 1)
	qdel(src)
	return did_hug

/mob/living/carbon/Xenomorph/Facehugger/age_xeno()
	if(stat == DEAD || !caste || QDELETED(src) || !client)
		return

	age = XENO_NORMAL

	var/total_facehugs = get_client_stat(client, PLAYER_STAT_FACEHUGS)
	switch(total_facehugs)
		if(FACEHUG_TIER_1 to FACEHUG_TIER_2)
			age = XENO_MATURE
		if(FACEHUG_TIER_2 to FACEHUG_TIER_3)
			age = XENO_ELDER
		if(FACEHUG_TIER_3 to FACEHUG_TIER_4)
			age = XENO_ANCIENT
		if(FACEHUG_TIER_4 to INFINITY)
			age = XENO_PRIME

	// For people who wish to remain anonymous
	if(!client.prefs.playtime_perks)
		age = XENO_NORMAL

	switch(age)
		if(XENO_NORMAL)
			age_prefix = "Young "
		if(XENO_MATURE)
			age_prefix = "Fledgling "
		if(XENO_ELDER)
			age_prefix = "Veteran "
		if(XENO_ANCIENT)
			age_prefix = "Baneful "
		if(XENO_PRIME)
			age_prefix = "Royal "

	hud_update() //update the age level insignia on our xeno hud.

	//One last shake for the sake of it
	xeno_jitter(25)

/mob/living/carbon/Xenomorph/Facehugger/handle_screech_act(var/mob/self, var/mob/living/carbon/Xenomorph/Queen/queen)
	return null

/mob/living/carbon/Xenomorph/Facehugger/handle_queen_screech(var/mob/living/carbon/Xenomorph/Queen/queen)
	to_chat(src, SPAN_DANGER("The mighty roar of the queen makes you tremble and fall over!"))
	AdjustStunned(6)
	KnockDown(6)

/mob/living/carbon/Xenomorph/Facehugger/add_xeno_shield(added_amount, shield_source, type = /datum/xeno_shield, duration = -1, decay_amount_per_second = 1, add_shield_on = FALSE, max_shield = 200)
	return
