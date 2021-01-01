
//Trucks
//Read the documentation in multitile.dm before trying to decipher this stuff

/obj/vehicle/multitile/van
	name = "Colony Van"
	desc = "A rather old hunk of metal with four wheels, you know what to do. Entrance on the back and sides."

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

	interior_capacity = 8

	misc_multipliers = list(
		"move" = 0.5, // fucking annoying how this is the only way to modify speed
		"accuracy" = 1,
		"cooldown" = 1
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_2_truck.ogg'

	luminosity = 8

	max_momentum = 3

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/van_wheels
	)

	hardpoints = list(
		HDPT_SUPPORT = null,
		HDPT_WHEELS = null
	)

	turn_momentum_loss_factor = 1

	req_access = list()
	req_one_access = list()

	door_locked = FALSE

	mob_size_required_to_hit = MOB_SIZE_XENO

	var/next_overdrive = 0
	var/overdrive_cooldown = 15 SECONDS
	var/overdrive_duration = 3 SECONDS
	var/overdrive_speed_mult = 0.3 // Additive (30% more speed, adds to 80% more speed)

	var/momentum_loss_on_weeds_factor = 0.2

	move_on_turn = TRUE

/obj/structure/interior_wall/van
	name = "van interior wall"
	desc = "An interior wall."
	icon = 'icons/obj/vehicles/interiors/van.dmi'
	icon_state = "van_right_1"
	density = 1
	opacity = 0
	anchored = 1
	mouse_opacity = 0
	layer = WINDOW_LAYER
	flags_atom = ON_BORDER|NOINTERACT
	unacidable = TRUE

/*
** PRESETS
*/
/obj/vehicle/multitile/van/handle_living_collide(var/mob/living/L)
	if(L.mob_size >= MOB_SIZE_IMMOBILE)
		return FALSE

	var/direction_taken = pick(45, -45)
	var/successful = step(L, turn(last_move_dir, direction_taken))

	if(!successful)
		successful = step(L, turn(last_move_dir, -direction_taken))

	if(L.mob_size >= MOB_SIZE_BIG)
		return FALSE

	return successful

/obj/vehicle/multitile/van/post_movement()
	if(locate(/obj/effect/alien/weeds) in loc)
		momentum *= momentum_loss_on_weeds_factor

	. = ..()


/obj/vehicle/multitile/van/attackby(obj/item/O, mob/user)
	if(iswelder(O) && health >= initial(health))
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
		if(next_overdrive > world.time)
			to_chat(user, SPAN_WARNING("You can't activate overdrive yet! Wait [round((next_overdrive - world.time) / 10, 0.1)] seconds."))
			return

		misc_multipliers["move"] -= overdrive_speed_mult
		addtimer(CALLBACK(src, .proc/reset_overdrive), overdrive_duration)

		next_overdrive = world.time + overdrive_cooldown
		to_chat(user, SPAN_NOTICE("You activate overdrive."))
		playsound(src, 'sound/vehicles/overdrive_activate.ogg', 75, FALSE)
		return

	return ..()

/obj/vehicle/multitile/van/proc/reset_overdrive()
	misc_multipliers["move"] += overdrive_speed_mult

//van spawner that spawns in an van that's NOT eight kinds of awful, mostly for testing purposes
/obj/vehicle/multitile/van/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/locomotion/van_wheels)

/obj/vehicle/multitile/van/decrepit/load_damage(var/obj/vehicle/multitile/R)
	take_damage_type(1e8, "abstract") //OOF.ogg


/obj/structure/interior_exit/vehicle/van/left
	name = "Van left door"
	icon = 'icons/obj/vehicles/interiors/van.dmi'
	icon_state = "van_left_3"

/obj/structure/interior_exit/vehicle/van/right
	name = "Van right door"
	icon = 'icons/obj/vehicles/interiors/van.dmi'
	icon_state = "van_right_3"
	dir = SOUTH

/obj/structure/interior_exit/vehicle/van/backleft
	name = "Van back exit"
	icon = 'icons/obj/vehicles/interiors/van.dmi'
	icon_state = "van_back_2"
	dir = WEST

/obj/structure/interior_exit/vehicle/van/backright
	name = "Van back exit"
	icon = 'icons/obj/vehicles/interiors/van.dmi'
	icon_state = "van_back_1"
	dir = WEST
