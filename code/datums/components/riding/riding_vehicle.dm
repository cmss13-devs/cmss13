// TG code for vehicles, maybe move our vehicles over to this some day

/datum/component/riding/vehicle/Initialize(mob/living/riding_mob, force = FALSE, ride_check_flags = (RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS))
	if(!isVehicle(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/riding/vehicle/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE, PROC_REF(driver_move))

/datum/component/riding/vehicle/driver_move(atom/movable/movable_parent, mob/living/user, direction)
	if(!COOLDOWN_FINISHED(src, vehicle_move_cooldown))
		return COMPONENT_DRIVER_BLOCK_MOVE
	var/obj/vehicle/vehicle_parent = parent

	if(!keycheck(user))
		if(COOLDOWN_FINISHED(src, message_cooldown))
			to_chat(user, SPAN_WARNING("[vehicle_parent] has no key inserted!"))
			COOLDOWN_START(src, message_cooldown, 5 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE

	if(HAS_TRAIT(user, TRAIT_INCAPACITATED))
		if(ride_check_flags & UNBUCKLE_DISABLED_RIDER)
			vehicle_parent.unbuckle(user, TRUE)
			user.visible_message(SPAN_DANGER("[user] falls off [vehicle_parent]."),\
			SPAN_DANGER("You slip off [vehicle_parent] as your body slumps!"))
			user.Stun(3 SECONDS)

		if(COOLDOWN_FINISHED(src, message_cooldown))
			to_chat(user, SPAN_WARNING("You cannot operate [vehicle_parent] right now!"))
			COOLDOWN_START(src, message_cooldown, 5 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE

	if(ride_check_flags & RIDER_NEEDS_LEGS && HAS_TRAIT(user, TRAIT_FLOORED))
		if(ride_check_flags & UNBUCKLE_DISABLED_RIDER)
			vehicle_parent.unbuckle(user, TRUE)
			user.visible_message(SPAN_DANGER("[user] falls off [vehicle_parent]."),\
			SPAN_DANGER("You fall off [vehicle_parent] while trying to operate it while unable to stand!"))
			user.Stun(3 SECONDS)

		if(COOLDOWN_FINISHED(src, message_cooldown))
			to_chat(user, SPAN_WARNING("You can't seem to manage that while unable to stand up enough to move [vehicle_parent]..."))
			COOLDOWN_START(src, message_cooldown, 5 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE

	if(ride_check_flags & RIDER_NEEDS_ARMS && user.is_mob_restrained())
		if(ride_check_flags & UNBUCKLE_DISABLED_RIDER)
			vehicle_parent.unbuckle(user, TRUE)
			user.visible_message(SPAN_DANGER("[user] falls off [vehicle_parent]."),\
			SPAN_DANGER("You fall off [vehicle_parent] while trying to operate it without being able to hold on!"))
			user.Stun(3 SECONDS)

		if(COOLDOWN_FINISHED(src, message_cooldown))
			to_chat(user, SPAN_WARNING("You can't seem to hold onto [vehicle_parent] to move it..."))
			COOLDOWN_START(src, message_cooldown, 5 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE

	handle_ride(user, direction)

/// This handles the actual movement for vehicles once [/datum/component/riding/vehicle/proc/driver_move] has given us the green light
/datum/component/riding/vehicle/proc/handle_ride(mob/user, direction)
	var/atom/movable/movable_parent = parent

	var/turf/next = get_step(movable_parent, direction)
	var/turf/current = get_turf(movable_parent)
	if(!next || !current)
		return //not happening.
	if(!turf_check(next, current))
		to_chat(user, SPAN_WARNING("[movable_parent] can not go onto [next]!"))
		return
	if(!isturf(movable_parent.loc))
		return

	step(movable_parent, direction)
	COOLDOWN_START(src, vehicle_move_cooldown, vehicle_move_delay)

	if(QDELETED(src))
		return
	handle_vehicle_layer(movable_parent.dir)
	return TRUE

