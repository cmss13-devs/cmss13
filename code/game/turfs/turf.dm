/*
/turf

	/open - all turfs with density = 0 are turf/open

		/floor - floors are constructed floor as opposed to natural grounds

		/space

		/shuttle - shuttle floors are separated from real floors because they're magic

		/snow - snow is one type of non-floor open turf

	/closed - all turfs with density = 1 are turf/closed

		/wall - walls are constructed walls as opposed to natural solid turfs

			/r_wall

		/shuttle - shuttle walls are separated from real walls because they're magic, and don't smoothes with walls.

		/ice_rock - ice_rock is one type of non-wall closed turf

*/



/turf
	icon = 'icons/turf/floors/floors.dmi'
	var/intact_tile = 1 //used by floors to distinguish floor with/without a floortile(e.g. plating).
	var/can_bloody = TRUE //Can blood spawn on this turf?
	var/old_turf = "" //The previous turf's path as text. Used when deconning on LV --MadSnailDisease
	var/list/linked_pylons = list()

	var/list/datum/automata_cell/autocells = list()
	var/list/dirt_overlays = list()

/turf/New()
	..()
	turfs += src
	if(src.z == 1)
		z1turfs += src

	for(var/atom/movable/AM as mob|obj in src)
		spawn(0)
			Entered(AM)

	levelupdate()

/turf/Dispose()
	. = ..()

	stop_processing()

	if(old_turf != "")
		ChangeTurf(text2path(old_turf), TRUE)
	else
		ChangeTurf(/turf/open/floor/plating, TRUE)

	// Changeturf handles the transition to the new turf type
	return GC_HINT_IGNORE

/turf/ex_act(severity)
	return 0

/turf/proc/update_icon() //Base parent. - Abby
	return

/turf/proc/loc_to_string()
	var/text
	text = " ( [x], [y], [z])"// Desc is the <area name> (x, y)
	return text

/turf/process()
	return

/turf/proc/start_processing()
	if(src in processing_turfs)
		return 0
	processing_turfs += src
	return 1

/turf/proc/stop_processing()
	if(src in processing_turfs)
		processing_turfs -= src
		return 1
	return 0

// Handles whether an atom is able to enter the src turf
/turf/Enter(atom/movable/mover, atom/forget)
	if (!mover || !isturf(mover.loc))
		return FALSE

	if(isobserver(mover) || istype(mover, /obj/item/projectile))
		return TRUE

	var/fdir = get_dir(mover, src)
	if (!fdir)
		return TRUE

	var/fd1 = fdir&(fdir-1) // X-component if fdir diagonal, 0 otherwise
	var/fd2 = fdir - fd1 // Y-component if fdir diagonal, fdir otherwise

	var/blocking_dir = 0 // The directions that the mover's path is being blocked by

	var/obstacle
	var/turf/T
	var/atom/A

	T = mover.loc
	blocking_dir |= T.BlockedExitDirs(mover, fdir)
	if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
		mover.Collide(T)
		return FALSE
	for (obstacle in T) //First, check objects to block exit
		if (mover == obstacle || forget == obstacle)
			continue
		if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
			continue
		A = obstacle
		blocking_dir |= A.BlockedExitDirs(mover, fdir)
		if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
			mover.Collide(A)
			return FALSE

	// if we are thrown, moved, dragged, or in any other way abused by code - check our diagonals
	if(!mover.move_intentionally)
		// Check objects in adjacent turf EAST/WEST
		if(mover.diagonal_movement == DIAG_MOVE_DEFAULT && \
			fd1 && fd1 != fdir
		)
			T = get_step(mover, fd1)
			if (T.BlockedExitDirs(mover, fd2) || T.BlockedPassDirs(mover, fd1))
				blocking_dir |= fd1
				if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
					mover.Collide(T)
					return FALSE
			for(obstacle in T)
				if(forget == obstacle)
					continue
				if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
					continue
				A = obstacle
				if (A.BlockedExitDirs(mover, fd2) || A.BlockedPassDirs(mover, fd1))
					blocking_dir |= fd1
					if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
						mover.Collide(A)
						return FALSE

		// Check for borders in adjacent turf NORTH/SOUTH
		if(mover.diagonal_movement == DIAG_MOVE_DEFAULT && \
			fd2 && fd2 != fdir
		)
			T = get_step(mover, fd2)
			if (T.BlockedExitDirs(mover, fd1) || T.BlockedPassDirs(mover, fd2))
				blocking_dir |= fd2
				if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
					mover.Collide(T)
					return FALSE
			for(obstacle in T)
				if(forget == obstacle)
					continue
				if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
					continue
				A = obstacle
				if (A.BlockedExitDirs(mover, fd1) || A.BlockedPassDirs(mover, fd2))
					blocking_dir |= fd2
					if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
						mover.Collide(A)
						return FALSE
					break
	
	//Next, check the turf itself
	blocking_dir |= BlockedPassDirs(mover, fdir)
	if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
		mover.Collide(src)
		return FALSE
	for(obstacle in src) //Then, check atoms in the target turf
		if(forget == obstacle)
			continue
		if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
			continue
		A = obstacle
		blocking_dir |= A.BlockedPassDirs(mover, fdir)
		if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
			if(!mover.Collide(A))
				return FALSE

	return TRUE //Nothing found to block so return success!

