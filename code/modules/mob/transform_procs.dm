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

	O.loc = loc
	O.viruses = viruses
	O.a_intent = "hurt"

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
	if(client)
		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // stop the jams for AIs
	var/mob/living/silicon/ai/O = new (loc,,1)//No MMI but safety is in effect.
	O.invisibility = 0
	O.aiRestorePowerRoutine = 0

	if(mind)
		mind.transfer_to(O)
		O.mind.original = O
	else
		O.key = key
		if(O.client) O.client.change_view(world_view_size)

	var/obj/loc_landmark
	for(var/obj/effect/landmark/start/sloc in landmarks_list)
		if (sloc.name == "AI")
			loc_landmark = sloc
	if(loc_landmark && loc_landmark.loc)
		O.loc = loc_landmark.loc
		for (var/obj/item/device/radio/intercom/comm in O.loc)
			comm.ai += O

		to_chat(O, "<B>You are playing the ship's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
		to_chat(O, "<B>To look at other parts of the station, click on yourself to get a camera menu.</B>")
		to_chat(O, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
		to_chat(O, "To use something, simply click on it.")
		O << {"Use :6 to speak to your cyborgs through binary."}
		O.show_laws()
		to_chat(O, "<b>These laws may be changed by other players, or by you being the traitor.</b>")

		O.add_ai_verbs()
		O.job = "AI"

		O.rename_self("ai",1)
		. = O
		qdel(src)


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

	O.loc = loc
	O.job = "Cyborg"
	if(O.job == "Cyborg")
		O.mmi = new /obj/item/device/mmi(O)

		if(O.mmi)
			O.mmi.transfer_identity(src)

	callHook("borgify", list(O))

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
			if("Runner")
				new_xeno = new /mob/living/carbon/Xenomorph/Runner(loc)
			if("Drone")
				new_xeno = new /mob/living/carbon/Xenomorph/Drone(loc)
			if("Sentinel")
				new_xeno = new /mob/living/carbon/Xenomorph/Sentinel(loc)
			if("Defender")
				new_xeno = new /mob/living/carbon/Xenomorph/Defender(loc)
			if("Lurker")
				new_xeno = new /mob/living/carbon/Xenomorph/Lurker(loc)
			if("Warrior")
				new_xeno = new /mob/living/carbon/Xenomorph/Warrior(loc)
			if("Burrower")
				new_xeno = new /mob/living/carbon/Xenomorph/Burrower(loc)
			if("Carrier")
				new_xeno = new /mob/living/carbon/Xenomorph/Carrier(loc)
			if("Spitter")
				new_xeno = new /mob/living/carbon/Xenomorph/Spitter(loc)
			if("Hivelord")
				new_xeno = new /mob/living/carbon/Xenomorph/Hivelord(loc)
			if("Ravager")
				new_xeno = new /mob/living/carbon/Xenomorph/Ravager(loc)
			if("Boiler")
				new_xeno = new /mob/living/carbon/Xenomorph/Boiler(loc)
			if("Crusher")
				new_xeno = new /mob/living/carbon/Xenomorph/Crusher(loc)
			if("Praetorian")
				new_xeno = new /mob/living/carbon/Xenomorph/Praetorian(loc)
			if("Queen")
				new_xeno = new /mob/living/carbon/Xenomorph/Queen(loc)
			else
				new_xeno = new /mob/living/carbon/Xenomorph/Drone(loc)

	new_xeno.a_intent = "hurt"
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
	new_corgi.a_intent = "hurt"
	new_corgi.key = key
	if(new_corgi.client) new_corgi.client.change_view(world_view_size)

	to_chat(new_corgi, "<B>You are now a Corgi. Yap Yap!</B>")
	qdel(src)
	return

/mob/living/carbon/human/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in mobtypes

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
	new_mob.a_intent = "hurt"


	to_chat(new_mob, "You suddenly feel more... animalistic.")
	QDEL_IN(src, 1)
	return

/mob/proc/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in mobtypes

	if(!safe_animal(mobpath))
		to_chat(usr, SPAN_DANGER("Sorry but this mob type is currently unavailable."))
		return

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	if(new_mob.client) new_mob.client.change_view(world_view_size)
	new_mob.a_intent = "hurt"
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

	if(ispath(MP, /mob/living/simple_animal/space_worm))
		return 0 //Unfinished. Very buggy, they seem to just spawn additional space worms everywhere and eating your own tail results in new worms spawning.

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
