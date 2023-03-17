#define MOVEMENT_DIRECTION_UPWARDS 1
#define MOVEMENT_DIRECTION_DOWNWARDS 0

#define ELEVATOR_MOVE_AWAY_FROM_ORIGIN_STAGE 1
#define ELEVATOR_MOVE_TOWARDS_DESTINATION_STAGE 0

/obj/effect/landmark/multi_fakezlevel_supply_elevator
	var/fake_zlevel
	var/is_primary_fake_zlevel = FALSE

/obj/effect/landmark/multi_fakezlevel_supply_elevator/Initialize(mapload, ...)
	. = ..()

	var/turf/dummy_variable
	for(var/i = 1; i != null; i++)
		if(length(GLOB.supply_elevator_turfs) < fake_zlevel)
			GLOB.supply_elevator_turfs += dummy_variable
		else
			break

	GLOB.supply_elevator_turfs[fake_zlevel] = get_turf(src)

	if(is_primary_fake_zlevel)
		supply_controller.primary_fake_zlevel = fake_zlevel

	return INITIALIZE_HINT_QDEL

/datum/shuttle/ferry/supply/multi
	iselevator = 1
	var/list/obj/effect/elevator/supply/multi/elevator_effects = list()
	/// contains lists which each contain groups of projectors near each stop of the elevator
	var/list/shaft_projectors = list()
	///contains lists which are indexed to each deck and contain clone_cleaners
	var/list/shaft_cleanerz = list()
	var/fake_zlevel = 0
	var/target_zlevel = 1
	var/obj/structure/elevator_control_mount/in_elevator_controller
	replacement_turf_type = /turf/open/floor/almayer/empty/multi_elevator
	var/list/transit_location_walls = list()
	/// purposefully defined this as something other than transit_area to not trigger shuttle code
	var/area/shaft_transit_area
	var/list/obj/effect/elevator/animation_overlay/elevator_animationz = list()
	/// z for coolness
	var/list/railingz = list()
	warmup_time = 5 SECONDS
	/// used when making things fall down shafts etc
	var/offset_distance

/datum/shuttle/ferry/supply/multi/New()
	for(var/i in 1 to length(GLOB.supply_elevator_turfs))
		elevator_animationz += list(list())
		shaft_cleanerz += list(list())
		railingz += list(list())
	for(var/turf/T in GLOB.supply_elevator_turfs)
		var/area/T_area = get_area(T)
		elevator_animationz[T_area.fake_zlevel] = new/obj/effect/elevator/animation_overlay()
		elevator_animationz[T_area.fake_zlevel].pixel_y = -192

		for(var/obj/effect/step_trigger/clone_cleaner/CC in range(6, T))
			shaft_cleanerz[T_area.fake_zlevel] |= CC

		for(var/obj/structure/machinery/door/poddoor/railing/R in range(5, T))
			railingz[T_area.fake_zlevel] |= R

	for(var/area/A in all_areas)
		if(istype(A, /area/supply/transit))
			shaft_transit_area = A
			break

	for(var/obj/effect/projector/P in projectors)
		for(var/turf/T in GLOB.supply_elevator_turfs)
			var/area/area_of_T = get_area(T)
			for(var/i in 0 to area_of_T.fake_zlevel)
				if(length(shaft_projectors) < area_of_T.fake_zlevel)
					shaft_projectors += list(list())
				else
					break
			var/maths_x = T.x - P.x
			var/maths_y = T.y - P.y
			if(T.z == P.z)
				if(maths_x > -5 && maths_x <= 0)
					if(maths_y > -5 && maths_y <= 0)
						shaft_projectors[area_of_T.fake_zlevel] |= P
					else if(maths_y < -5 && maths_y >= 0)
						shaft_projectors[area_of_T.fake_zlevel] |= P
				else if(maths_x < 5 && maths_x >= 0)
					if(maths_y > -5 && maths_y <= 0)
						shaft_projectors[area_of_T.fake_zlevel] |= P
					else if(maths_y < -5 && maths_y >= 0)
						shaft_projectors[area_of_T.fake_zlevel] |= P

	if(supply_controller)
		for(var/i in 1 to length(GLOB.supply_elevator_turfs))
			var/turf/T = GLOB.supply_elevator_turfs[i]
			var/area/T_area = get_area(T)
			var/Ts_fake_zlevel = T_area.fake_zlevel

			elevator_effects["[Ts_fake_zlevel]SW"]  = new /obj/effect/elevator/supply/multi(locate(T.x-2,T.y-2,T.z))
			elevator_effects["[Ts_fake_zlevel]SW"].vis_contents += elevator_animationz[Ts_fake_zlevel]

			elevator_effects["[Ts_fake_zlevel]SE"] = new /obj/effect/elevator/supply/multi(locate(T.x+2,T.y-2,T.z))
			elevator_effects["[Ts_fake_zlevel]SE"].pixel_x = -128
			elevator_effects["[Ts_fake_zlevel]SE"].vis_contents += elevator_animationz[Ts_fake_zlevel]

			elevator_effects["[Ts_fake_zlevel]NW"] = new /obj/effect/elevator/supply/multi(locate(T.x-2,T.y+2,T.z))
			elevator_effects["[Ts_fake_zlevel]NW"].pixel_y = -128
			elevator_effects["[Ts_fake_zlevel]NW"].vis_contents += elevator_animationz[Ts_fake_zlevel]

			elevator_effects["[Ts_fake_zlevel]NE"] = new /obj/effect/elevator/supply/multi(locate(T.x+2,T.y+2,T.z))
			elevator_effects["[Ts_fake_zlevel]NE"].pixel_x = -128
			elevator_effects["[Ts_fake_zlevel]NE"].pixel_y = -128
			elevator_effects["[Ts_fake_zlevel]NE"].vis_contents += elevator_animationz[Ts_fake_zlevel]

	var/list/all_directions = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

	for(var/turf/T in shaft_transit_area)
		for(var/i in all_directions)
			if(istype(get_step(T, i), /turf/closed/wall/supply_shaft))
				transit_location_walls |= get_step(T, i)

	for(var/turf/T in GLOB.supply_elevator_turfs)
		var/turf/starting_turf = T
		/// we're gonna assume the fake_zlevels are e/w of eachother & aligned
		while(!offset_distance)
			T = get_step(T, EAST)
			if(!T)
				break
			for(var/turf/XX in GLOB.supply_elevator_turfs)
				if(XX == T)
					offset_distance = T.x - starting_turf.x
					break
		if(offset_distance)
			break

