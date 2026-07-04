/obj/item/hardpoint/secondary
	name = "secondary hardpoint"
	desc = "Smaller support gun."

	slot = HDPT_SECONDARY

	damage_multiplier = 0.125

	activatable = TRUE

/**
 * Toggles control of this secondary between the gunner (default,, follows the turret's shared
 * rotation like any other mounted weapon) and the driver (self-gimballed, its own independent unrestricted 360-degree mouse-aim
 */
/obj/item/hardpoint/secondary/proc/toggle_slaved_to_driver(mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src]'s controls are busted!"))
		return

	var/obj/item/hardpoint/holder/tank_turret/turret = loc
	if(!istype(turret))
		return

	self_gimballed = !self_gimballed
	SEND_SIGNAL(src, COMSIG_GUN_INTERRUPT_FIRE)

	if(self_gimballed)
		allowed_seat = VEHICLE_DRIVER
		max_angular_velocity = max(TURRET_BASE_ANGULAR_VELOCITY * (traverse_arc / TURRET_ARC_NORMALIZATION), TURRET_MIN_ANGULAR_VELOCITY)
		current_angle = dir2angle(dir)
		desired_angle = current_angle
		angular_velocity = 0
		rotation_active = FALSE

		if(owner.active_hp[VEHICLE_GUNNER] == src)
			owner.active_hp[VEHICLE_GUNNER] = null

		to_chat(user, SPAN_NOTICE("You slave \the [src]'s controls to the driver's seat."))
		var/mob/driver = owner.seats[VEHICLE_DRIVER]
		if(driver)
			to_chat(driver, SPAN_NOTICE("\The [src] has been slaved to your controls. Use \"Cycle Active Hardpoint\" to select it."))
	else
		allowed_seat = initial(allowed_seat)

		if(owner.active_hp[VEHICLE_DRIVER] == src)
			owner.active_hp[VEHICLE_DRIVER] = null

		// dir already always mirrors the turret's own (unaffected by self_gimballed) so just settle current_angle back to zero swivel.
		current_angle = dir2angle(dir)
		desired_angle = current_angle
		angular_velocity = 0
		rotation_active = FALSE

		to_chat(user, SPAN_NOTICE("You return \the [src]'s controls to the gunner's seat."))
