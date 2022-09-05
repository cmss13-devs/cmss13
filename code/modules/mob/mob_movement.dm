/client/North()
	..()


/client/South()
	..()


/client/West()
	..()


/client/East()
	..()


/client/Northeast()
	return


/client/Southeast()
	attack_self()
	return


/client/Southwest()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.toggle_throw_mode(THROW_MODE_NORMAL)
	return


/client/Northwest()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(!C.get_active_hand())
			to_chat(usr, SPAN_DANGER("You have nothing to drop in your hand."))
			return
		C.drop_held_item()
	else
		to_chat(usr, SPAN_DANGER("This mob type cannot drop items."))
	return

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		to_chat(usr, SPAN_NOTICE("You are not pulling anything."))
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set name = ".SwapMobHand"
	set hidden = 1

	if(istype(mob, /mob/living/carbon))
		mob.swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return

/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob))
		mob.drop_item_v()
	return


/client/Center()
	return


/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.setDir(direct)
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))
	return

/client/proc/recalculate_move_delay()
	move_delay = mob.movement_delay()
	mob.next_delay_update = world.time + mob.next_delay_delay

/client/Move(n, direct)
	if(world.time < next_movement || (mob.lying && mob.crawling))
		return

	next_move_dir_add = 0
	next_move_dir_sub = 0

	next_movement = world.time + world.tick_lag

	if(!direct)
		return FALSE

	if(mob.control_object)
		next_movement = world.time + MINIMAL_MOVEMENT_INTERVAL
		return Move_object(direct)

	if(mob.noclip)
		switch(direct)
			if(NORTH)
				mob.y++
			if(SOUTH)
				mob.y--
			if(EAST)
				mob.x++
			if(WEST)
				mob.x--
		next_movement = world.time + MINIMAL_MOVEMENT_INTERVAL
		return

	if(isobserver(mob)) //Ghosts are snowflakes unfortunately
		next_movement = world.time + move_delay
		return mob.Move(n, direct)

	if(SEND_SIGNAL(mob, COMSIG_CLIENT_MOB_MOVE, n, direct) & COMPONENT_OVERRIDE_MOVE)
		next_movement = world.time + MINIMAL_MOVEMENT_INTERVAL
		return

	if(!mob.canmove || mob.is_mob_incapacitated(TRUE) || (mob.lying && !mob.can_crawl))
		return

	//Check if you are being grabbed and if so attemps to break it
	if(mob.pulledby)
		if(mob.is_mob_restrained(0))
			next_movement = world.time + 20 //to reduce the spam
			to_chat(src, SPAN_WARNING("You're restrained! You can't move!"))
			return
		else if(!mob.resist_grab(TRUE))
			return

	if(SEND_SIGNAL(mob, COMSIG_MOB_MOVE_OR_LOOK, TRUE, direct, direct) & COMPONENT_OVERRIDE_MOB_MOVE_OR_LOOK)
		next_movement = world.time + MINIMAL_MOVEMENT_INTERVAL
		return

	if(mob.buckled)
		return mob.buckled.relaymove(mob, direct)

	if(!mob.z)//Inside an object, tell it we moved
		var/atom/O = mob.loc
		if(!O)
			return
		return O.relaymove(mob, direct)
	else
		move_delay = mob.move_delay
		if(mob.recalculate_move_delay)// && mob.next_delay_update <= world.time)
			recalculate_move_delay()
		if(mob.next_move_slowdown)
			move_delay += mob.next_move_slowdown
			mob.next_move_slowdown = 0
		if((mob.flags_atom & DIRLOCK) && mob.dir != direct)
			move_delay += MOVE_REDUCTION_DIRECTION_LOCKED // by Geeves

		mob.last_move_intent = world.time + 10
		mob.cur_speed = Clamp(10/(move_delay + 0.5), MIN_SPEED, MAX_SPEED)
		//We are now going to move
		moving = TRUE
		mob.move_intentionally = TRUE
		if(mob.lying)
			//check for them not being a limbless blob (only humans have limbs)
			if(ishuman(mob))
				var/mob/living/carbon/human/human = mob
				var/list/extremities = list("l_hand", "r_hand", "l_foot", "r_foot", "l_arm", "r_arm", "l_leg", "r_leg")
				for(var/zone in extremities)
					if(!(human.get_limb(zone)))
						extremities.Remove(zone)
				if(extremities.len < 4)
					next_movement = world.time + MINIMAL_MOVEMENT_INTERVAL
					mob.move_intentionally = FALSE
					moving = FALSE
					return
			//now crawl
			mob.crawling = TRUE
			if(!do_after(mob, 3 SECONDS, INTERRUPT_MOVED|INTERRUPT_UNCONSCIOUS|INTERRUPT_STUNNED|INTERRUPT_RESIST|INTERRUPT_CHANGED_LYING, BUSY_ICON_GENERIC))
				mob.crawling = FALSE
				next_movement = world.time + MINIMAL_MOVEMENT_INTERVAL
				mob.move_intentionally = FALSE
				moving = FALSE
				return
		mob.crawling = FALSE
		if(mob.confused)
			mob.Move(get_step(mob, pick(cardinal)))
		else
			. = ..()

			if (mob.tile_contents)
				mob.tile_contents = list()
		if(.)
			mob.track_steps_walked()
			mob.life_steps_total++
			if(mob.clone != null)
				mob.update_clone()
		mob.move_intentionally = FALSE
		moving = FALSE
		next_movement = world.time + move_delay
	return

