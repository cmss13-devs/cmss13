#define STATE_TUGGED "tugged"
#define STATE_STOWED "grounded"
#define STATE_DEPLOYED "deployed"
#define STATE_TAKEOFF_LANDING "takeoff_landing"
#define STATE_VTOL "vtol"
#define STATE_FLIGHT "flight"
#define STATE_DESTROYED "destroyed"

/obj/vehicle/multitile/chimera
	name = "AD-19D chimera"
	desc = "Get inside to operate the vehicle."
	icon = 'icons/obj/vehicles/chimera.dmi'
	icon_state = "stowed"

	bound_width = 96
	bound_height = 96

	pixel_x = -64
	pixel_y = -32

	bound_x = -32
	bound_y = 0

	interior_map = /datum/map_template/interior/chimera

	move_max_momentum = 2.2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.8

	passengers_slots = 9
	xenos_slots = 5

	vehicle_light_power = 4
	vehicle_light_range = 5

	vehicle_flags = VEHICLE_CLASS_LIGHT

	vehicle_ram_multiplier = VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

	required_skill = SKILL_PILOT_EXPERT

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/chimera_thrusters,
	)

	entrances = list(
		"left" = list(2, 1),
		"right" = list(-2, 1),
		"back" = list(0, 3),
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

	var/last_flight_sound = 0
	var/flight_sound_cooldown = 4 SECONDS

	var/obj/chimera_shadow/shadow_holder

	var/busy = FALSE

	var/fuel = 600
	var/max_fuel = 600

	var/previous_move_delay

	var/list/atom/movable/screen/chimera/custom_hud = list(
		new /atom/movable/screen/chimera/fuel(),
		new /atom/movable/screen/chimera/integrity()
	)
	
	var/obj/structure/interior_exit/vehicle/chimera/back/back_door

/obj/chimera_shadow
	icon = 'icons/obj/vehicles/chimera.dmi'
	pixel_x = -64
	pixel_y = -160
	layer = ABOVE_MOB_LAYER

/obj/vehicle/multitile/chimera/Initialize(mapload, ...)
	. = ..()
	add_hardpoint(new /obj/item/hardpoint/locomotion/arc_wheels)
	update_icon()

/obj/vehicle/multitile/chimera/Destroy()
	QDEL_NULL(shadow_holder)

	. = ..()

/obj/vehicle/multitile/chimera/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_OPERATIONS_PILOT)
	RRS.total = 1
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Crew"
	RRS.roles = list(JOB_DROPSHIP_CREW_CHIEF)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/chimera/update_icon()
	. = ..()

	switch (state)
		if(STATE_VTOL, STATE_TAKEOFF_LANDING)
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
			overlays += image(icon, "stowed_lights")
		if(STATE_DEPLOYED)
			icon_state = "flight"
			overlays += image(icon, "stowed_lights")
		if(STATE_TUGGED)
			icon_state = "stowed"
			overlays += image(icon, "stowed_lights")
			overlays += image(icon, "tug_underlay", layer = BELOW_MOB_LAYER)
		if(STATE_DESTROYED)
			icon_state = "flight"
			overlays += image(icon, "stowed_lights")
			overlays += image(icon, "damage")

	if(shadow_holder)
		shadow_holder.icon_state = "[icon_state]_shadow"

/obj/vehicle/multitile/chimera/relaymove(mob/user, direction)
	if(state == STATE_TUGGED)
		. = ..()

		var/turf/possible_pad_turf = locate(x - 1, y - 1, z)
		var/obj/structure/landing_pad/landing_pad = locate() in possible_pad_turf

		if(!landing_pad)
			return

		to_chat(seats[VEHICLE_DRIVER], SPAN_NOTICE("Landing pad detected, Starting fueling procedures."))
		START_PROCESSING(SSobj, landing_pad)

		return

	if(last_turn + turn_delay > world.time)
		return FALSE

	if(state != STATE_FLIGHT && state != STATE_VTOL)
		return

	if (dir == turn(direction, 180) || dir == direction)
		return FALSE

	shadow_holder.dir = direction
	try_rotate(turning_angle(dir, direction))

