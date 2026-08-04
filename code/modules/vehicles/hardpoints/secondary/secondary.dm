/obj/item/hardpoint/secondary
	name = "secondary hardpoint"
	desc = "Smaller support gun."

	slot = HDPT_SECONDARY

	damage_multiplier = 0.125

	activatable = TRUE
	// draws above wheels.
	hdpt_layer = HDPT_LAYER_TURRET

/**
 * Accuracy/scatter now depend on this weapon's own raw integrity.
 * Also refreshes this secondary's slaved turn rate if it's currently active.
 */
/obj/item/hardpoint/secondary/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	. = ..()
	if(owner)
		recalculate_hardpoint_bonuses()
	recalculate_slaved_turn_rate()
	recalculate_own_turn_rate()

/obj/item/hardpoint/secondary/recalculate_wound_effects()
	. = ..()
	recalculate_slaved_turn_rate()
	recalculate_own_turn_rate()

/// Slows fire rate by SECONDARY_SLAVED_COOLDOWN_MULT while this secondary is slaved to the driver.
/obj/item/hardpoint/secondary/recalculate_hardpoint_bonuses()
	. = ..()
	if(!self_gimballed)
		return
	set_fire_delay(fire_delay * SECONDARY_SLAVED_COOLDOWN_MULT)
	set_burst_delay(burst_delay * SECONDARY_SLAVED_COOLDOWN_MULT)
	extra_delay *= SECONDARY_SLAVED_COOLDOWN_MULT

/**
 * Refreshes max_angular_velocity for a slaved-to-driver secondary from its own current integrity.
 * No-ops if not slaved. Floored at the absolute minimum unless fully destroyed.
 */
/obj/item/hardpoint/secondary/proc/recalculate_slaved_turn_rate()
	if(!self_gimballed || !owner)
		return
	var/health_scale = get_own_health_scale()
	max_angular_velocity = max(TURRET_BASE_ANGULAR_VELOCITY * (traverse_arc / TURRET_ARC_NORMALIZATION), TURRET_MIN_ANGULAR_VELOCITY) * health_scale
	if(health_scale > 0)
		max_angular_velocity = max(max_angular_velocity, TURRET_ABSOLUTE_MIN_ANGULAR_VELOCITY)

/// Toggles control of this secondary between the gunner and the driver (self-gimballed, independent mouse-aim).
/obj/item/hardpoint/secondary/proc/toggle_slaved_to_driver(mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src]'s controls are busted!"))
		return
	if(!owner || !traverse_arc)
		return

	self_gimballed = !self_gimballed
	SEND_SIGNAL(src, COMSIG_GUN_INTERRUPT_FIRE)
	recalculate_hardpoint_bonuses()

	if(self_gimballed)
		allowed_seat = VEHICLE_DRIVER
		recalculate_slaved_turn_rate()
		current_angle = dir2angle(dir)
		desired_angle = current_angle
		angular_velocity = 0
		rotation_active = FALSE

		to_chat(user, SPAN_NOTICE("You slave \the [src]'s controls to the driver's seat."))
		var/mob/driver = owner.seats[VEHICLE_DRIVER]
		if(driver)
			to_chat(driver, SPAN_NOTICE("\The [src] has been slaved to your controls. Use \"Cycle Active Hardpoint\" to select it."))
	else
		allowed_seat = initial(allowed_seat)

		current_angle = dir2angle(dir)
		desired_angle = current_angle
		angular_velocity = 0
		rotation_active = FALSE

		to_chat(user, SPAN_NOTICE("You return \the [src]'s controls to the gunner's seat."))

	// Re-picks a valid active hardpoint for whichever seat just lost its selected pick.
	owner.ensure_active_hardpoint(VEHICLE_GUNNER)
	owner.ensure_active_hardpoint(VEHICLE_DRIVER)
