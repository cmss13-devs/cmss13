#define STATE_TUGGED "tugged"
#define STATE_STOWED "grounded"
#define STATE_DEPLOYED "deployed"
#define STATE_IDLING "idling"
#define STATE_TAKEOFF_LANDING "takeoff_landing"
#define STATE_VTOL "vtol"
#define STATE_FLIGHT "flight"
#define STATE_DESTROYED "destroyed"

/obj/vehicle/multitile/blackfoot
	name = "AD-71E Blackfoot"
	desc = "A twin tilt-jet VTOL, the Blackfoot is the Bearcat's ugly big sister. For what she lacks in fire power and agility, she more than makes up for in utility and love handles. First tested by UA Northridge on American soil, the Blackfoot is currently undergoing active combat trials."
	icon = 'icons/obj/vehicles/blackfoot.dmi'
	icon_state = "stowed"

	bound_width = 96
	bound_height = 96

	pixel_x = -64
	pixel_y = -32

	bound_x = -32
	bound_y = 0

	interior_map = /datum/map_template/interior/blackfoot

	move_max_momentum = 2.2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.8

	passengers_slots = 9
	xenos_slots = 5

	vehicle_light_power = 4
	vehicle_light_range = 5

	vehicle_flags = VEHICLE_CLASS_LIGHT

	vehicle_ram_multiplier = VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

	required_skill = SKILL_PILOT_MASTER

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/blackfoot_thrusters,
		/obj/item/hardpoint/primary/chimera_launchers,
		/obj/item/hardpoint/support/sensor_array,
		/obj/item/hardpoint/secondary/doorgun,
	)

	entrances = list(
		"left" = list(2, 1),
		"right" = list(-2, 1),
		"back" = list(0, 3),
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	health = 500

	dmg_multipliers = list(
		"all" = 1,
		"acid" = 3,
		"slash" = 5,
		"bullet" = 0.6,
		"explosive" = 0.7,
		"blunt" = 0.7,
		"abstract" = 1
	)

	var/image/thrust_overlay

	var/last_turn = 0
	var/turn_delay = 1 SECONDS

	var/state = STATE_STOWED

	var/last_flight_sound = 0
	var/flight_sound_cooldown = 4 SECONDS

	var/obj/blackfoot_shadow/shadow_holder

	var/busy = FALSE

	var/fuel = 600
	var/max_fuel = 600

	var/battery = 600
	var/max_battery = 600

	var/previous_move_delay

	var/list/atom/movable/screen/blackfoot/custom_hud = list(
		new /atom/movable/screen/blackfoot/fuel(),
		new /atom/movable/screen/blackfoot/integrity(),
		new /atom/movable/screen/blackfoot/battery()
	)

	var/obj/structure/interior_exit/vehicle/blackfoot/back/back_door

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

/datum/tacmap/drawing/blackfoot/ui_status(mob/user)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(blackfoot_owner.seats[VEHICLE_DRIVER] != user)
		return UI_CLOSE

	return UI_INTERACTIVE

/obj/blackfoot_shadow
	icon = 'icons/obj/vehicles/blackfoot.dmi'
	pixel_x = -64
	pixel_y = -160
	layer = ABOVE_MOB_LAYER
	flags_atom = NO_ZFALL

/obj/downwash_effect
	icon = 'icons/obj/vehicles/blackfoot.dmi'
	icon_state = "downwash"
	pixel_x = -64
	pixel_y = -32

/obj/vehicle/multitile/blackfoot/Initialize(mapload, ...)
	. = ..()
	tacmap = new /datum/tacmap/drawing/blackfoot(src, minimap_type)
	update_icon()

/obj/vehicle/multitile/blackfoot/Destroy()
	QDEL_NULL(shadow_holder)

	. = ..()

/obj/vehicle/multitile/blackfoot/load_role_reserved_slots()
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

/obj/vehicle/multitile/blackfoot/can_install_hardpoint(obj/item/hardpoint/hardpoint, mob/user)
	if(interior.get_passengers())
		to_chat(user, SPAN_WARNING("Installing an hardpoint is unsafe when there are people inside the [src]."))
		return FALSE

	return TRUE

/obj/vehicle/multitile/blackfoot/proc/get_sprite_state()
	switch (state)
		if(STATE_VTOL, STATE_TAKEOFF_LANDING)
			return "vtol"
		if(STATE_FLIGHT, STATE_DEPLOYED, STATE_IDLING, STATE_DESTROYED)
			return "flight"
		if(STATE_STOWED, STATE_TUGGED)
			return "stowed"

/obj/vehicle/multitile/blackfoot/update_icon()
	. = ..()

	var/vtol_type

	if(ispath(interior_map, /datum/map_template/interior/blackfoot))
		vtol_type = ""
	else if (ispath(interior_map, /datum/map_template/interior/blackfoot_doorgun))
		vtol_type = "doorgun_"

	switch (state)
		if(STATE_VTOL, STATE_TAKEOFF_LANDING)
			icon_state = "[vtol_type]vtol"
			overlays += image(icon, "vtol_thrust")
			overlays += image(icon, "fan-overlay")
			overlays += image(icon, "flight_lights")
		if(STATE_FLIGHT)
			icon_state = "[vtol_type]flight"
			overlays += image(icon, "fan-overlay")
			overlays += image(icon, "flight_lights")
		if(STATE_STOWED)
			icon_state = "[vtol_type]stowed"
			overlays += image(icon, "stowed_lights")
		if(STATE_DEPLOYED, STATE_IDLING)
			icon_state = "[vtol_type]flight"
			overlays += image(icon, "stowed_lights")
		if(STATE_TUGGED)
			icon_state = "[vtol_type]stowed"
			overlays += image(icon, "stowed_lights")
			overlays += image(icon, "tug_underlay", layer = BELOW_MOB_LAYER)
		if(STATE_DESTROYED)
			icon_state = "[vtol_type]flight"
			overlays += image(icon, "stowed_lights")
			overlays += image(icon, "damage")

	if(shadow_holder)
		shadow_holder.icon_state = "[get_sprite_state()]_shadow"

/obj/vehicle/multitile/blackfoot/relaymove(mob/user, direction)
	if(state == STATE_TUGGED)
		. = ..()

		var/turf/possible_pad_turf = locate(x - 1, y - 1, z)
		var/obj/structure/landing_pad/landing_pad = locate() in possible_pad_turf

		if(!landing_pad)
			return

		to_chat(seats[VEHICLE_DRIVER], SPAN_NOTICE("Landing pad detected, Starting fueling procedures."))
		START_PROCESSING(SSobj, landing_pad)

		return

	if(state == STATE_VTOL)
		return ..()

	if(last_turn + turn_delay > world.time)
		return FALSE

	if(state != STATE_FLIGHT)
		return

	if (dir == turn(direction, 180) || dir == direction)
		return FALSE

	try_rotate(turning_angle(dir, direction))

/obj/vehicle/multitile/blackfoot/try_rotate(deg)
	. = ..()

	if(!.)
		return

	shadow_holder.dir = dir
	last_turn = world.time

/obj/vehicle/multitile/blackfoot/process(deltatime)
	if (state == STATE_FLIGHT)
		overlays -= thrust_overlay
		pre_movement(dir)
		thrust_overlay = image(icon, "flight_thrust")
		overlays += thrust_overlay

	if(world.time > last_flight_sound + flight_sound_cooldown)
		last_flight_sound = world.time
		playsound(loc, 'sound/vehicles/vtol/exteriorflight.ogg', 25, FALSE)

	for(var/atom/movable/screen/blackfoot/custom_screen as anything in custom_hud)
		custom_screen.update(fuel, max_fuel, health, maxhealth, battery, max_battery)

	if(state == STATE_VTOL)
		fuel -= deltatime * 3
	else if (state == STATE_FLIGHT)
		fuel -= deltatime

	if(fuel <= 0)
		STOP_PROCESSING(SSsuperfastobj, src)
		crash()

/obj/vehicle/multitile/blackfoot/proc/crash()
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
	var/turf/below_turf = SSmapping.get_turf_below(get_turf(src))

	while(SSmapping.get_turf_below(below_turf))
		if(!fits_in_turf(below_turf))
			break

		below_turf = SSmapping.get_turf_below(below_turf)
	
	forceMove(below_turf)
	cell_explosion(below_turf, 400, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("blackfoot crash"))
	qdel(shadow_holder)
	entrances = null

/obj/vehicle/multitile/blackfoot/before_move(direction)
	if(back_door.open)
		update_rear_view()
	
	if(state != STATE_FLIGHT && state != STATE_VTOL)
		return

	var/turf/below = SSmapping.get_turf_below(get_step(get_turf(src), direction))

	if(!below)
		return

	var/turf/shadow_turf = SSmapping.get_turf_below(below)

	while(SSmapping.get_turf_below(shadow_turf))
		if(!fits_in_turf(SSmapping.get_turf_below(shadow_turf)))
			break
		
		shadow_turf = SSmapping.get_turf_below(shadow_turf)

	shadow_holder.dir = dir
	shadow_holder.forceMove(shadow_turf)

/obj/vehicle/multitile/blackfoot/add_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return

	if(seat == VEHICLE_GUNNER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
		))
		return
	
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/toggle_door_lock,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/blackfoot/proc/takeoff,
		/obj/vehicle/multitile/blackfoot/proc/land,
		/obj/vehicle/multitile/blackfoot/proc/toggle_vtol,
		/obj/vehicle/multitile/blackfoot/proc/toggle_stow,
		/obj/vehicle/multitile/proc/switch_hardpoint
	))

	give_action(M, /datum/action/human_action/blackfoot/takeoff)
	give_action(M, /datum/action/human_action/blackfoot/land)
	give_action(M, /datum/action/human_action/blackfoot/toggle_vtol)
	give_action(M, /datum/action/human_action/blackfoot/toggle_stow)
	give_action(M, /datum/action/human_action/blackfoot/disconnect_tug)
	give_action(M, /datum/action/human_action/blackfoot/toggle_sensors)
	give_action(M, /datum/action/human_action/blackfoot/access_tacmap)
	give_action(M, /datum/action/human_action/blackfoot/toggle_nvg)
	give_action(M, /datum/action/human_action/blackfoot/toggle_engines)
	give_action(M, /datum/action/human_action/blackfoot/toggle_targeting)

	for(var/atom/movable/screen/blackfoot/screen_to_add as anything in custom_hud)
		M.client.add_to_screen(screen_to_add)
		screen_to_add.update(fuel, max_fuel, health, maxhealth, battery, max_battery)