///Process_Spacemove
///Called by /client/Move()
///For moving in space
///Return 1 for movement 0 for none
/mob/proc/Process_Spacemove(var/check_drift = 0)

	if(!Check_Dense_Object()) //Nothing to push off of so end here
		make_floating(1)
		return 0

	if(istype(src,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = src
		if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.flags_inventory & NOSLIPPING))  //magboots + dense_object = no floaty effect
			make_floating(0)
		else
			make_floating(1)
	else
		make_floating(1)

	if(is_mob_restrained()) //Check to see if we can do things
		return 0

	//Check to see if we slipped
	if(prob(Process_Spaceslipping(5)))
		to_chat(src, SPAN_NOTICE(" <B>You slipped!</B>"))
		src.inertia_dir = src.last_move_dir
		step(src, src.inertia_dir)
		return 0
	//If not then we can reset inertia and move
	inertia_dir = 0
	return 1

/mob/proc/Check_Dense_Object() //checks for anything to push off in the vicinity. also handles magboots on gravity-less floors tiles

	var/dense_object = 0
	for(var/turf/turf in oview(1,src))
		if(istype(turf,/turf/open/space))
			continue

		if(istype(src,/mob/living/carbon/human/))  // Only humans can wear magboots, so we give them a chance to.
			var/mob/living/carbon/human/H = src
			if((istype(turf,/turf/open/floor)) && (src.lastarea.has_gravity == 0) && !(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.flags_inventory & NOSLIPPING)))
				continue


		else
			if((istype(turf,/turf/open/floor)) && (src.lastarea && src.lastarea.has_gravity == 0)) // No one else gets a chance.
				continue



		/*
		if(istype(turf,/turf/open/floor) && (src.flags & NOGRAV))
			continue
		*/


		dense_object++
		break

	if(!dense_object && (locate(/obj/structure/lattice) in oview(1, src)))
		dense_object++

	//Lastly attempt to locate any dense objects we could push off of
	//TODO: If we implement objects drifing in space this needs to really push them
	//Due to a few issues only anchored and dense objects will now work.
	if(!dense_object)
		for(var/obj/O in oview(1, src))
			if((O) && (O.density) && (O.anchored))
				dense_object++
				break

	return dense_object


/mob/proc/Process_Spaceslipping(var/prob_slip = 5)
	//Setup slipage
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.
	if(stat)
		prob_slip = 0  // Changing this to zero to make it line up with the comment.

	prob_slip = round(prob_slip)
	return(prob_slip)