/datum/shuttle/ferry/supply/multi/add_structures()  //places the shuttle controller on the lift
	for(var/turf/T in area_offsite)
		var/check1 = (get_step(T, NORTH).density ? TRUE : FALSE)
		var/check2 = (get_step(T, EAST).density ? TRUE : FALSE)
		if(check1 && check2)
			in_elevator_controller = new/obj/structure/elevator_control_mount(T)
			break

/datum/shuttle/ferry/supply/multi/pick_loc()
	RETURN_TYPE(/turf)
	if(!supply_controller.multi_fakezlevel_elevator)
		return GLOB.supply_elevator_turfs[target_zlevel]

/datum/shuttle/ferry/supply/multi/get_location_area(location_id)
	if(moving_status != SHUTTLE_INTRANSIT)
		if(!fake_zlevel)
			return area_offsite
		else
			return get_area(GLOB.supply_elevator_turfs[fake_zlevel])
	else
		return shaft_transit_area

/datum/shuttle/ferry/supply/multi/proc/get_movement_direction()
	if(moving_status == SHUTTLE_IDLE)
		return null

	if(!target_zlevel)
		return MOVEMENT_DIRECTION_DOWNWARDS

	else if(!fake_zlevel)
		return MOVEMENT_DIRECTION_UPWARDS

	else if(target_zlevel < fake_zlevel)
		return MOVEMENT_DIRECTION_UPWARDS
	else
		return MOVEMENT_DIRECTION_DOWNWARDS

/datum/shuttle/ferry/supply/multi/at_station()
	var/area/elevator_location_area = get_location_area()
	return moving_status == SHUTTLE_INTRANSIT ? FALSE : elevator_location_area.fake_zlevel

