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
	if(new_xeno.client)
		new_xeno.client.change_view(GLOB.world_view_size)

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
	if(new_mob.client)
		new_mob.client.change_view(GLOB.world_view_size)
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
	if(new_mob.client)
		new_mob.client.change_view(GLOB.world_view_size)
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
