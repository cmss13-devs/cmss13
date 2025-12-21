// For any mob that can be ridden

/datum/component/riding/creature
	/// If TRUE, this creature's movements can be controlled by the rider while mounted (as opposed to riding cyborgs and humans, which is passive)
	var/can_be_driven = TRUE


/datum/component/riding/creature/Initialize(mob/living/riding_mob, force = FALSE, check_loc, lying_buckle, hands_needed, target_hands_needed, silent)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	. = ..()
	var/mob/living/living_parent = parent
	living_parent.stop_pulling() // was only used on humans previously, may change some other behavior
	log_riding(living_parent, riding_mob)
	riding_mob.glide_size = living_parent.glide_size
	handle_vehicle_offsets(living_parent.dir)

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
		RegisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE, PROC_REF(driver_move)) // this isn't needed on riding humans or cyborgs since the rider can't control them

/// Creatures need to be logged when being mounted
/datum/component/riding/creature/proc/log_riding(mob/living/living_parent, mob/living/rider)
	if(!istype(living_parent) || !istype(rider))
		return

	msg_admin_attack("[living_parent] is now being ridden by [rider]", living_parent.loc.x, living_parent.loc.y, living_parent.loc.z)
	msg_admin_attack("[rider] started riding [living_parent]", rider.loc.x, rider.loc.y, rider.loc.z)

// this applies to humans and most creatures, but is replaced again for cyborgs
/datum/component/riding/creature/ride_check(mob/living/rider)
	var/mob/living/living_parent = parent

	var/kick_us_off
	if(LYING_DOWN_TRAIT in living_parent._status_traits) // if we move while on the ground, the rider falls off
		kick_us_off = TRUE
	// for piggybacks and (redundant?) borg riding, check if the rider is stunned/restrained
	else if((ride_check_flags & RIDER_NEEDS_ARMS) && (rider.grab_level == GRAB_CHOKE || rider.is_mob_incapacitated(TRUE)))
		kick_us_off = TRUE
	// for fireman carries, check if the ridden is stunned/restrained
	else if((ride_check_flags & CARRIER_NEEDS_ARM) && (rider.grab_level == GRAB_CHOKE || living_parent.is_mob_incapacitated(TRUE)))
		kick_us_off = TRUE

	if(!kick_us_off)
		return TRUE

	rider.visible_message("<span class='warning'>[rider] falls off of [living_parent]!</span>", \
					"<span class='warning'>You fall off of [living_parent]!</span>")
	rider.KnockOut(1)
	rider.KnockDown(4)
	living_parent.unbuckle(rider)

/datum/component/riding/creature/vehicle_mob_unbuckle(mob/living/living_parent, mob/living/former_rider, force = FALSE)
	if(istype(living_parent) && istype(former_rider))
		msg_admin_attack("[living_parent] is no longer being ridden by [former_rider]", living_parent.loc.x, living_parent.loc.y, living_parent.loc.z)
		msg_admin_attack("[former_rider] is no longer riding [living_parent]", former_rider.loc.x, former_rider.loc.y, former_rider.loc.z)
	return ..()

/datum/component/riding/creature/driver_move(atom/movable/movable_parent, mob/living/user, direction)
	if(!COOLDOWN_FINISHED(src, vehicle_move_cooldown))
		return COMPONENT_DRIVER_BLOCK_MOVE
	if(!keycheck(user))
		if(ispath(keytype, /obj/item))
			var/obj/item/key = keytype
			to_chat(user, "<span class='warning'>You need a [initial(key.name)] to ride [movable_parent]!</span>")
		return COMPONENT_DRIVER_BLOCK_MOVE
	var/mob/living/living_parent = parent
	var/turf/next = get_step(living_parent, direction)
	step(living_parent, direction)
	last_move_diagonal = ((direction & (direction - 1)) && (living_parent.loc == next))
	COOLDOWN_START(src, vehicle_move_cooldown, (last_move_diagonal? 2 : 1) * vehicle_move_delay)

/// Yeets the rider off, used for animals and cyborgs, redefined for humans who shove their piggyback rider off
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
		rider.visible_message("<span class='warning'>[rider] is thrown clear of [movable_parent]!</span>", \
		"<span class='warning'>You're thrown clear of [movable_parent]!</span>")
		rider.throw_atom(target, 8, 3, movable_parent)
	else
		rider.visible_message("<span class='warning'>[rider] is thrown violently from [movable_parent]!</span>", \
		"<span class='warning'>You're thrown violently from [movable_parent]!</span>")
		rider.throw_atom(target, 14, 5, movable_parent)

/datum/component/riding/creature/proc/check_carrier_fall_over(mob/living/carbon/carrying)
	SIGNAL_HANDLER

	for(var/mob/living/rider in carrying.buckled_mobs)
		carrying.unbuckle(rider)
		rider.KnockDown(1)
		carrying.visible_message("<span class='danger'>[rider] topples off of [carrying] as they both fall to the ground!</span>", \
					"<span class='warning'>You fall to the ground, bringing [rider] with you!</span>", "<span class='hear'>You hear two consecutive thuds.</span>")
		to_chat(rider, "<span class='danger'>[carrying] falls to the ground, bringing you with [carrying.p_them()]!</span>")


/datum/component/riding/creature/runner
	can_be_driven = FALSE

/datum/component/riding/creature/runner/Initialize(mob/living/riding_mob, force = FALSE, check_loc, lying_buckle, hands_needed, target_hands_needed, silent)
	. = ..()
	riding_mob.density = FALSE

/datum/component/riding/creature/runner/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_LIVING_SET_LYING_ANGLE, PROC_REF(check_carrier_fall_over))

/datum/component/riding/creature/runner/vehicle_mob_unbuckle(datum/source, mob/living/former_rider, force = FALSE)
	unequip_buckle_inhands(parent)
	former_rider.density = TRUE
	return ..()

/datum/component/riding/creature/runner/get_offsets(pass_index, mob_type) // list(dir = x, y, layer)
	. = list(TEXT_NORTH = list(0, 0), TEXT_SOUTH = list(0, 0), TEXT_EAST = list(0, 0), TEXT_WEST = list(0, 0))
	if (riding_offsets["[mob_type]"])
		. = riding_offsets["[mob_type]"]
	else if(riding_offsets["[RIDING_OFFSET_ALL]"])
		. = riding_offsets["[RIDING_OFFSET_ALL]"]

/datum/component/riding/creature/runner/handle_specials()
	. = ..()
	set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 8), TEXT_SOUTH = list(0, 6), TEXT_EAST = list(5, 8), TEXT_WEST = list(-5, 8)))
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