/datum/shuttle/ferry/supply/multi/short_jump(area/origin, area/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(target_zlevel == fake_zlevel)
		return

	recharging = 1

	if(!destination)
		if(!target_zlevel)
			destination = area_offsite
		else
			destination = get_area(GLOB.supply_elevator_turfs[target_zlevel])
	if(!origin)
		if(!fake_zlevel)
			origin = area_offsite
		else
			origin = get_location_area()

	moving_status = SHUTTLE_WARMUP
	update_controller()
	if(!target_zlevel && fake_zlevel)
		playsound(GLOB.supply_elevator_turfs[fake_zlevel], 'sound/machines/cargo_alarm.ogg', 50, 0) //ELEVATOR IS GOING TO ASRS GERT UFF!!
		raise_railingz(fake_zlevel)

	sleep(warmup_time)

	if (moving_status == SHUTTLE_IDLE)
		return	//someone cancelled the launch

	raise_railingz(fake_zlevel)

	if (!target_zlevel)
		sleep(12)
		if(forbidden_atoms_check())
			//cancel the launch because of forbidden atoms. announce over supply channel?
			moving_status = SHUTTLE_IDLE
			playsound(GLOB.supply_elevator_turfs[fake_zlevel], 'sound/machines/buzz-two.ogg', 50, 0)
			if(fake_zlevel == supply_controller.primary_fake_zlevel)
				lower_railingz(fake_zlevel)
			update_controller()
			lower_railingz(fake_zlevel)
			return
	else if(!fake_zlevel)	//at ASRS
		supply_controller.buy()

	if(target_zlevel)
		moving_status = SHUTTLE_IDLE
		for(var/turf/T in shaft_transit_area)
			elevator_animationz[target_zlevel].vis_contents += T
		moving_status = SHUTTLE_WARMUP
	if(fake_zlevel)
		moving_status = SHUTTLE_IDLE
		for(var/turf/T in shaft_transit_area)
			elevator_animationz[fake_zlevel].vis_contents += T
		moving_status = SHUTTLE_WARMUP

	//We pretend it's a long_jump by making the shuttle move to transit location for the "in-transit" period.
	move_elevator_to_transit(origin, shaft_transit_area)

	var/timing_multiplier = (target_zlevel > fake_zlevel) ? target_zlevel - fake_zlevel : fake_zlevel - target_zlevel
	sleep(5 SECONDS * timing_multiplier) //muh transit time

	move_elevator_to_destination(shaft_transit_area, destination)

	addtimer(CALLBACK(src, PROC_REF(finish_jump)), 2.2 SECONDS, TIMER_UNIQUE)

/datum/shuttle/ferry/supply/multi/proc/finish_jump()
	fake_zlevel = target_zlevel
	lower_railingz(target_zlevel)
	update_controller()
	stop_gears()
	if (!at_station())	//at centcom
		handle_sell()
	recharging = 0

/datum/shuttle/ferry/supply/multi/proc/raise_railingz(deck)
	if(!deck)
		return

	var/effective = FALSE

	for(var/obj/structure/machinery/door/poddoor/railing/M in railingz[deck])
		if(!M.density)
			effective = TRUE

			M.close()

	for(var/obj/structure/machinery/door/airlock/D in range(GLOB.supply_elevator_turfs[deck], 3))
		for(var/turf/T in D.locs)
			for(var/mob/moving_mob in T.contents) // Bump all mobs outta the way for outside airlocks of shuttles
				if(isliving(moving_mob))
					to_chat(moving_mob, SPAN_HIGHDANGER("You get thrown back as the elevator doors slam shut!"))
					moving_mob.apply_effect(4, WEAKEN)
					for(var/turf/TT in orange(1, moving_mob)) // Forcemove to a non shuttle turf
						if(!TT.density && !istype(TT, /turf/open/floor/almayer/empty) && !(TT in D.locs) && get_area(TT) != get_location_area())
							moving_mob.forceMove(TT)
							break
		D.close()
		D.locked = TRUE
		D.update_icon()

	if(effective)
		playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/elevator_openclose.ogg', 50, 0)

/datum/shuttle/ferry/supply/multi/proc/lower_railingz(deck)
	if(!deck)
		return

	var/effective = FALSE

	for(var/obj/structure/machinery/door/poddoor/railing/M in railingz[deck])
		if(M.density)
			effective = TRUE
			INVOKE_ASYNC(M,  TYPE_PROC_REF(/obj/structure/machinery/door, open))

	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/elevator_3wide/D in range(GLOB.supply_elevator_turfs[deck], 4))
		D.locked = FALSE
		D.update_icon()

	if(effective)
		playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/elevator_openclose.ogg', 50, 0)

