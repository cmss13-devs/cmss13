/*
 * Hull-destruction grand finale: an optional ammo-cookoff sequence a vehicle opts into by having
 * its own on_hull_destroyed() override (hardpoint_wounds.dm) call start_hull_cookoff_sequence().
 * A vehicle that never overrides on_hull_destroyed() just goes inert once its hull reaches 0 health.
 */

/**
 * Stops the vehicle dead, plays a hissing warning, and gives everyone a chance to clear out before
 * resolve_hull_destruction_sequence() detonates. Guarded by hull_destroyed_sequence_started since
 * this can otherwise fire again on every subsequent hit.
 */
/obj/vehicle/multitile/proc/start_hull_cookoff_sequence()
	if(hull_destroyed_sequence_started)
		return
	hull_destroyed_sequence_started = TRUE

	move_momentum = 0
	drift_speed = 0
	current_speed = 0
	set_engine_on(FALSE)

	visible_message("<span style='font-size: 1.15em'>[SPAN_HIGHDANGER("\The [src] lets out a violent hiss from somewhere deep inside - it's about to cook off!")]</span>")
	playsound(src, 'sound/effects/pipe_hissing10s.ogg', vol = 40)
	warn_cookoff_passengers()
	// The on-screen banner fades out before the countdown ends, so repeat it at this cadence.
	for(var/elapsed = hull_cookoff_passenger_warning_interval, elapsed < hull_cookoff_warning_time, elapsed += hull_cookoff_passenger_warning_interval)
		addtimer(CALLBACK(src, PROC_REF(warn_cookoff_passengers)), elapsed)

	var/obj/effect/warning/explosive/warning = new(get_turf(src), hull_cookoff_warning_time)
	// Scoped to just this instance so only the cookoff warning icon can mount on the vehicle.
	warning.is_allowed_atop_vehicle = TRUE
	// Same per-instance scoping, a hull-cookoff crash shouldn't fling its own warning icon off the vehicle.
	warning.immune_to_tank_crash_scatter = TRUE
	obj_mark_on_top(warning)

	// Bumped above the vehicle's own sprite and the warning-phase flame/fireball so draw order isn't left to chance.
	warning.layer = HULL_COOKOFF_WARNING_ICON_LAYER

	ignite_cookoff_warning_flame(get_turf(src))

	addtimer(CALLBACK(src, PROC_REF(resolve_hull_destruction_sequence)), hull_cookoff_warning_time)

/**
 * A single tile of regular napalm lit at the start of the countdown
 */
/obj/vehicle/multitile/proc/ignite_cookoff_warning_flame(turf/epicenter)
	var/datum/cause_data/fire_cause = create_cause_data("vehicle ammunition cookoff")
	new /obj/flamer_fire(epicenter, fire_cause, new /datum/reagent/napalm/ut())
	raise_cookoff_fire_layer(epicenter, hull_cookoff_warning_flame_radius)
	addtimer(CALLBACK(src, PROC_REF(raise_cookoff_fire_layer), epicenter, hull_cookoff_warning_flame_radius), 3)

/// Warns everyone inside the interior that the cookoff is coming, with both a chat message and an on-screen banner.
/obj/vehicle/multitile/proc/warn_cookoff_passengers()
	for(var/mob/living/passenger in get_passengers())
		to_chat(passenger, SPAN_BOLDWARNING("\The [src] is about to cook off - get out NOW!"))
		passenger.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>HULL BREACH IMMINENT</u></span><br>GET OUT NOW!", /atom/movable/screen/text/screen_text/command_order, "#ff3b3b", TRUE)

/**
 * The actual detonation, hull_cookoff_warning_time after start_hull_cookoff_sequence() started the countdown.
 * Whoever's still trapped inside takes a separate, contained explosion and spreading napalm fire, since the exterior blast can't reach it.
 * The exterior takes a hit sized to hull_cookoff_exterior_power, every hardpoint is zeroed, and launch_special_wreckage() gets a chance to eject anything worth ejecting.
 * The hull itself is never qdel'd, it's meant to remain a permanent wreck sitting on the map.
 */
/obj/vehicle/multitile/proc/resolve_hull_destruction_sequence()
	var/list/mob/living/trapped = get_passengers()
	if(length(trapped))
		var/turf/interior_epicenter = interior.get_middle_turf()
		var/datum/cause_data/interior_cause = create_cause_data("vehicle ammunition cookoff")
		cell_explosion(interior_epicenter, hull_cookoff_interior_power, hull_cookoff_interior_falloff, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, interior_cause)
		fire_spread(interior_epicenter, interior_cause, 2, new /datum/reagent/napalm/ut())

	// The hull is a total wreck by this point, so its own explosive resistance shouldn't block its own detonation.
	explosive_resistance = 0

	var/turf/epicenter = get_turf(src)
	cell_explosion(epicenter, hull_cookoff_exterior_power, hull_cookoff_exterior_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("vehicle ammunition cookoff"))
	ignite_cookoff_fireball(epicenter)

	destroy_all_hardpoints()

	if(!is_mainship_level(z))
		launch_special_wreckage()

	update_icon()

/**
 * Ignites a fireball at the vehicle's own turf. Bumped up to ride atop it.
 */
/obj/vehicle/multitile/proc/ignite_cookoff_fireball(turf/epicenter)
	var/datum/cause_data/fire_cause = create_cause_data("vehicle ammunition cookoff")
	flame_radius(fire_cause, hull_cookoff_fire_radius, epicenter, BURN_TIME_TIER_5 + 5, BURN_LEVEL_TIER_4, FLAMESHAPE_DEFAULT, null, FIRE_VARIANT_TYPE_B)
	raise_cookoff_fire_layer(epicenter, hull_cookoff_fire_radius)
	addtimer(CALLBACK(src, PROC_REF(raise_cookoff_fire_layer), epicenter, hull_cookoff_fire_radius), 3)

/// Bumps every /obj/flamer_fire within `radius` tiles of epicenter up to TANK_ABOVE_RIDER_LAYER, and marks any that landed on this vehicle's own footprint as riding along with it (see obj_mark_on_top(), multitile_riding.dm) so a subsequent push/shove carries the fire along instead of leaving it behind.
/obj/vehicle/multitile/proc/raise_cookoff_fire_layer(turf/epicenter, radius)
	for(var/obj/flamer_fire/fire in range(radius, epicenter))
		obj_mark_on_top(fire)
		fire.layer = TANK_ABOVE_RIDER_LAYER

/// Zeroes out every currently-alive hardpoint on this vehicle, including ones nested inside a holder.
/obj/vehicle/multitile/proc/destroy_all_hardpoints()
	for(var/obj/item/hardpoint/H in get_hardpoints_copy())
		if(H.health <= 0)
			continue
		H.health = 0
		H.on_destroy()
		if(!istype(H, /obj/item/hardpoint/holder))
			continue
		var/obj/item/hardpoint/holder/holder_hp = H
		for(var/obj/item/hardpoint/nested in holder_hp.hardpoints)
			if(nested.health <= 0)
				continue
			nested.health = 0
			nested.on_destroy()

/// Overridable hook for ejecting something special (e.g. a turret) as flying wreckage once the hull cooks off. No-op on the base class.
/obj/vehicle/multitile/proc/launch_special_wreckage()
	return
