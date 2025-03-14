/obj/structure/prop/vehicle/blackfoot
	name = "blackfoot chassis"

	icon = 'icons/obj/vehicles/interiors/blackfoot_chassis.dmi'
	icon_state = "chassis"
	layer = ABOVE_TURF_LAYER
	mouse_opacity = FALSE

/obj/structure/interior_exit/vehicle/blackfoot
	icon = 'icons/obj/vehicles/interiors/blackfoot.dmi'
	icon_state = "door left"
	opacity = FALSE

/obj/structure/interior_exit/vehicle/blackfoot/left
	name = "blackfoot side door"
	icon_state = "door left"

/obj/structure/interior_exit/vehicle/blackfoot/right
	name = "blackfoot side door"
	icon_state = "door right"

/obj/structure/interior_exit/vehicle/blackfoot/back
	name = "blackfoot back door"
	icon_state = "rear door closed"
	flags_atom = NO_ZFALL
	var/open = FALSE

/obj/structure/interior_exit/vehicle/blackfoot/back/Initialize()
	. = ..()
	overlays += image('icons/obj/vehicles/interiors/blackfoot_rear_overlay.dmi', "overlay", pixel_x = -32)

/obj/structure/interior_exit/vehicle/blackfoot/back/proc/toggle_open()
	playsound(loc, 'sound/machines/blastdoor.ogg', 25)
	if(open)
		open = FALSE
		flick("door closing", src)
		icon_state = "rear door closed"
	else
		open = TRUE
		flick("door opening", src)
		icon_state = "rear door open"

/obj/structure/machinery/door_control/blackfoot_rear_door
	var/obj/vehicle/multitile/blackfoot/linked_blackfoot

/obj/structure/machinery/door_control/blackfoot_rear_door/attack_hand(mob/user)
	linked_blackfoot.toggle_rear_door()

	. = ..()

/obj/effect/landmark/interior/spawn/blackfoot_rear_door_button
	name = "rear door button"

/obj/effect/landmark/interior/spawn/blackfoot_rear_door_button/on_load(datum/interior/interior)
	var/obj/structure/machinery/door_control/blackfoot_rear_door/door_control = new(get_turf(src))

	door_control.name = name
	door_control.setDir(dir)
	door_control.alpha = alpha
	door_control.update_icon()
	door_control.pixel_x = pixel_x
	door_control.pixel_y = pixel_y

	if(istype(interior.exterior, /obj/vehicle/multitile/blackfoot))
		var/obj/vehicle/multitile/blackfoot/linked_blackfoot = interior.exterior
		door_control.linked_blackfoot = linked_blackfoot

	qdel(src)	

/obj/effect/landmark/interior/spawn/entrance/blackfoot_rear_door
	name = "blackfoot back door"
	pixel_x = 0
	pixel_y = 24
	dir = 1
	offset_y = -1
	exit_type = /obj/structure/interior_exit/vehicle/blackfoot/back

/obj/effect/landmark/interior/spawn/entrance/blackfoot_rear_door/on_load(datum/interior/interior)
	var/obj/structure/interior_exit/vehicle/blackfoot/back_door = ..()

	if(!back_door)
		return

	if(istype(interior.exterior, /obj/vehicle/multitile/blackfoot))
		var/obj/vehicle/multitile/blackfoot/linked_blackfoot = interior.exterior
		linked_blackfoot.back_door = back_door

/obj/structure/bed/chair/vehicle/blackfoot
	name = "passenger seat"
	icon = 'icons/obj/vehicles/interiors/blackfoot.dmi'
	icon_state = "seat"

/obj/structure/bed/chair/vehicle/blackfoot/top_right_top
	pixel_x = -12
	pixel_y = 10
	dir = WEST

/obj/structure/bed/chair/vehicle/blackfoot/top_right_bottom
	pixel_x = -12
	pixel_y = -6
	dir = WEST

/obj/structure/bed/chair/vehicle/blackfoot/top_left_top
	pixel_x = 12
	pixel_y = 10
	dir = EAST

/obj/structure/bed/chair/vehicle/blackfoot/top_left_bottom
	pixel_x = 12
	pixel_y = -6
	dir = EAST

/obj/structure/bed/chair/vehicle/blackfoot/bottom_right_top
	pixel_x = -12
	pixel_y = 16
	dir = WEST

/obj/structure/bed/chair/vehicle/blackfoot/bottom_right_bottom
	pixel_x = -12
	pixel_y = 3
	dir = WEST

/obj/structure/bed/chair/vehicle/blackfoot/bottom_left_top
	pixel_x = 12
	pixel_y = 16
	dir = EAST

/obj/structure/bed/chair/vehicle/blackfoot/bottom_left_bottom
	pixel_x = 12
	pixel_y = 3
	dir = EAST

/obj/structure/bed/chair/comfy/vehicle/driver/blackfoot
	icon = 'icons/obj/vehicles/interiors/blackfoot.dmi'
	icon_state = "seat"
	skill_to_check = SKILL_PILOT

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/blackfoot
	pixel_y = -10

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/blackfoot/on_load(datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/driver/blackfoot/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.layer = layer
	S.vehicle = I.exterior
	S.required_skill = S.vehicle.required_skill
	S.setDir(dir)
	S.alpha = alpha
	S.update_icon()
	S.handle_rotation()
	S.pixel_x = pixel_x
	S.pixel_y = pixel_y

	qdel(src)

/obj/structure/bed/chair/vehicle/blackfoot/buckle_mob(mob/M, mob/user)
	if (!ismob(M) || (get_dist(src, user) > 1) || user.stat || buckled_mob || M.buckled || !isturf(user.loc))
		return

	if (user.is_mob_incapacitated() || HAS_TRAIT(user, TRAIT_IMMOBILIZED) || HAS_TRAIT(user, TRAIT_FLOORED))
		to_chat(user, SPAN_WARNING("You can't do this right now."))
		return

	if (isxeno(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do that, try a nest."))
		return

	if (iszombie(user))
		return

	if(M.loc != loc)
		M.forceMove(loc) //buckle if you're right next to it

		. = buckle_mob(M)

	if (M.mob_size <= MOB_SIZE_XENO)
		if ((M.stat == DEAD && istype(src, /obj/structure/bed/roller) || HAS_TRAIT(M, TRAIT_OPPOSABLE_THUMBS)))
			do_buckle(M, user)
			return
	if ((M.mob_size > MOB_SIZE_HUMAN))
		to_chat(user, SPAN_WARNING("[M] is too big to buckle in."))
		return
	do_buckle(M, user)

/obj/structure/bed/chair/vehicle/blackfoot/afterbuckle(mob/user)
	. = ..()

	if(buckled_mob)
		return

	user.forceMove(get_step(user, dir))

/turf/open/floor/transparent
	icon_state = "transparent"