/obj/vehicle/multitile/chimera/try_rotate(deg)
	. = ..()

	if(!.)
		return

	last_turn = world.time

/obj/vehicle/multitile/chimera/process(deltatime)
	if (state == STATE_FLIGHT)
		overlays -= thrust_overlay
		pre_movement(dir)
		thrust_overlay = image(icon, "flight_thrust")
		overlays += thrust_overlay

	if(world.time > last_flight_sound + flight_sound_cooldown)
		last_flight_sound = world.time
		playsound(loc, 'sound/vehicles/vtol/exteriorflight.ogg', 25, FALSE)

	for(var/atom/movable/screen/chimera/custom_screen as anything in custom_hud)
		custom_screen.update(fuel, max_fuel, health, maxhealth)

	if(state == STATE_VTOL)
		fuel -= deltatime * 2
	else if (state == STATE_FLIGHT)
		fuel -= deltatime

	if(fuel <= 0)
		STOP_PROCESSING(SSsuperfastobj, src)
		crash()

	if(back_door.open)
		update_rear_view()

/obj/vehicle/multitile/chimera/proc/crash()
	for(var/mob/living/passenger in interior.get_passengers())
		var/turf/fall_turf = locate(x + rand(-5, 5), y + rand(-5, 5), z)

		if(passenger.buckled)
			passenger.buckled.unbuckle()

		passenger.unset_interaction()
		passenger.client.change_view(GLOB.world_view_size, passenger)
		passenger.client.pixel_x = 0
		passenger.client.pixel_y = 0
		passenger.reset_view()
		passenger.forceMove(fall_turf)

	playsound(loc, 'sound/effects/metal_crash.ogg', 50, FALSE)
	state = STATE_DESTROYED
	update_icon()
	var/turf/crash_turf = SSmapping.get_turf_below(get_turf(src))
	forceMove(crash_turf)
	cell_explosion(crash_turf, 400, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("chimera crash"))
	qdel(shadow_holder)
	entrances = null

/obj/vehicle/multitile/chimera/before_move(direction)
	if(state != STATE_FLIGHT && state != STATE_VTOL)
		return
	
	var/turf/below = SSmapping.get_turf_below(get_turf(src))

	if(!below)	
		return

	shadow_holder.dir = direction
	shadow_holder.forceMove(below)

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
		/obj/vehicle/multitile/chimera/proc/toggle_vtol,
		/obj/vehicle/multitile/chimera/proc/toggle_stow
	))

	give_action(M, /datum/action/human_action/chimera/takeoff)
	give_action(M, /datum/action/human_action/chimera/land)
	give_action(M, /datum/action/human_action/chimera/toggle_vtol)
	give_action(M, /datum/action/human_action/chimera/toggle_stow)
	give_action(M, /datum/action/human_action/chimera/disconnect_tug)
	give_action(M, /datum/action/human_action/chimera/toggle_rear_door)

	for(var/atom/movable/screen/chimera/screen_to_add as anything in custom_hud)
		M.client.add_to_screen(screen_to_add)
		screen_to_add.update(fuel, max_fuel, health, maxhealth)

/atom/movable/screen/chimera
	icon = 'icons/obj/vehicles/chimera_hud.dmi'

/atom/movable/screen/chimera/proc/update(fuel, max_fuel, health, max_health)
	return

/atom/movable/screen/chimera/fuel
	icon_state = "fuel"
	screen_loc = "WEST,CENTER"

/atom/movable/screen/chimera/fuel/update(fuel, max_fuel, health, max_health)
	var/fuel_percent = min(round(fuel / max_fuel * 100), 99)
	var/tens = round(fuel_percent / 10)
	var/digits = fuel_percent % 10

	overlays.Cut()
	overlays += image(icon, "[tens]", pixel_y = -8, pixel_x = -1)
	overlays += image(icon, "[digits]", pixel_y = -8, pixel_x = 4)

/atom/movable/screen/chimera/integrity
	icon_state = "integrity"
	screen_loc = "WEST,CENTER+1"

