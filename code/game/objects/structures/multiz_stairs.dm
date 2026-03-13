/obj/structure/stairs/multiz
	var/direction
	layer = OBJ_LAYER // Cannot be obstructed by weeds
	var/list/blockers = list()

/obj/structure/stairs/multiz/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(loc, COMSIG_TURF_ENTERED, PROC_REF(on_turf_entered))
	for(var/turf/blocked_turf in range(1, src))
		blockers += WEAKREF(new /obj/effect/build_blocker(blocked_turf, src))
		blockers += WEAKREF(new /obj/structure/blocker/anti_cade(blocked_turf))
	return INITIALIZE_HINT_LATELOAD

/obj/structure/stairs/multiz/Destroy()
	QDEL_LIST(blockers)
	return ..()

/obj/structure/stairs/multiz/proc/on_turf_entered(turf/source, atom/movable/enterer)
	SIGNAL_HANDLER
	if(!istype(enterer, /mob))
		return

	RegisterSignal(enterer, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_premove))
	RegisterSignal(enterer, COMSIG_MOVABLE_MOVED, PROC_REF(on_leave))

/obj/structure/stairs/multiz/proc/on_leave(atom/movable/mover, atom/oldloc, newDir)
	SIGNAL_HANDLER
	if(mover.loc == loc)
		return
	UnregisterSignal(mover, list(COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED))

/obj/structure/stairs/multiz/proc/on_premove(atom/movable/mover, atom/newLoc)
	SIGNAL_HANDLER

	if(direction == UP && get_dir(src, newLoc) != dir || direction == DOWN && get_dir(src, newLoc) != REVERSE_DIR(dir))
		return

	var/turf/target_turf = get_step(src, direction == UP ? dir : REVERSE_DIR(dir))
	var/turf/actual_turf
	if(direction == UP)
		actual_turf = SSmapping.get_turf_above(target_turf)
	else
		actual_turf = SSmapping.get_turf_below(target_turf)
		mover.plane = ABOVE_BLACKNESS_PLANE
		addtimer(VARSET_CALLBACK(mover, plane, GAME_PLANE), 0.5 SECONDS)

	if(actual_turf)
		if(actual_turf.check_blocked())
			to_chat(mover, SPAN_WARNING("Something is blocking the way."))
			return COMPONENT_CANCEL_MOVE
		if(istype(mover, /mob))
			var/mob/mover_mob = mover
			mover_mob.trainteleport(actual_turf)
		else
			mover.forceMove(actual_turf)
		if(!(mover.flags_atom & DIRLOCK))
			mover.setDir(direction == UP ? dir : REVERSE_DIR(dir))

	return COMPONENT_CANCEL_MOVE

/obj/structure/stairs/multiz/up
	direction = UP

	var/datum/staircase/staircase

/obj/structure/stairs/multiz/up/LateInitialize()
	. = ..()

	if(staircase)
		return

	var/stairs = list(src)

	for(var/direction in list(turn(dir, 90), turn(dir, -90)))
		var/adjacent_turf = get_step(src, direction)
		while(adjacent_turf)
			var/obj/structure/stairs/multiz/up/up_ladder = locate() in adjacent_turf
			if(!up_ladder || up_ladder.staircase || up_ladder.dir != dir)
				break

			stairs += up_ladder
			adjacent_turf = get_step(adjacent_turf, direction)

	staircase = new(stairs, dir)

/datum/staircase

	/// The direction that this staircase is going in
	var/dir

	/// A mapping of turf -> list of client images shown when stepped on
	var/alist/from_turf_to_images = alist()

	/// Mobs that we are currently displaying images to
	var/in_range_mob = list()