/atom/movable/screen/blackfoot
	icon = 'icons/obj/vehicles/blackfoot_hud.dmi'

/atom/movable/screen/blackfoot/proc/update(fuel, max_fuel, health, max_health, battery, max_battery)
	return

/atom/movable/screen/blackfoot/fuel
	icon_state = "fuel"
	screen_loc = "WEST,CENTER"

/atom/movable/screen/blackfoot/fuel/update(fuel, max_fuel, health, max_health, battery, max_battery)
	var/fuel_percent = min(round(fuel / max_fuel * 100), 99)
	var/tens = round(fuel_percent / 10)
	var/digits = fuel_percent % 10

	overlays.Cut()
	overlays += image(icon, "[tens]", pixel_y = -8, pixel_x = -1)
	overlays += image(icon, "[digits]", pixel_y = -8, pixel_x = 4)

/atom/movable/screen/blackfoot/integrity
	icon_state = "integrity"
	screen_loc = "WEST,CENTER+1"

/atom/movable/screen/blackfoot/integrity/update(fuel, max_fuel, health, max_health, battery, max_battery)
	var/integrity = min(round(health / max_health * 100), 99)
	var/tens = round(integrity / 10)
	var/digits = integrity % 10

	overlays.Cut()
	overlays += image(icon, "[tens]", pixel_y = -8, pixel_x = -1)
	overlays += image(icon, "[digits]", pixel_y = -8, pixel_x = 4)