/datum/shuttle/ferry/supply/multi/proc/move_elevator_to_transit(origin, destination)
	var/movement_direction = get_movement_direction()
	var/do_continue_this_proc = FALSE

	var/plane_for_all_elevator_atoms = elevator_animationz[1].plane
	var/layer_for_all_elevator_atoms = elevator_animationz[1].layer

	for(var/turf/T in get_location_area())
		for(var/obj/O in T)
			if(O.clone)
				O.destroy_clone_movable()
			O.plane = plane_for_all_elevator_atoms
			if(O.layer >= T.layer)
				O.layer = layer_for_all_elevator_atoms + 0.015
			else
				O.layer = layer_for_all_elevator_atoms - 0.01
		for(var/mob/M in destination)
			if(M.clone)
				M.destroy_clone_movable()
			M.layer = layer_for_all_elevator_atoms + 0.02
			M.plane = plane_for_all_elevator_atoms + 0.02
		T.layer = layer_for_all_elevator_atoms + 0.01
		T.plane = plane_for_all_elevator_atoms

	moving_status = SHUTTLE_INTRANSIT

	// alot of checks here, ALL WORTH IT TRUST ME
	// the excessive logic is to find zlevels between the origin and the destination
	// and play animations of the elevator there

	if(!target_zlevel || !fake_zlevel)
		do_continue_this_proc = TRUE
	else if(target_zlevel > fake_zlevel && target_zlevel - fake_zlevel > 1)
		do_continue_this_proc = TRUE
	else if(target_zlevel < fake_zlevel && fake_zlevel - target_zlevel > 1)
		do_continue_this_proc = TRUE
	if(do_continue_this_proc)
		for(var/turf/T in GLOB.supply_elevator_turfs)
			var/area/Ts_area = get_area(T)
			var/Ts_fake_zlevel = Ts_area.fake_zlevel

			if(Ts_fake_zlevel == fake_zlevel || Ts_fake_zlevel == target_zlevel)
				continue
			if(movement_direction && Ts_fake_zlevel < target_zlevel)
				continue
			if(!movement_direction && target_zlevel && Ts_fake_zlevel > target_zlevel)
				continue

			for(var/turf/TT in shaft_transit_area)
				elevator_animationz[Ts_fake_zlevel].vis_contents += TT

			if(movement_direction)
				elevator_animationz[Ts_fake_zlevel].pixel_y = -180
				elevator_animationz[Ts_fake_zlevel].alpha = 255
			else
				elevator_animationz[Ts_fake_zlevel].pixel_y = 180
				elevator_animationz[Ts_fake_zlevel].alpha = 0

			animate(elevator_animationz[Ts_fake_zlevel], pixel_y = 0, alpha = 255, time = 2 SECONDS)
			elevator_animationz[Ts_fake_zlevel].pixel_y = 0

			if(movement_direction)
				animate(elevator_animationz[Ts_fake_zlevel], pixel_y = 180, alpha = 0, time = 2 SECONDS)
			else
				animate(elevator_animationz[Ts_fake_zlevel], pixel_y = 180, time = 2 SECONDS)

			message_admins("[fake_zlevel] ---> [target_zlevel] @ [Ts_fake_zlevel]")

			addtimer(CALLBACK(src, PROC_REF(premove_shenanigans), Ts_fake_zlevel), 4 SECONDS, TIMER_UNIQUE)

	if(movement_direction)
		move_elevator_up_from(origin, destination)
	else
		move_elevator_down_from(origin, destination)

/datum/shuttle/ferry/supply/multi/proc/move_elevator_to_destination(origin, destination)
	if(get_movement_direction())
		moving_status = SHUTTLE_IDLE
		move_elevator_up_towards(origin, destination)
	else
		moving_status = SHUTTLE_IDLE
		move_elevator_down_towards(origin, destination)

///MOVE JANKS vvvvvvvvvvv

/datum/shuttle/ferry/supply/multi/proc/move_elevator_down_from(origin, destination)
	move(origin, destination)
	start_gears(SOUTH)
	if(fake_zlevel)
		var/animation_timing = 2 SECONDS
		var/animation_offset = -180
		if(target_zlevel == fake_zlevel + 1)
			animation_timing = 7 SECONDS
			animation_offset = -128
		elevator_animationz[fake_zlevel].pixel_y = 0
		//elevator_animationz[fake_zlevel].color = "#000000"
		playsound(GLOB.supply_elevator_turfs[fake_zlevel], 'sound/machines/asrs_lowering.ogg', 50, 0)
		animate(elevator_animationz[fake_zlevel], pixel_y = animation_offset, color = "#577eaa", time = animation_timing)
		addtimer(CALLBACK(src, PROC_REF(premove_shenanigans), fake_zlevel), animation_timing, TIMER_UNIQUE)

/datum/shuttle/ferry/supply/multi/proc/move_elevator_up_from(origin, destination)
	move(origin, destination)
	start_gears(NORTH)
	if(fake_zlevel)
		elevator_animationz[fake_zlevel].pixel_y = 0
		elevator_animationz[fake_zlevel].alpha = 255
		playsound(GLOB.supply_elevator_turfs[fake_zlevel], 'sound/machines/asrs_raising.ogg', 50, 0)
		animate(elevator_animationz[fake_zlevel], pixel_y = 96, alpha = 0, time = 2 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(premove_shenanigans), fake_zlevel), 2 SECONDS, TIMER_UNIQUE)
		if(target_zlevel == fake_zlevel - 1) //then we need to play unique animation of elevator crawling up @ the target_zlevel
			elevator_animationz[target_zlevel].pixel_y = -128
			elevator_animationz[target_zlevel].color = "#577eaa"
			animate(elevator_animationz[target_zlevel], pixel_y = 0,  color = "#ffffff", time = 7 SECONDS)

