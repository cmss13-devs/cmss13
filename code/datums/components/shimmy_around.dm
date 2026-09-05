/// The maximum duration we allow the animations to tween
#define MAX_ANIMATE_TIME (3.55 DECISECONDS)

/**
 * A component to act on the signal COMSIG_STRUCTURE_COLLIDED to shimmy around a dense structure
 * NOTE: If any part of the Collided proc chain is overriden from obj/structure you must ensure the signal is sent
 */
/datum/component/shimmy_around
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// The structure that we are bound to
	var/obj/structure/parent_structure
	/// Approachable directions bitfield
	var/approach_dirs = NORTH|SOUTH|EAST|WEST
	/// Approach directions bitfield that override the mob's layer to be above our structure's
	var/approach_dirs_layer_override = NORTH|SOUTH|EAST|WEST
	/// internal movement allowed dirs bitfield
	var/internal_dirs = NORTH|SOUTH|EAST|WEST
	/// The pixel_x offset when approaching and facing NORTH
	var/north_offset = 12
	/// The pixel_x offset when approaching and facing SOUTH
	var/south_offset = -12
	/// The pixel_y offset when approaching and facing EAST
	var/east_offset = -5
	/// The pixel_y offset when approaching and facing WEST
	var/west_offset = -5
	/// Whether to adjust the offset using the structure's offset as well
	var/additional_offset = TRUE
	/// Extra time added to next_move to shimmy around
	var/extra_delay = 1 DECISECONDS

/datum/component/shimmy_around/Initialize(\
	approach_dirs = NORTH|SOUTH|EAST|WEST,\
	approach_dirs_layer_override = NORTH|SOUTH|EAST|WEST,\
	internal_dirs =  NORTH|SOUTH|EAST|WEST,\
	north_offset = 12,\
	south_offset = -12,\
	east_offset = -5,\
	west_offset = -5,\
	additional_offset = TRUE,\
	extra_delay = 1 DECISECONDS)

	parent_structure = parent
	if(!istype(parent_structure))
		return COMPONENT_INCOMPATIBLE

	src.approach_dirs = approach_dirs
	src.approach_dirs_layer_override = approach_dirs_layer_override
	src.internal_dirs = internal_dirs
	src.north_offset = north_offset
	src.south_offset = south_offset
	src.east_offset = east_offset
	src.west_offset = west_offset
	src.additional_offset = additional_offset
	src.extra_delay = extra_delay

/datum/component/shimmy_around/Destroy(force, silent)
	var/turf/my_turf = get_turf(parent_structure)
	if(my_turf)
		for(var/mob/living/shimmied_mob in my_turf)	// we need to unshimmy shimmied mobs if this component is seeya byebye
			if(shimmied_mob.pixel_x != initial(shimmied_mob.pixel_x) || shimmied_mob.pixel_y != initial(shimmied_mob.pixel_y) || shimmied_mob.layer != initial(shimmied_mob.layer))
				UnregisterSignal(shimmied_mob, list(COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED, COMSIG_LIVING_SHIMMY_LAYER))
				animate(shimmied_mob, pixel_x = initial(shimmied_mob.pixel_x), pixel_y = initial(shimmied_mob.pixel_y), time = 0)
				if(shimmied_mob.layer != XENO_HIDING_LAYER)	// leave xeno hide alone
					shimmied_mob.layer = initial(shimmied_mob.layer)
	parent_structure = null
	return ..()

