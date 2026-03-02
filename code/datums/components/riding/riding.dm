/**
 * This is the riding component, which is applied to a movable atom by the [ridable element][/datum/element/ridable] when a mob is successfully buckled to said movable.
 *
 * This component lives for as long as at least one mob is buckled to the parent. Once all mobs are unbuckled, the component is deleted, until another mob is buckled in
 * and we make a new riding component, so on and so forth until the sun explodes.
 */
/datum/component/riding
	dupe_mode = COMPONENT_DUPE_UNIQUE
	///tick delay between movements, lower = faster, higher = slower
	var/vehicle_move_delay = 2

	/**
	 * If the driver needs a certain item in hand (or inserted, for vehicles) to drive this. For vehicles, this must be duplicated on the actual vehicle object in their
	 * [/obj/vehicle/var/key_type] variable because the vehicle objects still have a few special checks/functions of their own I'm not porting over to the riding component
	 * quite yet. Make sure if you define it on the vehicle, you define it here too.
	 */
	var/keytype

	/// position_of_user = list(dir = list(px, py)), or RIDING_OFFSET_ALL for a generic one.
	var/list/riding_offsets = list()
	/// ["[DIRECTION]"] = layer. Don't set it for a direction for default, set a direction to null for no change.
	var/list/directional_vehicle_layers = list()
	/// same as above but instead of layer you have a list(px, py)
	var/list/directional_vehicle_offsets = list()
	/// allow typecache for only certain turfs, forbid to allow all but those. allow only certain turfs will take precedence.
	var/list/allowed_turf_typecache
	/// allow typecache for only certain turfs, forbid to allow all but those. allow only certain turfs will take precedence.
	var/list/forbid_turf_typecache

	/**
	 * Ride check flags defined for the specific riding component types, so we know if we need arms, legs, or whatever.
	 * Takes additional flags from the ridable element and the buckle proc (buckle_mob_flags) for riding cyborgs/humans in case we need to reserve arms
	 */
	var/ride_check_flags = NONE
	/// For telling someone they can't drive
	COOLDOWN_DECLARE(message_cooldown)
	/// For telling someone they can't drive
	COOLDOWN_DECLARE(vehicle_move_cooldown)


/datum/component/riding/Initialize(mob/living/riding_mob, force = FALSE, check_loc, lying_buckle, hands_needed, target_hands_needed, silent)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	handle_specials()
	ride_check_flags |= args_to_flags(check_loc, lying_buckle, hands_needed, target_hands_needed)//buckle_mob_flags

///converts buckle args to their flags. We use this proc since I dont want to add a buckle refactor to this riding refactor port
/datum/component/riding/proc/args_to_flags(check_loc, lying_buckle, hands_needed, target_hands_needed)
	if(!lying_buckle)
		. = UNBUCKLE_DISABLED_RIDER
	if(hands_needed == 1)
		. |= RIDER_NEEDS_ARM
	else if(hands_needed > 1)
		. |= RIDER_NEEDS_ARMS
	if(target_hands_needed)
		. |= CARRIER_NEEDS_ARM

/datum/component/riding/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(vehicle_turned))
	RegisterSignal(parent, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(handle_mob_move_or_look))
	RegisterSignal(parent, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(vehicle_mob_unbuckle))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(vehicle_moved))

/// This proc handles all of the proc calls to things like set_vehicle_dir_layer() that a type of riding datum needs to call on creation
/datum/component/riding/proc/handle_specials()
	return

/// This proc is called when a rider unbuckles, whether they chose to or not. If there's no more riders, this will be the riding component's death knell.
/datum/component/riding/proc/vehicle_mob_unbuckle(datum/source, force = FALSE)
	SIGNAL_HANDLER

	var/atom/movable/movable_parent = parent
	for(var/mob/mob in movable_parent.buckled_mobs)
		restore_position(mob)
		unequip_buckle_inhands(mob)
		DISABLE_BITFIELD(mob.flags_atom, NO_ZFALL)
	if(LAZYLEN(movable_parent.buckled_mobs) == 1) // mob removal from buckled_mob happens after this signal, so the list will be empty if only 1 mob is in it
		qdel(src)
	UnregisterSignal(movable_parent, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(handle_mob_move_or_look))

