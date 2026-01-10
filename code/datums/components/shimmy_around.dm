/// The maximum duration we allow the animations to tween
#define MAX_ANIMATE_TIME (3.55 DECISECONDS)

/**
 * A component to act on the signal COMSIG_STRUCTURE_COLLIDED to shimmy around a dense structure
 * NOTE: If any part of the Collided proc chain is overriden from obj/structure you must ensure the signal is sent
 */
/datum/component/shimmy_around
	/// The structure that we are bound to
	var/obj/structure/parent_structure
	/// Approachable directions bitfield
	var/approach_dirs = NORTH|SOUTH|EAST|WEST
	/// Approach directions bitfield that override the mob's layer to be above our structure's
	var/approach_dirs_layer_override = NORTH|SOUTH|EAST|WEST
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
	src.north_offset = north_offset
	src.south_offset = south_offset
	src.east_offset = east_offset
	src.west_offset = west_offset
	src.additional_offset = additional_offset
	src.extra_delay = extra_delay

/datum/component/shimmy_around/Destroy(force, silent)
	. = ..()
	parent_structure = null

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
		return // Merely checking the return value for Move is insufficent to detect a mob swap

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

/// Signal handler for COMSIG_MOVABLE_PRE_MOVE to prevent movement into us
/datum/component/shimmy_around/proc/on_mob_pre_move(atom/movable/source, new_loc)
	SIGNAL_HANDLER

	var/mob/living/mob = source
	var/animate_time = min(mob.move_delay + extra_delay, MAX_ANIMATE_TIME)
	var/new_direction = get_dir(mob, new_loc)
	var/offset_x = mob.pixel_x - initial(mob.pixel_x)
	var/offset_y = mob.pixel_y - initial(mob.pixel_y)
	if(additional_offset)
		// compensate for any additional adjustment we made
		if(offset_x)
			offset_x -= parent_structure.pixel_x
		else if(offset_y)
			offset_y -= parent_structure.pixel_y

	// Block movement into parent, but swing around instead
	if(offset_x)
		if(offset_x > 0)
			if(new_direction & WEST)
				var/extra_offset = additional_offset ? parent_structure.pixel_y : 0
				animate(mob, time = animate_time, pixel_x = initial(mob.pixel_x), pixel_y = mob.pixel_y + west_offset + extra_offset)
				. = COMPONENT_CANCEL_MOVE
		else
			if(new_direction & EAST)
				var/extra_offset = additional_offset ? parent_structure.pixel_y : 0
				animate(mob, time = animate_time, pixel_x = initial(mob.pixel_x), pixel_y = mob.pixel_y + east_offset + extra_offset)
				. = COMPONENT_CANCEL_MOVE
	else if(offset_y)
		if(offset_y > 0)
			if(new_direction & SOUTH)
				var/extra_offset = additional_offset ? parent_structure.pixel_x : 0
				animate(mob, time = animate_time, pixel_y = initial(mob.pixel_y), pixel_x = mob.pixel_x + south_offset + extra_offset)
				. = COMPONENT_CANCEL_MOVE
		else
			if(new_direction & NORTH)
				var/extra_offset = additional_offset ? parent_structure.pixel_x : 0
				animate(mob, time = animate_time, pixel_y = initial(mob.pixel_y), pixel_x = mob.pixel_x + north_offset + extra_offset)
				. = COMPONENT_CANCEL_MOVE

	// If we are swinging them around, so set dir, delay, and layer as needed
	if(. == COMPONENT_CANCEL_MOVE)
		source.dir = new_direction
		if(extra_delay && mob.client)
			mob.client.move_delay += extra_delay
		var/desired_layer = round(parent_structure.layer + 0.05, 0.01) // Byond floats are garbage
		if(desired_layer == XENO_HIDING_LAYER)
			desired_layer += 0.01
		var/layer_changing = mob.plane == parent_structure.plane && (new_direction & approach_dirs_layer_override) && initial(mob.layer) < desired_layer
		if(layer_changing)
			RegisterSignal(mob, COMSIG_LIVING_SHIMMY_LAYER, PROC_REF(on_mob_shimmy_layer), override = TRUE) // Override because we're just ensuring its set if not already set
			if(mob.layer == XENO_HIDING_LAYER && isxeno(mob))
				var/datum/action/xeno_action/onclick/xenohide/hide = get_action(mob, /datum/action/xeno_action/onclick/xenohide)
				if(hide)
					hide.post_attack()
			mob.layer = desired_layer
		else
			UnregisterSignal(mob, COMSIG_LIVING_SHIMMY_LAYER)
			if(mob.layer != XENO_HIDING_LAYER || !isxeno(mob))
				mob.layer = initial(mob.layer)

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

#undef MAX_ANIMATE_TIME