/datum/component/shimmy_around/InheritComponent(datum/component/C, i_am_original,
	approach_dirs, approach_dirs_layer_override, internal_dirs, north_offset,\
	south_offset, east_offset, west_offset,	additional_offset, extra_delay)
	. = ..()
	if(approach_dirs && src.approach_dirs != approach_dirs)
		src.approach_dirs =  approach_dirs
	if(approach_dirs_layer_override && approach_dirs_layer_override != src.approach_dirs_layer_override)
		src.approach_dirs_layer_override = approach_dirs_layer_override
	if(internal_dirs && internal_dirs != src.internal_dirs)
		src.internal_dirs = internal_dirs
	if(north_offset && north_offset != src.north_offset)
		src.north_offset = north_offset
	if(south_offset && south_offset != src.south_offset)
		src.south_offset = south_offset
	if(east_offset && east_offset != src.east_offset)
		src.east_offset = east_offset
	if(west_offset &&  west_offset != src.west_offset)
		src.west_offset = west_offset
	if(additional_offset &&  additional_offset != src.additional_offset)
		src.additional_offset = additional_offset
	if(extra_delay && extra_delay != src.extra_delay)
		src.extra_delay = extra_delay

/datum/component/shimmy_around/RegisterWithParent()
	RegisterSignal(parent_structure, COMSIG_STRUCTURE_COLLIDED, PROC_REF(on_collide))

/datum/component/shimmy_around/UnregisterFromParent()
	if(parent_structure)
		UnregisterSignal(parent_structure, COMSIG_STRUCTURE_COLLIDED)

/// Determines whether the user can move to some turf relative to us
/datum/component/shimmy_around/proc/can_move(mob/living/user, direction)
	// Check turf + atoms with our parent_structure
	var/turf/parent_turf = get_turf(parent_structure)
	if(!can_move_internal(user, parent_turf, direction))
		return FALSE

	// Check turf + atoms on the other side too
	if(can_move_internal(user, get_step(parent_structure, direction), direction, ignore_exit = TRUE))
		return TRUE

	// Determine the alternate directions
	var/alt_direction = 0
	var/tertiary_direction = 0
	switch(direction)
		if(NORTH)
			if(north_offset < 0)
				alt_direction = WEST
				tertiary_direction = EAST
			else
				alt_direction = EAST
				tertiary_direction = WEST
		if(SOUTH)
			if(south_offset < 0)
				alt_direction = WEST
				tertiary_direction = EAST
			else
				alt_direction = EAST
				tertiary_direction = WEST
		if(EAST)
			if(east_offset < 0)
				alt_direction = SOUTH
				tertiary_direction = NORTH
			else
				alt_direction = NORTH
				tertiary_direction = SOUTH
		if(WEST)
			if(west_offset < 0)
				alt_direction = SOUTH
				tertiary_direction = NORTH
			else
				alt_direction = NORTH
				tertiary_direction = SOUTH

	// Try an alternate direction
	if(can_move_internal(user, get_step(parent_structure, alt_direction), alt_direction, ignore_exit = TRUE))
		if(can_move_internal(user, parent_turf, alt_direction))
			return TRUE

	// Try a tertiary direction
	if(can_move_internal(user, get_step(parent_structure, tertiary_direction), tertiary_direction, ignore_exit = TRUE))
		if(can_move_internal(user, parent_turf, tertiary_direction))
			return TRUE

	return FALSE

/datum/component/shimmy_around/proc/can_move_internal(mob/living/user, turf/turf, direction, ignore_exit)
	if(turf.density)
		return FALSE

	for(var/atom/exit_atom in turf)
		if(!exit_atom.density)
			continue

		if(exit_atom.GetComponent(type))
			continue

		if(istype(exit_atom, /atom/movable))
			var/atom/movable/moveable_exit_atom = exit_atom
			// Assume we can move the atom over or something when it's not anchored
			if(!moveable_exit_atom.anchored)
				continue

		if(exit_atom.BlockedPassDirs(user, direction))
			return FALSE

		if(!ignore_exit && exit_atom.BlockedExitDirs(user, direction))
			return FALSE

	return TRUE

