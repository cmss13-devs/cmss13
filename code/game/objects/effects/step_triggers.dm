/* Simple object type, calls a proc when "stepped" on by something */

/obj/effect/step_trigger
	var/affect_ghosts = 0
	var/stopper = 1 // stops throwers
	invisibility = 101 // nope cant see this shit
	anchored = 1

/obj/effect/step_trigger/proc/Trigger(var/atom/movable/A)
	return 0

/obj/effect/step_trigger/Crossed(H as mob|obj)
	..()
	if(!H)
		return
	if(istype(H, /mob/dead/observer) && !affect_ghosts)
		return
	Trigger(H)



/* Tosses things in a certain direction */

/obj/effect/step_trigger/thrower
	var/direction = SOUTH // the direction of throw
	var/tiles = 3	// if 0: forever until atom hits a stopper
	var/immobilize = 1 // if nonzero: prevents mobs from moving while they're being flung
	var/speed = 1	// delay of movement
	var/facedir = 0 // if 1: atom faces the direction of movement
	var/nostop = 0 // if 1: will only be stopped by teleporters
	var/list/affecting = list()

/obj/effect/step_trigger/thrower/Trigger(var/atom/A)
	if(!A || !istype(A, /atom/movable))
		return

	if(!istype(A,/obj) && !istype(A,/mob)) //mobs and objects only.
		return
	if(istype(A,/obj/effect)) return

	var/atom/movable/AM = A
	var/curtiles = 0
	var/stopthrow = 0
	for(var/obj/effect/step_trigger/thrower/T in orange(2, src))
		if(AM in T.affecting)
			return

	if(ismob(AM))
		var/mob/M = AM
		if(immobilize)
			M.canmove = 0

	affecting.Add(AM)
	while(AM && !stopthrow)
		if(tiles)
			if(curtiles >= tiles)
				break
		if(AM.z != src.z)
			break

		curtiles++

		sleep(speed)

		// Calculate if we should stop the process
		if(!nostop)
			for(var/obj/effect/step_trigger/T in get_step(AM, direction))
				if(T.stopper && T != src)
					stopthrow = 1
		else
			for(var/obj/effect/step_trigger/teleporter/T in get_step(AM, direction))
				if(T.stopper)
					stopthrow = 1

		if(AM)
			var/predir = AM.dir
			step(AM, direction)
			if(!facedir)
				AM.dir = predir



	affecting.Remove(AM)

	if(ismob(AM))
		var/mob/M = AM
		if(immobilize)
			M.canmove = 1

/* Stops things thrown by a thrower, doesn't do anything */

/obj/effect/step_trigger/stopper

/* Deletes any clones related to the atom */

/obj/effect/step_trigger/clone_cleaner/Trigger(var/atom/movable/A)
	if(A.clone)
		A.destroy_clone()

/* Seamless vector teleporter - to be used with projectors */

/obj/effect/step_trigger/teleporter_vector
	var/vector_x = 0	//Teleportation vector
	var/vector_y = 0
	var/vector_z = 0
	affect_ghosts = 1

/obj/effect/step_trigger/teleporter_vector/Trigger(var/atom/movable/A)
	if(A && A.loc && A.type != /atom/movable/clone) //Prevent clones from teleporting
		var/lx = A.x
		var/ly = A.y
		var/target = locate(A.x + vector_x, A.y + vector_y, A.z)
		var/target_dir = get_dir(A, target)

		if(A.clone) //Clones have to be hard-synced both before and after the transition
			A.update_clone() //Update No. 1

		if(istype(A,/mob))
			var/mob/AM = A
			sleep(AM.movement_delay() + 0.4) //Make the transition as seamless as possible

		if(!Adjacent(A, locate(lx, ly, A.z))) //If the subject has moved too quickly, abort - this prevents double jumping
			return

		for(var/mob/M in target) //If the target location is obstructed, abort
			if(M.BlockedPassDirs(A, target_dir))
				return

		A.x += vector_x
		A.y += vector_y
		A.z += vector_z

		if(A.clone)
			A.clone.proj_x *= -1 //Swap places with the clone
			A.clone.proj_y *= -1
			A.update_clone() //Update No. 2


/* Instant teleporter */

/obj/effect/step_trigger/teleporter
	icon = 'icons/old_stuff/debug_group.dmi'
	icon_state = "red"
	var/teleport_x = 0	// teleportation coordinates (if one is null, then no teleport!)
	var/teleport_y = 0
	var/teleport_z = 0

/obj/effect/step_trigger/teleporter/Trigger(var/atom/movable/A, teleportation_type)
	set waitfor = 0

	if(!istype(A,/obj) && !istype(A,/mob)) //mobs and objects only.
		return

	if(istype(A,/obj/effect) || A.anchored)
		return
	var/mob/User = A
	var/mob/M
	if(isliving(User))
		M = User.pulling

	if(teleport_x && teleport_y && teleport_z)
		/* TODO: replace this -spookydonut
		switch(teleportation_type)
			if(1)
				sleep(animation_teleport_quick_out(A)) //Sleep for the duration of the animation.
			if(2)
				sleep(animation_teleport_magic_out(A))
			if(3)
				sleep(animation_teleport_spooky_out(A))*/

		if(A && A.loc)
			A.forceMove(locate(teleport_x,teleport_y,teleport_z))
		if(M && M.loc)
			M.forceMove(locate(teleport_x,teleport_y,teleport_z))
			/*
			switch(teleportation_type)
				if(1)
					animation_teleport_quick_in(A)
				if(2)
					animation_teleport_magic_in(A)
				if(3)
					animation_teleport_spooky_in(A)*/

/* Predator Ship Teleporter - set in each individual gamemode */

/obj/effect/step_trigger/teleporter/yautja_ship/Trigger(atom/movable/A)
	var/turf/destination
	if(length(GLOB.yautja_teleports))	//We have some possible locations.
		var/pick = tgui_input_list(usr, "Where do you want to go today?", "Locations", GLOB.yautja_teleport_descs)	//Pick one of them in the list.)
		destination = GLOB.yautja_teleport_descs[pick]
	if(!destination || (A.loc != loc))
		return
	teleport_x = destination.x	//Configure the destination locations.
	teleport_y = destination.y
	teleport_z = destination.z
	..(A, 1)	//Run the parent proc for teleportation. Tell it to play the animation.

/* Random teleporter, teleports atoms to locations ranging from teleport_x - teleport_x_offset, etc */

/obj/effect/step_trigger/teleporter/random
	var/teleport_x_offset = 0
	var/teleport_y_offset = 0
	var/teleport_z_offset = 0

/obj/effect/step_trigger/teleporter/random/Trigger(var/atom/movable/A)
	if(istype(A, /obj)) //mobs and objects only.
		if(istype(A, /obj/effect)) return
		qdel(A)
	else if(isliving(A)) //Hacked it up so it just deletes it
		to_chat(A, SPAN_DANGER("You get lost into the depths of space, never to be seen again."))
		qdel(A)

