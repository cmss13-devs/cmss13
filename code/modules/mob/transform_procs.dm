/mob/living/carbon/human/proc/monkeyize()
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		if (W==w_uniform) // will be torn
			continue
		drop_inv_item_on_ground(W)
	regenerate_icons()
	monkeyizing = 1
	anchored = TRUE
	ADD_TRAIT(src, TRAIT_INCAPACITATED, "Terminal Monkeyziation")
	icon = null
	invisibility = 101
	for(var/t in limbs)
		qdel(t)
	var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	//animation = null

	if(!species.primitive) //If the creature in question has no primitive set, this is going to be messy.
		gib()
		return

	var/mob/living/carbon/human/monkey/O = null

	O = new species.primitive(loc)

	O.forceMove(loc)
	O.viruses = viruses
	O.a_intent = INTENT_HARM

	for(var/datum/disease/D in O.viruses)
		D.affected_mob = O

	O.med_hud_set_status()

	if (client)
		client.mob = O
	if(mind)
		mind.transfer_to(O)

	to_chat(O, "<B>You are now [O]. </B>")

	qdel(src)
	qdel(animation)

	return O

//human -> alien
/mob/living/carbon/human/proc/Alienize(list/types)
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_inv_item_on_ground(W)
	regenerate_icons()
	monkeyizing = 1
	ADD_TRAIT(src, TRAIT_INCAPACITATED, "Terminal Monkeyziation")
	icon = null
	invisibility = 101
	for(var/t in limbs)
		qdel(t)

	var/mob/living/carbon/xenomorph/new_xeno
	if(!types)
		new_xeno = new /mob/living/carbon/xenomorph/larva(loc)
	else
		var/type = pick(types)
		switch(type)
			if(XENO_CASTE_RUNNER)
				new_xeno = new /mob/living/carbon/xenomorph/runner(loc)
			if(XENO_CASTE_DRONE)
				new_xeno = new /mob/living/carbon/xenomorph/drone(loc)
			if(XENO_CASTE_SENTINEL)
				new_xeno = new /mob/living/carbon/xenomorph/sentinel(loc)
			if(XENO_CASTE_DEFENDER)
				new_xeno = new /mob/living/carbon/xenomorph/defender(loc)
			if(XENO_CASTE_LURKER)
				new_xeno = new /mob/living/carbon/xenomorph/lurker(loc)
			if(XENO_CASTE_WARRIOR)
				new_xeno = new /mob/living/carbon/xenomorph/warrior(loc)
			if(XENO_CASTE_BURROWER)
				new_xeno = new /mob/living/carbon/xenomorph/burrower(loc)
			if(XENO_CASTE_CARRIER)
				new_xeno = new /mob/living/carbon/xenomorph/carrier(loc)
			if(XENO_CASTE_SPITTER)
				new_xeno = new /mob/living/carbon/xenomorph/spitter(loc)
			if(XENO_CASTE_HIVELORD)
				new_xeno = new /mob/living/carbon/xenomorph/hivelord(loc)
			if(XENO_CASTE_RAVAGER)
				new_xeno = new /mob/living/carbon/xenomorph/ravager(loc)
			if(XENO_CASTE_BOILER)
				new_xeno = new /mob/living/carbon/xenomorph/boiler(loc)
			if(XENO_CASTE_CRUSHER)
				new_xeno = new /mob/living/carbon/xenomorph/crusher(loc)
			if(XENO_CASTE_PRAETORIAN)
				new_xeno = new /mob/living/carbon/xenomorph/praetorian(loc)
			if(XENO_CASTE_QUEEN)
				new_xeno = new /mob/living/carbon/xenomorph/queen(loc)
			if(XENO_CASTE_HELLHOUND)
				new_xeno = new /mob/living/carbon/xenomorph/hellhound(loc)
			else
				new_xeno = new /mob/living/carbon/xenomorph/drone(loc)

	new_xeno.a_intent = INTENT_HARM
	new_xeno.key = key
	if(new_xeno.client) new_xeno.client.change_view(GLOB.world_view_size)

	to_chat(new_xeno, "<B>You are now an alien.</B>")
	qdel(src)
	return

