/obj/structure/prop/vehicle/chimera
	name = "chimera chassis"

	icon = 'icons/obj/vehicles/interiors/chimera_chassis.dmi'
	icon_state = "chassis"
	layer = ABOVE_TURF_LAYER
	mouse_opacity = FALSE

/obj/structure/interior_exit/vehicle/chimera
	icon = 'icons/obj/vehicles/interiors/chimera.dmi'
	opacity = FALSE

/obj/structure/interior_exit/vehicle/chimera/left
	name = "chimera side door"
	icon_state = "door left"

/obj/structure/interior_exit/vehicle/chimera/right
	name = "chimera side door"
	icon_state = "door right"

/obj/structure/interior_exit/vehicle/chimera/back
	name = "chimera back door"
	icon_state = "rear door closed"

/obj/structure/bed/chair/vehicle/chimera
	name = "passenger seat"
	icon = 'icons/obj/vehicles/interiors/chimera.dmi'
	icon_state = "seat"

/obj/structure/bed/chair/vehicle/chimera/top_right_top
	pixel_x = -12
	pixel_y = 10
	dir = WEST

/obj/structure/bed/chair/vehicle/chimera/top_right_bottom
	pixel_x = -12
	pixel_y = -6
	dir = WEST

/obj/structure/bed/chair/vehicle/chimera/top_left_top
	pixel_x = 12
	pixel_y = 10
	dir = EAST

/obj/structure/bed/chair/vehicle/chimera/top_left_bottom
	pixel_x = 12
	pixel_y = -6
	dir = EAST

/obj/structure/bed/chair/vehicle/chimera/bottom_right_top
	pixel_x = -12
	pixel_y = 16
	dir = WEST

/obj/structure/bed/chair/vehicle/chimera/bottom_right_bottom
	pixel_x = -12
	pixel_y = 3
	dir = WEST

/obj/structure/bed/chair/vehicle/chimera/bottom_left_top
	pixel_x = 12
	pixel_y = 16
	dir = EAST

/obj/structure/bed/chair/vehicle/chimera/bottom_left_bottom
	pixel_x = 12
	pixel_y = 3
	dir = EAST

/obj/structure/bed/chair/comfy/vehicle/driver/chimera
	icon = 'icons/obj/vehicles/interiors/chimera.dmi'
	icon_state = "sit"
	skill_to_check = SKILL_PILOT

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/chimera
	pixel_y = -10

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/chimera/on_load(datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/driver/chimera/S = new(loc)

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

/obj/structure/bed/chair/vehicle/chimera/buckle_mob(mob/M, mob/user)
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

/obj/structure/bed/chair/vehicle/chimera/afterbuckle(mob/user)
	. = ..()

	if(buckled_mob)
		return

	user.forceMove(get_step(user, dir))

/turf/open/floor/transparent
	icon_state = "transparent"
