/obj/vehicle/multitile/Collide(atom/A)
	if(A && !QDELETED(A))
		A.last_bumped = world.time
		A.Collided(src)
	return A.handle_vehicle_bump(src)


//-----------------MAIN BUMP HANDLING PROC-------------------

/atom/proc/handle_vehicle_bump(obj/vehicle/multitile/V)
	return FALSE

//-----------------------------------------------------------
//-------------------------TURFS-----------------------------
//-----------------------------------------------------------


/turf/closed/wall/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!(turf_flags & TURF_HULL) && !(V.vehicle_flags & VEHICLE_CLASS_WEAK))
		var/speed_scale = V.get_collision_speed_scale()
		take_damage(V.wall_ram_damage * speed_scale)
		V.take_damage_type(10 * speed_scale, "blunt", src)
		playsound(V, 'sound/effects/metal_crash.ogg', 35)
		visible_message(SPAN_DANGER("\The [V] rams \the [src]!"))

		// movement_locked means this wall hit came from a forced knockback, not a driver-caused crash.
		var/obj/vehicle/multitile/tank/tank = V
		if(istype(tank) && tank.movement_locked)
			tank.take_damage_type(KNOCKBACK_WALL_SLAM_DAMAGE, "blunt", src)

			if(tank.knockback_crusher_source && tank.engine_on)
				tank.set_engine_on(FALSE) // also refreshes the Toggle Engine action button
				var/mob/living/driver = tank.get_seat_mob(VEHICLE_DRIVER)
				if(driver)
					to_chat(driver, SPAN_WARNING("The impact stalls out \the [tank]'s engine!"))
	return FALSE

//-----------------------------------------------------------
//-------------------------OBJECTS---------------------------
//-----------------------------------------------------------

/obj/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!unacidable)
		V.take_damage_type(5 * V.get_collision_speed_scale(), "blunt", src)
		visible_message(SPAN_DANGER("\The [V] crushes [src]!"))
		playsound(V, 'sound/effects/metal_crash.ogg', 20)
		qdel(src)
	return FALSE

//-------------------------STRUCTURES------------------------

/obj/structure/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!explo_proof && !unacidable && !(V.vehicle_flags & VEHICLE_CLASS_WEAK))
		visible_message(SPAN_DANGER("\The [V] crushes [src]!"))
		playsound(V, 'sound/effects/metal_crash.ogg', 20)
		qdel(src)
	if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY)
		return TRUE
	return FALSE

/obj/structure/mineral_door/resin/handle_vehicle_bump(obj/vehicle/multitile/V)
	take_damage(V.wall_ram_damage * V.get_collision_speed_scale())
	visible_message(SPAN_DANGER("\The [V] rams [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	return FALSE

/obj/structure/barricade/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!(V.vehicle_flags & VEHICLE_CLASS_WEAK))
		take_damage(maxhealth)
		visible_message(SPAN_DANGER("\The [V] crushes [src]!"))
		playsound(V, 'sound/effects/metal_crash.ogg', 20)
	if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY)
		return TRUE
	return FALSE

/obj/structure/barricade/plasteel/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY)
		close(src)
		return TRUE
	if(V.seats[VEHICLE_DRIVER])
		close(src)
	return ..()

/obj/structure/barricade/deployable/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] crushes [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	collapse()
	return TRUE

/obj/structure/barricade/handrail/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] crushes [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	take_damage(maxhealth)
	return TRUE

/obj/structure/alien/movable_wall/handle_vehicle_bump(obj/vehicle/multitile/V)
	playsound(V, 'sound/effects/metal_crash.ogg', 35)
	var/speed_scale = V.get_collision_speed_scale()
	V.take_damage_type(5 * speed_scale, "blunt", src)

	if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
		return FALSE

	if(group)
		take_damage(V.wall_ram_damage * speed_scale)
		group.try_move_in_direction(get_dir(V.loc, get_turf(src)))
	else
		qdel(src)
	return TRUE

/obj/structure/mortar/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(fixed)
		if(V.seats[VEHICLE_DRIVER])
			to_chat(V.seats[VEHICLE_DRIVER], SPAN_WARNING("[src]'s supports are bolted and welded into the floor. You need to find a way around!"))
		return FALSE
	if(firing)
		if(V.seats[VEHICLE_DRIVER])
			to_chat(V.seats[VEHICLE_DRIVER], SPAN_WARNING("[src]'s barrel is still steaming hot. Wait a few seconds and try again!"))
		return FALSE
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	var/obj/item/mortar_kit/M = new /obj/item/mortar_kit(loc)
	M.name = name
	visible_message(SPAN_DANGER("\The [V] drives over \the [src]!"))
	qdel(src)
	return TRUE

/obj/structure/surface/handle_vehicle_bump(obj/vehicle/multitile/V)
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	qdel(src)
	return TRUE

/obj/structure/surface/table/handle_vehicle_bump(obj/vehicle/multitile/V)
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	new sheet_type(loc) // always drops exactly one sheet, no more a coin flip
	qdel(src)
	return TRUE

/obj/structure/surface/rack/handle_vehicle_bump(obj/vehicle/multitile/V)
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	deconstruct(FALSE) // drops a metal sheet instead of rack parts, this isn't a clean disassembly
	return TRUE

/obj/structure/reagent_dispensers/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(prob(50))
		new /obj/effect/particle_effect/water(src.loc)
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	qdel(src)
	return TRUE

/obj/structure/reagent_dispensers/tank/fuel/handle_vehicle_bump(obj/vehicle/multitile/V)
	reagents.source_mob = WEAKREF(V.seats[VEHICLE_DRIVER])
	if(reagents.handle_volatiles())
		if(V.seats[VEHICLE_DRIVER])
			log_game("[key_name(V.seats[VEHICLE_DRIVER])] exploded [name] by ramming it with [V] in [get_area(src)] ([loc.x],[loc.y],[loc.z]).")
		visible_message(SPAN_DANGER("\The [V] crushes \the [src], causing explosion!"))
	else
		visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	qdel(src)
	return FALSE

/obj/structure/dropship_equipment/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.seats[VEHICLE_DRIVER])
		var/last_moved = V.l_move_time //in case VC moves before answering
		if(alert(V.seats[VEHICLE_DRIVER], "Are you sure you want to crush \the [name]?", "Ramming confirmation","Yes","No") == "Yes")
			if(last_moved == V.l_move_time)
				visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
				playsound(V, 'sound/effects/metal_crash.ogg', 20)
				log_attack("[src] was crushed by [key_name(V.seats[VEHICLE_DRIVER])] with [V].")
				message_admins("[src] was crushed by [key_name(V.seats[VEHICLE_DRIVER])] with [V].")
				qdel(src)
				return FALSE
	return FALSE