/atom/movable/screen/blackfoot/battery
	icon_state = "battery"
	screen_loc = "WEST,CENTER+2"

/atom/movable/screen/blackfoot/battery/update(fuel, max_fuel, health, max_health, battery, max_battery)
	var/battery_percent = min(round(battery / max_battery * 100), 99)
	var/tens = round(battery_percent / 10)
	var/digits = battery_percent % 10

	overlays.Cut()
	overlays += image(icon, "[tens]", pixel_y = 0, pixel_x = 0)
	overlays += image(icon, "[digits]", pixel_y = 0, pixel_x = 5)

/obj/vehicle/multitile/blackfoot/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return

	if(seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
		))
		return
	
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/toggle_door_lock,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/blackfoot/proc/takeoff,
		/obj/vehicle/multitile/blackfoot/proc/land,
		/obj/vehicle/multitile/blackfoot/proc/toggle_vtol,
		/obj/vehicle/multitile/blackfoot/proc/toggle_stow,
	))

	remove_action(M, /datum/action/human_action/blackfoot/takeoff)
	remove_action(M, /datum/action/human_action/blackfoot/land)
	remove_action(M, /datum/action/human_action/blackfoot/toggle_vtol)
	remove_action(M, /datum/action/human_action/blackfoot/toggle_stow)
	remove_action(M, /datum/action/human_action/blackfoot/disconnect_tug)
	remove_action(M, /datum/action/human_action/blackfoot/toggle_sensors)
	remove_action(M, /datum/action/human_action/blackfoot/access_tacmap)
	remove_action(M, /datum/action/human_action/blackfoot/toggle_nvg)
	remove_action(M, /datum/action/human_action/blackfoot/toggle_engines)
	remove_action(M, /datum/action/human_action/blackfoot/toggle_targeting)

	M.client?.mouse_pointer_icon = initial(M.client?.mouse_pointer_icon)
	var/obj/item/hardpoint/primary/chimera_launchers/launchers = locate() in hardpoints

	if(launchers)
		launchers.safety = TRUE

	for(var/atom/movable/screen/blackfoot/screen_to_remove as anything in custom_hud)
		M.client.remove_from_screen(screen_to_remove)

	SStgui.close_user_uis(M, src)

