/*
All ShuttleMove procs go here
*/

/* ***********************************Base procs************************************/

// Called on every turf in the shuttle region, returns a bitflag for allowed movements of that turf
// returns the new move_mode (based on the old)
/turf/proc/fromShuttleMove(turf/newT, move_mode)
	if(!(move_mode & MOVE_AREA) || !isshuttleturf(src))
		return move_mode

	return move_mode | MOVE_TURF | MOVE_CONTENTS

// Called from the new turf before anything has been moved
// Only gets called if fromShuttleMove returns true first
// returns the new move_mode (based on the old)
/turf/proc/toShuttleMove(turf/oldT, move_mode, obj/docking_port/mobile/shuttle)
	. = move_mode
	if(!(. & (MOVE_TURF|MOVE_CONTENTS)))
		return

// var/shuttle_dir = shuttle.dir
	for(var/i in contents)
		var/atom/movable/thing = i
		SEND_SIGNAL(thing, COMSIG_MOVABLE_SHUTTLE_CRUSH, shuttle)
		if(ismob(thing))
			if(isliving(thing))
				var/mob/living/M = thing
// if(M.status_flags & INCORPOREAL)
// continue // Ghost things don't splat
				if(M.buckled)
					M.buckled.unbuckle()//M, TRUE)
				if(M.pulledby)
					M.pulledby.stop_pulling()
				M.stop_pulling()
				M.visible_message(SPAN_WARNING("[shuttle] slams into [M]!"))
				M.gib()

		else //non-living mobs shouldn't be affected by shuttles, which is why this is an else
			if(thing.anchored)
				// Ordered by most likely:
				if(istype(thing, /obj/effect/projector))
					// delete the clone not the projector
					if(clone)
						GLOB.clones.Remove(clone)
						qdel(clone, TRUE)
						clone = null
					continue
				if(istype(thing, /obj/effect/hangar_airlock))
					continue
				if(istype(thing, /obj/structure/machinery/landinglight))
					continue
				if(istype(thing, /obj/docking_port))
					continue
				if(istype(thing, /obj/structure/machinery/camera))
					continue
				if(istype(thing, /obj/structure/machinery/floodlight/landing/floor))
					continue

				// SSshuttle also removes these in remove_ripples, but its timing is weird
				if(!istype(thing, /obj/effect))
					log_debug("[shuttle] deleted an anchored [thing]")

			qdel(thing)

// Called on the old turf to move the turf data
/turf/proc/onShuttleMove(turf/newT, list/movement_force, move_dir)
	if(newT == src) // In case of in place shuttle rotation shenanigans.
		return
	if(src.clone)
		GLOB.clones.Remove(src.clone)
		qdel(src.clone, TRUE)
		src.clone = null
	//Destination turf changes
	//Baseturfs is definitely a list or this proc wouldnt be called
	var/shuttle_boundary = baseturfs.Find(/turf/baseturf_skipover/shuttle)
	if(!shuttle_boundary)
		CRASH("A turf queued to move via shuttle somehow had no skipover in baseturfs. [src]([type]):[loc]")
	var/depth = length(baseturfs) - shuttle_boundary + 1
	newT.CopyOnTop(src, 1, depth, TRUE)
	return TRUE

// Called on the new turf after everything has been moved
/turf/proc/afterShuttleMove(turf/oldT, rotation)
	//Dealing with the turf we left behind
	oldT.TransferComponents(src)
// SSexplosions.wipe_turf(src)

	var/shuttle_boundary = baseturfs.Find(/turf/baseturf_skipover/shuttle)
	if(shuttle_boundary)
		oldT.ScrapeAway(length(baseturfs) - shuttle_boundary + 1)

	if(rotation)
		shuttleRotate(rotation) //see shuttle_rotate.dm

	return TRUE

/turf/proc/lateShuttleMove(turf/oldT)



//=====================================================================//

// Called on every atom in shuttle turf contents before anything has been moved
// returns the new move_mode (based on the old)
// WARNING: Do not leave turf contents in beforeShuttleMove or dock() will runtime
/atom/movable/proc/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	return move_mode

// Called on atoms to move the atom to the new location
/atom/movable/proc/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if(newT == oldT) // In case of in place shuttle rotation shenanigans.
		return

	if(loc != oldT) // This is for multi tile objects
		return

	if(clone)
		destroy_clone()

	loc = newT

	return TRUE

// Called on atoms after everything has been moved
/atom/movable/proc/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)

	var/turf/newT = get_turf(src)
	if (newT.z != oldT.z)
		onTransitZ(oldT.z, newT.z)

	if(light)
		update_light()
	if(rotation)
		shuttleRotate(rotation)