/mob/living/carbon/human/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = tgui_input_list(usr, "Which type of mob should [src] turn into?", "Choose a type", mobtypes)

	if(!safe_animal(mobpath))
		to_chat(usr, SPAN_DANGER("Sorry but this mob type is currently unavailable."))
		return

	if(monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_inv_item_on_ground(W)

	regenerate_icons()
	monkeyizing = 1
	ADD_TRAIT(src, TRAIT_INCAPACITATED, "Terminal Monkeyziation")
	icon = null
	invisibility = 101

	for(var/t in limbs)
		qdel(t)

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	if(new_mob.client) new_mob.client.change_view(GLOB.world_view_size)
	new_mob.a_intent = INTENT_HARM


	to_chat(new_mob, "You suddenly feel more... animalistic.")
	QDEL_IN(src, 1)
	return

/mob/proc/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = tgui_input_list(usr, "Which type of mob should [src] turn into?", "Choose a type", mobtypes)

	if(!safe_animal(mobpath))
		to_chat(usr, SPAN_DANGER("Sorry but this mob type is currently unavailable."))
		return

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	if(new_mob.client) new_mob.client.change_view(GLOB.world_view_size)
	new_mob.a_intent = INTENT_HARM
	to_chat(new_mob, "You feel more... animalistic")

	qdel(src)

/* Certain mob types have problems and should not be allowed to be controlled by players.
 *
 * This proc is here to force coders to manually place their mob in this list, hopefully tested.
 * This also gives a place to explain -why- players shouldnt be turn into certain mobs and hopefully someone can fix them.
 */
/mob/proc/safe_animal(MP)

//Bad mobs! - Remember to add a comment explaining what's wrong with the mob
	if(!MP)
		return 0 //Sanity, this should never happen.

//Good mobs!
	if(ispath(MP, /mob/living/simple_animal/cat))
		return 1
	if(ispath(MP, /mob/living/simple_animal/corgi))
		return 1
	if(ispath(MP, /mob/living/simple_animal/crab))
		return 1
	if(ispath(MP, /mob/living/simple_animal/hostile/carp))
		return 1
	if(ispath(MP, /mob/living/simple_animal/tomato))
		return 1
	if(ispath(MP, /mob/living/simple_animal/mouse))
		return 1 //It is impossible to pull up the player panel for mice (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple_animal/hostile/bear))
		return 1 //Bears will auto-attack mobs, even if they're player controlled (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple_animal/parrot))
		return 1 //Parrots are no longer unfinished! -Nodrak

	//Not in here? Must be untested!
	return 0


/mob/living/carbon/proc/WeaveClaim(cause = CAUSE_ADMIN)
	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_WEAVE]

	var/truecause = "Unknown Means"
	var/traitsource = TRAIT_SOURCE_ADMIN
	switch(cause)
		if(CAUSE_ADMIN)
			truecause = "Divine Intervention"
		if(CAUSE_ESSENCE)
			truecause = "Essence Exposure"
			traitsource = TRAIT_SOURCE_ABILITY("WeaveExposure")
		if(CAUSE_WEAVER)
			truecause = "The Prime Weaver"
			traitsource = TRAIT_SOURCE_ABILITY("WeaveBlessing")

	if(!istype(hive))
		message_admins("[truecause] attempted to make [key_name(src)] a Weave cultist, but The Weave doesn't exist!")
		return FALSE

	if(client)
		playsound_client(client, 'sound/effects/xeno_newlarva.ogg', null, 25)
	setBrainLoss(0)
	KnockOut(5)
	make_jittery(105)

	to_chat(src, SPAN_XENODANGER("You have been enlightened by [truecause]!"))
	xeno_message("[src] has been claimed by The Weave!", 2, XENO_HIVE_WEAVE)
	ADD_TRAIT(src, TRAIT_WEAVE_SENSITIVE, traitsource)
	return TRUE