/obj/vehicle/multitile/blackfoot/give_seated_mob_actions(mob/seated_mob)
	if(seats[VEHICLE_DRIVER] != seated_mob)
		return
	
	give_action(seated_mob, /datum/action/human_action/vehicle_unbuckle/blackfoot)

/obj/vehicle/multitile/blackfoot/Collided(atom/movable/collided_atom)
	if(state != STATE_STOWED)
		return

	if(!istype(collided_atom, /obj/structure/blackfoot_tug))
		return

	if(collided_atom.dir != REVERSE_DIR(dir))
		return

	qdel(collided_atom)
	state = STATE_TUGGED
	previous_move_delay = move_delay
	move_delay = VEHICLE_SPEED_NORMAL
	update_icon()

/obj/vehicle/multitile/blackfoot/proc/disconnect_tug()
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
	var/obj/structure/blackfoot_tug/tug = new(disconnect_turf)
	tug.dir = dir

/obj/vehicle/multitile/blackfoot/proc/update_rear_view()
	var/turf/open_space/blackfoot/new_turf = get_turf(back_door)
	new_turf = locate(new_turf.x, new_turf.y + 1, new_turf.z)

	var/turf/rear_turf

	switch(dir)
		if(SOUTH)
			rear_turf = locate(x, y + 2, z)
		if(NORTH)
			rear_turf = locate(x, y, z)
		if(EAST)
			rear_turf = locate(x - 1, y + 1, z)
		if(WEST)
			rear_turf = locate(x - 1, y + 1, z)

	if(state == STATE_VTOL || state == STATE_FLIGHT)
		rear_turf = SSmapping.get_turf_below(rear_turf)
		new_turf.should_fall = TRUE
	else
		new_turf.should_fall = FALSE

	new_turf.target_x = rear_turf.x
	new_turf.target_y = rear_turf.y
	new_turf.target_z = rear_turf.z
	new_turf.update_vis_contents()
	var/matrix/transform_matrix = matrix()
	transform_matrix.Translate(0, -16)
	for(var/obj/vis_contents_holder/vis_holder in new_turf)
		vis_holder.transform = transform_matrix

/obj/vehicle/multitile/blackfoot/proc/fits_in_turf(turf/target_turf)
	for(var/turf/cur_turf in CORNER_BLOCK_OFFSET(target_turf, 3, 3, -1, 0))
		var/area/cur_turf_area = get_area(cur_turf)

		if(CEILING_IS_PROTECTED(cur_turf_area.ceiling, CEILING_PROTECTION_TIER_1) || cur_turf.density)
			return FALSE

	return TRUE


/obj/vehicle/multitile/blackfoot/proc/toggle_sensors(mode)
	var/obj/item/hardpoint/support/sensor_array/sensors = locate() in hardpoints

	if(!sensors)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("CRITICAL ERROR: NO SENSORS DETECTED."))
		return

	sensors.toggle(mode)

	if(sensors.active)
		to_chat(seats[VEHICLE_DRIVER], SPAN_NOTICE("Turned on [mode] mode."))
		playsound(seats[VEHICLE_DRIVER].loc, 'sound/vehicles/vtol/radaractive.ogg', 25, FALSE)
	else
		to_chat(seats[VEHICLE_DRIVER], SPAN_NOTICE("Turned sensor array off."))

/obj/vehicle/multitile/blackfoot/proc/toggle_rear_door()
	back_door.toggle_open()

	if(back_door.open)
		var/turf/back_door_turf = get_turf(back_door)
		back_door_turf = locate(back_door_turf.x, back_door_turf.y + 1, back_door_turf.z)
		back_door_turf.ChangeTurf(/turf/open_space/blackfoot)
		update_rear_view()
	else
		addtimer(CALLBACK(src, PROC_REF(finish_close_rear_door)), 9 DECISECONDS, TIMER_UNIQUE|TIMER_OVERRIDE) // Account for animation time

