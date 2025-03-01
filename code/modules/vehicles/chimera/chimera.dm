#define STATE_GROUNDED "grounded"
#define STATE_AIRBORNE "airborne"

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

	vehicle_light_power = 0
	vehicle_light_range = 0

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


	var/state = STATE_GROUNDED

	//----------------------------
	// Light Related Vars
	var/side_lights_x_offset = 32
	var/side_lights_y_offset = 0

	var/rear_lights_x_offset = 20
	var/rear_lights_y_offset = 60

	var/front_lights_x_offset = -18
	var/front_lights_y_offset = -46

	var/lights_range = 3
	var/lights_power = 3

	var/side_light_color_1 = LIGHT_COLOR_RED
	var/side_light_color_2 = LIGHT_COLOR_GREEN
	var/rear_light_color = LIGHT_COLOR_LIGHT_CYAN
	var/front_light_color = COLOR_WHITE

/obj/vehicle/multitile/chimera/Initialize(mapload, ...)
	. = ..()
	add_hardpoint(new /obj/item/hardpoint/locomotion/arc_wheels)
	create_lights()

/atom/movable/chimera_light
	light_system = DIRECTIONAL_LIGHT

/obj/vehicle/multitile/chimera/proc/create_lights()
	var/atom/movable/chimera_light/light_holder = new(src)
	light_holder.light_pixel_x = side_lights_x_offset
	light_holder.light_pixel_y = side_lights_y_offset
	light_holder.set_light_color(side_light_color_1)
	light_holder.set_light_flags(LIGHT_ATTACHED)
	light_holder.set_light_range(light_range)
	light_holder.set_light_power(lights_power)
	light_holder.set_light_on(TRUE)

/obj/vehicle/multitile/chimera/relaymove(mob/user, direction)
	if(state == STATE_GROUNDED)
		return FALSE

	return ..()

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
	))
	SStgui.close_user_uis(M, src)	

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

	if(vehicle.state == STATE_AIRBORNE)
		return

	vehicle.forceMove(locate(vehicle.x, vehicle.y, vehicle.z + 1))
	vehicle.state = STATE_AIRBORNE
	return

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

	if(vehicle.state == STATE_GROUNDED)
		return

	vehicle.forceMove(locate(vehicle.x, vehicle.y, vehicle.z - 1))
	vehicle.state = STATE_GROUNDED
	return