// --------------- LEAVING ORIGIN ^^^^^^^ --------- ARRIVING AT DESTINATION vvvvvvvvv

/datum/shuttle/ferry/supply/multi/proc/move_elevator_down_towards(origin, destination)
	if(target_zlevel)
		elevator_animationz[target_zlevel].pixel_y = 96
		elevator_animationz[target_zlevel].alpha = 0
		animate(elevator_animationz[target_zlevel], pixel_y = 0,  alpha = 255, time = 2 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(premove_shenanigans), target_zlevel,  list(origin, destination)), 2 SECONDS, TIMER_UNIQUE)
	playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/asrs_lowering.ogg', 50, 0)
	start_gears(SOUTH)

/datum/shuttle/ferry/supply/multi/proc/move_elevator_up_towards(origin, destination)
	playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/asrs_raising.ogg', 50, 0)

	if(target_zlevel != fake_zlevel - 1) //if this is true then the animation has already been handled in move_elevator_up_from()
		elevator_animationz[target_zlevel].pixel_y = -180
		elevator_animationz[target_zlevel].color = "#577eaa"
		animate(elevator_animationz[target_zlevel], pixel_y = 0, color = "#ffffff", time = 2 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(premove_shenanigans), target_zlevel, list(origin, destination)), 2 SECONDS, TIMER_UNIQUE)
	start_gears(NORTH)

/datum/shuttle/ferry/supply/multi/proc/premove_shenanigans(key_into_elevator_animationz, list/trigger_move)
	if(key_into_elevator_animationz && key_into_elevator_animationz <= length(elevator_animationz))
		elevator_animationz[key_into_elevator_animationz].vis_contents.Cut()
	if(length(trigger_move) == 2)
		move(trigger_move[1], trigger_move[2])

// ============== BIG HONCHO MOVE PROC VVVVVVV ============ turf changes happen here!

/datum/shuttle/ferry/supply/multi/move(area/origin, area/destination)
	update_shaft_projectors(destination == shaft_transit_area ? ELEVATOR_MOVE_AWAY_FROM_ORIGIN_STAGE : ELEVATOR_MOVE_TOWARDS_DESTINATION_STAGE, TRUE)
	update_shaft_effects(ELEVATOR_MOVE_AWAY_FROM_ORIGIN_STAGE, destination)

	for(var/turf/closed/wall/supply_shaft/SS in transit_location_walls)
		SS.set_movement_dir(get_movement_direction())

	if(get_area(in_elevator_controller.attached_to) != get_area(in_elevator_controller))
		var/mob/dummy_user
		in_elevator_controller.attackby(in_elevator_controller.attached_to, dummy_user)
		//if the remote isnt in the elevator it just rubber banded

	..()

	update_shaft_effects(ELEVATOR_MOVE_TOWARDS_DESTINATION_STAGE, destination)
	update_shaft_projectors(destination == shaft_transit_area ? ELEVATOR_MOVE_AWAY_FROM_ORIGIN_STAGE : ELEVATOR_MOVE_TOWARDS_DESTINATION_STAGE, FALSE)

	if(destination != shaft_transit_area)
		for(var/turf/T in destination)
			T.layer = initial(T.layer)
			T.plane = initial(T.plane)
			for(var/obj/O in T.contents)
				O.layer = initial(O.layer)
				O.plane = initial(O.plane)
			for(var/mob/M in destination)
				M.layer = initial(M.layer)
				M.plane = initial(M.plane)

		var/area/target_area
		if(!target_zlevel)
			target_area = area_offsite
		else
			target_area = get_area(GLOB.supply_elevator_turfs[target_zlevel])
		fake_zlevel = target_area.fake_zlevel

//END MOVE JANKS ^^^^^^^^^^^