/obj/vehicle/multitile/blackfoot/proc/finish_close_rear_door()
	var/turf/back_door_turf = get_turf(back_door)
	back_door_turf = locate(back_door_turf.x, back_door_turf.y + 1, back_door_turf.z)
	back_door_turf.ChangeTurf(/turf/open/void/vehicle)

/obj/vehicle/multitile/blackfoot/proc/start_takeoff()
	var/obj/item/hardpoint/locomotion/blackfoot_thrusters/thrusters = locate() in hardpoints

	if(!thrusters)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("CRITICAL ERROR: NO ENGINES DETECTED."))
		return

	var/turf/turf_to_check = get_turf(src)

	if(!fits_in_turf(turf_to_check))
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can't takeoff here, the area is roofed."))
		return

	while(SSmapping.get_turf_above(turf_to_check))
		turf_to_check = SSmapping.get_turf_above(turf_to_check)

		if(!fits_in_turf(turf_to_check))
			to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can't takeoff here, the area is roofed."))
			return

	if(busy)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("The vehicle is currently busy performing another action."))
		return

	busy = TRUE
	new /obj/downwash_effect(get_turf(src))
	playsound(loc, 'sound/vehicles/vtol/takeoff.ogg', 25, FALSE)
	transition_engines()
	addtimer(CALLBACK(src, PROC_REF(takeoff_engage_vtol)), 14 SECONDS)

/obj/vehicle/multitile/blackfoot/proc/takeoff_engage_vtol()
	state = STATE_TAKEOFF_LANDING
	update_icon()
	playsound(loc, 'sound/vehicles/vtol/mechanical.ogg', 25, FALSE)
	addtimer(CALLBACK(src, PROC_REF(finish_takeoff)), 7 SECONDS)

/obj/vehicle/multitile/blackfoot/proc/finish_takeoff()
	flags_atom |= NO_ZFALL
	state = STATE_VTOL
	update_icon()
	var/obj/downwash_effect/downwash = locate() in get_turf(src)
	qdel(downwash)

	var/turf/top_turf = SSmapping.get_turf_above(get_turf(src))
	while(SSmapping.get_turf_above(top_turf))
		top_turf = SSmapping.get_turf_above(top_turf)
	
	forceMove(top_turf)

	var/turf/shadow_turf = SSmapping.get_turf_below(get_turf(src))

	while(SSmapping.get_turf_below(shadow_turf))
		if(!fits_in_turf(SSmapping.get_turf_below(shadow_turf)))
			break
		
		shadow_turf = SSmapping.get_turf_below(shadow_turf)
	shadow_holder = new(shadow_turf)
	shadow_holder.icon_state = "[get_sprite_state()]_shadow"
	update_rear_view()
	START_PROCESSING(SSsuperfastobj, src)
	busy = FALSE

/obj/vehicle/multitile/blackfoot/proc/start_landing()
	var/obj/item/hardpoint/locomotion/blackfoot_thrusters/thrusters = locate() in hardpoints

	if(!thrusters)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("CRITICAL ERROR: NO ENGINES DETECTED."))
		return

	var/turf/below_turf = SSmapping.get_turf_below(get_turf(src))

	if(!fits_in_turf(below_turf))
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can't land here, the area is roofed or blocked by something."))
		return

	while(SSmapping.get_turf_below(below_turf))
		if(!fits_in_turf(below_turf))
			to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can't land here, the area is roofed or blocked by something."))
			return

		below_turf = SSmapping.get_turf_below(below_turf)

	if(busy)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("The vehicle is currently busy performing another action."))
		return

	animate(shadow_holder, pixel_x = src.pixel_x, pixel_y = src.pixel_y, time = 18 SECONDS)
	new /obj/downwash_effect(below_turf)
	busy = TRUE
	state = STATE_TAKEOFF_LANDING
	update_icon()

	playsound(loc, 'sound/vehicles/vtol/landing.ogg', 25, FALSE)
	addtimer(CALLBACK(src, PROC_REF(finish_landing)), 18 SECONDS)