/obj/structure/powerloader_wreckage/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	qdel(src)
	return FALSE

/obj/structure/largecrate/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	unpack()
	return TRUE

/obj/structure/largecrate/machine/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	if(turf_blocked_check())
		qdel(src)
	else
		unpack()
	return FALSE

/obj/structure/closet/crate/handle_vehicle_bump(obj/vehicle/multitile/V)
	open()
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	qdel(src)
	return FALSE

//med-heavy tank crushes boulders
/obj/structure/prop/dam/large_boulder/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY)
		visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
		playsound(V, 'sound/soundscape/rocksfalling2.ogg', 20)
		qdel(src)
		return TRUE
	return FALSE

/obj/structure/prop/dam/wide_boulder/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY)
		visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
		playsound(V, 'sound/soundscape/rocksfalling2.ogg', 20)
		qdel(src)
		return TRUE
	return FALSE

/obj/structure/fence/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY))
		V.apply_collision_speed_penalty(0.5)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(src, 'sound/effects/grillehit.ogg', 20)
	deconstruct(TRUE) // spawns its normal rods and handles its own qdel
	return TRUE

/obj/structure/foamed_metal/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY))
		V.apply_collision_speed_penalty(0.5)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(src, 'sound/effects/metalhit.ogg', 20)
	qdel(src)
	return TRUE

/obj/structure/grille/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY))
		V.apply_collision_speed_penalty(0.5)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(src, 'sound/effects/grillehit.ogg', 20)
	handle_debris() // same rods drop as cutting it apart normally
	qdel(src)
	return TRUE

/obj/structure/inflatable/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
		V.apply_collision_speed_penalty(0.5)
	visible_message(SPAN_DANGER("\The [V] rams \the [src]!"))
	density = FALSE
	deflate(TRUE)
	return TRUE

/obj/structure/bed/chair/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] rams \the [src]!"))
	new /obj/item/stack/sheet/metal(loc, 1)
	if(stacked_size)
		stack_collapse()
	else
		qdel(src)
	return TRUE

/obj/structure/bed/stool/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] rams \the [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	new /obj/item/stack/sheet/metal(loc, 1)
	qdel(src)
	return TRUE

/obj/structure/prop/dam/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM)
		V.apply_collision_speed_penalty(0.5)
	else if(!(V.vehicle_flags & VEHICLE_CLASS_HEAVY))
		return FALSE

	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(src, 'sound/effects/metal_crash.ogg', 20)
	qdel(src)
	return TRUE

/obj/structure/prop/dam/drill/handle_vehicle_bump(obj/vehicle/multitile/V)
	return FALSE

/obj/structure/prop/dam/torii/handle_vehicle_bump(obj/vehicle/multitile/V)
	return FALSE

/obj/structure/flora/tree/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
		return FALSE
	else if(V.vehicle_flags & VEHICLE_CLASS_LIGHT)
		V.apply_collision_speed_penalty(0.5)

	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(src, 'sound/effects/metal_crash.ogg', 20)
	playsound(src, 'sound/effects/woodhit.ogg', 20)
	qdel(src)
	return TRUE

/obj/structure/flora/tree/jungle/handle_vehicle_bump(obj/vehicle/multitile/V)
	return FALSE

/obj/structure/girder/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	new /obj/item/stack/sheet/metal(loc, 2)
	qdel(src)
	return TRUE

/obj/structure/window/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(not_damageable)
		return FALSE

	health = 0
	healthcheck()
	return TRUE

/obj/structure/window_frame/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	new /obj/item/stack/sheet/metal(loc, 2)
	qdel(src)
	return TRUE