/// Signal handler for COMSIG_STRUCTURE_COLLIDED to start a shimmy
/datum/component/shimmy_around/proc/on_collide(atom/source, atom/movable/collided_atom)
	SIGNAL_HANDLER

	var/mob/living/mob = collided_atom
	if(!istype(mob))
		return

	// See if we allow this approach direction
	var/direction = get_dir(mob, parent_structure)
	if(!(direction & approach_dirs))
		return

	// See if the exit is blocked
	if(!can_move(mob, direction))
		return

	// Determine if the layer will need to change
	var/desired_layer = round(parent_structure.layer + 0.05, 0.01) // Byond floats are garbage
	if(desired_layer == XENO_HIDING_LAYER)
		desired_layer += 0.01
	var/layer_changing = mob.plane == parent_structure.plane && (direction & approach_dirs_layer_override) && initial(mob.layer) < desired_layer
	if(layer_changing)
		RegisterSignal(mob, COMSIG_LIVING_SHIMMY_LAYER, PROC_REF(on_mob_shimmy_layer))

	// Actually move them (opting to just make this structure not dense so Move can handle pushing & pulling)
	var/turf/destination = get_turf(parent_structure)
	var/prev_density = parent_structure.density
	parent_structure.density = FALSE
	mob.Move(destination, direction)
	parent_structure.density = prev_density
	if(mob.loc != destination)
		if(layer_changing)
			UnregisterSignal(mob, COMSIG_LIVING_SHIMMY_LAYER)
		return // Merely checking the return value for Move is insufficient to detect a mob swap

	// Override their layer if needed
	var/animate_time = min(mob.move_delay + extra_delay, MAX_ANIMATE_TIME)
	if(layer_changing)
		if(mob.layer == XENO_HIDING_LAYER && isxeno(mob))
			var/datum/action/xeno_action/onclick/xenohide/hide = get_action(mob, /datum/action/xeno_action/onclick/xenohide)
			if(hide)
				hide.post_attack()
		if(mob.layer > desired_layer)
			// Delayed since our layer already satisfies the requirement and we might be moving off of another shimmy
			addtimer(VARSET_CALLBACK(mob, layer, desired_layer), animate_time * 0.5)
		else
			mob.layer = desired_layer

	// Offset them
	switch(direction)
		if(NORTH)
			var/extra_offset = additional_offset ? parent_structure.pixel_x : 0
			animate(mob, time = animate_time, pixel_x = mob.pixel_x + north_offset + extra_offset)
		if(SOUTH)
			var/extra_offset = additional_offset ? parent_structure.pixel_x : 0
			animate(mob, time = animate_time, pixel_x = mob.pixel_x + south_offset + extra_offset)
		if(EAST)
			var/extra_offset = additional_offset ? parent_structure.pixel_y : 0
			animate(mob, time = animate_time, pixel_y = mob.pixel_y + east_offset + extra_offset)
		if(WEST)
			var/extra_offset = additional_offset ? parent_structure.pixel_y : 0
			animate(mob, time = animate_time, pixel_y = mob.pixel_y + west_offset + extra_offset)

	// Delay them if needed
	if(extra_delay && mob.client)
		mob.client.move_delay += extra_delay

	// Reset their offset once they move
	RegisterSignal(mob, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_mob_pre_move))
	RegisterSignal(mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_move))

/// Signal handler for COMSIG_LIVING_SHIMMY_LAYER to prevent layer reset from another shimmy component
/datum/component/shimmy_around/proc/on_mob_shimmy_layer(mob/living/source)
	SIGNAL_HANDLER
	return COMSIG_LIVING_SHIMMY_LAYER_CANCEL