// update_parallax_contents()

	return TRUE

/atom/movable/proc/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	if(!movement_force || anchored)
		return
	var/throw_force = movement_force["THROW"]
	if(!throw_force)
		return
	var/turf/target = get_edge_target_turf(src, move_dir)
	var/range = throw_force * 10
	range = CEILING(rand(range-(range*0.1), range+(range*0.1)), 10)/10
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, safe_throw_at), target, range, SPEED_AVERAGE)

//=====================================================================//

// Called on areas before anything has been moved
// returns the new move_mode (based on the old)
/area/proc/beforeShuttleMove(list/shuttle_areas)
	if(!shuttle_areas[src])
		return NONE
	return MOVE_AREA

// Called on areas to move their turf between areas
/area/proc/onShuttleMove(turf/oldT, turf/newT, area/underlying_old_area)
	if(newT == oldT) // In case of in place shuttle rotation shenanigans.
		return TRUE

	contents -= oldT
	underlying_old_area.contents += oldT
	oldT.change_area(src, underlying_old_area) //lighting
	//The old turf has now been given back to the area that turf originaly belonged to

	var/area/old_dest_area = newT.loc
	//parallax_movedir = old_dest_area.parallax_movedir

	old_dest_area.contents -= newT
	contents += newT
	newT.change_area(old_dest_area, src) //lighting
	return TRUE

// Called on areas after everything has been moved
/area/proc/afterShuttleMove(new_parallax_dir)
	//parallax_movedir = new_parallax_dir
	return TRUE

/area/proc/lateShuttleMove()
	return

/* ***********************************Turf move procs************************************/

/* ***********************************Area move procs************************************/

/* ***********************************Machinery move procs************************************/

/obj/structure/machinery/door/airlock/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	for(var/obj/structure/machinery/door/airlock/A in range(1, src))  // includes src
		INVOKE_ASYNC(A, TYPE_PROC_REF(/obj/structure/machinery/door, close))

/obj/structure/machinery/camera/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS

/obj/structure/machinery/atmospherics/pipe/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	var/turf/T = loc
	hide(T.intact_tile)

/obj/structure/machinery/power/terminal/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	var/turf/T = src.loc
	if(level==1)
		hide(T.intact_tile)

/* ***********************************Mob move procs************************************/

/mob/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if(!move_on_shuttle)
		return
	. = ..()

/mob/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	if(!move_on_shuttle)
		return
	. = ..()
	client?.soundOutput?.update_ambience(null, null, TRUE)
	if(client && movement_force)
		var/shake_force = max(movement_force["THROW"], movement_force["KNOCKDOWN"])
		if(buckled)
			shake_force *= 0.25
		shake_camera(src, shake_force, 1)

/mob/living/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	QDEL_NULL(observed_atom)
	. = ..()

/mob/living/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	if(buckled)
		return

	. = ..()

	var/knockdown = movement_force["KNOCKDOWN"]
	if(knockdown)
		apply_effect(knockdown, WEAKEN)


/* ***********************************Structure move procs************************************/

/obj/structure/grille/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS

/obj/structure/lattice/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS

/obj/structure/disposalpipe/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	update()

/obj/structure/cable/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	var/turf/T = loc
	if(level==1)
		hide(T.intact_tile)

/obj/structure/shuttle/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS

/*
/obj/structure/ladder/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if (!(resistance_flags & INDESTRUCTIBLE))
		disconnect()

/obj/structure/ladder/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	if (!(resistance_flags & INDESTRUCTIBLE))
		LateInitialize()

/obj/structure/ladder/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if (resistance_flags & INDESTRUCTIBLE)
		// simply don't be moved
		return FALSE
	return ..()
*/

/* ***********************************Misc move procs************************************/

/atom/movable/lighting_object/onShuttleMove()
	return FALSE

/obj/docking_port/mobile/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(moving_dock == src)
		. |= MOVE_CONTENTS

/obj/docking_port/stationary/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if(!moving_dock.can_move_docking_ports || old_dock == src)
		return FALSE
	. = ..()

/obj/docking_port/stationary/public_mining_dock/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	id = "mining_public" //It will not move with the base, but will become enabled as a docking point.

/*
/obj/effect/abstract/proximity_checker/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	//timer so it only happens once
	addtimer(CALLBACK(monitor, /datum/proximity_monitor/proc/SetRange, monitor.current_range, TRUE), 0, TIMER_UNIQUE)
*/