/datum/staircase/New(list/obj/structure/stairs/multiz/up/stairs, dir)
	src.dir = dir

	var/alist/destination_turf_images = alist()
	var/alist/source_vectors = alist()
	var/alist/destination_vectors = alist()
	var/alist/stair_vectors = alist()
	for(var/obj/structure/stairs/multiz/up/stair as anything in stairs)
		stair.staircase = src
		// we don't need to track which stair it is, just the position

		var/turf/under_the_stairs = get_step(stair, stair.dir)
		for(var/turf/from_turf in view(under_the_stairs))
			if((dir == NORTH && from_turf.y > stair.y) || (dir == EAST && from_turf.x > stair.x) || (dir == SOUTH && from_turf.y < stair.y) || (dir == WEST && from_turf.x < stair.x))
				continue
			LAZYADD(stair_vectors[from_turf], vector(under_the_stairs.x - from_turf.x, under_the_stairs.y - from_turf.y))
			source_vectors[from_turf] = vector(from_turf.x, from_turf.y) // offset by half a tile so it checks the center

		for(var/turf/target_turf in view(SSmapping.get_turf_above(under_the_stairs)))
			if((dir == NORTH && target_turf.y <= stair.y) || (dir == EAST && target_turf.x <= stair.x) || (dir == SOUTH && target_turf.y >= stair.y) || (dir == WEST && target_turf.x >= stair.x))
				continue
			// Don't skip transparent turfs here; vis_contents_holder has VIS_HIDE and will not be copied
			// So we'll just get the turf itself (for catwalks, etc) and anything on it, like lights or flying objects
			destination_turf_images[target_turf] = create_vis_contents_screen(SSmapping.get_turf_below(target_turf), target_turf)
			destination_vectors[target_turf] = vector(target_turf.x, target_turf.y)

	for(var/from_turf, from_vector in source_vectors)
		for(var/to_turf, to_vector in destination_vectors)
			if(from_vector ~= to_vector) // this would overlap the source and look weird
				continue
			var/vector/turf_to_target = (to_vector - from_vector)
			var/distance_to_target = turf_to_target.size
			// WARNING, HERE BE GEOMETRY
			for(var/vector/turf_to_stair in stair_vectors[from_turf])
				// this gives the signed area of the parallelogram formed by both vectors
				// as the z axis of the 3d cross product (because both are 2d vectors)
				// todo: test if doing the determinant in softcode is faster
				var/vector/cross_product = turf_to_stair.Cross(turf_to_target)
				// the target has to be within half a tile of the line from the source to the stair (line of sight)
				// we use the area divided by the base of the parallelogram to get the height
				// the base is the distance to the target, and the height is the distance of
				// the target to the line
				if((abs(cross_product.z) / distance_to_target) >= 0.5)
					continue // try some different stairs
				// this can use a lazylist macro because the value inside the alist is a lazylist
				// from_turf_to_images itself is NOT a lazylist, it's a normal alist
				LAZYADD(from_turf_to_images[from_turf], destination_turf_images[to_turf])
				break // we found stairs that work, go on to the next turf
		if(length(from_turf_to_images[from_turf]))
			RegisterSignal(from_turf, COMSIG_TURF_ENTERED, PROC_REF(handle_entered), TRUE)

/datum/staircase/proc/handle_entered(turf/originator, atom/what_did_it)
	SIGNAL_HANDLER

	var/mob/mover = what_did_it
	if(!istype(mover))
		return

	if(mover in in_range_mob)
		return

	RegisterSignal(mover, COMSIG_MOVABLE_MOVED, PROC_REF(handle_movement))
	RegisterSignal(mover, COMSIG_PARENT_QDELETING, PROC_REF(handle_deleted))
	handle_movement(mover, originator)

	in_range_mob += mover


/datum/staircase/proc/handle_movement(mob/mover, old_loc, direction)
	SIGNAL_HANDLER

	var/turf/where_from = get_turf(old_loc)
	if(length(from_turf_to_images[where_from]))
		for(var/image in from_turf_to_images[where_from])
			mover.client?.images -= image

	var/turf/where_to = get_turf(mover)
	if(length(from_turf_to_images[where_to]))
		for(var/image in from_turf_to_images[where_to])
			mover.client?.images += image

		return

	in_range_mob -= mover
	UnregisterSignal(mover, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))

/datum/staircase/proc/handle_deleted(atom/updater)
	SIGNAL_HANDLER

	in_range_mob -= updater

/proc/create_vis_contents_screen(turf/appear_where, turf/clone_what)
	var/image/clone = image('icons/turf/floors/floors.dmi', appear_where, "transparent")
	clone.vis_contents += clone_what
	clone.vis_contents += GLOB.above_blackness_backdrop
	clone.override = TRUE

	// Make sure we aren't blocked by the blackness plane, we're drawing over obscured turfs after all
	clone.plane = ABOVE_BLACKNESS_PLANE

	return clone

GLOBAL_DATUM_INIT(above_blackness_backdrop, /atom/movable/above_blackness_backdrop, new)

/atom/movable/above_blackness_backdrop
	name = "above_blackness_backdrop"
	anchored = TRUE
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "grey"
	plane = ABOVE_BLACKNESS_BACKDROP_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/stairs/multiz/down
	direction = DOWN

/obj/structure/stairs/multiz/rock
	icon = 'icons/obj/structures/stairs/ramp.dmi'
	icon_state = "dark_ramp"

/obj/structure/stairs/multiz/rock/up
	direction = UP

/obj/structure/stairs/multiz/rock/down
	direction = DOWN