/atom/movable/screen/chimera/integrity/update(fuel, max_fuel, health, max_health)
	var/integrity = min(round(health / max_health * 100), 99)
	var/tens = round(integrity / 10)
	var/digits = integrity % 10

	overlays.Cut()
	overlays += image(icon, "[tens]", pixel_y = -8, pixel_x = -1)
	overlays += image(icon, "[digits]", pixel_y = -8, pixel_x = 4)

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
		/obj/vehicle/multitile/chimera/proc/toggle_vtol,
		/obj/vehicle/multitile/chimera/proc/toggle_stow
	))

	remove_action(M, /datum/action/human_action/chimera/takeoff)
	remove_action(M, /datum/action/human_action/chimera/land)
	remove_action(M, /datum/action/human_action/chimera/toggle_vtol)
	remove_action(M, /datum/action/human_action/chimera/toggle_stow)
	remove_action(M, /datum/action/human_action/chimera/disconnect_tug)
	remove_action(M, /datum/action/human_action/chimera/toggle_rear_door)

	for(var/atom/movable/screen/chimera/screen_to_remove as anything in custom_hud)
		M.client.remove_from_screen(screen_to_remove) 

	SStgui.close_user_uis(M, src)	

/obj/vehicle/multitile/chimera/give_seated_mob_actions(mob/seated_mob)
	give_action(seated_mob, /datum/action/human_action/vehicle_unbuckle/chimera)

/obj/vehicle/multitile/chimera/Collided(atom/movable/collided_atom)
	if(state != STATE_STOWED)
		return

	if(!istype(collided_atom, /obj/structure/chimera_tug))
		return
	
	if(collided_atom.dir != REVERSE_DIR(dir))
		return

	qdel(collided_atom)
	state = STATE_TUGGED
	previous_move_delay = move_delay
	move_delay = VEHICLE_SPEED_NORMAL
	update_icon()

/obj/vehicle/multitile/chimera/proc/disconnect_tug()
	if(state != STATE_TUGGED)
		return

	state = STATE_STOWED
	update_icon()

	var/turf/disconnect_turf

	switch(dir)
		if(SOUTH)
			disconnect_turf = locate(x, y - 2, z)
		if(NORTH)
			disconnect_turf = locate(x, y + 2, z)
		if(EAST)
			disconnect_turf = locate(x + 2, y, z)
		if(WEST)
			disconnect_turf = locate(x - 2, y, z)

	move_delay = previous_move_delay
	var/obj/structure/chimera_tug/tug = new(disconnect_turf)
	tug.dir = dir

/obj/vehicle/multitile/chimera/crew_mousedown(datum/source, atom/object, turf/location, control, params)
	return

/obj/vehicle/multitile/chimera/proc/update_rear_view()
	var/turf/open_space/custom/new_turf = get_turf(back_door)
	new_turf = locate(new_turf.x, new_turf.y + 1, new_turf.z)

	var/turf/rear_turf

	switch(dir)
		if(SOUTH)
			rear_turf = SSmapping.get_turf_below(locate(x, y + 2, z))
		if(NORTH)
			rear_turf = SSmapping.get_turf_below(locate(x, y, z))
		if(EAST)
			rear_turf = SSmapping.get_turf_below(locate(x - 1, y + 1, z))
		if(WEST)
			rear_turf = SSmapping.get_turf_below(locate(x - 1, y + 1, z))
	
	new_turf.target_x = rear_turf.x
	new_turf.target_y = rear_turf.y
	new_turf.target_z = rear_turf.z
	new_turf.update_vis_contents()
	var/matrix/transform_matrix = matrix()
	transform_matrix.Translate(0, -16)
	for(var/obj/vis_contents_holder/vis_holder in new_turf)
		vis_holder.transform = transform_matrix