//-------------------------MACHINERY------------------------

/obj/structure/machinery/door/handle_vehicle_bump(obj/vehicle/multitile/V)
	// We attempt to open doors before crushing them
	// Check if we can even fit through first
	var/list/vehicle_dimensions = V.get_dimensions()
	// The door should be facing east/west when the vehicle is facing north/south, and north/south when the vehicle is facing east/west
	// The door must also be wide enough for the vehicle to fit inside
	if(((V.dir & (NORTH|SOUTH) && dir & (EAST|WEST)) || (V.dir & (EAST|WEST) && dir & (NORTH|SOUTH))) && width >= vehicle_dimensions["width"])
	// Driver needs access
		var/mob/living/driver = V.get_seat_mob(VEHICLE_DRIVER)
		if(!requiresID() || (driver && allowed(driver)))
			if(operating != DOOR_OPERATING_OPENING)
				open(TRUE)
			return FALSE
	if(!unacidable)
		visible_message(SPAN_DANGER("\The [V] pushes [src] over!"))
		playsound(V, 'sound/effects/metal_crash.ogg', 20)
		new /obj/item/stack/sheet/metal(loc, 5)
		qdel(src)
	return FALSE

/obj/structure/machinery/door/poddoor/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!(V.vehicle_flags & VEHICLE_CLASS_WEAK))
		if(!unacidable)
			visible_message(SPAN_DANGER("\The [V] pushes [src] over!"))
			playsound(V, 'sound/effects/metal_crash.ogg', 35)
			V.take_damage_type(10 * V.get_collision_speed_scale(), "blunt", V)
			qdel(src)
	return FALSE

/obj/structure/machinery/door/poddoor/shutters/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!unacidable)
		visible_message(SPAN_DANGER("\The [V] pushes [src] over!"))
		playsound(V, 'sound/effects/metal_crash.ogg', 35)
		qdel(src)
	return FALSE

/obj/structure/machinery/door/poddoor/almayer/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!unacidable)
		if(vehicle_resistant)
			visible_message(SPAN_DANGER("\The [V] can't destroy [src]!"))
			playsound(V, 'sound/effects/metal_crash.ogg', 35)
		else
			visible_message(SPAN_DANGER("\The [V] crushes [src]!"))
			playsound(V, 'sound/effects/metal_crash.ogg', 35)
			qdel(src)
	return FALSE

/obj/structure/machinery/door/poddoor/hybrisa/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!unacidable)
		if(vehicle_resistant)
			visible_message(SPAN_DANGER("\The [V] can't destroy [src]!"))
			playsound(V, 'sound/effects/metal_crash.ogg', 35)
		else
			visible_message(SPAN_DANGER("\The [V] crushes [src]!"))
			playsound(V, 'sound/effects/metal_crash.ogg', 35)
			qdel(src)
	return FALSE

/obj/structure/machinery/cm_vending/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] pushes [src] over!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	tip_over()
	return TRUE

/obj/structure/machinery/m56d_post/handle_vehicle_bump(obj/vehicle/multitile/V)
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V] drives over \the [src]!"))

	if(gun_mounted)
		var/obj/item/device/m56d_gun/HMG = new(loc)
		transfer_label_component(HMG)
		HMG.rounds = gun_rounds
		HMG.has_mount = TRUE
		if(gun_health)
			HMG.health = gun_health
		HMG.update_icon()
		qdel(src)
	else
		var/obj/item/device/m56d_post/post = new(loc)
		post.health = health
		transfer_label_component(post)
		qdel(src)

	return TRUE

/obj/structure/machinery/m56d_hmg/handle_vehicle_bump(obj/vehicle/multitile/V)
	var/obj/item/device/m56d_gun/HMG = new(loc)
	HMG.name = name
	HMG.rounds = rounds
	HMG.has_mount = TRUE
	HMG.health = health
	HMG.update_icon()
	transfer_label_component(HMG)
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V] drives over \the [src]!"))
	qdel(src)
	return TRUE

/obj/structure/machinery/m56d_hmg/mg_turret/handle_vehicle_bump(obj/vehicle/multitile/V)
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V] drives over \the [src]!"))
	update_health(health + 1)
	return TRUE

/obj/structure/machinery/m56d_hmg/auto/handle_vehicle_bump(obj/vehicle/multitile/V)
	var/obj/item/device/m2c_gun/HMG = new(loc)
	HMG.name = name
	HMG.rounds = rounds
	HMG.overheat_value = floor(0.5 * overheat_value)
	if(HMG.overheat_value <= 10)
		HMG.overheat_value = 0
	HMG.update_icon()
	HMG.health = health
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V] drives over \the [src]!"))
	qdel(src)
	return TRUE

