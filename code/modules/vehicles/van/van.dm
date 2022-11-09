
//Trucks
//Read the documentation in multitile.dm before trying to decipher this stuff

/obj/vehicle/multitile/van
	name = "Colony Van"
	desc = "A rather old hunk of metal with four wheels, you know what to do. Entrance on the back and sides."
	layer = ABOVE_XENO_LAYER

	icon = 'icons/obj/vehicles/van.dmi'
	icon_state = "van_base"
	pixel_x = -16
	pixel_y = -16

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	interior_map = "van"
	entrances = list(
		"left" = list(2, 0),
		"right" = list(-1, 0),
		"back_left" = list(1, 2),
		"back_right" = list(0, 2)
	)

	vehicle_flags = VEHICLE_CLASS_WEAK

	passengers_slots = 8
	xenos_slots = 2
	list/datum/role_served_slots/role_reserved_slots = list()

	misc_multipliers = list(
		"move" = 0.5, // fucking annoying how this is the only way to modify speed
		"accuracy" = 1,
		"cooldown" = 1
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_2_truck.ogg'

	luminosity = 8

	move_max_momentum = 3

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/van_wheels
	)

	move_turn_momentum_loss_factor = 1

	req_access = list()
	req_one_access = list()

	door_locked = FALSE

	mob_size_required_to_hit = MOB_SIZE_XENO

	var/overdrive_next = 0
	var/overdrive_cooldown = 15 SECONDS
	var/overdrive_duration = 3 SECONDS
	var/overdrive_speed_mult = 0.3 // Additive (30% more speed, adds to 80% more speed)

	var/momentum_loss_on_weeds_factor = 0.2

	move_on_turn = TRUE

	var/list/mobs_under = list()
	var/image/under_image
	var/image/normal_image

	var/next_push = 0
	var/push_delay = 0.5 SECONDS

/obj/vehicle/multitile/van/Initialize()
	. = ..()
	under_image = image(icon, src, icon_state, layer = BELOW_MOB_LAYER)
	under_image.alpha = 127

	normal_image = image(icon, src, icon_state, layer = layer)

	icon_state = null

	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGIN, .proc/add_default_image)

	for(var/I in GLOB.player_list)
		add_default_image(SSdcs, I)

/obj/vehicle/multitile/van/BlockedPassDirs(atom/movable/mover, target_dir)
	if(mover in mobs_under) //can't collide with the thing you're buckled to
		return NO_BLOCKED_MOVEMENT

	if(ismob(mover))
		var/mob/M = mover
		if(M.mob_flags & SQUEEZE_UNDER_VEHICLES)
			add_under_van(M)
			return NO_BLOCKED_MOVEMENT

		if(M.lying)
			return NO_BLOCKED_MOVEMENT

		if(M.mob_size >= MOB_SIZE_IMMOBILE && next_push < world.time)
			if(try_move(target_dir, force=TRUE))
				next_push = world.time + push_delay
				return NO_BLOCKED_MOVEMENT

	return ..()

/*
** PRESETS
*/
/obj/vehicle/multitile/van/pre_movement()
	. = ..()

	for(var/I in mobs_under)
		var/mob/M = I
		if(!(M.loc in locs))
			remove_under_van(M)

/obj/vehicle/multitile/van/proc/add_under_van(var/mob/living/L)
	if(L in mobs_under)
		return

	mobs_under += L
	RegisterSignal(L, COMSIG_PARENT_QDELETING, .proc/remove_under_van)
	RegisterSignal(L, COMSIG_MOB_LOGIN, .proc/add_client)
	RegisterSignal(L, COMSIG_MOVABLE_MOVED, .proc/check_under_van)

	if(L.client)
		add_client(L)

/obj/vehicle/multitile/van/proc/remove_under_van(var/mob/living/L)
	SIGNAL_HANDLER
	mobs_under -= L

	if(L.client)
		L.client.images -= under_image
		add_default_image(SSdcs, L)

	UnregisterSignal(L, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOB_LOGIN,
		COMSIG_MOVABLE_MOVED,
	))

/obj/vehicle/multitile/van/proc/check_under_van(var/mob/M, var/turf/oldloc, var/direction)
	SIGNAL_HANDLER
	if(!(M.loc in locs))
		remove_under_van(M)