/obj/vehicle/multitile/chimera/proc/toggle_rear_door()
	if(state != STATE_FLIGHT && state != STATE_VTOL)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can only do this while in the air."))
		return

	back_door.toggle_open()

	if(back_door.open)
		var/turf/back_door_turf = get_turf(back_door)
		back_door_turf = locate(back_door_turf.x, back_door_turf.y + 1, back_door_turf.z)
		back_door_turf.ChangeTurf(/turf/open_space/custom)
		update_rear_view()
	else
		var/turf/back_door_turf = get_turf(back_door)
		back_door_turf = locate(back_door_turf.x, back_door_turf.y + 1, back_door_turf.z)
		back_door_turf.ChangeTurf(/turf/open/void/vehicle)

/obj/vehicle/multitile/chimera/proc/start_takeoff()
	for(var/turf/takeoff_turf in CORNER_BLOCK_OFFSET(get_turf(src), 3, 3, -1, 0))
		var/area/takeoff_turf_area = get_area(takeoff_turf)

		if(CEILING_IS_PROTECTED(takeoff_turf_area.ceiling, CEILING_PROTECTION_TIER_1) || takeoff_turf.density)
			to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can't takeoff here, the area is roofed."))
			return
	
	if(busy)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("The vehicle is currently busy performing another action."))
		return

	busy = TRUE

	playsound(loc, 'sound/vehicles/vtol/takeoff.ogg', 25, FALSE)
	addtimer(CALLBACK(src, PROC_REF(takeoff_engage_vtol)), 20 SECONDS)

/obj/vehicle/multitile/chimera/proc/takeoff_engage_vtol()
	state = STATE_TAKEOFF_LANDING
	update_icon()
	playsound(loc, 'sound/vehicles/vtol/mechanical.ogg', 25, FALSE)
	addtimer(CALLBACK(src, PROC_REF(finish_takeoff)), 10 SECONDS)

/obj/vehicle/multitile/chimera/proc/finish_takeoff()
	flags_atom |= NO_ZFALL
	state = STATE_VTOL
	update_icon()
	forceMove(SSmapping.get_turf_above(get_turf(src)))
	shadow_holder = new(SSmapping.get_turf_below(src))
	START_PROCESSING(SSsuperfastobj, src)
	busy = FALSE

/obj/vehicle/multitile/chimera/proc/start_landing()
	var/turf/below_turf = SSmapping.get_turf_below(get_turf(src))

	for(var/turf/landing_turf in CORNER_BLOCK_OFFSET(below_turf, 3, 3, -1, 0))
		var/area/landing_turf_area = get_area(landing_turf)

		if(CEILING_IS_PROTECTED(landing_turf_area.ceiling, CEILING_PROTECTION_TIER_1) || landing_turf.density)
			to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can't land here, the area is roofed or blocked by something."))
			return
	
	if(busy)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("The vehicle is currently busy performing another action."))
		return

	busy = TRUE
	state = STATE_TAKEOFF_LANDING
	update_icon()

	playsound(loc, 'sound/vehicles/vtol/landing.ogg', 25, FALSE)
	addtimer(CALLBACK(src, PROC_REF(finish_landing)), 18 SECONDS)

/obj/vehicle/multitile/chimera/proc/finish_landing()
	STOP_PROCESSING(SSsuperfastobj, src)
	forceMove(SSmapping.get_turf_below(get_turf(src)))
	qdel(shadow_holder)
	flags_atom &= ~NO_ZFALL
	state = STATE_DEPLOYED
	update_icon()
	busy = FALSE

	var/turf/possible_pad_turf = locate(x - 1, y - 1, z)
	var/obj/structure/landing_pad = locate() in possible_pad_turf

	if(!landing_pad)
		return

	to_chat(seats[VEHICLE_DRIVER], SPAN_NOTICE("Landing pad detected, Starting fueling procedures."))
	START_PROCESSING(SSobj, landing_pad)

/obj/vehicle/multitile/chimera/proc/toggle_stowed()
	if(state != STATE_DEPLOYED && state != STATE_STOWED)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can only do this while in stowed or deployed mode."))
		return
	
	if(busy)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("The vehicle is currently busy performing another action."))
		return

	busy = TRUE
	playsound(loc, 'sound/vehicles/vtol/mechanical.ogg', 25, FALSE)
	addtimer(CALLBACK(src, PROC_REF(transition_stowed)), 4 SECONDS)

