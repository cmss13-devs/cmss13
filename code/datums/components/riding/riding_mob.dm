/// Variant of /datum/component/riding specifically for living mobs
/datum/component/riding/creature
	/// If TRUE, this creature's movements can be controlled by the rider while mounted (as opposed to player controlled mobs, which is passive)
	var/can_be_driven = TRUE


/datum/component/riding/creature/Initialize(mob/living/riding_mob, force = FALSE, check_loc, lying_buckle, hands_needed, target_hands_needed, silent)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	. = ..()
	var/mob/living/living_parent = parent
	living_parent.stop_pulling()
	ENABLE_BITFIELD(riding_mob.flags_atom, NO_ZFALL)
	log_riding(living_parent, riding_mob)
	riding_mob.glide_size = living_parent.glide_size

	if(isanimal(parent))
		var/mob/living/simple_animal/simple_parent = parent
		simple_parent.stop_automated_movement = TRUE

/datum/component/riding/creature/Destroy(force, silent)
	unequip_buckle_inhands(parent)
	if(isanimal(parent))
		var/mob/living/simple_animal/simple_parent = parent
		simple_parent.stop_automated_movement = FALSE
	return ..()

/datum/component/riding/creature/RegisterWithParent()
	. = ..()
	if(can_be_driven)
		RegisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE, PROC_REF(driver_move)) // this isn't needed on player controlled mobs since the rider can't control them

/// Creatures need to be logged when being mounted
/datum/component/riding/creature/proc/log_riding(mob/living/living_parent, mob/living/rider)
	if(!istype(living_parent) || !istype(rider))
		return

	log_interact(rider, living_parent, "[rider] started riding [living_parent]")

/datum/component/riding/creature/ride_check(mob/living/rider)
	var/mob/living/living_parent = parent

	var/kick_us_off
	if(HAS_TRAIT_FROM(living_parent, TRAIT_UNDENSE, LYING_DOWN_TRAIT)) // if we move while on the ground, the rider falls off
		kick_us_off = TRUE
	// check if the rider is stunned/restrained
	else if((ride_check_flags & RIDER_NEEDS_ARMS) && (rider.grab_level == GRAB_CHOKE || rider.is_mob_incapacitated(TRUE)))
		kick_us_off = TRUE
	// check if the ridden is stunned/restrained
	else if((ride_check_flags & CARRIER_NEEDS_ARM) && (rider.grab_level == GRAB_CHOKE || living_parent.is_mob_incapacitated(TRUE)))
		kick_us_off = TRUE

	if(!kick_us_off)
		return TRUE

	rider.visible_message(SPAN_WARNING("[rider] falls off of [living_parent]!"), \
					SPAN_WARNING("You fall off of [living_parent]!"))
	rider.KnockOut(1)
	rider.KnockDown(4)
	living_parent.unbuckle(rider)

/datum/component/riding/creature/vehicle_mob_unbuckle(mob/living/living_parent, force = FALSE)
	log_interact(usr, living_parent, "[usr] is no longer riding [living_parent]")
	return ..()

/datum/component/riding/creature/driver_move(atom/movable/movable_parent, mob/living/user, direction)
	if(!COOLDOWN_FINISHED(src, vehicle_move_cooldown))
		return COMPONENT_DRIVER_BLOCK_MOVE
	if(!keycheck(user))
		if(ispath(keytype, /obj/item))
			var/obj/item/key = keytype
			to_chat(user, SPAN_WARNING("You need a [initial(key.name)] to ride [movable_parent]!"))
		return COMPONENT_DRIVER_BLOCK_MOVE
	var/mob/living/living_parent = parent
	step(living_parent, direction)
	COOLDOWN_START(src, vehicle_move_cooldown, vehicle_move_delay)

/// Yeets the rider off
/datum/component/riding/creature/proc/force_dismount(mob/living/rider, gentle = FALSE)
	var/atom/movable/movable_parent = parent
	movable_parent.unbuckle(rider)

	if(!isanimal(movable_parent))
		return

	var/turf/target = get_edge_target_turf(movable_parent, movable_parent.dir)
	var/turf/targetm = get_step(get_turf(movable_parent), movable_parent.dir)
	rider.Move(targetm)
	rider.KnockDown(3)
	if(gentle)
		rider.visible_message(SPAN_WARNING("[rider] is thrown clear of [movable_parent]!"), \
		SPAN_WARNING("You're thrown clear of [movable_parent]!"))
		rider.throw_atom(target, 3, SPEED_FAST, movable_parent)
	else
		rider.visible_message(SPAN_WARNING("[rider] is thrown violently from [movable_parent]!"), \
		SPAN_WARNING("You're thrown violently from [movable_parent]!"))
		rider.throw_atom(target, 5, SPEED_FAST, movable_parent)

/datum/component/riding/creature/proc/check_carrier_fall_over(mob/living/carbon/carrying)
	SIGNAL_HANDLER

	for(var/mob/living/rider in carrying.buckled_mobs)
		carrying.unbuckle(rider)
		rider.KnockDown(1)
		carrying.visible_message(SPAN_DANGER("[rider] topples off of [carrying] as they both fall to the ground!"), \
					SPAN_DANGER("You fall to the ground, bringing [rider] with you!</span>"), \
					"You hear two consecutive thuds.")


/datum/component/riding/creature/runner
	can_be_driven = FALSE

/datum/component/riding/creature/runner/Initialize(mob/living/riding_mob, force = FALSE, check_loc, lying_buckle, hands_needed, target_hands_needed, silent)
	. = ..()
	riding_mob.density = FALSE

/datum/component/riding/creature/runner/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_LIVING_SET_LYING_ANGLE, PROC_REF(check_carrier_fall_over))

/datum/component/riding/creature/runner/vehicle_mob_unbuckle(datum/source, force = FALSE)
	var/mob/living/ridden = parent
	for(var/mob/mob in ridden.buckled_mobs)
		unequip_buckle_inhands(mob)
	ridden.density = TRUE
	return ..()

/datum/component/riding/creature/runner/handle_specials()
	. = ..()
	set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
	set_vehicle_dir_layer(NORTH, ABOVE_MOB_LAYER)
	set_vehicle_dir_layer(EAST, ABOVE_LYING_MOB_LAYER)
	set_vehicle_dir_layer(WEST, ABOVE_LYING_MOB_LAYER)

/datum/component/riding/creature/runner/check_carrier_fall_over(mob/living/carbon/xenomorph/runner/carrying_runner)
	for(var/mob/living/rider in carrying_runner.buckled_mobs)
		carrying_runner.unbuckle(rider)
		rider.KnockDown(1)
		carrying_runner.visible_message(SPAN_DANGER("[rider] topples off of [carrying_runner] as they both fall to the ground!"), \
					SPAN_DANGER("You fall to the ground, bringing [rider] with you!"), SPAN_NOTICE("You hear two consecutive thuds."))
		to_chat(rider, SPAN_DANGER("[carrying_runner] falls to the ground, bringing you with [carrying_runner.p_them()]!"))