/obj/structure/machinery/defenses/sentry/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] drives over \the [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	if(static)
		update_health(health + 1)
	else if(health < health_max * 0.15)
		if(V.seats[VEHICLE_DRIVER])
			to_chat(V.seats[VEHICLE_DRIVER], SPAN_WARNING("[src]'s was too damaged already and didn't handle well being rammed."))
			destroyed_action()
	else
		HD.forceMove(get_turf(src))
		HD.dropped = 1
		HD.update_icon()
		power_off()
		placed = 0
		forceMove(HD)
	return TRUE

/obj/structure/machinery/defenses/sentry/premade/dropship/handle_vehicle_bump(obj/vehicle/multitile/V)
	deployment_system.undeploy_sentry()
	return FALSE

/obj/structure/machinery/m56d_hmg/mg_turret/dropship/handle_vehicle_bump(obj/vehicle/multitile/V)
	deployment_system.undeploy_mg()
	return FALSE

/obj/structure/machinery/defenses/sentry/launchable/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.seats[VEHICLE_DRIVER])
		var/last_moved = V.l_move_time //in case VC moves before answering
		if(alert(V.seats[VEHICLE_DRIVER], "Are you sure you want to crush \the [name]?", "Ramming confirmation","Yes","No") == "Yes")
			if(last_moved == V.l_move_time)
				visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
				playsound(V, 'sound/effects/metal_crash.ogg', 20)
				log_attack("[src] was crushed by [key_name(V.seats[VEHICLE_DRIVER])] with [V].")
				message_admins("[src] was crushed by [key_name(V.seats[VEHICLE_DRIVER])] with [V].")
				qdel(src)
				return FALSE
	return FALSE

/obj/structure/machinery/disposal/handle_vehicle_bump(obj/vehicle/multitile/V)
	qdel(src)
	return TRUE

/obj/structure/machinery/telecomms/relay/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] slams into \the [src], but it holds firm!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	return FALSE

/obj/structure/machinery/sensortower/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] slams into \the [src], but it holds firm!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	return FALSE

// Non-dense, only runs via can_move()'s dedicated non-dense crush-scan.
/obj/structure/machinery/constructable_frame/handle_vehicle_bump(obj/vehicle/multitile/V)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	new /obj/item/stack/sheet/metal(loc, 5)
	qdel(src)
	return TRUE

/obj/structure/machinery/vending/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(is_tipped_over)
		return TRUE
	visible_message(SPAN_DANGER("\The [V] tips \the [src] over!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	tip_over()
	return TRUE

/obj/structure/machinery/floodlight/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
		return FALSE
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V]crushes \the [src]!"))
	qdel(src)
	return TRUE

/obj/structure/machinery/colony_floodlight/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
		return FALSE
	if(!(V.vehicle_flags & VEHICLE_CLASS_HEAVY))
		V.apply_collision_speed_penalty(0.5)
	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V]crushes \the [src]!"))
	qdel(src)
	return TRUE

/obj/structure/machinery/floodlight/landing/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY)
		playsound(V, 'sound/effects/metal_crash.ogg', 20)
		visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
		qdel(src)
		return TRUE
	return FALSE

/obj/structure/machinery/autolathe/handle_vehicle_bump(obj/vehicle/multitile/V)
	for(var/obj/I in component_parts)
		if(I.reliability != 100 && crit_fail)
			I.crit_fail = 1
		I.forceMove(loc)

	playsound(V, 'sound/effects/metal_crash.ogg', 20)
	visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
	qdel(src)
	return TRUE

/obj/structure/machinery/portable_atmospherics/hydroponics/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(!(V.vehicle_flags & VEHICLE_CLASS_WEAK))
		playsound(V, 'sound/effects/metal_crash.ogg', 20)
		visible_message(SPAN_DANGER("\The [V] crushes \the [src]!"))
		qdel(src)
		return TRUE
	return FALSE

//-------------------------VEHICLES------------------------

/obj/vehicle/handle_vehicle_bump(obj/vehicle/multitile/V)
	V.take_damage_type(5, "blunt", V)
	health = health - ceil(maxhealth/2.8) //we destroy any simple vehicle in 3 crushes
	healthcheck()

	visible_message(SPAN_DANGER("\The [V] crushes into \the [src]!"))
	playsound(V, 'sound/effects/metal_crash.ogg', 35)
	return FALSE

/// Weight-class rank derived from vehicle_flags, higher is heavier.
/obj/vehicle/multitile/proc/get_weight_class_rank()
	if(vehicle_flags & VEHICLE_CLASS_HEAVY)
		return 4
	if(vehicle_flags & VEHICLE_CLASS_MEDIUM)
		return 3
	if(vehicle_flags & VEHICLE_CLASS_LIGHT)
		return 2
	return 1 // VEHICLE_CLASS_WEAK, or no class flag set at all

/**
 * Vehicle-vs-vehicle ramming. Weight class decides who wins:
 *
 * * Equal weight: both hard crash, V loses all momentum and jousts its riders. We get shoved back.
 * * V lighter than us: V still hard crashes, but we're too heavy to be pushed.
 * * V heavier than us: V soft crashes instead, only some momentum bleeds off.
 *
 * Knockback and damage scale with how much of V's own top speed it crashed in at.
 *
 * skip_generic_crash_response tells can_move() that momentum loss/jousting are already resolved here.
 */