/turf/Entered(atom/movable/A)
	if(!istype(A))
		return

	// Let explosions know that the atom entered
	for(var/datum/automata_cell/explosion/E in autocells)
		E.on_turf_entered(A)

/turf/proc/is_plating()
	return 0
/turf/proc/is_asteroid_floor()
	return 0
/turf/proc/is_plasteel_floor()
	return 0
/turf/proc/is_light_floor()
	return 0
/turf/proc/is_grass_floor()
	return 0
/turf/proc/is_wood_floor()
	return 0
/turf/proc/is_carpet_floor()
	return 0
/turf/proc/return_siding_icon_state()		//used for grass floors, which have siding.
	return 0

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(!(A.last_move_dir))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Process_Spacemove(1))
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && !(M.pulledby) && (M.loc == src)))
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move_dir
				step(M, M.inertia_dir)
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(intact_tile)

//Creates a new turf. this is called by every code that changes a turf ("spawn atom" verb, qdel, build mode stuff, etc)
/turf/proc/ChangeTurf(new_turf_path, forget_old_turf)
	if (!new_turf_path)
		return

	var/old_lumcount = lighting_lumcount - initial(lighting_lumcount)

	var/path = "[src.type]"
	if(istype(src, /turf/open/snow))
		var/turf/open/snow/s = src
		//This is so we revert back to a proper snow layer
		path = "/turf/open/snow/layer[s.slayer]"

	if(src.type == new_turf_path)
		return

	var/pylons = linked_pylons

	var/turf/W = new new_turf_path( locate(src.x, src.y, src.z) )

	W.linked_pylons = pylons

	if(!forget_old_turf)	//e.g. if an admin spawn a new wall on a wall tile, we don't
		W.old_turf = path	//want the new wall to change into the old wall when destroyed
	W.lighting_lumcount += old_lumcount
	if(old_lumcount != W.lighting_lumcount)
		W.lighting_changed = 1
		SSlighting.changed_turfs += W

	W.levelupdate()
	return W


/turf/proc/ReplaceWithLattice()
	src.ChangeTurf(/turf/open/space)
	new /obj/structure/lattice( locate(src.x, src.y, src.z) )

/turf/proc/AdjacentTurfs()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		return cost
	else
		return get_dist(src,t)


//for xeno corrosive acid, 0 for unmeltable, 1 for regular, 2 for strong walls that require strong acid and more time.
/turf/proc/can_be_dissolved()
	return 0

/turf/proc/ceiling_debris_check(var/size = 1)
	return

/turf/proc/ceiling_debris(var/size = 1) //debris falling in response to airstrikes, etc
	var/area/A = get_area(src)
	if(!A.ceiling) return

	var/amount = size
	var/spread = round(sqrt(size)*1.5)

	var/list/turfs = list()
	for(var/turf/open/floor/F in range(src,spread))
		turfs += F

	switch(A.ceiling)
		if(CEILING_GLASS)
			playsound(src, "sound/effects/Glassbr1.ogg", 60, 1)
			spawn(8)
				if(amount >1)
					visible_message(SPAN_BOLDNOTICE("Shards of glass rain down from above!"))
				for(var/i=1, i<=amount, i++)
					new /obj/item/shard(pick(turfs))
					new /obj/item/shard(pick(turfs))
		if(CEILING_METAL,CEILING_REINFORCED_METAL)
			playsound(src, "sound/effects/metal_crash.ogg", 60, 1)
			spawn(8)
				if(amount >1)
					visible_message(SPAN_BOLDNOTICE("Pieces of metal crash down from above!"))
				for(var/i=1, i<=amount, i++)
					new /obj/item/stack/sheet/metal(pick(turfs))
		if(CEILING_UNDERGROUND, CEILING_DEEP_UNDERGROUND)
			playsound(src, "sound/effects/meteorimpact.ogg", 60, 1)
			spawn(8)
				if(amount >1)
					visible_message(SPAN_BOLDNOTICE("Chunks of rock crash down from above!"))
				for(var/i=1, i<=amount, i++)
					new /obj/item/ore(pick(turfs))
					new /obj/item/ore(pick(turfs))
		if(CEILING_UNDERGROUND_METAL, CEILING_DEEP_UNDERGROUND_METAL)
			playsound(src, "sound/effects/metal_crash.ogg", 60, 1)
			spawn(8)
				for(var/i=1, i<=amount, i++)
					new /obj/item/stack/sheet/metal(pick(turfs))
					new /obj/item/ore(pick(turfs))