/mob/living/carbon/xenomorph/WeaveClaim(cause = CAUSE_ADMIN)
	..()

	var/mob/living/carbon/xenomorph/weaveling/new_xeno = new(get_turf(src), src)

	// subtract the threshold, keep the stored amount
	evolution_stored -= evolution_threshold
	var/obj/item/organ/xeno/organ = locate() in src
	if(!isnull(organ))
		qdel(organ)
	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(usr, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		stack_trace("Xeno evolution failed: [src] attempted to evolve into \'[WEAVE_CASTE_WEAVELING]\'")
		if(new_xeno)
			qdel(new_xeno)
		return
	var/area/xeno_area = get_area(new_xeno)
	if(!should_block_game_interaction(new_xeno) || (xeno_area.flags_atom & AREA_ALLOW_XENO_JOIN))
		switch(new_xeno.tier) //They have evolved, add them to the slot count IF they are in regular game space
			if(2)
				hive.tier_2_xenos |= new_xeno
			if(3)
				hive.tier_3_xenos |= new_xeno

	log_game("EVOLVE: [key_name(src)] was converted into [new_xeno].")
	set_hive_and_update(XENO_HIVE_WEAVE)
	if(mind)
		mind.transfer_to(new_xeno)
	else
		new_xeno.key = src.key
		if(new_xeno.client)
			new_xeno.client.change_view(GLOB.world_view_size)
	var/level_to_switch_to = get_vision_level()
	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()
	if(new_xeno.client)
		new_xeno.set_lighting_alpha(level_to_switch_to)
	if(new_xeno.health - getBruteLoss(src) - getFireLoss(src) > 0) //Cmon, don't kill the new one! Shouldnt be possible though
		new_xeno.bruteloss = src.bruteloss //Transfers the damage over.
		new_xeno.fireloss = src.fireloss //Transfers the damage over.
		new_xeno.updatehealth()

	if(plasma_max == 0)
		new_xeno.plasma_stored = new_xeno.plasma_max
	else
		new_xeno.plasma_stored = new_xeno.plasma_max*(plasma_stored/plasma_max) //preserve the ratio of plasma

	new_xeno.built_structures = built_structures.Copy()

	built_structures = null

	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_type] emerges from the husk of \the [src]."), \
	SPAN_XENODANGER("We emerge in a greater form from the husk of our old body. For The Weave!"))

	if(hive.living_xeno_queen && hive.living_xeno_queen.observed_xeno == src)
		hive.living_xeno_queen.overwatch(new_xeno)

	src.transfer_observers_to(new_xeno)

	qdel(src)
	new_xeno.xeno_jitter(25)
	new_xeno.set_hive_and_update(XENO_HIVE_WEAVE)

	if (new_xeno.client)
		new_xeno.client.mouse_pointer_icon = initial(new_xeno.client.mouse_pointer_icon)

	if(new_xeno.mind && GLOB.round_statistics)
		GLOB.round_statistics.track_new_participant(new_xeno.faction, -1) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.track_player(new_xeno)

/mob/living/carbon/human/WeaveClaim(cause = CAUSE_ADMIN)
	..()

	var/datum/equipment_preset/other/weave_cultist/WC = new()
	var/eyecolor = "#5adfe4"
	r_eyes = hex2num(copytext(eyecolor, 2, 4))
	g_eyes = hex2num(copytext(eyecolor, 4, 6))
	b_eyes = hex2num(copytext(eyecolor, 6, 8))
	update_body()
	WC.load_race(src, XENO_HIVE_WEAVE)
	WC.load_status(src)

	to_chat(src, SPAN_XENOHIGHDANGER("<hr>You are now a Weave Devotee!"))
	to_chat(src, SPAN_XENODANGER("Worship The Weave and listen to the Prime Weaver for orders. You are bound to peace and fanatic neutrality, however, you may defend yourself and The Weave if there is no alternative.<hr>"))

	allow_gun_usage = FALSE