/obj/vehicle/multitile/handle_vehicle_bump(obj/vehicle/multitile/V)
	var/target_rank = get_weight_class_rank()
	var/mover_rank = V.get_weight_class_rank()

	// A skidding vehicle can ram sideways off drift_speed, so read whichever axis has more momentum.
	var/facing_speed = abs(V.move_momentum)
	var/drift_dominant = V.drift_speed > facing_speed
	var/collision_speed = drift_dominant ? V.drift_speed : facing_speed
	var/collision_direction = drift_dominant ? V.drift_direction : V.last_move_dir

	var/fraction = V.move_max_momentum ? clamp(collision_speed / V.move_max_momentum, 0, 1) : 0
	var/effective_fraction = max(0, (fraction - VEHICLE_COLLISION_MOMENTUM_THRESHOLD) / (1 - VEHICLE_COLLISION_MOMENTUM_THRESHOLD))
	var/damage = round(effective_fraction * VEHICLE_COLLISION_MAX_DAMAGE)
	// A lighter mover still crashes hard, just without displacing something equal-or-heavier.
	var/knockback_tiles = (mover_rank >= target_rank) ? round(effective_fraction * VEHICLE_COLLISION_MAX_KNOCKBACK_TILES) : 0

	playsound(V, 'sound/effects/metal_crash.ogg', 35)

	if(mover_rank > target_rank)
		// Soft crash, too heavy to be bothered by something lighter.
		V.apply_collision_speed_penalty(VEHICLE_SOFT_CRASH_MOMENTUM_LOSS)
		V.drift_speed *= (1 - VEHICLE_SOFT_CRASH_MOMENTUM_LOSS)
		if(damage)
			// Same cosmetic cue a real hardpoint wound-gain uses.
			play_wound_gain_effects(src, WOUND_DAMTYPE_BRUTE, V)
			take_damage_type(damage, "blunt", V)
	else
		// Hard crash, stops V dead like slamming into a wall. on_crash() must run before we zero out
		// V's momentum below, it reads the untouched values to decide whether to joust V's riders.
		V.on_crash()
		V.apply_collision_speed_penalty(1)
		V.drift_speed = 0
		if(damage)
			play_wound_gain_effects(src, WOUND_DAMTYPE_BRUTE, V)
			take_damage_type(damage, "blunt", V)
			play_wound_gain_effects(V, WOUND_DAMTYPE_BRUTE, src)
			V.take_damage_type(damage, "blunt", src)

	V.skip_generic_crash_response = TRUE

	if(knockback_tiles)
		// Deferred a tick so we don't pull ourselves out from under this collision mid-resolution.
		addtimer(CALLBACK(src, PROC_REF(knockback), collision_direction, knockback_tiles), 0)

	visible_message(SPAN_DANGER("\The [V] crashes into \the [src]!"))
	return FALSE

// legacy cargo train gets ran over and crushed without a fuss by medium and heavy vehicles
/obj/vehicle/train/cargo/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM || V.vehicle_flags & VEHICLE_CLASS_HEAVY)
		health = 0
		healthcheck()

		visible_message(SPAN_DANGER("\The [V] crushes into \the [src]!"))
		playsound(V, 'sound/effects/metal_crash.ogg', 35)
		return TRUE
	. = ..()

//-----------------------------------------------------------
//-------------------------MOBS------------------------------
//-----------------------------------------------------------

/// Pure read of whether this mob would stop the vehicle. Used by the tank's stairs transition.
/mob/living/proc/would_block_tank_stairs(obj/vehicle/multitile/V)
	return FALSE

/mob/living/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(is_mob_incapacitated(1))
		apply_damage(7 + rand(0, 5), BRUTE)
		return TRUE

	var/mob/living/driver = V.get_seat_mob(VEHICLE_DRIVER)
	var/dmg = FALSE
	if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
		if(mob_flags & SQUEEZE_UNDER_VEHICLES && istype(V, /obj/vehicle/multitile/van))
			var/obj/vehicle/multitile/van/Van = V
			Van.add_under_van(src)
			if(mob_size >= MOB_SIZE_BIG)
				V.take_damage_type(TIER_3_RAM_DAMAGE_TAKEN, "blunt", src)
				playsound(V, 'sound/effects/metal_crash.ogg', 35)
				return FALSE
		else if(driver && get_target_lock(driver.faction))
			apply_effect(0.5, WEAKEN)
		else
			apply_effect(1, WEAKEN)

	else if(V.vehicle_flags & VEHICLE_CLASS_LIGHT)
		if(driver && get_target_lock(driver.faction))
			apply_effect(0.5, WEAKEN)
		else
			apply_effect(2, WEAKEN)
			apply_damage(5 + rand(0, 10), BRUTE)
			dmg = TRUE

	else if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM)
		apply_effect(3, WEAKEN)
		apply_damage(10 + rand(0, 10), BRUTE)
		dmg = TRUE

	else if(V.vehicle_flags & VEHICLE_CLASS_HEAVY)
		apply_effect(5, WEAKEN)
		apply_damage(15 + rand(0, 10), BRUTE)
		dmg = TRUE

	var/list/slots = V.get_activatable_hardpoints()
	for(var/slot in slots)
		var/obj/item/hardpoint/H = V.hardpoints[slot]
		if(!H)
			continue
		H.livingmob_interact(src)

	apply_effect(3, WEAKEN)
	apply_damage(7 + rand(0, 5), BRUTE)
	var/mob_moved = step(src, V.last_move_dir)

	visible_message(SPAN_DANGER("\The [V] rams \the [src]!"), SPAN_DANGER("\The [V] rams you! Get out of the way!"))
	if(dmg)
		playsound(loc, "punch", 25, 1)
		last_damage_data = create_cause_data("[initial(V.name)] roadkill", driver)
		log_attack("[key_name(src)] was rammed by [key_name(driver)] with [V].")
		if(driver && faction == driver.faction)
			msg_admin_ff("[key_name(driver)] rammed [key_name(src)] with \the [V] in [get_area(src)] [ADMIN_JMP(driver)] [ADMIN_PM(driver)]", TRUE, loc.z)
	else
		log_attack("[key_name(src)] was friendly pushed by [key_name(driver)] with [V].") //to be able to determine whether vehicle was pushign friendlies

	return mob_moved

