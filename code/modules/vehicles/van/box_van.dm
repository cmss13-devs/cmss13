
//Trucks
//Read the documentation in multitile.dm before trying to decipher this stuff

/obj/vehicle/multitile/box_van
	name = "\improper box-van"
	desc = "A small box-type van. It's a compact vehicle with a rectangular cargo area, typically designed for transporting goods or small equipment. It features a high roof and straight sides, providing ample vertical space for storage. Its size makes it maneuverable and ideal for urban driving and tight spaces."
	layer = ABOVE_XENO_LAYER

	icon = 'icons/obj/vehicles/box_van.dmi'
	icon_state = "van_base"
	pixel_y = 8

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	interior_map = /datum/map_template/interior/box_van

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-1, 0),
		"back_left" = list(1, 2),
		"back_right" = list(0, 2)
	)

	vehicle_flags = VEHICLE_CLASS_WEAK

	passengers_slots = 4
	xenos_slots = 2

	misc_multipliers = list(
		"move" = 0.5, // fucking annoying how this is the only way to modify speed
		"accuracy" = 1,
		"cooldown" = 1
	)

	movement_sound = 'sound/vehicles/box_van_driving.ogg'
	honk_sound = 'sound/vehicles/box_van_horn.ogg'

	vehicle_light_range = 8

	move_max_momentum = 3

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/van_wheels,
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

/obj/vehicle/multitile/box_van/Initialize()
	. = ..()
	under_image = image(icon, src, icon_state, layer = BELOW_MOB_LAYER)
	under_image.alpha = 127

	normal_image = image(icon, src, icon_state, layer = layer)

	icon_state = null

	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGGED_IN, PROC_REF(add_default_image))

	for(var/icon in GLOB.player_list)
		add_default_image(SSdcs, icon)

/obj/vehicle/multitile/box_van/crew_mousedown(datum/source, atom/object, turf/location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers[SHIFT_CLICK] || modifiers[MIDDLE_CLICK] || modifiers[RIGHT_CLICK]) //don't step on examine, point, etc
		return

	switch(get_mob_seat(source))
		if(VEHICLE_DRIVER)
			if(modifiers[LEFT_CLICK] && modifiers[CTRL_CLICK])
				activate_horn()

/obj/vehicle/multitile/box_van/BlockedPassDirs(atom/movable/mover, target_dir)
	if(mover in mobs_under) //can't collide with the thing you're buckled to
		return NO_BLOCKED_MOVEMENT

	if(isliving(mover))
		var/mob/living/mob = mover
		if(mob.mob_flags & SQUEEZE_UNDER_VEHICLES)
			add_under_van(mob)
			return NO_BLOCKED_MOVEMENT

		if(mob.body_position == LYING_DOWN)
			return NO_BLOCKED_MOVEMENT

		if(mob.mob_size >= MOB_SIZE_IMMOBILE && next_push < world.time)
			if(try_move(target_dir, force=TRUE))
				next_push = world.time + push_delay
				return NO_BLOCKED_MOVEMENT

	return ..()

/*
** PRESETS
*/
/obj/vehicle/multitile/box_van/pre_movement()
	if(locate(/obj/effect/alien/weeds) in loc)
		move_momentum *= momentum_loss_on_weeds_factor

	. = ..()

	for(var/icon in mobs_under)
		var/mob/mob = icon
		if(!(mob.loc in locs))
			remove_under_van(mob)

/obj/vehicle/multitile/box_van/proc/add_under_van(mob/living/living)
	if(living in mobs_under)
		return

	mobs_under += living
	RegisterSignal(living, COMSIG_PARENT_QDELETING, PROC_REF(remove_under_van))
	RegisterSignal(living, COMSIG_MOB_LOGGED_IN, PROC_REF(add_client))
	RegisterSignal(living, COMSIG_MOVABLE_MOVED, PROC_REF(check_under_van))

	if(living.client)
		add_client(living)