/obj/vehicle/multitile/blackfoot/proc/finish_landing()
	STOP_PROCESSING(SSsuperfastobj, src)

	var/turf/below_turf = SSmapping.get_turf_below(get_turf(src))

	while(SSmapping.get_turf_below(below_turf))
		if(!fits_in_turf(below_turf))
			break

		below_turf = SSmapping.get_turf_below(below_turf)
	
	forceMove(below_turf)
	qdel(shadow_holder)
	flags_atom &= ~NO_ZFALL
	state = STATE_DEPLOYED
	transition_engines() // Idle mode by default
	update_icon()
	update_rear_view()
	busy = FALSE

	var/turf/downwash_turf = get_turf(src)
	var/obj/downwash_effect/downwash = locate() in downwash_turf

	if(downwash)
		qdel(downwash)

	var/turf/possible_pad_turf = locate(x - 1, y - 1, z)
	var/obj/structure/landing_pad = locate() in possible_pad_turf

	if(!landing_pad)
		return

	to_chat(seats[VEHICLE_DRIVER], SPAN_NOTICE("Landing pad detected, Starting fueling procedures."))
	START_PROCESSING(SSobj, landing_pad)

/obj/vehicle/multitile/blackfoot/proc/toggle_stowed()
	if(state != STATE_DEPLOYED && state != STATE_STOWED)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can only do this while in stowed or deployed mode."))
		return

	if(busy)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("The vehicle is currently busy performing another action."))
		return

	busy = TRUE
	playsound(loc, 'sound/vehicles/vtol/mechanical.ogg', 25, FALSE)
	addtimer(CALLBACK(src, PROC_REF(transition_stowed)), 4 SECONDS)

/obj/vehicle/multitile/blackfoot/proc/transition_stowed()
	if(state == STATE_DEPLOYED)
		state = STATE_STOWED
	else
		state = STATE_DEPLOYED

	update_icon()
	busy = FALSE

/obj/vehicle/multitile/blackfoot/proc/toggle_engines()
	var/obj/item/hardpoint/locomotion/blackfoot_thrusters/thrusters = locate() in hardpoints

	if(!thrusters)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("CRITICAL ERROR: NO ENGINES DETECTED."))
		return

	if(state != STATE_DEPLOYED && state != STATE_IDLING)
		return

	if(busy)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("The vehicle is currently busy performing another action."))
		return

	busy = TRUE
	if(state == STATE_DEPLOYED)
		playsound(loc, 'sound/vehicles/vtol/enginestartup.ogg', 25, FALSE)
	else
		playsound(loc, 'sound/vehicles/vtol/engineshutdown.ogg', 25, FALSE)

	addtimer(CALLBACK(src, PROC_REF(transition_engines)), 3 SECONDS)
	addtimer(VARSET_CALLBACK(src, busy, FALSE), 3 SECONDS)

/obj/vehicle/multitile/blackfoot/proc/transition_engines()
	if(state == STATE_DEPLOYED)
		var/obj/item/hardpoint/locomotion/blackfoot_thrusters/thrusters = locate() in hardpoints
		if(!thrusters)
			return
		START_PROCESSING(SSobj, thrusters)
		state = STATE_IDLING
	else
		var/obj/item/hardpoint/locomotion/blackfoot_thrusters/thrusters = locate() in hardpoints
		if(!thrusters)
			return
		STOP_PROCESSING(SSobj, thrusters)
		state = STATE_DEPLOYED

/obj/vehicle/multitile/blackfoot/proc/toggle_targeting()
	var/obj/item/hardpoint/primary/chimera_launchers/launchers = locate() in hardpoints

	if(!launchers)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("CRITICAL ERROR: NO LAUNCHERS DETECTED."))
		return

	launchers.safety = !launchers.safety

	var/mob/user = seats[VEHICLE_DRIVER]

	if(!user)
		return

	if(launchers.safety)
		user.client?.mouse_pointer_icon = initial(user.client?.mouse_pointer_icon)
	else
		user.client?.mouse_pointer_icon = 'icons/obj/vehicles/blackfoot_cursor.dmi'

/obj/vehicle/multitile/blackfoot/proc/takeoff()
	set name = "Takeoff"
	set desc = "Initiate the take off sequence."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/blackfoot/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(vehicle.state != STATE_IDLING)
		to_chat(seats[VEHICLE_DRIVER], SPAN_WARNING("You can only do this while in deployed mode."))
		return

	vehicle.start_takeoff()
	return

/obj/vehicle/multitile/blackfoot/proc/toggle_vtol()
	set name = "Toggle VTOL"
	set desc = "Toggle VTOL mode."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/blackfoot/vehicle = user.interactee
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

/obj/vehicle/multitile/blackfoot/proc/land()
	set name = "Land"
	set desc = "Initiate the landing sequence."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/blackfoot/vehicle = user.interactee
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

/obj/vehicle/multitile/blackfoot/proc/toggle_stow()
	set name = "Toggle Stow Mode"
	set desc = "Toggle between stowed and deployed mode."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/blackfoot/vehicle = user.interactee
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