/obj/vehicle/multitile/chimera/proc/transition_stowed()
	if(state == STATE_DEPLOYED)
		state = STATE_STOWED
	else
		state = STATE_DEPLOYED

	update_icon()
	busy = FALSE

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

	if(vehicle.state != STATE_DEPLOYED)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can only do this while in deployed mode."))
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

	if(!is_ground_level(vehicle.z))
		return

	if(vehicle.state != STATE_FLIGHT && vehicle.state != STATE_VTOL)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can only do this while in flight or hover mode."))
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

	if(vehicle.state != STATE_FLIGHT && vehicle.state != STATE_VTOL)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can only do this while in the air."))
		return

	vehicle.start_landing()

/obj/vehicle/multitile/chimera/proc/toggle_stow()
	set name = "Toggle Stow Mode"
	set desc = "Toggle between stowed and deployed mode."
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

	vehicle.toggle_stowed()
	return


/datum/action/human_action/chimera/New(Target, obj/item/holder)
	. = ..()
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/chimera/action_activate()
	. = ..()

	playsound(owner.loc, 'sound/vehicles/vtol/buttonpress.ogg', 25, FALSE)

/datum/action/human_action/chimera/takeoff
	name = "Takeoff"
	action_icon_state = "takeoff"

/datum/action/human_action/chimera/takeoff/action_activate()
	var/obj/vehicle/multitile/chimera/vehicle = owner.interactee
	
	if(!istype(vehicle))
		return

	. = ..()

	vehicle.takeoff()

/datum/action/human_action/chimera/land
	name = "Land"
	action_icon_state = "land"

/datum/action/human_action/chimera/land/action_activate()
	var/obj/vehicle/multitile/chimera/vehicle = owner.interactee
	
	if(!istype(vehicle))
		return

	. = ..()

	vehicle.land()

/datum/action/human_action/chimera/toggle_vtol
	name = "Toggle VTOL"
	action_icon_state = "vtol-mode-transition"

/datum/action/human_action/chimera/toggle_vtol/action_activate()
	var/obj/vehicle/multitile/chimera/vehicle = owner.interactee
	
	if(!istype(vehicle))
		return

	. = ..()

	vehicle.toggle_vtol()

/datum/action/human_action/chimera/toggle_stow
	name = "Toggle Stow Mode"
	action_icon_state = "stow-mode-transition"

/datum/action/human_action/chimera/toggle_stow/action_activate()
	var/obj/vehicle/multitile/chimera/vehicle = owner.interactee
	
	if(!istype(vehicle))
		return

	. = ..()

	vehicle.toggle_stow()

/datum/action/human_action/chimera/disconnect_tug
	name = "Disconnect Tug"
	action_icon_state = "tug-disconnect"

/datum/action/human_action/chimera/disconnect_tug/action_activate()
	var/obj/vehicle/multitile/chimera/vehicle = owner.interactee
	
	if(!istype(vehicle))
		return

	. = ..()

	vehicle.disconnect_tug()

/datum/action/human_action/chimera/toggle_rear_door
	name = "Toggle Rear Door"
	action_icon_state = "tug-disconnect"

/datum/action/human_action/chimera/toggle_rear_door/action_activate()
	var/obj/vehicle/multitile/chimera/vehicle = owner.interactee
	
	if(!istype(vehicle))
		return

	. = ..()

	vehicle.toggle_rear_door()

/datum/action/human_action/vehicle_unbuckle/chimera
	action_icon_state = "pilot-unbuckle"

/obj/structure/chimera_tug
	name = "aerospace tug"
	desc = ""
	icon = 'icons/obj/vehicles/chimera_tug.dmi'
	icon_state = "aerospace-tug"
	density = TRUE
	anchored = FALSE

	pixel_x = -16
	pixel_y = 0

/obj/structure/landing_pad_folded
	name = "folded landing pad"
	desc = ""
	icon = 'icons/obj/vehicles/chimera_structures.dmi'
	icon_state = "landing-pad-folded"
	density = TRUE
	anchored = FALSE

	pixel_x = -16
	pixel_y = -16