//-------------------------HUMANS------------------------

/mob/living/carbon/human/handle_vehicle_bump(obj/vehicle/multitile/V)
	var/mob/living/driver = V.get_seat_mob(VEHICLE_DRIVER)
	var/dmg = FALSE

	var/mob_moved = FALSE
	var/mob_knocked_down = is_mob_incapacitated()

	// A front hit scoops the marine onto the hull instead of leaving them stuck underneath, only a stun.
	var/obj/vehicle/multitile/tank/tank_rammer = istype(V, /obj/vehicle/multitile/tank) ? V : null
	var/front_hit = tank_rammer && (get_dir(tank_rammer, src) == tank_rammer.dir)
	if(front_hit)
		// Captured before apply_effect(WEAKEN) drops whatever's in both hands from the knockdown.
		var/obj/item/prev_l_hand = l_hand
		var/obj/item/prev_r_hand = r_hand
		apply_effect(2, WEAKEN)
		// Deferred a tick, the tank's locs don't include this tile yet so mark_on_top() would reject it.
		addtimer(CALLBACK(tank_rammer, TYPE_PROC_REF(/obj/vehicle/multitile/tank, mark_on_top_after_ram), src, prev_l_hand, prev_r_hand), 0)
		visible_message(SPAN_DANGER("\The [V] scoops up \the [src]!"), SPAN_DANGER("\The [V] scoops you up!"))
		log_attack("[key_name(src)] was scooped up by [key_name(driver)] with [V].")
		return TRUE

	if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
		if(!mob_knocked_down)
			var/direction_taken = pick(45, 0, -45)
			mob_moved = step(src, turn(V.last_move_dir, direction_taken))
			if(!mob_moved)
				mob_moved = step(src, turn(V.last_move_dir, -direction_taken))
	else if(V.vehicle_flags & VEHICLE_CLASS_LIGHT)
		dmg = TRUE
		if(driver && get_target_lock(driver.faction))
			apply_effect(0.5, WEAKEN)
			apply_damage(5 + rand(0, 5), BRUTE, no_limb_loss = TRUE)
			to_chat(V.seats[VEHICLE_DRIVER], SPAN_WARNING(SPAN_BOLD("*YOU RAMMED AN ALLY AND HURT THEM!*")))
		else
			apply_effect(2, WEAKEN)
			apply_damage(10 + rand(0, 10), BRUTE)

	else if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM)
		// move_momentum is 0 during a Crusher-forced knockback, treat that as a full-force impact instead.
		var/effective_momentum_ratio = (tank_rammer && tank_rammer.movement_locked) ? 1 : (V.move_momentum / V.move_max_momentum)
		apply_effect((1.5 * effective_momentum_ratio), WEAKEN) // Even with the nerfs, still by far the most frustrating thing about the tank.
		apply_effect((3 * effective_momentum_ratio), SLOW)
		apply_damage(5 + rand(0, 5), BRUTE)
		dmg = TRUE

	else if(V.vehicle_flags & VEHICLE_CLASS_HEAVY)
		apply_effect(5, WEAKEN)
		apply_damage(15 + rand(0, 10), BRUTE)
		dmg = TRUE

	// Shove them clear of the tank's new footprint too. A front hit already returned early.
	if(tank_rammer && tank_rammer.movement_locked && !mob_knocked_down)
		step_away(src, get_turf(tank_rammer), 2)

	visible_message(SPAN_DANGER("\The [V] rams \the [src]!"), SPAN_DANGER("\The [V] rams you! Get out of the way!"))
	if(dmg)
		playsound(loc, "punch", 25, 1)
		last_damage_data = create_cause_data("[initial(V.name)] roadkill", driver)
		log_attack("[key_name(src)] was rammed by [key_name(driver)] with [V].")
		if(driver && faction == driver.faction)
			msg_admin_ff("[key_name(driver)] rammed and damaged member of allied faction [key_name(src)] with \the [V] in [get_area(src)] [ADMIN_JMP(driver)] [ADMIN_PM(driver)]", TRUE, loc.z)
	else
		log_attack("[key_name(src)] was friendly pushed by [key_name(driver)] with [V].") //to be able to determine whether vehicle was pushing friendlies

	if(mob_knocked_down)
		return TRUE
	else if (mob_moved)
		playsound(loc, "punch", 25, 1)

	return TRUE