/datum/action/human_action/blackfoot/New(Target, obj/item/holder)
	. = ..()
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/blackfoot/action_activate()
	. = ..()

	playsound(owner.loc, 'sound/vehicles/vtol/buttonpress.ogg', 25, FALSE)

/datum/action/human_action/blackfoot/takeoff
	name = "Takeoff"
	action_icon_state = "takeoff"

/datum/action/human_action/blackfoot/takeoff/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.takeoff()

/datum/action/human_action/blackfoot/land
	name = "Land"
	action_icon_state = "land"

/datum/action/human_action/blackfoot/land/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.land()

/datum/action/human_action/blackfoot/toggle_vtol
	name = "Toggle VTOL"
	action_icon_state = "vtol-mode-transition"

/datum/action/human_action/blackfoot/toggle_vtol/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.toggle_vtol()

/datum/action/human_action/blackfoot/toggle_stow
	name = "Toggle Stow Mode"
	action_icon_state = "stow-mode-transition"

/datum/action/human_action/blackfoot/toggle_stow/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.toggle_stow()

/datum/action/human_action/blackfoot/disconnect_tug
	name = "Disconnect Tug"
	action_icon_state = "tug-disconnect"

/datum/action/human_action/blackfoot/disconnect_tug/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.disconnect_tug()

#define SENSOR_MODE "sensor"

/datum/action/human_action/blackfoot/toggle_sensors
	name = "Toggle Sensors"
	action_icon_state = "radar-ping"

/datum/action/human_action/blackfoot/toggle_sensors/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.toggle_sensors(SENSOR_MODE)

#undef SENSOR_MODE

#define NIGHTVISION_MODE "nightvision"

/datum/action/human_action/blackfoot/toggle_nvg
	name = "Toggle Night-Vision Mode"
	action_icon_state = "nightvision"

/datum/action/human_action/blackfoot/toggle_nvg/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.toggle_sensors(NIGHTVISION_MODE)

#undef NIGHTVISION_MODE

/datum/action/human_action/blackfoot/access_tacmap
	name = "Access Tacmap"
	action_icon_state = "minimap-vtol"

/datum/action/human_action/blackfoot/access_tacmap/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.tacmap.tgui_interact(owner)

/datum/action/human_action/blackfoot/toggle_engines
	name = "Toggle Engine Idling"
	action_icon_state = "engine-idle"

/datum/action/human_action/blackfoot/toggle_engines/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.toggle_engines()

/datum/action/human_action/blackfoot/toggle_targeting
	name = "Toggle Targeting Mode"
	action_icon_state = "targeting-mode"

/datum/action/human_action/blackfoot/toggle_targeting/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	vehicle.toggle_targeting()

/datum/action/human_action/vehicle_unbuckle/blackfoot
	action_icon_state = "pilot-unbuckle"

/obj/structure/blackfoot_tug
	name = "UG8 Aerospace Tug"
	desc = "A rugged and durable self-propelled front-gear tug designed to allow light aircraft to taxi short distances without powered landing gear. The tug, while large, and easily be moved around by a single crewman. It can be manually attached to the front of an aircraft, giving movement control over to the pilot. The UG8 model was created by UA Northridge in response to a compressor burst incident on the USS Shadow Line. Rest his soul."
	icon = 'icons/obj/vehicles/blackfoot_tug.dmi'
	icon_state = "aerospace-tug"
	density = TRUE
	anchored = FALSE
	pixel_x = -16
	pixel_y = 0

/obj/structure/landing_pad_folded
	name = "M9AB Landing Pad"
	desc = "A specially fabricated ultra-light, carbon-fiber, fiberglass reinforced, fuel saturated foldable landing pad designed for quick in-field deployment. VTOL aircraft can be automatically refueled by landing directly on this pad, taking fuel in at a slow rate through a emissive membrane sealed into the pad layer. It is firm, but malleable, like a water bed full of tar."
	icon = 'icons/obj/vehicles/blackfoot_structures.dmi'
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
	name = "M3 Landing Pad Light"
	desc = "It doesn't get more simple than this. It's a light stick with 1/4-20 threaded ends to fasten directly into the corners of the M9AB landing pad. It's like a glowstick made out of glass, at the mere price of $20,000 taxpayer dollars a pop."
	icon = 'icons/obj/vehicles/blackfoot_peripherals.dmi'
	icon_state = "landing pad light"
	layer = BELOW_MOB_LAYER