/turf/proc/ceiling_desc(mob/user)

	if (linked_pylons.len > 0)
		switch(get_pylon_protection_level())
			if(TURF_PROTECTION_MORTAR)
				to_chat(user, "The ceiling above is made of light resin.")
				return
			if(TURF_PROTECTION_CAS)
				to_chat(user, "The ceiling above is made of resin.")
				return
			if(TURF_PROTECTION_OB)
				to_chat(user, "The ceiling above is made of thick resin. Nothing is getting through that")
				return

	var/area/A = get_area(src)
	switch(A.ceiling)
		if(CEILING_GLASS)
			to_chat(user, "The ceiling above is glass.")
		if(CEILING_METAL)
			to_chat(user, "The ceiling above is metal.")
		if(CEILING_UNDERGROUND)
			to_chat(user, "It is underground. The cavern roof lies above.")
		if(CEILING_UNDERGROUND_METAL)
			to_chat(user, "It is underground. The ceiling above is metal.")
		if(CEILING_DEEP_UNDERGROUND)
			to_chat(user, "It is deep underground. The cavern roof lies above.")
		if(CEILING_DEEP_UNDERGROUND_METAL)
			to_chat(user, "It is deep underground. The ceiling above is metal.")
		if(CEILING_REINFORCED_METAL)
			to_chat(user, "The ceiling above is heavy reinforced metal. Nothing is getting through that.")
		else
			to_chat(user, "It is in the open.")

/turf/proc/wet_floor()
	return

/turf/proc/get_cell(var/type)
	for(var/datum/automata_cell/C in autocells)
		if(istype(C, type))
			return C
	return null

//////////////////////////////////////////////////////////

//Check if you can plant weeds on that turf.
//Does NOT return a message, just a 0 or 1.
/turf/proc/is_weedable()
	return !density

/turf/open/space/is_weedable()
	return FALSE

/turf/open/gm/grass/is_weedable()
	return FALSE

/turf/open/gm/dirtgrassborder/is_weedable()
	return FALSE

/turf/open/gm/river/is_weedable()
	return FALSE

/turf/open/gm/coast/is_weedable()
	return FALSE

/turf/open/snow/is_weedable()
	return !slayer

/turf/open/mars/is_weedable()
	return FALSE

/turf/open/jungle/is_weedable()
	return FALSE

/turf/closed/wall/is_weedable()
	return TRUE //so we can spawn weeds on the walls

/turf/closed/wall/almayer/research/containment/wall/divide/is_weedable()
	return FALSE

/turf/proc/can_dig_xeno_tunnel()
	return FALSE

/turf/open/gm/can_dig_xeno_tunnel()
	return TRUE

/turf/open/gm/river/can_dig_xeno_tunnel()
	return FALSE

/turf/open/snow/can_dig_xeno_tunnel()
	return TRUE

/turf/open/mars/can_dig_xeno_tunnel()
	return TRUE

/turf/open/mars_cave/can_dig_xeno_tunnel()
	return TRUE

/turf/open/organic/can_dig_xeno_tunnel()
	return TRUE

/turf/open/floor/prison/can_dig_xeno_tunnel()
	return TRUE

/turf/open/desert/dirt/can_dig_xeno_tunnel()
	return TRUE

/turf/open/desert/rock/can_dig_xeno_tunnel()
	return TRUE

/turf/open/floor/ice/can_dig_xeno_tunnel()
	return TRUE

/turf/open/floor/wood/can_dig_xeno_tunnel()
	return TRUE

/turf/open/floor/corsat/can_dig_xeno_tunnel()
	return TRUE

/turf/closed/wall/almayer/research/containment/wall/divide/can_dig_xeno_tunnel()
	return FALSE

//what dirt type you can dig from this turf if any.
/turf/proc/get_dirt_type()
	return NO_DIRT

/turf/open/gm/get_dirt_type()
	return DIRT_TYPE_GROUND

/turf/open/organic/grass/get_dirt_type()
	return DIRT_TYPE_GROUND

/turf/open/mars/get_dirt_type()
	return DIRT_TYPE_MARS

/turf/open/snow/get_dirt_type()
	return DIRT_TYPE_SNOW

/turf/open/desert/dirt/get_dirt_type()
	return DIRT_TYPE_MARS

/turf/BlockedPassDirs(atom/movable/mover, target_dir)
	if(density)
		return BLOCKED_MOVEMENT
	return NO_BLOCKED_MOVEMENT

//whether the turf cancels a crusher charge
/turf/proc/stop_crusher_charge()
	return FALSE

/turf/proc/get_pylon_protection_level()
	var/protection_level = TURF_PROTECTION_NONE
	for (var/atom/pylon in linked_pylons)
		if (pylon.loc != null)
			var/obj/effect/alien/resin/special/pylon/P = pylon

			if(!istype(P))
				continue

			if(P.protection_level > protection_level)
				protection_level = P.protection_level
		else 
			linked_pylons -= pylon

	return protection_level