/datum/shuttle/ferry/supply/multi/proc/update_shaft_effects(mode, destination)
	switch(mode)
		if(ELEVATOR_MOVE_AWAY_FROM_ORIGIN_STAGE)
			if(destination != shaft_transit_area)
				if(target_zlevel)
					elevator_effects["[target_zlevel]SW"].moveToNullspace()
					elevator_effects["[target_zlevel]SE"].moveToNullspace()
					elevator_effects["[target_zlevel]NW"].moveToNullspace()
					elevator_effects["[target_zlevel]NE"].moveToNullspace()
			if(fake_zlevel)
				elevator_effects["[fake_zlevel]SW"].moveToNullspace()
				elevator_effects["[fake_zlevel]SE"].moveToNullspace()
				elevator_effects["[fake_zlevel]NW"].moveToNullspace()
				elevator_effects["[fake_zlevel]NE"].moveToNullspace()

		if(ELEVATOR_MOVE_TOWARDS_DESTINATION_STAGE)
			if(destination != shaft_transit_area)
				if(target_zlevel)
					var/turf/turf_arrived_at = GLOB.supply_elevator_turfs[target_zlevel]
					elevator_effects["[target_zlevel]SW"].forceMove(locate(turf_arrived_at.x-2, turf_arrived_at.y-2, turf_arrived_at.z))
					elevator_effects["[target_zlevel]SE"].forceMove(locate(turf_arrived_at.x+2, turf_arrived_at.y-2, turf_arrived_at.z))
					elevator_effects["[target_zlevel]NW"].forceMove(locate(turf_arrived_at.x-2, turf_arrived_at.y+2, turf_arrived_at.z))
					elevator_effects["[target_zlevel]NE"].forceMove(locate(turf_arrived_at.x+2, turf_arrived_at.y+2, turf_arrived_at.z))
			if(fake_zlevel)
				var/turf/departing_from_turf = GLOB.supply_elevator_turfs[fake_zlevel]
				elevator_effects["[fake_zlevel]SW"].forceMove(locate(departing_from_turf.x-2, departing_from_turf.y-2, departing_from_turf.z))
				elevator_effects["[fake_zlevel]SE"].forceMove(locate(departing_from_turf.x+2, departing_from_turf.y-2, departing_from_turf.z))
				elevator_effects["[fake_zlevel]NW"].forceMove(locate(departing_from_turf.x-2, departing_from_turf.y+2, departing_from_turf.z))
				elevator_effects["[fake_zlevel]NE"].forceMove(locate(departing_from_turf.x+2, departing_from_turf.y+2, departing_from_turf.z))

/datum/shuttle/ferry/supply/multi/proc/update_shaft_projectors(mode, stage)
	//this assumes the projectors are from lower zlevels [FROM INSIDE A SHAFT]
	//and that lower zlevels are ordered from 1 up, moving downwards from the topdeck(1)
	//all logic handled by /datum/controller/subsystem/fz_transitions/fire()
	var/zlevel_key = mode ? fake_zlevel : target_zlevel
	if(zlevel_key && zlevel_key <= length(shaft_projectors))
		for(var/obj/effect/projector/P in shaft_projectors[zlevel_key])
			P.update_state(stage)
		if((zlevel_key) + 1 <= length(shaft_projectors))
			if(stage != mode)
				for(var/obj/effect/projector/P in shaft_projectors[(zlevel_key) + 1])
					P.update_state(stage)

		for(var/obj/effect/step_trigger/clone_cleaner/CC in shaft_cleanerz[zlevel_key])
			switch(stage)
				if(TRUE)
					CC.coord_cache = list(CC.x,CC.y,CC.z)
					CC.moveToNullspace()
				if(FALSE)
					CC.forceMove(locate(CC.coord_cache[1], CC.coord_cache[2], CC.coord_cache[3]))

/datum/shuttle/ferry/supply/multi/forbidden_atoms_check()
	if(!target_zlevel)
		return ..()
	else
		return FALSE

/datum/shuttle/ferry/supply/multi/proc/update_controller()
	in_elevator_controller.attached_to.overlays.Cut()

	var/deck_above = fake_zlevel - 1 > 0 ? TRUE : FALSE
	var/deck_below = fake_zlevel + 1 <= length(GLOB.supply_elevator_turfs) ? TRUE : FALSE

	if(moving_status != SHUTTLE_IDLE)
		if(!target_zlevel)
			in_elevator_controller.attached_to.overlays += icon('icons/obj/items/misc.dmi', "ec_overlay_asrs")
		else if(!isnull(get_movement_direction()))
			if(get_movement_direction())
				in_elevator_controller.attached_to.overlays += icon('icons/obj/items/misc.dmi', "ec_overlay_up")
			else
				in_elevator_controller.attached_to.overlays += icon('icons/obj/items/misc.dmi', "ec_overlay_down")
	else
		if(!deck_above)
			in_elevator_controller.attached_to.overlays += icon('icons/obj/items/misc.dmi', "ec_overlay_top")

		if(!deck_below)
			in_elevator_controller.attached_to.overlays += icon('icons/obj/items/misc.dmi', "ec_overlay_bottom")

		if(fake_zlevel)
			in_elevator_controller.attached_to.overlays += icon('icons/obj/items/misc.dmi', "ec_overlay_level[fake_zlevel]")
			//in_elevator_controller.attached_to.choices[fake_zlevel].underlays += icon('icons/obj/items/misc.dmi', "ec_button_current")