/obj/vehicle/multitile/van/proc/add_client(var/mob/living/L)
	SIGNAL_HANDLER
	L.client.images += under_image
	L.client.images -= normal_image

/obj/vehicle/multitile/van/proc/add_default_image(var/subsystem, var/mob/M)
	SIGNAL_HANDLER
	M.client.images += normal_image

/obj/vehicle/multitile/van/Destroy()
	for(var/I in mobs_under)
		remove_under_van(I)

	for(var/I in GLOB.player_list)
		var/mob/M = I
		M.client.images -= normal_image

	return ..()


/obj/vehicle/multitile/van/pre_movement()
	if(locate(/obj/effect/alien/weeds) in loc)
		move_momentum *= momentum_loss_on_weeds_factor

	. = ..()


/obj/vehicle/multitile/van/attackby(obj/item/O, mob/user)
	if(user.z != z)
		return ..()

	if(iswelder(O) && health >= initial(health))
		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/hardpoint/H
		for(var/obj/item/hardpoint/potential_hardpoint in hardpoints)
			if(potential_hardpoint.health < initial(potential_hardpoint.health))
				H = potential_hardpoint
				break

		if(H)
			H.handle_repair(O, user)
			update_icon()
			return

	. = ..()


/obj/vehicle/multitile/van/handle_click(mob/living/user, atom/A, list/mods)
	if(mods["shift"] && !mods["alt"])
		if(overdrive_next > world.time)
			to_chat(user, SPAN_WARNING("You can't activate overdrive yet! Wait [round((overdrive_next - world.time) / 10, 0.1)] seconds."))
			return

		misc_multipliers["move"] -= overdrive_speed_mult
		addtimer(CALLBACK(src, .proc/reset_overdrive), overdrive_duration)

		overdrive_next = world.time + overdrive_cooldown
		to_chat(user, SPAN_NOTICE("You activate overdrive."))
		playsound(src, 'sound/vehicles/overdrive_activate.ogg', 75, FALSE)
		return

	return ..()

/obj/vehicle/multitile/van/proc/reset_overdrive()
	misc_multipliers["move"] += overdrive_speed_mult

/obj/vehicle/multitile/van/get_projectile_hit_boolean(obj/item/projectile/P)
	if(src == P.original) //clicking on the van itself will hit it.
		var/hitchance = P.get_effective_accuracy()
		if(prob(hitchance))
			return TRUE
	return FALSE

/obj/vehicle/multitile/van/Collide(var/atom/A)
	if(!seats[VEHICLE_DRIVER])
		return FALSE

	if(istype(A, /obj/structure/barricade/plasteel))
		return ..()

	if(istype(A, /turf/closed/wall) || \
	   istype(A, /obj/structure/barricade/sandbags) || \
	   istype(A, /obj/structure/barricade/metal) || \
	   istype(A, /obj/structure/barricade/deployable) || \
	   istype(A, /obj/structure/machinery/cryopod)) //Can no longer runover cryopods

		return FALSE

	return ..()

/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/van
	name = "Van Spawner"
	icon = 'icons/obj/vehicles/van.dmi'
	icon_state = "van_base"
	pixel_x = -16
	pixel_y = -16

/obj/effect/vehicle_spawner/van/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/van/spawn_vehicle()
	var/obj/vehicle/multitile/van/VAN = new (loc)

	load_misc(VAN)
	handle_direction(VAN)
	VAN.update_icon()

//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/van/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/van/VAN = new (loc)

	load_misc(VAN)
	load_hardpoints(VAN)
	handle_direction(VAN)
	load_damage(VAN)
	VAN.update_icon()

/obj/effect/vehicle_spawner/van/decrepit/load_hardpoints(var/obj/vehicle/multitile/van/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)

//PRESET: wheels installed
/obj/effect/vehicle_spawner/van/fixed/spawn_vehicle()
	var/obj/vehicle/multitile/van/VAN = new (loc)

	load_misc(VAN)
	load_hardpoints(VAN)
	handle_direction(VAN)
	VAN.update_icon()

/obj/effect/vehicle_spawner/van/fixed/load_hardpoints(var/obj/vehicle/multitile/van/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)