/datum/component/shimmy_around/proc/on_mob_pre_move(atom/movable/source, new_loc)
	SIGNAL_HANDLER

	var/mob/living/mob = source
	var/animate_time = min(mob.move_delay + extra_delay, MAX_ANIMATE_TIME)
	var/new_direction = get_dir(mob, new_loc)

	var/list/offsets = get_compensated_offsets(mob)
	var/offset_x = offsets[1]
	var/offset_y = offsets[2]

	// Block movement into parent, but swing around instead
	if(offset_x)
		if(offset_x > 0)
			if(new_direction & WEST)
				if(internal_dirs & WEST)
					apply_directional_offset(mob, WEST, animate_time)
				. = COMPONENT_CANCEL_MOVE
		else
			if(new_direction & EAST)
				if(internal_dirs & EAST)
					apply_directional_offset(mob, EAST, animate_time)
				. = COMPONENT_CANCEL_MOVE
	else if(offset_y)
		if(offset_y > 0)
			if(new_direction & SOUTH)
				if(internal_dirs & SOUTH)
					apply_directional_offset(mob, SOUTH, animate_time)
				. = COMPONENT_CANCEL_MOVE
		else
			if(new_direction & NORTH)
				if(internal_dirs & NORTH)
					apply_directional_offset(mob, NORTH, animate_time)
				. = COMPONENT_CANCEL_MOVE

	if(. == COMPONENT_CANCEL_MOVE)
		source.dir = new_direction
		if(extra_delay && mob.client)
			mob.client.move_delay += extra_delay
		update_shimmy_layer(mob, new_direction)

	return .

/// Signal handler for COMSIG_MOVABLE_MOVED to reset their pixel offsets
/datum/component/shimmy_around/proc/on_mob_move(atom/movable/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	var/mob/living/mob = source
	UnregisterSignal(source, list(COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED, COMSIG_LIVING_SHIMMY_LAYER))
	// Undo changes
	var/animate_time = min(mob.move_delay + extra_delay, MAX_ANIMATE_TIME)
	animate(mob, time = animate_time, pixel_x = initial(mob.pixel_x), pixel_y = initial(mob.pixel_y))
	// Undo layer change only if we aren't shimmying again
	if(!(SEND_SIGNAL(mob, COMSIG_LIVING_SHIMMY_LAYER) & COMSIG_LIVING_SHIMMY_LAYER_CANCEL))
		if(mob.layer != XENO_HIDING_LAYER || !isxeno(mob))
			if(dir & NORTH)
				mob.layer = initial(mob.layer)
			else
				addtimer(VARSET_CALLBACK(mob, layer, initial(mob.layer)), animate_time * 0.5)
	// Delay them if needed
	if(extra_delay && mob.client)
		mob.client.move_delay += extra_delay

//used when we want to inherit shimmying mobs from another /datum/component/shimmy_around, or if our offsets changed and mobs' need to be refreshed
/datum/component/shimmy_around/proc/refresh_mob_offsets(mob/living/shimmied_living, list/old_data)
	if(!shimmied_living || !old_data || shimmied_living.loc != get_turf(parent_structure))
		return

	// old_data layout you are currently using:
	// 1 north, 2 south, 3 east, 4 west, 5 additional_offset
	var/old_north   = old_data[1]
	var/old_south   = old_data[2]
	var/old_east    = old_data[3]
	var/old_west    = old_data[4]
	var/old_add_off = old_data[5]

	var/delta_x = shimmied_living.pixel_x - initial(shimmied_living.pixel_x)
	var/delta_y = shimmied_living.pixel_y - initial(shimmied_living.pixel_y)
	if(old_add_off)
		if(delta_x)
			delta_x -= parent_structure.pixel_x
		if(delta_y)
			delta_y -= parent_structure.pixel_y

	var/recovered_dir = 0
	#define OFFSET_TOLERANCE 3

	if(abs(delta_x) > OFFSET_TOLERANCE && abs(delta_y) <= OFFSET_TOLERANCE)
		if(abs(delta_x - old_north) <= OFFSET_TOLERANCE)
			recovered_dir = NORTH
		else if(abs(delta_x - old_south) <= OFFSET_TOLERANCE)
			recovered_dir = SOUTH
	else if(abs(delta_y) > OFFSET_TOLERANCE && abs(delta_x) <= OFFSET_TOLERANCE)
		if(abs(delta_y - old_east) <= OFFSET_TOLERANCE)
			recovered_dir = EAST
		else if(abs(delta_y - old_west) <= OFFSET_TOLERANCE)
			recovered_dir = WEST

	#undef OFFSET_TOLERANCE

	if(!recovered_dir)
		animate(shimmied_living, pixel_x = initial(shimmied_living.pixel_x), pixel_y = initial(shimmied_living.pixel_y), time = 0)
		return

	var/animate_time = min(shimmied_living.move_delay + extra_delay, MAX_ANIMATE_TIME)
	apply_directional_offset(shimmied_living, recovered_dir, animate_time)

	// Re-own the mob
	RegisterSignal(shimmied_living, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_mob_pre_move), override = TRUE)
	RegisterSignal(shimmied_living, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_move), override = TRUE)

	update_shimmy_layer(shimmied_living, recovered_dir)

