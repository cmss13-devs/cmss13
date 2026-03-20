#define LAYER_OFFSET_ABOVE_BASE 0.1
#define LAYER_OFFSET_LOW 0.2
#define LAYER_OFFSET_ABOVE_LOW 0.3
#define LAYER_OFFSET_HIGH 0.4

/**
 * Finish the machine gun
 * Fix pixel_w and z offsets not reseting on unbuckle
 * Animate client's pixel_w and z to make it less nausea inducing
 */


/obj/vehicle/multitile/warthog
	name = "M12 'Warthog' Light Reconnaissance Vehicle"
	desc = "Its definitely not a Puma."
	layer = ABOVE_XENO_LAYER // its probably fine

	icon = 'icons/halo/obj/vehicles/warthog.dmi'
	icon_state = "warthog_base"
	pixel_x = -16
	pixel_y = -16

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	// interior_map = /datum/map_template/interior/van
	interior_map = null

	vehicle_flags = VEHICLE_CLASS_LIGHT
	move_delay = VEHICLE_SPEED_FASTER

	misc_multipliers = list(
		"move" = 0.5, // fucking annoying how this is the only way to modify speed
		"accuracy" = 1,
		"cooldown" = 1
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_4_light.ogg'

	light_range = 3
	vehicle_light_range = 6

	move_max_momentum = 3

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/van_wheels,
		/obj/item/hardpoint/special/vulcan,
	)

	move_turn_momentum_loss_factor = 1

	req_access = list()
	req_one_access = list()

	door_locked = FALSE

	move_on_turn = TRUE

	can_buckle = TRUE
	buckle_lying = 0

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_SUPPORT_GUNNER_ONE = null,
		VEHICLE_GUNNER = null,
	)
	silent_hardpoint_warning = TRUE

	var/list/buckled_offsets = list()

	var/list/locs_positions = list()

	var/obj/item/steering_wheel/the_steering_wheel

/obj/vehicle/multitile/warthog/Initialize()
	. = ..()

	buckled_offsets = list(
		// position, direction, (x, y)
		VEHICLE_DRIVER = list(
			"[NORTH]" = list(-8, -8, FALSE),
			"[SOUTH]" = list(8, -8, TRUE),
			"[EAST]" = list(0, 0, FALSE),
			"[WEST]" = list(0, -10, TRUE)
		),
		VEHICLE_SUPPORT_GUNNER_ONE = list(
			"[NORTH]" = list(8, -6, FALSE),
			"[SOUTH]" = list(-8, -6, TRUE),
			"[EAST]" = list(0, -8, TRUE),
			"[WEST]" = list(0, 0, FALSE)
		),
		VEHICLE_GUNNER = list(
			"[NORTH]" = list(0, -20, TRUE),
			"[SOUTH]" = list(0, 28, FALSE),
			"[EAST]" = list(-26, 8, FALSE),
			"[WEST]" = list(26, 8, FALSE)
		)
	)

	locs_positions = list(
		VEHICLE_DRIVER = list(
			"[NORTH]" = 1,
			"[SOUTH]" = 2,
			"[EAST]" = 4,
			"[WEST]" = 1
		),
		VEHICLE_SUPPORT_GUNNER_ONE = list(
			"[NORTH]" = 2,
			"[SOUTH]" = 1,
			"[EAST]" = 2,
			"[WEST]" = 3
		),
		VEHICLE_GUNNER = list(
			"[NORTH]" = list(1, 2),
			"[SOUTH]" = list(3, 4),
			"[EAST]" = list(1, 3),
			"[WEST]" = list(2, 4)
		)
	)

/obj/vehicle/multitile/warthog/Destroy()
	qdel(the_steering_wheel)
	return ..()

