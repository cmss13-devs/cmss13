/mob/living/carbon/human/proc/monkeyize()
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		if (W==w_uniform) // will be torn
			continue
		drop_inv_item_on_ground(W)
	regenerate_icons()
	monkeyizing = 1
	canmove = 0
	stunned = 1
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

/mob/new_player/AIize()
	spawning = TRUE
	return ..()

/mob/living/carbon/human/AIize()
	if (monkeyizing)
		return
	for(var/t in limbs)
		qdel(t)

	return ..()

/mob/living/carbon/AIize()
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_inv_item_on_ground(W)
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	return ..()

/mob/proc/AIize()
	return // this was unmaintained


//human -> robot
/mob/living/carbon/human/proc/Robotize()
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_inv_item_on_ground(W)
	regenerate_icons()
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in limbs)
		qdel(t)

	var/mob/living/silicon/robot/O = new /mob/living/silicon/robot( loc )

	// cyborgs produced by Robotize get an automatic power cell
	O.cell = new(O)
	O.cell.maxcharge = 7500
	O.cell.charge = 7500


	O.gender = gender
	O.invisibility = 0

	if(mind)		//TODO
		mind.transfer_to(O)
		if(O.job == "Cyborg")
			O.mind.original = O
	else
		O.key = key
		if(O.client) O.client.change_view(world_view_size)

	O.forceMove(loc)
	O.job = "Cyborg"
	if(O.job == "Cyborg")
		O.mmi = new /obj/item/device/mmi(O)

		if(O.mmi)
			O.mmi.transfer_identity(src)

	O.Namepick()

	qdel(src)
	return O

//human -> alien
/mob/living/carbon/human/proc/Alienize(var/list/types)
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_inv_item_on_ground(W)
	regenerate_icons()
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in limbs)
		qdel(t)

	var/mob/living/carbon/Xenomorph/new_xeno
	if(!types)
		new_xeno = new /mob/living/carbon/Xenomorph/Larva(loc)
	else
		var/type = pick(types)
		switch(type)
			if(XENO_CASTE_RUNNER)
				new_xeno = new /mob/living/carbon/Xenomorph/Runner(loc)
			if(XENO_CASTE_DRONE)
				new_xeno = new /mob/living/carbon/Xenomorph/Drone(loc)
			if(XENO_CASTE_SENTINEL)
				new_xeno = new /mob/living/carbon/Xenomorph/Sentinel(loc)
			if(XENO_CASTE_DEFENDER)
				new_xeno = new /mob/living/carbon/Xenomorph/Defender(loc)
			if(XENO_CASTE_LURKER)
				new_xeno = new /mob/living/carbon/Xenomorph/Lurker(loc)
			if(XENO_CASTE_WARRIOR)
				new_xeno = new /mob/living/carbon/Xenomorph/Warrior(loc)
			if(XENO_CASTE_BURROWER)
				new_xeno = new /mob/living/carbon/Xenomorph/Burrower(loc)
			if(XENO_CASTE_CARRIER)
				new_xeno = new /mob/living/carbon/Xenomorph/Carrier(loc)
			if(XENO_CASTE_SPITTER)
				new_xeno = new /mob/living/carbon/Xenomorph/Spitter(loc)
			if(XENO_CASTE_HIVELORD)
				new_xeno = new /mob/living/carbon/Xenomorph/Hivelord(loc)
			if(XENO_CASTE_RAVAGER)
				new_xeno = new /mob/living/carbon/Xenomorph/Ravager(loc)
			if(XENO_CASTE_BOILER)
				new_xeno = new /mob/living/carbon/Xenomorph/Boiler(loc)
			if(XENO_CASTE_CRUSHER)
				new_xeno = new /mob/living/carbon/Xenomorph/Crusher(loc)
			if(XENO_CASTE_PRAETORIAN)
				new_xeno = new /mob/living/carbon/Xenomorph/Praetorian(loc)
			if(XENO_CASTE_QUEEN)
				new_xeno = new /mob/living/carbon/Xenomorph/Queen(loc)
			else
				new_xeno = new /mob/living/carbon/Xenomorph/Drone(loc)

	new_xeno.a_intent = INTENT_HARM
	new_xeno.key = key
	if(new_xeno.client) new_xeno.client.change_view(world_view_size)

	to_chat(new_xeno, "<B>You are now an alien.</B>")
	qdel(src)
	return

/mob/living/carbon/human/proc/corgize()
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_inv_item_on_ground(W)
	regenerate_icons()
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in limbs)	//this really should not be necessary
		qdel(t)

	var/mob/living/simple_animal/corgi/new_corgi = new /mob/living/simple_animal/corgi (loc)
	new_corgi.a_intent = INTENT_HARM
	new_corgi.key = key
	if(new_corgi.client) new_corgi.client.change_view(world_view_size)

	to_chat(new_corgi, "<B>You are now a Corgi. Yap Yap!</B>")
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
	canmove = 0
	icon = null
	invisibility = 101

	for(var/t in limbs)
		qdel(t)

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	if(new_mob.client) new_mob.client.change_view(world_view_size)
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
	if(new_mob.client) new_mob.client.change_view(world_view_size)
	new_mob.a_intent = INTENT_HARM
	to_chat(new_mob, "You feel more... animalistic")

	qdel(src)

/* Certain mob types have problems and should not be allowed to be controlled by players.
 *
 * This proc is here to force coders to manually place their mob in this list, hopefully tested.
 * This also gives a place to explain -why- players shouldnt be turn into certain mobs and hopefully someone can fix them.
 */
/mob/proc/safe_animal(var/MP)

//Bad mobs! - Remember to add a comment explaining what's wrong with the mob
	if(!MP)
		return 0	//Sanity, this should never happen.

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