/obj/item/flight_cpu
	name = "GZ0 Operations Terminal"
	desc = "A rugged and durable operations computer designed for quick deployment at a field landing zone, made to link up directly to the M9AB landing pad and provide optimized fueling and charging data to a docked aircraft."
	icon = 'icons/obj/vehicles/blackfoot_peripherals.dmi'
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
	var/obj/vehicle/multitile/blackfoot/aircraft = locate() in center_turf
	if(aircraft)
		data["vtol_detected"] = TRUE
		data["fuel"] = aircraft.fuel
		data["max_fuel"] = aircraft.max_fuel
		data["battery"] = aircraft.battery
		data["max_battery"] = aircraft.max_battery
		data["fueling"] = fueling

	return data

/obj/item/flight_cpu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/turf/center_turf = locate(x + 2, y + 1, z)
	var/obj/vehicle/multitile/blackfoot/parked_aircraft = locate() in center_turf

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
	var/turf/center_turf = locate(x + 2, y + 1, z)
	var/obj/vehicle/multitile/blackfoot/parked_aircraft = locate() in center_turf

	if(!parked_aircraft)
		STOP_PROCESSING(SSobj, src)
		fueling = FALSE
		return

	if(parked_aircraft.fuel < parked_aircraft.max_fuel || parked_aircraft.battery < parked_aircraft.max_battery)
		parked_aircraft.fuel = min(parked_aircraft.fuel + 5 * deltatime, parked_aircraft.max_fuel)
		parked_aircraft.battery = min(parked_aircraft.battery + 5 * deltatime, parked_aircraft.max_battery)
	else
		STOP_PROCESSING(SSobj, src)
		fueling = FALSE

/obj/item/fuel_pump
	name = "M6G Short-Cycle Pump"
	desc = "Another peripheral system of the M9AB landing pad, a rotary driven pumping mechanism with a low head-pressure resevoir encased in a shell made out of air-grade aluminium and inconel fittings. You don't know how it works, it just does."
	icon = 'icons/obj/vehicles/blackfoot_peripherals.dmi'
	icon_state = "fuelpump-crate"
	layer = BELOW_MOB_LAYER

/obj/structure/landing_pad
	name = "M9AB Landing Pad"
	desc = "A specially fabricated ultra-light, carbon-fiber, fiberglass reinforced, fuel saturated foldable landing pad designed for quick in-field deployment. VTOL aircraft can be automatically refueled by landing directly on this pad, taking fuel in at a slow rate through a emissive membrane sealed into the pad layer. It is firm, but malleable, like a water bed full of tar."
	icon = 'icons/obj/vehicles/blackfoot_landing_pad.dmi'
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
	var/obj/vehicle/multitile/blackfoot/parked_aircraft = locate() in center_turf.contents

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
		hit_item.icon = 'icons/obj/vehicles/blackfoot_structures.dmi'
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
		hit_item.icon = 'icons/obj/vehicles/blackfoot_structures.dmi'
		hit_item.icon_state = "fuel pump"
		fuelpump_installed = TRUE
		return

/obj/structure/largecrate/supply/blackfoot_peripherals
	name = "\improper blackfoot peripherals crate"
	desc = "A supply crate containig the peripheral service units for the VTOL landing pad."
	supplies = list(
		/obj/item/fuel_pump = 1,
		/obj/item/flight_cpu = 1,
		/obj/item/landing_pad_light = 4,
		/obj/item/ammo_magazine/hardpoint/chimera_launchers_ammo = 4,
	)
	icon_state = "secure_crate_strapped"


/obj/structure/chimera_loader
	name = "\improper chimera internal access point"
	icon = 'icons/obj/vehicles/blackfoot_peripherals.dmi'

	var/obj/vehicle/multitile/blackfoot/linked_blackfoot

/obj/structure/chimera_loader/attackby(obj/item/attack_item, mob/user)
	if(!linked_blackfoot)
		return

	if(istype(attack_item, /obj/item/ammo_magazine/hardpoint/chimera_launchers_ammo))
		var/obj/item/ammo_magazine/hardpoint/chimera_launchers_ammo/ammo = attack_item
		var/obj/item/hardpoint/primary/chimera_launchers/launchers = locate() in linked_blackfoot.hardpoints

		if(!launchers)
			return

		launchers.try_add_clip(ammo, user)

#undef STATE_TUGGED
#undef STATE_STOWED
#undef STATE_DEPLOYED
#undef STATE_IDLING
#undef STATE_TAKEOFF_LANDING
#undef STATE_VTOL
#undef STATE_FLIGHT
#undef STATE_DESTROYED