/obj/vehicle/multitile/warthog/buckle_mob(mob/M, mob/user)
	if (!ismob(M) || user.stat || M.buckled || !isturf(user.loc))
		return

	if (!Adjacent(M))
		return

	if (user.is_mob_incapacitated() || HAS_TRAIT(user, TRAIT_IMMOBILIZED) || HAS_TRAIT(user, TRAIT_FLOORED))
		to_chat(user, SPAN_WARNING("You can't do this right now."))
		return

	if (isxeno(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do that, try a nest."))
		return
	if (iszombie(user))
		return

	var/target_seat = get_target_seat(M)

	if(!target_seat)
		to_chat(user, SPAN_WARNING("Get [M] closer to a seat!"))
		return

	if(seats[target_seat])
		to_chat(user, SPAN_WARNING("[seats[target_seat]] is already sitting in the [target_seat] seat!"))
		return

	M.visible_message(SPAN_NOTICE("[M] starts climbing into the [target_seat] seat."), SPAN_NOTICE("You start climbing into the [target_seat] seat."))
	if(!do_after(user, 0.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		return

	if(density)
		density = FALSE
		if(!step(M, get_dir(M, locs[locs_positions[target_seat]["[dir]"]])) && !is_valid_seat_locs_turf(M, target_seat))
			density = TRUE
			return
		density = TRUE
	else
		if(!is_valid_seat_locs_turf(M, target_seat))
			step_towards(M, locs[locs_positions[target_seat]["[dir]"]]) //buckle if you're right next to it
			if(!is_valid_seat_locs_turf(M, target_seat))
				return
			. = buckle_mob(M)

	if (M.mob_size <= MOB_SIZE_XENO)
		if (HAS_TRAIT(M, TRAIT_OPPOSABLE_THUMBS))
			do_buckle(M, user, target_seat)
			return
	if (M.mob_size > MOB_SIZE_HUMAN)
		to_chat(user, SPAN_WARNING("[M] is too big to buckle in."))
		return
	do_buckle(M, user, target_seat)

/obj/vehicle/multitile/warthog/do_buckle(mob/living/target, mob/user, seat)
	if(!seat || !src || !loc)
		return FALSE
	send_buckling_message(target, user, seat)
	target.throw_alert(ALERT_BUCKLED, /atom/movable/screen/alert/buckled)
	target.set_buckled(src)
	target.forceMove(loc)
	target.setDir(dir)
	buckled_mob = null
	set_seated_mob(seat, target)
	add_fingerprint(user)
	afterbuckle(target)
	switch(seat)
		if(VEHICLE_DRIVER)
			vehicle_faction = target.faction
		if(VEHICLE_GUNNER)
			for(var/obj/item/hardpoint/special/vulcan/vulcan in hardpoints)
				active_hp[VEHICLE_GUNNER] = vulcan
				break
	return TRUE

/obj/vehicle/multitile/warthog/afterbuckle(mob/M)
	. = ..()
	update_mob_offsets()

/obj/vehicle/multitile/warthog/update_icon()
	. = ..()
	overlays += image(icon_state = "warthog_low_overlay", layer = src.layer + LAYER_OFFSET_LOW)
	overlays += image(icon_state = "warthog_high_overlay", layer = src.layer + LAYER_OFFSET_HIGH)

/obj/vehicle/multitile/warthog/manual_unbuckle(mob/user)
	for(var/key in seats)
		if(user == seats[key])
			unbuckle(key)
			add_fingerprint(user)
			return TRUE
	var/target_seat = get_target_seat(user, FALSE)
	if(isnull(target_seat))
		to_chat(user, SPAN_WARNING("You have to be closer to unbuckle a seat."))
		return FALSE
	if(seats[target_seat])
		unbuckle(target_seat)
		add_fingerprint(user)
		return TRUE
	return FALSE

/obj/vehicle/multitile/warthog/unbuckle(unbuckle_seat)
	if(!unbuckle_seat)
		for(var/key in seats)
			if(ismob(seats[key]))
				unbuckle(key)
		return

	if(!ismob(seats[unbuckle_seat]))
		return

	buckled_mob = seats[unbuckle_seat]
	var/mob/the_mob = buckled_mob
	. = ..()
	if(unbuckle_seat == VEHICLE_DRIVER)
		QDEL_NULL(the_steering_wheel)
		vehicle_faction = ""
	the_mob.pixel_w = 0
	the_mob.pixel_z = 0
	the_mob.layer = MOB_LAYER
	set_seated_mob(unbuckle_seat, null)
	active_hp[unbuckle_seat] = null
	INVOKE_ASYNC(src, PROC_REF(exit_animation), the_mob, unbuckle_seat)

/obj/vehicle/multitile/warthog/proc/exit_animation(mob/living/the_mob, unbuckle_seat)
	var/exit_dir = NONE
	var/turf/exit_turf = get_seat_turf(unbuckle_seat)

	switch(unbuckle_seat)
		if(VEHICLE_DRIVER)
			exit_dir = turn(dir, 90)
		if(VEHICLE_SUPPORT_GUNNER_ONE)
			exit_dir = turn(dir, 270)
		if(VEHICLE_GUNNER)
			exit_dir = turn(dir, 180)
	the_mob.forceMove(exit_turf)
	sleep(0.1 SECONDS)
	step(the_mob, exit_dir)

/obj/vehicle/multitile/warthog/proc/get_seat_turf(target_seat)
	var/position = locs_positions[target_seat]["[dir]"]
	if(islist(position))
		position = pick(position)
	return locs[position]

/obj/vehicle/multitile/warthog/send_buckling_message(mob/living/target, mob/user, target_seat)
	target.visible_message(SPAN_NOTICE("[target] climbs into the [target_seat] seat."), SPAN_NOTICE("You climb into the [target_seat] seat."))

/obj/vehicle/multitile/warthog/forceMove(dest)
	var/old_loc = loc
	. = ..()
	handle_buckled_mob_movement(old_loc, dest)

/obj/vehicle/multitile/warthog/handle_buckled_mob_movement(NewLoc, direct)
	for(var/key in seats)
		if(!ismob(seats[key]))
			continue
		var/mob/seated_mob = seats[key]
		if(key != VEHICLE_GUNNER)
			seated_mob.setDir(dir)
		seated_mob.forceMove(loc)
		last_move_dir = seated_mob.last_move_dir
		seated_mob.inertia_dir = last_move_dir

		// Even if the movement is entirely managed by the object, notify the buckled mob that it's moving for its handler.
		//It won't be called otherwise because it's a function of client_move or pulled mob, neither of which accounts for this.
		SEND_SIGNAL(seated_mob, COMSIG_MOB_MOVE_OR_LOOK, TRUE, direct, direct)
		. = TRUE

/obj/vehicle/multitile/warthog/set_seated_mob(seat, mob/living/M)
	seats[seat] = M

	// Checked here because we want to be able to null the mob in a seat
	if(!istype(M))
		return FALSE

	M.set_interaction(src)
	return TRUE


/obj/vehicle/multitile/warthog/try_rotate()
	. = ..()
	if(.)
		update_mob_offsets()

/obj/vehicle/multitile/warthog/proc/update_mob_offsets()
	for(var/key in seats)
		if(!ismob(seats[key]))
			continue
		var/mob/seated_mob = seats[key]
		var/list/offsets = buckled_offsets[key]["[dir]"]
		seated_mob.pixel_w = offsets[1] + 16
		seated_mob.pixel_z = offsets[2] + 16
		seated_mob.layer = src.layer + (offsets[3] ? LAYER_OFFSET_ABOVE_LOW : LAYER_OFFSET_ABOVE_BASE)
	update_icon()

/obj/vehicle/multitile/warthog/relaymove(mob/user, direction)
	if(user == seats[VEHICLE_GUNNER])
		for(var/obj/item/hardpoint/special/vulcan/vulcan in hardpoints)
			if(!vulcan.target)
				user.setDir(direction)
				vulcan.setDir(direction)
				return
		return

	if(user != seats[VEHICLE_DRIVER])
		return

	var/obj/item/steering_wheel/wheel = user.get_active_hand()
	if(istype(wheel, /obj/item/steering_wheel))
		if(wheel.flags_item & WIELDED)
			move_delay = VEHICLE_SPEED_FASTER
		else
			move_delay = VEHICLE_SPEED_FAST
		return ..()

	wheel = user.get_inactive_hand()
	if(istype(wheel, /obj/item/steering_wheel))
		if(wheel.flags_item & WIELDED)
			move_delay = VEHICLE_SPEED_FASTER
		else
			move_delay = VEHICLE_SPEED_FAST
			if(prob(5) && user.get_active_hand())
				direction = pick(turn(direction, 90), turn(direction, -90))
				user.visible_message(
					SPAN_WARNING("[user]'s hand slips causing the warthog to swerve!"),
					SPAN_WARNING("Your off-hand grip on [wheel] slips, causing the warthog to swerve!")
				)
		return ..()
	the_steering_wheel = new /obj/item/steering_wheel(loc)
	RegisterSignal(the_steering_wheel, COMSIG_PARENT_QDELETING, PROC_REF(null_steering_wheel))
	if(user.put_in_any_hand_if_possible(the_steering_wheel, TRUE, TRUE))
		return relaymove(user, direction)
	direction = dir // LOOK MOM NO HANDS!!!
	return ..()

/obj/vehicle/multitile/warthog/proc/null_steering_wheel()
	the_steering_wheel = null

/obj/vehicle/multitile/warthog/proc/get_target_seat(mob/M, ignore_full_seats = TRUE)
	var/bucklee_dir = get_dir(M, src)
	if(get_turf(M) in locs)
		for(var/seat in locs_positions)
			if(seats[seat] && ignore_full_seats)
				continue
			if(is_valid_seat_locs_turf(M, seat))
				return seat
		return
	if(bucklee_dir & turn(dir, 180))
		return null
	else if(bucklee_dir & dir)
		return VEHICLE_GUNNER
	else if(bucklee_dir & turn(dir, -90))
		return VEHICLE_DRIVER
	else if(bucklee_dir & turn(dir, 90))
		return VEHICLE_SUPPORT_GUNNER_ONE

/obj/vehicle/multitile/warthog/proc/is_valid_seat_locs_turf(mob/M, target_seat)
	return TRUE
/*
	var/list/position = locs_positions[target_seat]["[dir]"]
	var/turf/mob_turf = get_turf(M)
	if(islist(position))
		for(var/turf_key in position)
			if(mob_turf == locs[turf_key])
				return TRUE
	else
		if(mob_turf == locs[position])
			return TRUE
	return FALSE
*/
/obj/vehicle/multitile/warthog/BlockedPassDirs(atom/movable/mover, target_dir)
	if(isliving(mover))
		var/mob/living/M = mover
		if(M.mob_flags & SQUEEZE_UNDER_VEHICLES)
			return NO_BLOCKED_MOVEMENT

		if(M.body_position == LYING_DOWN)
			return NO_BLOCKED_MOVEMENT

	return ..()

/obj/vehicle/multitile/warthog/attackby(obj/item/O, mob/user)
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


/obj/vehicle/multitile/warthog/get_projectile_hit_boolean(obj/projectile/P)
	if(src == P.original) //clicking on the car itself will hit it.
		var/hitchance = P.get_effective_accuracy()
		if(prob(hitchance))
			return TRUE
	return FALSE

/obj/vehicle/multitile/warthog/Collide(atom/A)
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

/obj/vehicle/multitile/warthog/handle_hardpoint_images()
	for(var/obj/item/hardpoint/hardpoint in hardpoints)
		var/image/hardpoint_image = hardpoint.get_hardpoint_image()
		if(islist(hardpoint_image))
			var/list/image/hardpoint_image_list = hardpoint_image
			var/base_offset = src.layer + (buckled_offsets[VEHICLE_GUNNER]["[dir]"][3] ? LAYER_OFFSET_ABOVE_LOW : LAYER_OFFSET_ABOVE_BASE)
			var/image/chaingun_low = hardpoint_image_list[1]
			var/image/chaingun_high = hardpoint_image_list[2]
			chaingun_low.layer = base_offset - 0.01
			chaingun_high.layer = base_offset + 50 // peak shitcode
		else if(istype(hardpoint_image))
			hardpoint_image.layer = layer + hardpoint.hdpt_layer * 0.1
		overlays += hardpoint_image

/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/warthog
	name = "Warthog Spawner"
	icon = 'icons/halo/obj/vehicles/warthog.dmi'
	icon_state = "warthog_base"
	pixel_x = -16
	pixel_y = -16

/obj/effect/vehicle_spawner/warthog/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

/obj/effect/vehicle_spawner/warthog/spawn_vehicle()
	var/obj/vehicle/multitile/warthog/hog = new (loc)

	handle_direction(hog)
	load_hardpoints(hog)
	hog.update_icon()
	. = hog

/obj/effect/vehicle_spawner/warthog/load_hardpoints(obj/vehicle/multitile/warthog/V)
	// V.add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)

/obj/effect/vehicle_spawner/warthog/marines/machinegun/load_hardpoints(obj/vehicle/multitile/warthog/V)
	. = ..()
	V.add_hardpoint(new /obj/item/hardpoint/special/vulcan)

/**
 * For easier debugging, a preset that has marines in it
 */

/obj/effect/vehicle_spawner/warthog/marines/spawn_vehicle()
	var/obj/vehicle/multitile/warthog/hog = ..()
	var/mob/living/carbon/human/next_passenger = new /mob/living/carbon/human(loc)
	arm_equipment(next_passenger, /datum/equipment_preset/unsc/pfc/equipped, TRUE, TRUE)
	qdel(next_passenger.glasses)
	hog.do_buckle(next_passenger, next_passenger, VEHICLE_DRIVER)

	next_passenger = new /mob/living/carbon/human(loc)
	arm_equipment(next_passenger, /datum/equipment_preset/unsc/leader/equipped, TRUE, TRUE)
	hog.do_buckle(next_passenger, next_passenger, VEHICLE_GUNNER)

	next_passenger = new /mob/living/carbon/human(loc)
	arm_equipment(next_passenger, /datum/equipment_preset/unsc/medic/equipped, TRUE, TRUE)
	qdel(next_passenger.glasses)
	next_passenger.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	hog.do_buckle(next_passenger, next_passenger, VEHICLE_SUPPORT_GUNNER_ONE)

// //PRESET: wheels installed
/obj/effect/vehicle_spawner/warthog/machinegun/load_hardpoints(obj/vehicle/multitile/warthog/V)
	. = ..()
	V.add_hardpoint(new /obj/item/hardpoint/special/vulcan)

/obj/item/steering_wheel
	name = "steering wheel"
	desc = "Use it to drive. Supposedly using both hands makes you go faster."
	icon = 'icons/halo/obj/vehicles/hardpoints/warthog.dmi'
	icon_state = "steering_wheel"
	w_class = SIZE_LARGE
	flags_item = TWOHANDED|DELONDROP

/obj/item/steering_wheel/attack_self(mob/user)
	. = ..()
	if(flags_item & WIELDED)
		unwield(user)
	else
		wield(user)

/obj/item/steering_wheel/dropped(mob/user)
	..()
	unwield(user)
