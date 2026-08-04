
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

	engine_on = FALSE

	uses_gear_transmission = TRUE
	current_gear = "P"
	top_speed = 3.5
	base_acceleration = 1
	// Matches the ARC's own fuel consumption.
	base_fuel_use = 0.175
	idle_fuel_use_mult = 0.2
	overdrive_speed_mult = 0.3
	overdrive_sound = 'sound/vehicles/box_van_overdrive.ogg'
	desant_momentum_cap = 0.35

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/van_wheels,
		/obj/item/hardpoint/engine/van,
		/obj/item/hardpoint/fuel_tank/van,
		/obj/item/hardpoint/radiator/civilian,
		/obj/item/hardpoint/battery/civilian,
	)

	move_turn_momentum_loss_factor = 1

	req_access = list()
	req_one_access = list()

	door_locked = FALSE

	mob_size_required_to_hit = MOB_SIZE_XENO

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

	gear_stats = build_gear_stats()
	cruise_control_granularity = gear_stats["D"]["max_speed"] * CRUISE_CONTROL_DEFAULT_GRANULARITY_FRACTION

/obj/vehicle/multitile/box_van/add_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
	))
	if(seat == VEHICLE_DRIVER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/name_vehicle,
			/obj/vehicle/multitile/proc/toggle_cruise_control,
			/obj/vehicle/multitile/proc/set_cruise_control_granularity,
			/obj/vehicle/multitile/proc/toggle_turn_signal_north,
			/obj/vehicle/multitile/proc/toggle_turn_signal_south,
			/obj/vehicle/multitile/proc/toggle_turn_signal_east,
			/obj/vehicle/multitile/proc/toggle_turn_signal_west,
			/obj/vehicle/multitile/proc/toggle_engine,
		))
		give_action(M, /datum/action/human_action/vehicle_action/toggle_door_lock)
		give_action(M, /datum/action/human_action/vehicle_action/toggle_engine)
		give_action(M, /datum/action/human_action/vehicle_action/use_phone)
		if(!(M.client.prefs.toggles_vehicle & VEHICLE_SIMPLE_ACCELERATION))
			give_action(M, /datum/action/human_action/vehicle_action/toggle_cruise_control)
			give_action(M, /datum/action/human_action/vehicle_action/set_cruise_control_granularity)
		RegisterSignal(M, COMSIG_MOB_VEHICLE_PREFS_CHANGED, PROC_REF(on_driver_prefs_changed))
		start_crew_hud(M, VEHICLE_DRIVER)
	refresh_hardpoint_actions()

/obj/vehicle/multitile/box_van/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
	))
	if(seat == VEHICLE_DRIVER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/name_vehicle,
			/obj/vehicle/multitile/proc/toggle_cruise_control,
			/obj/vehicle/multitile/proc/set_cruise_control_granularity,
			/obj/vehicle/multitile/proc/toggle_turn_signal_north,
			/obj/vehicle/multitile/proc/toggle_turn_signal_south,
			/obj/vehicle/multitile/proc/toggle_turn_signal_east,
			/obj/vehicle/multitile/proc/toggle_turn_signal_west,
			/obj/vehicle/multitile/proc/toggle_engine,
		))
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_door_lock)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_engine)
		remove_action(M, /datum/action/human_action/vehicle_action/use_phone)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_cruise_control)
		remove_action(M, /datum/action/human_action/vehicle_action/set_cruise_control_granularity)
		UnregisterSignal(M, COMSIG_MOB_VEHICLE_PREFS_CHANGED)
		stop_crew_hud(M, VEHICLE_DRIVER)
	SStgui.close_user_uis(M, src)

/obj/vehicle/multitile/box_van/crew_mousedown(datum/source, atom/object, turf/location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers[SHIFT_CLICK] || modifiers[MIDDLE_CLICK] || modifiers[RIGHT_CLICK] || modifiers[BUTTON4] || modifiers[BUTTON5]) //don't step on examine, point, etc
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
	if(mods[SHIFT_CLICK] && !mods[ALT_CLICK])
		activate_overdrive(user)
		return

	return ..()

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
	V.add_hardpoint(new /obj/item/hardpoint/engine/van)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/van)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/civilian)
	V.add_hardpoint(new /obj/item/hardpoint/battery/civilian)

//PRESET: wheels installed
/obj/effect/vehicle_spawner/box_van/fixed/spawn_vehicle()
	var/obj/vehicle/multitile/box_van/VAN = new (loc)

	load_misc(VAN)
	load_hardpoints(VAN)
	handle_direction(VAN)
	VAN.update_icon()

/obj/effect/vehicle_spawner/box_van/fixed/load_hardpoints(obj/vehicle/multitile/box_van/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)
	V.add_hardpoint(new /obj/item/hardpoint/engine/van)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/van)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/civilian)
	V.add_hardpoint(new /obj/item/hardpoint/battery/civilian)
