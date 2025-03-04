#define STATE_STOWED "grounded"
#define STATE_VTOL "vtol"
#define STATE_FLIGHT "flight"

/obj/vehicle/multitile/chimera
	name = "AD-19D chimera"
	desc = "Get inside to operate the vehicle."
	icon = 'icons/obj/vehicles/chimera.dmi'
	icon_state = "stowed"

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -64

	pixel_x = -64
	pixel_y = -80

	luminosity = 0

	interior_map = /datum/map_template/interior/chimera

	move_max_momentum = 2.2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.8

	vehicle_light_power = 4
	vehicle_light_range = 5

	vehicle_flags = VEHICLE_CLASS_LIGHT

	vehicle_ram_multiplier = VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/arc_wheels,
	)

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0),
		"back" = list(0, 1),
	)

	seats = list(
		VEHICLE_DRIVER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
	)

	var/image/thrust_overlay

	var/last_turn = 0
	var/turn_delay = 1 SECONDS

	var/state = STATE_STOWED

/obj/vehicle/multitile/chimera/Initialize(mapload, ...)
	. = ..()
	add_hardpoint(new /obj/item/hardpoint/locomotion/arc_wheels)

/obj/vehicle/multitile/chimera/update_icon()
	. = ..()

	switch (state)
		if(STATE_VTOL)
			icon_state = "vtol"
			overlays += image(icon, "vtol_thrust")
			overlays += image(icon, "fan-overlay")
			overlays += image(icon, "flight_lights")
		if(STATE_FLIGHT)
			icon_state = "flight"
			overlays += image(icon, "fan-overlay")
			overlays += image(icon, "flight_lights")
		if(STATE_STOWED)
			icon_state = "stowed"


/obj/vehicle/multitile/chimera/relaymove(mob/user, direction)
	if(last_turn + turn_delay > world.time)
		return FALSE

	if(state == STATE_STOWED)
		return

	if (dir == turn(direction, 180) || dir == direction)
		return FALSE

	try_rotate(turning_angle(dir, direction))

/obj/vehicle/multitile/chimera/try_rotate(deg)
	. = ..()

	if(.)
		last_turn = world.time

/obj/vehicle/multitile/chimera/process(deltatime)

	if (state == STATE_FLIGHT)
		overlays -= thrust_overlay
		pre_movement(dir)
		thrust_overlay = image(icon, "flight_thrust")
		overlays += thrust_overlay

/obj/vehicle/multitile/chimera/add_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/toggle_door_lock,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/chimera/proc/takeoff,
		/obj/vehicle/multitile/chimera/proc/land,
		/obj/vehicle/multitile/chimera/proc/toggle_vtol
	))

/obj/vehicle/multitile/chimera/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/toggle_door_lock,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/chimera/proc/takeoff,
		/obj/vehicle/multitile/chimera/proc/land,
		/obj/vehicle/multitile/chimera/proc/toggle_vtol
	))
	SStgui.close_user_uis(M, src)	

/obj/vehicle/multitile/chimera/proc/start_takeoff()
	playsound(loc, 'sound/vehicles/vtol/takeoff.ogg', 25, TRUE)
	addtimer(CALLBACK(src, PROC_REF(finish_takeoff)), 40 SECONDS)

/obj/vehicle/multitile/chimera/proc/finish_takeoff()
	flags_atom |= NO_ZFALL
	state = STATE_VTOL
	update_icon()
	forceMove(SSmapping.get_turf_above(get_turf(src)))
	START_PROCESSING(SSsuperfastobj, src)

/obj/vehicle/multitile/chimera/proc/start_landing()
	if(state != STATE_VTOL)
		state = STATE_VTOL
		update_icon()

	playsound(loc, 'sound/vehicles/vtol/landing.ogg', 25, TRUE)
	addtimer(CALLBACK(src, PROC_REF(finish_landing)), 18 SECONDS)

/obj/vehicle/multitile/chimera/proc/finish_landing()
	forceMove(SSmapping.get_turf_below(get_turf(src)))
	flags_atom &= ~NO_ZFALL
	state = STATE_STOWED
	update_icon()
	STOP_PROCESSING(SSsuperfastobj, src)

/obj/vehicle/multitile/chimera/proc/takeoff()
	set name = "Takeoff"
	set desc = "Initiate the take off sequence."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/chimera/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(vehicle.state == STATE_FLIGHT)
		return

	vehicle.start_takeoff()
	return

/obj/vehicle/multitile/chimera/proc/toggle_vtol()
	set name = "Toggle VTOL"
	set desc = "Toggle VTOL mode."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/chimera/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(vehicle.state == STATE_STOWED)
		return

	if(vehicle.state == STATE_FLIGHT)
		vehicle.state = STATE_VTOL
		vehicle.update_icon()
	else if (vehicle.state == STATE_VTOL)
		vehicle.state = STATE_FLIGHT
		vehicle.update_icon()

/obj/vehicle/multitile/chimera/proc/land()
	set name = "Land"
	set desc = "Initiate the landing sequence."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/chimera/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(vehicle.state == STATE_STOWED)
		return

	vehicle.start_landing()


#undef STATE_STOWED
#undef STATE_VTOL
#undef STATE_FLIGHT