/// Returns the current pixel deltas after stripping any additional_offset the
/// component previously applied.  Used by both the signal path and refresh.
/datum/component/shimmy_around/proc/get_compensated_offsets(mob/living/mob)
	var/offset_x = mob.pixel_x - initial(mob.pixel_x)
	var/offset_y = mob.pixel_y - initial(mob.pixel_y)
	if(additional_offset)
		if(offset_x)
			offset_x -= parent_structure.pixel_x
		else if(offset_y)
			offset_y -= parent_structure.pixel_y
	return list(offset_x, offset_y)

/// Animate the mob to the visual offset that belongs to the given approach
/// direction.  Always goes from initial() so it is safe for both a fresh shimmy and a refresh.
/datum/component/shimmy_around/proc/apply_directional_offset(mob/living/mob, direction, animate_time)
	switch(direction)
		if(NORTH)
			var/extra = additional_offset ? parent_structure.pixel_x : 0
			animate(mob, time = animate_time,
				pixel_x = initial(mob.pixel_x) + north_offset + extra,
				pixel_y = initial(mob.pixel_y))
		if(SOUTH)
			var/extra = additional_offset ? parent_structure.pixel_x : 0
			animate(mob, time = animate_time,
				pixel_x = initial(mob.pixel_x) + south_offset + extra,
				pixel_y = initial(mob.pixel_y))
		if(EAST)
			var/extra = additional_offset ? parent_structure.pixel_y : 0
			animate(mob, time = animate_time,
				pixel_x = initial(mob.pixel_x),
				pixel_y = initial(mob.pixel_y) + east_offset + extra)
		if(WEST)
			var/extra = additional_offset ? parent_structure.pixel_y : 0
			animate(mob, time = animate_time,
				pixel_x = initial(mob.pixel_x),
				pixel_y = initial(mob.pixel_y) + west_offset + extra)

/// Layer override / restore logic shared by the signal path and refresh.
/datum/component/shimmy_around/proc/update_shimmy_layer(mob/living/mob, direction)
	var/desired_layer = round(parent_structure.layer + 0.05, 0.01)
	if(desired_layer == XENO_HIDING_LAYER)
		desired_layer += 0.01

	var/layer_changing = mob.plane == parent_structure.plane \
		&& (direction & approach_dirs_layer_override) \
		&& initial(mob.layer) < desired_layer

	if(layer_changing)
		RegisterSignal(mob, COMSIG_LIVING_SHIMMY_LAYER, PROC_REF(on_mob_shimmy_layer), override = TRUE)
		if(mob.layer == XENO_HIDING_LAYER && isxeno(mob))
			var/datum/action/xeno_action/onclick/xenohide/hide = get_action(mob, /datum/action/xeno_action/onclick/xenohide)
			if(hide)
				hide.post_attack()
		mob.layer = desired_layer
	else
		UnregisterSignal(mob, COMSIG_LIVING_SHIMMY_LAYER)
		if(mob.layer != XENO_HIDING_LAYER || !isxeno(mob))
			mob.layer = initial(mob.layer)