/datum/shuttle/ferry/supply/multi/proc/choices_to_number(choice)
	if(isnum(choice))
		if(choice <= 0)
			return "ASRS"
		else
			return "Deck [choice]"
	else if(istext(choice))
		if(findtext(choice, "ASRS"))
			return 0
		else
			var/list/parsedText = splittext(choice, " ")
			if(length(parsedText) == 2 && parsedText[1] == "Deck")
				return text2num(parsedText[2])
	else
		return null

/obj/item/elevator_contoller
	name = "Freight Elevator Controller"
	icon = 'icons/obj/items/misc.dmi'
	icon_state = "elevator_control"

	w_class = SIZE_LARGE

	var/obj/structure/elevator_control_mount/attached_to
	var/datum/effects/tethering/tether_effect

	var/zlevel_transfer = FALSE
	var/zlevel_transfer_timer = TIMER_ID_NULL
	var/zlevel_transfer_timeout = 5 SECONDS

	var/list/image/choices = list()

	var/datum/shuttle/ferry/supply/multi/my_elevator

/obj/item/elevator_contoller/Initialize(mapload)
	. = ..()
	if(istype(loc, /obj/structure/elevator_control_mount))
		attach_to(loc)

	choices["ASRS"] =  image(icon= icon, icon_state = "ec_button_asrs")

	for(var/turf/T in GLOB.supply_elevator_turfs)
		var/area/T_area = get_area(T)
		var/T_fake_zlevel = T_area.fake_zlevel
		choices["Deck [T_fake_zlevel]"] = image(icon = icon, icon_state = "ec_button_[T_fake_zlevel]")

	addtimer(CALLBACK(src, PROC_REF(elevator_check)), 10 SECONDS, TIMER_UNIQUE)

/obj/item/elevator_contoller/proc/elevator_check()
	my_elevator = supply_controller.shuttle

	if(!istype(my_elevator, /datum/shuttle/ferry/supply/multi))
		//so many runtimes will happen if this is operated without the proper elevator, necessary preventative measure here
		message_admins("/obj/item/elevator_contoller was created without the proper elevator in existence; deleted itself")
		qdel(attached_to)
		qdel(src)

/obj/item/elevator_contoller/Destroy()
	remove_attached()
	return ..()

/obj/item/elevator_contoller/attack_self(mob/user)
	. = ..()

	if(!skillcheck(user, SKILL_POWERLOADER, SKILL_POWERLOADER_TRAINED))
		to_chat(user, SPAN_BOLDNOTICE("You have no idea how to work this thing. Better not mess with it."))
		return

	if(supply_controller.shuttle.moving_status != SHUTTLE_IDLE)
		to_chat(user, SPAN_BOLDNOTICE("The elevator is still processing."))
		return

	var/choice = show_radial_menu(user, user, choices, require_near = TRUE)
	try_moving_shuttle(user, my_elevator.choices_to_number(choice))

/obj/item/elevator_contoller/proc/try_moving_shuttle(mob/user, target_deck)
	if(isnull(target_deck) || !istype(supply_controller.shuttle, /datum/shuttle/ferry/supply/multi))
		return

	var/datum/shuttle/ferry/supply/multi/m_shuttle = supply_controller.shuttle

	if(m_shuttle.fake_zlevel == target_deck)
		to_chat(user, SPAN_WARNING("The elevator is already on Deck [target_deck]"))
		return

	to_chat(user, SPAN_WARNING("Moving the elevator to [my_elevator.choices_to_number(target_deck)]!"))
	m_shuttle.target_zlevel = target_deck
	if(m_shuttle.process_state == WAIT_LAUNCH)
		m_shuttle.force_launch()
	else
		m_shuttle.launch()

/obj/item/elevator_contoller/proc/attach_to(obj/structure/elevator_control_mount/to_attach)
	if(!istype(to_attach))
		return

	remove_attached()

	attached_to = to_attach

/obj/item/elevator_contoller/proc/remove_attached()
	attached_to = null
	reset_tether()

/obj/item/elevator_contoller/proc/reset_tether()
	SIGNAL_HANDLER
	if (tether_effect)
		UnregisterSignal(tether_effect, COMSIG_PARENT_QDELETING)
		if(!QDESTROYING(tether_effect))
			qdel(tether_effect)
		tether_effect = null
	if(!do_zlevel_check())
		on_beam_removed()

/obj/item/elevator_contoller/attack_hand(mob/user)
	if(attached_to && get_dist(user, attached_to) > attached_to.range)
		return FALSE
	return ..()