/// Some ridable atoms may want to only show on top of the rider in certain directions
/datum/component/riding/proc/handle_vehicle_layer(dir)
	var/atom/movable/movable_parent = parent
	var/static/list/defaults = list(TEXT_NORTH = OBJ_LAYER, TEXT_SOUTH = ABOVE_MOB_LAYER, TEXT_EAST = ABOVE_MOB_LAYER, TEXT_WEST = ABOVE_MOB_LAYER)
	. = defaults["[dir]"]
	if(directional_vehicle_layers["[dir]"])
		. = directional_vehicle_layers["[dir]"]
	if(isnull(.)) //you can set it to null to not change it.
		. = movable_parent.layer
	movable_parent.layer = .

/datum/component/riding/proc/set_vehicle_dir_layer(dir, layer)
	directional_vehicle_layers["[dir]"] = layer

/// This is called after the ridden atom is successfully moved and is used to handle icon stuff
/datum/component/riding/proc/vehicle_moved(datum/source, oldloc, dir, forced)
	SIGNAL_HANDLER

	var/atom/movable/movable_parent = parent
	if(isnull(dir))
		dir = movable_parent.dir
	for(var/mob/buckled_mob as anything in movable_parent.buckled_mobs)
		buckled_mob.setDir(dir)
		ride_check(buckled_mob)
	if(QDELETED(src))
		return // runtimed with piggy's without this, look into this more
	handle_vehicle_layer(dir)

/// Turning is like moving
/datum/component/riding/proc/vehicle_turned(datum/source, _old_dir, new_dir)
	SIGNAL_HANDLER

	vehicle_moved(source, _old_dir, new_dir)

/datum/component/riding/proc/handle_mob_move_or_look(mob/living/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	vehicle_moved(mover, dir = direction)

/// Check to see if we have all of the necessary bodyparts and not-falling-over statuses we need to stay onboard
/datum/component/riding/proc/ride_check(mob/living/rider)
	return

/**
 * This proc is used to see if we have the appropriate key to drive this atom, if such a key is needed. Returns FALSE if we don't have what we need to drive.
 *
 * Still needs to be neatened up and spruced up with proper OOP, as a result of vehicles having their own key handling from other ridable atoms
 */
/datum/component/riding/proc/keycheck(mob/user)
	if(!keytype)
		return TRUE

	return user.is_holding_item_of_type(keytype, mainhand=FALSE)

//BUCKLE HOOKS
/datum/component/riding/proc/restore_position(mob/living/buckled_mob)
	if(!buckled_mob)
		return
	buckled_mob.pixel_x = initial(buckled_mob.pixel_x)//buckled_mob.base_pixel_x
	buckled_mob.pixel_y = initial(buckled_mob.pixel_y)//buckled_mob.base_pixel_y
	buckled_mob.client?.view = 7

//MOVEMENT
/datum/component/riding/proc/turf_check(turf/next, turf/current)
	if(allowed_turf_typecache && !allowed_turf_typecache[next.type])
		return allowed_turf_typecache[current.type]
	else if(forbid_turf_typecache && forbid_turf_typecache[next.type])
		return !forbid_turf_typecache[current.type]
	return TRUE

/// Every time the driver tries to move, this is called to see if they can actually drive and move the vehicle (via relaymove)
/datum/component/riding/proc/driver_move(atom/movable/movable_parent, mob/living/user, direction)
	SIGNAL_HANDLER
	return

/// So we can check all occupants when we bump a door to see if anyone has access
/datum/component/riding/proc/vehicle_bump(atom/movable/movable_parent, obj/structure/machinery/door/possible_bumped_door)
	SIGNAL_HANDLER
	if(!istype(possible_bumped_door))
		return
	for(var/occupant in movable_parent.buckled_mob)
		INVOKE_ASYNC(possible_bumped_door, TYPE_PROC_REF(/obj/structure/machinery/door, bumpopen), occupant)

/// currently replicated from ridable because we need this behavior here too, see if we can deal with that
/datum/component/riding/proc/unequip_buckle_inhands(mob/living/carbon/user)
	for(var/obj/item/riding_offhand/reins in user)
		if(reins.selfdeleting)
			continue
		qdel(reins)
	return TRUE