//-------------------------XENOS------------------------

/// Mirrors handle_vehicle_bump() below. Large xenos planted head-on, or a Queen hit from any side,
/// stop the vehicle instead of being pushed.
/mob/living/carbon/xenomorph/would_block_tank_stairs(obj/vehicle/multitile/V)
	if((mob_size >= MOB_SIZE_IMMOBILE) && !is_mob_incapacitated() && !buckled)
		if(!(V.vehicle_flags & VEHICLE_CLASS_HEAVY))
			var/dir_between = get_dir(src, V)
			if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
				return TRUE
			else if(dir_between == dir) // front hit (facing the vehicle)
				return TRUE
			else if(caste.caste_type == XENO_CASTE_QUEEN) // queen blocks even with sides
				return TRUE
	return FALSE

/mob/living/carbon/xenomorph/handle_vehicle_bump(obj/vehicle/multitile/V)

	//whether xeno is knocked down
	var/is_knocked_down = FALSE
	//whether xeno takes damage
	var/takes_damage = FALSE
	//whether vehicle is being "stopped in its tracks"
	var/blocked = FALSE
	//whether vehicle receives momentum penalty
	var/momentum_penalty = FALSE

	if((mob_size >= MOB_SIZE_IMMOBILE) && !is_mob_incapacitated() && !buckled)
		if(!(V.vehicle_flags & VEHICLE_CLASS_HEAVY)) //heavy vehicles just don't give a damn
			var/dir_between = get_dir(src, V)
			if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
				blocked = TRUE
			//Check what dir they should be facing to be looking directly at the vehicle
			else if(dir_between == dir) //front hit (facing the vehicle)
				blocked = TRUE
			else if(dir_between == GLOB.reverse_dir[dir]) // rear hit (facing directly away from the vehicle)
				takes_damage = TRUE
			//side hit
			else if(caste.caste_type == XENO_CASTE_QUEEN) // queen blocks even with sides
				blocked = TRUE
			else
				momentum_penalty = TRUE

		if(blocked)
			visible_message(SPAN_DANGER("\The [src] digs its claws into the ground, anchoring itself in place and halting \the [V] in its tracks!"),
			SPAN_DANGER("You dig your claws into the ground, stopping \the [V] in its tracks!"))
			return FALSE

	else
		if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
			if(istype(V, /obj/vehicle/multitile/van) && mob_flags & SQUEEZE_UNDER_VEHICLES)
				var/obj/vehicle/multitile/van/Van = V
				Van.add_under_van(src)
			if(mob_size >= MOB_SIZE_BIG)
				V.take_damage_type(TIER_3_RAM_DAMAGE_TAKEN, "blunt", src)
				playsound(V, 'sound/effects/metal_crash.ogg', 35)
				return FALSE
			momentum_penalty = TRUE

		else if(V.vehicle_flags & VEHICLE_CLASS_LIGHT)
			takes_damage = TRUE
			momentum_penalty = TRUE

		else if(V.vehicle_flags & VEHICLE_CLASS_MEDIUM)
			takes_damage = TRUE

		else if(V.vehicle_flags & VEHICLE_CLASS_HEAVY)
			is_knocked_down = TRUE
			takes_damage = TRUE

	visible_message(SPAN_DANGER("\The [V] rams \the [src]!"), SPAN_DANGER("\The [V] rams you! Get out of the way!"))
	if(is_knocked_down)
		apply_effect(3, WEAKEN)

	var/mob_moved = FALSE
	var/mob_knocked_down = is_mob_incapacitated()
	if(!mob_knocked_down)
		if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
			var/direction_taken = pick(45, 0, -45)
			mob_moved = step(src, turn(V.last_move_dir, direction_taken))

			if(!mob_moved)
				mob_moved = step(src, turn(V.last_move_dir, -direction_taken))
		else
			mob_moved = step_away(src, get_turf(V), 2)

	var/list/slots = V.get_activatable_hardpoints()
	for(var/slot in slots)
		var/obj/item/hardpoint/H = V.hardpoints[slot]
		if(!H)
			continue
		H.livingmob_interact(src)

	if(takes_damage)
		//This could 100% be coded as max(VEHICLE_TRAMPLE_DAMAGE_MIN, 22.5-4.5*X.tier) but I think this is more readable, plus it lets me avoid a special case for Queen/Larva/Abom.
		var/damage_percentage = VEHICLE_TRAMPLE_DAMAGE_SPECIAL // Queen and abomb
		switch (tier)
			if (1)
				damage_percentage = VEHICLE_TRAMPLE_DAMAGE_TIER_1 // 2.5 * 9 = 22.5
			if (2)
				damage_percentage = VEHICLE_TRAMPLE_DAMAGE_TIER_2 // 18%
			if (3)
				damage_percentage = VEHICLE_TRAMPLE_DAMAGE_TIER_3 // 13.5%

		//this adds more flexibility for trample damage
		damage_percentage *= VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

		damage_percentage -= floor((armor_deflection*(armor_integrity/100)) / VEHICLE_TRAMPLE_DAMAGE_REDUCTION_ARMOR_MULT) // Ravager reduces percentage by ~50% by virtue of having very high armor.

		if(locate(/obj/item/hardpoint/support/overdrive_enhancer) in V)
			damage_percentage += VEHICLE_TRAMPLE_DAMAGE_OVERDRIVE_BUFF

		damage_percentage = max(VEHICLE_TRAMPLE_DAMAGE_OVERDRIVE_BUFF, max(0, damage_percentage))
		damage_percentage = max(damage_percentage, VEHICLE_TRAMPLE_DAMAGE_MIN)

		apply_damage(floor((maxHealth / 100) * damage_percentage), BRUTE)
		last_damage_data = create_cause_data("[initial(V.name)] roadkill", V.seats[VEHICLE_DRIVER])
		var/mob/living/driver = V.get_seat_mob(VEHICLE_DRIVER)
		log_attack("[key_name(src)] was rammed by [key_name(driver)] with [V].")

	// If the mob is knocked down or was pushed away from the APC (aka have actual space to move), allow movement in desired direction
	if(mob_knocked_down)
		return TRUE
	else if (mob_moved)
		if(momentum_penalty)
			V.apply_collision_speed_penalty(0.2, reschedule = TRUE)
		playsound(loc, "punch", 25, 1)
		return TRUE

	return FALSE