/obj/vehicle/multitile/box_van/proc/remove_under_van(mob/living/living)
	SIGNAL_HANDLER
	mobs_under -= living

	if(living.client)
		living.client.images -= under_image
		add_default_image(SSdcs, living)

	UnregisterSignal(living, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOB_LOGGED_IN,
		COMSIG_MOVABLE_MOVED,
	))

/obj/vehicle/multitile/box_van/proc/check_under_van(mob/mob, turf/oldloc, direction)
	SIGNAL_HANDLER
	if(!(mob.loc in locs))
		remove_under_van(mob)

/obj/vehicle/multitile/box_van/proc/add_client(mob/living/living)
	SIGNAL_HANDLER
	living.client.images += under_image
	living.client.images -= normal_image

/obj/vehicle/multitile/box_van/proc/add_default_image(subsystem, mob/mob)
	SIGNAL_HANDLER
	mob.client.images += normal_image

/obj/vehicle/multitile/box_van/Destroy()
	for(var/icon in mobs_under)
		remove_under_van(icon)

	for(var/icon in GLOB.player_list)
		var/mob/mob = icon
		mob.client.images -= normal_image

	QDEL_NULL(lighting_holder)

	return ..()

/obj/vehicle/multitile/box_van/attackby(obj/item/O, mob/user)
	if(user.z != z)
		return ..()

	if(iswelder(O) && health >= initial(health))
		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/hardpoint/health
		for(var/obj/item/hardpoint/potential_hardpoint in hardpoints)
			if(potential_hardpoint.health < initial(potential_hardpoint.health))
				health = potential_hardpoint
				break

		if(health)
			health.handle_repair(O, user)
			update_icon()
			return

	. = ..()


/obj/vehicle/multitile/box_van/handle_click(mob/living/user, atom/A, list/mods)
	if(mods["shift"] && !mods["alt"])
		if(overdrive_next > world.time)
			to_chat(user, SPAN_WARNING("You can't activate overdrive yet! Wait [round((overdrive_next - world.time) / 10, 0.1)] seconds."))
			return

		misc_multipliers["move"] -= overdrive_speed_mult
		addtimer(CALLBACK(src, PROC_REF(reset_overdrive)), overdrive_duration)

		overdrive_next = world.time + overdrive_cooldown
		to_chat(user, SPAN_NOTICE("You activate overdrive."))
		playsound(src, 'sound/vehicles/box_van_overdrive.ogg', 75, FALSE)
		return

	return ..()

/obj/vehicle/multitile/box_van/proc/reset_overdrive()
	misc_multipliers["move"] += overdrive_speed_mult

/obj/vehicle/multitile/box_van/get_projectile_hit_boolean(obj/projectile/P)
	if(src == P.original) //clicking on the van itself will hit it.
		var/hitchance = P.get_effective_accuracy()
		if(prob(hitchance))
			return TRUE
	return FALSE

/obj/vehicle/multitile/box_van/Collide(atom/A)
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

/obj/effect/vehicle_spawner/box_van
	name = "Van Spawner"
	icon = 'icons/obj/vehicles/box_van.dmi'
	icon_state = "van_base"

/obj/effect/vehicle_spawner/box_van/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/box_van/spawn_vehicle()
	var/obj/vehicle/multitile/box_van/VAN = new (loc)

	load_misc(VAN)
	handle_direction(VAN)
	VAN.update_icon()

//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/box_van/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/box_van/VAN = new (loc)

	load_misc(VAN)
	load_hardpoints(VAN)
	handle_direction(VAN)
	load_damage(VAN)
	VAN.update_icon()

/obj/effect/vehicle_spawner/box_van/decrepit/load_hardpoints(obj/vehicle/multitile/box_van/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)

//PRESET: wheels installed
/obj/effect/vehicle_spawner/box_van/fixed/spawn_vehicle()
	var/obj/vehicle/multitile/box_van/VAN = new (loc)

	load_misc(VAN)
	load_hardpoints(VAN)
	handle_direction(VAN)
	VAN.update_icon()

/obj/effect/vehicle_spawner/box_van/fixed/load_hardpoints(obj/vehicle/multitile/box_van/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)