/obj/structure/landing_pad_folded/attackby(obj/item/hit_item, mob/user)
	if(!HAS_TRAIT(hit_item, TRAIT_TOOL_WRENCH))
		return

	if(!is_ground_level(user.z))
		to_chat(user, SPAN_WARNING("You probably shouldn't deploy this here."))
		return

	for(var/atom/possible_blocker in CORNER_BLOCK(loc, 3, 3))
		if(possible_blocker.density)
			to_chat(user, SPAN_WARNING("There is something in the way, you need a more open area."))
			return FALSE

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)

	to_chat(user, SPAN_NOTICE("You start assembling the landing pad..."))

	if(!do_after(user, 20 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		return

	for(var/atom/possible_blocker in CORNER_BLOCK(loc, 3, 3))
		if(possible_blocker.density)
			to_chat(user, SPAN_WARNING("There is something in the way, you need a more open area."))
			return FALSE

	to_chat(user, SPAN_NOTICE("You assemble the landing pad."))
		
	new /obj/structure/landing_pad(loc)

	qdel(src)

/obj/item/landing_pad_light
	name = "landing pad light"
	icon = 'icons/obj/vehicles/chimera_peripherals.dmi'
	icon_state = "landing pad light"
	layer = BELOW_MOB_LAYER

/obj/item/flight_cpu
	name = "flight cpu crate"
	icon = 'icons/obj/vehicles/chimera_peripherals.dmi'
	icon_state = "flightcpu-crate"
	layer = BELOW_MOB_LAYER

	var/obj/structure/landing_pad/linked_pad
	var/fueling = FALSE

/obj/item/flight_cpu/Initialize(mapload, obj/structure/landing_pad/linked_pad = null)
	src.linked_pad = linked_pad

	. = ..()

/obj/item/flight_cpu/Destroy()
	linked_pad = null
	
	. = ..()

/obj/item/flight_cpu/attack_hand(mob/user)
	if(!linked_pad)
		return ..()

	playsound(loc, 'sound/vehicles/vtol/buttonpress.ogg', 25, FALSE)

	if(!linked_pad.fuelpump_installed)
		to_chat(user, SPAN_WARNING("ERROR: Fuel pump not detected."))
		return

	if(linked_pad.installed_lights < 4)
		to_chat(user, SPAN_WARNING("ERROR: Insufficent landing lights detected for safe operation."))
		return

	tgui_interact(user)

/obj/item/flight_cpu/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FlightComputer", "Flight Computer", 900, 600)
		ui.open()

/obj/item/flight_cpu/ui_data(mob/user)
	var/list/data = list()

	var/turf/center_turf = locate(x + 2, y + 1, z)
	var/obj/vehicle/multitile/chimera/aircraft = locate() in center_turf
	if(aircraft)
		data["vtol_detected"] = TRUE
		data["fuel"] = aircraft.fuel
		data["max_fuel"] = aircraft.max_fuel
		data["fueling"] = fueling

	return data

/obj/item/flight_cpu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/turf/center_turf = locate(x + 2, y + 1, z)
	var/obj/vehicle/multitile/chimera/parked_aircraft = locate() in center_turf

	if(!parked_aircraft)
		return

	switch (action)
		if("start_fueling")
			fueling = TRUE
			START_PROCESSING(SSobj, src)
		if("stop_fueling")
			fueling = FALSE
			STOP_PROCESSING(SSobj, src)

/obj/item/flight_cpu/process(deltatime)
	var/turf/center_turf = locate(x + 1, y + 1, z)
	var/obj/vehicle/multitile/chimera/parked_aircraft

	for(var/obj/vehicle/multitile/chimera/aircraft in center_turf.contents)
		if(aircraft.x == center_turf.x + 1 && aircraft.y == aircraft.y)
			parked_aircraft = aircraft
			break

	if(!parked_aircraft)
		STOP_PROCESSING(SSobj, src)
		fueling = FALSE
		return

	if(parked_aircraft.fuel < parked_aircraft.max_fuel)
		parked_aircraft.fuel = min(parked_aircraft.fuel + 5 * deltatime, parked_aircraft.max_fuel)
	else
		STOP_PROCESSING(SSobj, src)
		fueling = FALSE

/obj/item/fuel_pump
	name = "fuelpump crate"
	icon = 'icons/obj/vehicles/chimera_peripherals.dmi'
	icon_state = "fuelpump-crate"
	layer = BELOW_MOB_LAYER

/obj/structure/landing_pad
	name = "landing pad"
	desc = ""
	icon = 'icons/obj/vehicles/chimera_landing_pad.dmi'
	icon_state = "pad"
	light_pixel_x = 48
	light_pixel_y = 48

	pixel_x = -2
	pixel_y = 4

	var/installed_lights = 0
	var/flight_cpu_installed = FALSE
	var/fuelpump_installed = FALSE

/obj/structure/landing_pad/process(deltatime)
	var/turf/center_turf = locate(x + 1, y + 1, z)
	var/obj/vehicle/multitile/chimera/parked_aircraft

	for(var/obj/vehicle/multitile/chimera/aircraft in center_turf.contents)
		if(aircraft.x == center_turf.x && aircraft.y == aircraft.y)
			parked_aircraft = aircraft
			break

	if(!parked_aircraft)
		STOP_PROCESSING(SSobj, src)
		return

	parked_aircraft.fuel = min(parked_aircraft.fuel + deltatime, parked_aircraft.max_fuel)

/obj/structure/landing_pad/attackby(obj/item/hit_item, mob/user)
	if(istype(hit_item, /obj/item/landing_pad_light))
		if(installed_lights >= 4)
			return
		
		qdel(hit_item)
		hit_item = new /obj/item/landing_pad_light(src)
		vis_contents += hit_item
		hit_item.icon_state = "landing pad light on"
		installed_lights++
		set_light(installed_lights, 3, LIGHT_COLOR_RED)
		switch(installed_lights)
			if(1)
				hit_item.pixel_x = -2
				hit_item.pixel_y = 1
			if(2)
				hit_item.pixel_x = 71
				hit_item.pixel_y = 1
			if(3)
				hit_item.pixel_x = -2
				hit_item.pixel_y = 91
			if(4)
				hit_item.pixel_x = 71
				hit_item.pixel_y = 91
		return

	if(istype(hit_item, /obj/item/flight_cpu))
		if(flight_cpu_installed)
			return

		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
			return
		
		qdel(hit_item)
		hit_item = new /obj/item/flight_cpu(locate(x - 1, y, z), src)
		hit_item.name = "flight cpu"
		hit_item.pixel_x = -7
		hit_item.pixel_y = -2
		hit_item.icon = 'icons/obj/vehicles/chimera_structures.dmi'
		hit_item.icon_state = "flight-cpu"
		flight_cpu_installed = TRUE
		return

	if(istype(hit_item, /obj/item/fuel_pump))
		if(fuelpump_installed)
			return

		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
			return
		
		qdel(hit_item)
		hit_item = new /obj/item/fuel_pump(src)
		vis_contents += hit_item
		hit_item.name = "fuel pump"
		hit_item.pixel_x = -25
		hit_item.pixel_y = 29
		hit_item.icon = 'icons/obj/vehicles/chimera_structures.dmi'
		hit_item.icon_state = "fuel pump"
		fuelpump_installed = TRUE
		return

/obj/structure/largecrate/supply/chimera_peripherals
	name = "\improper chimera peripherals crate"
	desc = "A supply crate containig the peripherals for the VTOL landing pad."
	supplies = list(
		/obj/item/fuel_pump = 1,
		/obj/item/flight_cpu = 1,
		/obj/item/landing_pad_light = 4,
	)
	icon_state = "secure_crate_strapped"


#undef STATE_TUGGED
#undef STATE_STOWED
#undef STATE_DEPLOYED
#undef STATE_TAKEOFF_LANDING
#undef STATE_VTOL
#undef STATE_FLIGHT
#undef STATE_DESTROYED
