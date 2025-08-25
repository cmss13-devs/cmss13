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
CLIENT_VERB(delete_key_pressed)
	set hidden = TRUE

	if(!usr.pulling)
		to_chat(usr, SPAN_NOTICE("You are not pulling anything."))
		return
	usr.stop_pulling()

CLIENT_VERB(swap_hand)
	set name = ".SwapMobHand"
	set hidden = TRUE

	if(istype(mob, /mob/living/carbon))
		mob.swap_hand()
	return



CLIENT_VERB(attack_self)
	set hidden = TRUE
	if(mob)
		mob.mode()
	return

CLIENT_VERB(drop_item)
	set hidden = TRUE
	mob.drop_item_v()
	return


/client/Center()
	return


/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)
				return
			mob.control_object.setDir(direct)
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))
	return

/client/proc/recalculate_move_delay()
	move_delay = mob.movement_delay()
	mob.next_delay_update = world.time + mob.next_delay_delay

/client/Move(n, direct)
	var/mob/living/living_mob
	if(isliving(mob))
		living_mob = mob

	if(ishuman(living_mob)) // Might as well just do it here than set movement delay to 0
		var/mob/living/carbon/human/human = living_mob
		if(HAS_TRAIT(human, TRAIT_HAULED))
			human.handle_haul_resist()
			return

	if(world.time < next_movement)
		return
	if(living_mob && living_mob.body_position == LYING_DOWN && mob.crawling)
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

	if(!isliving(mob))
		return mob.Move(n, direct)

	if(mob.is_mob_incapacitated(TRUE))
		return

	if(mob.buckled)
		// Handle buckled relay before mobility because buckling inherently immobilizes
		// This means you can (try to) move with a cargo tug or powerloader while immobilized, which i think makes sense
		return mob.buckled.relaymove(mob, direct)

	if(!(living_mob.mobility_flags & MOBILITY_MOVE))
		return
	if(living_mob.body_position == LYING_DOWN && !living_mob.can_crawl)
		return
	if(living_mob.body_position == LYING_DOWN && isxeno(mob.pulledby))
		next_movement = world.time + 20 //Good Idea
		to_chat(src, SPAN_NOTICE("You cannot crawl while a xeno is grabbing you."))
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

		mob.cur_speed = clamp(10/(move_delay + 0.5), MIN_SPEED, MAX_SPEED)
		next_movement = world.time + MINIMAL_MOVEMENT_INTERVAL // We pre-set this now for the crawling case. If crawling do_after fails, next_movement would be set after the attempt end instead of now.

		//Try to crawl first
		if(living_mob && living_mob.body_position == LYING_DOWN)
			if(mob.crawling)
				return // Already doing it.
			//check for them not being a limbless blob (only humans have limbs)
			if(ishuman(mob))
				var/mob/living/carbon/human/human = mob
				var/list/extremities = list("l_hand", "r_hand", "l_foot", "r_foot", "l_arm", "r_arm", "l_leg", "r_leg")
				for(var/zone in extremities)
					if(!(human.get_limb(zone)))
						extremities.Remove(zone)
				if(length(extremities) < 4)
					return
			//now crawl
			mob.crawling = TRUE
			if(!do_after(mob, 1 SECONDS, INTERRUPT_MOVED|INTERRUPT_UNCONSCIOUS|INTERRUPT_STUNNED|INTERRUPT_RESIST|INTERRUPT_CHANGED_LYING, NO_BUSY_ICON))
				mob.crawling = FALSE
				return
			if(!mob.crawling)
				return // Crawling interrupted by a "real" move. Do nothing. In theory INTERRUPT_MOVED|INTERRUPT_CHANGED_LYING catches this in do_after.
		mob.crawling = FALSE
		mob.move_intentionally = TRUE
		moving = TRUE
		if(mob.confused)
			mob.Move(get_step(mob, pick(GLOB.cardinals)))
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
/mob/proc/Process_Spacemove(check_drift = 0)

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
			if((istype(turf,/turf/open/floor)) && !(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.flags_inventory & NOSLIPPING)))
				continue


		else
			if(istype(turf,/turf/open/floor)) // No one else gets a chance.
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


/mob/proc/Process_Spaceslipping(prob_slip = 5)
	//Setup slipage
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.
	if(stat)
		prob_slip = 0  // Changing this to zero to make it line up with the comment.

	prob_slip = floor(prob_slip)
	return(prob_slip)