/obj/item/elevator_contoller/proc/on_beam_removed()
	if(!attached_to)
		return

	if(loc == attached_to)
		return

	if(get_dist(attached_to, src) > attached_to.range)
		attached_to.recall_phone()

	var/atom/tether_to = src

	if(loc != get_turf(src))
		tether_to = loc
		if(tether_to.loc != get_turf(tether_to))
			attached_to.recall_phone()
			return

	var/atom/tether_from = attached_to

	if(attached_to.tether_holder)
		tether_from = attached_to.tether_holder

	if(tether_from == tether_to)
		return

	var/list/tether_effects = apply_tether(tether_from, tether_to, range = attached_to.range, icon = "wire", always_face = FALSE)
	tether_effect = tether_effects["tetherer_tether"]
	RegisterSignal(tether_effect, COMSIG_PARENT_QDELETING, PROC_REF(reset_tether))

/obj/item/elevator_contoller/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_LIVING_SPEAK)

/obj/item/elevator_contoller/on_enter_storage(obj/item/storage/S)
	. = ..()
	if(attached_to)
		attached_to.recall_phone()

/obj/item/elevator_contoller/forceMove(atom/dest)
	. = ..()
	if(.)
		reset_tether()

/obj/item/elevator_contoller/proc/do_zlevel_check()
	if(!attached_to || !loc.z || !attached_to.z)
		return FALSE

	if(zlevel_transfer)
		if(loc.z == attached_to.z)
			zlevel_transfer = FALSE
			if(zlevel_transfer_timer)
				deltimer(zlevel_transfer_timer)
			UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
			return FALSE
		return TRUE

	if(attached_to && loc.z != attached_to.z)
		zlevel_transfer = TRUE
		zlevel_transfer_timer = addtimer(CALLBACK(src, PROC_REF(try_doing_tether)), zlevel_transfer_timeout, TIMER_UNIQUE|TIMER_STOPPABLE)
		return TRUE
	return FALSE


/obj/item/elevator_contoller/proc/try_doing_tether()
	zlevel_transfer_timer = TIMER_ID_NULL
	zlevel_transfer = FALSE
	UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
	reset_tether()

// ------------- HERE BE YE OLDE INDUSTRIAL ELEVATOR CONTROLLER MOUNT STRUCTURE ------------

/obj/structure/elevator_control_mount
	name = "Elevator Control"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "elevator_control"
	desc = "This holds the elevator controller. What a fine piece of technology."
	pixel_y = 28
	layer = ABOVE_MOB_LAYER

	var/obj/item/elevator_contoller/attached_to
	var/atom/tether_holder

	var/range = 3

	var/enabled = TRUE

/obj/structure/action_relay
	//I relay actions YO
	var/obj/target

/obj/structure/action_relay/attack_hand(mob/user)
	if(target)
		target.attack_hand(user)

/obj/structure/elevator_control_mount/Initialize(mapload, ...)
	. = ..()

	attached_to = new /obj/item/elevator_contoller(src)
	RegisterSignal(attached_to, COMSIG_PARENT_PREQDELETED, PROC_REF(override_delete))

	for(var/obj/structure/action_relay/AR in range(10, src))
		AR.target = src
		AR.appearance = appearance
		AR.pixel_y = -4

/obj/structure/elevator_control_mount/update_icon()
	. = ..()

	if(attached_to in contents)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_hand"

/obj/structure/elevator_control_mount/attack_hand(mob/user)
	. = ..()

	if(!attached_to || attached_to.loc != src)
		return

	if(!ishuman(user))
		return

	if(!enabled)
		return

	user.put_in_active_hand(attached_to)
	update_icon()

/obj/structure/elevator_control_mount/proc/recall_phone()
	if(ismob(attached_to.loc))
		var/mob/M = attached_to.loc
		M.drop_held_item(attached_to)
		playsound(get_turf(M), "rtb_handset", 100, FALSE, 7)

	attached_to.forceMove(src)

	update_icon()

/obj/structure/elevator_control_mount/proc/override_delete()
	SIGNAL_HANDLER
	recall_phone()
	return COMPONENT_ABORT_QDEL

/obj/structure/elevator_control_mount/proc/set_tether_holder(atom/A)
	tether_holder = A

	if(attached_to)
		attached_to.reset_tether()

/obj/structure/elevator_control_mount/attackby(obj/item/W, mob/user)
	if(W == attached_to)
		recall_phone()
	else
		. = ..()

/obj/structure/elevator_control_mount/Destroy()
	if(attached_to)
		if(attached_to.loc == src)
			UnregisterSignal(attached_to, COMSIG_PARENT_PREQDELETED)
			qdel(attached_to)
		else
			attached_to.attached_to = null
			attached_to = null

	return ..()