//BURROWER
/mob/living/carbon/xenomorph/burrower/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return TRUE
	else
		return . = ..()

//DEFENDER
/mob/living/carbon/xenomorph/defender/handle_vehicle_bump(obj/vehicle/multitile/V)
	if(fortify)
		if(V.vehicle_flags & VEHICLE_CLASS_WEAK) //defenders being able to completely block armored vehicles by crawling into a boulder is ridiculous
			visible_message(SPAN_DANGER("[src] digs its claws into the ground, anchoring itself in place and halting [V] in its tracks!"),
			SPAN_DANGER("You dig your claws into the ground, stopping [V] in its tracks!"))
			return FALSE
		else if(V.vehicle_flags & VEHICLE_CLASS_LIGHT)
			visible_message(SPAN_DANGER("[src] digs its claws into the ground, slowing [V]'s movement!"),
			SPAN_DANGER("You dig your claws into the ground, slowing [V]'s movement!"))
			var/mob_moved = step(src, V.last_move_dir)
			V.apply_collision_speed_penalty(2/3, reschedule = TRUE)
			return mob_moved

		//medium-to-heavy vehicles will still push fortified defender back but without dealing damage. Need to change snowplow effects later
		if(!is_mob_incapacitated())
			playsound(loc, "punch", 25, 1)
			visible_message(SPAN_DANGER("\The [V] rams fortified [src], pushing it away!"), SPAN_DANGER("You can't stop \the [V] from pushing you when it rams you!"))
			var/list/slots = V.get_activatable_hardpoints()
			for(var/slot in slots)
				var/obj/item/hardpoint/H = V.hardpoints[slot]
				if(!H)
					continue
				H.livingmob_interact(src)

			var/mob_moved = step(src, V.last_move_dir)
			return mob_moved

	else
		return . = ..()

/**
 * Handles something bumping into this vehicle.
 * Does nothing for our own riders. A charging Crusher gets a generic ram/damage/knockback, unless
 * this vehicle resolves its own crusher-charge hits elsewhere (resolve_crusher_charge_hit(), tank.dm).
 * Otherwise, attempts to climb the bumper onto the hull (mark_on_top()/climb_onto(), multitile_riding.dm).
 *
 * Arguments:
 * * atom/movable/AM = The atom bumping into this vehicle.
 */
/obj/vehicle/multitile/Collided(atom/movable/AM)
	if(_is_our_rider(AM))
		return

	if(!ismob(AM))
		if(istype(AM, /obj))
			var/obj/O = AM
			if(O.buckled_mob)
				Collided(O.buckled_mob)
		return ..()

	var/mob/living/M = AM
	if(!istype(M))
		return ..()

	if(!has_own_crusher_charge_handling && iscrusher(M))
		var/mob/living/carbon/xenomorph/crusher/C = M
		if(C.throwing)
			var/do_move = TRUE
			if(health > 0)
				take_damage_type(100, "blunt", C)
				visible_message(SPAN_DANGER("\The [C] ramms \the [src]!"))
				for(var/obj/item/hardpoint/locomotion/Loco in hardpoints)
					if(Loco.health > 0)
						do_move = FALSE
						break
			if(do_move)
				try_move(C.dir, force=TRUE)
				visible_message(SPAN_DANGER("The sheer force of the impact makes \the [src] slide back!"))
			log_attack("\The [src] was rammed [do_move ? "and pushed " : " "]by [key_name(C)].")
			playsound(loc, 'sound/effects/metal_crash.ogg', 35)
			interior_crash_effect()
			return

	if(M.action_busy)
		return
	if(M.pulledby || M.throwing)
		return
	var/turf/facing_turf = get_step(get_turf(M), M.dir)
	if(!facing_turf)
		return ..()
	if(M.resting)
		// A resting mob crawling into/under the vehicle should just slide through, never become a tracked rider here.
		M.forceMove(facing_turf)
		return ..()
	if(get_turf(M) in locs)
		return

	climb_onto(M, facing_turf)
	return
