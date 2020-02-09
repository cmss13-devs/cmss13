// Wall
/obj/structure/interior_wall/tank
	name = "tank interior wall"
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	icon_state = "tank_right_1"

// Props
/obj/structure/prop/tank
	name = "tank machinery"
	mouse_opacity = FALSE
	density = TRUE

	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	icon_state = "prop0"

// Hatch
/obj/structure/interior_exit/vehicle/tank
	name = "tank hatch"
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	icon_state = "hatch"

// Custom tank seats
/obj/effect/landmark/interior/spawn/vehicle_driver_seat/tank
	name = "driver's seat spawner"
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	icon_state = "tank_chair"
	color = "red"

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/tank/on_load(var/datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/driver/tank/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.layer = layer
	S.vehicle = I.exterior
	S.dir = dir
	S.update_icon()

	qdel(src)

/obj/structure/bed/chair/comfy/vehicle/driver/tank
	var/image/over_image = null

/obj/structure/bed/chair/comfy/vehicle/driver/tank/New()
	over_image = image("icons/obj/vehicles/interiors/tank.dmi", "tank_chair_buckled")
	over_image.layer = ABOVE_MOB_LAYER

	return ..()

/obj/structure/bed/chair/comfy/vehicle/driver/tank/do_buckle(var/mob/target, var/mob/user)
	. = ..()
	update_icon()

/obj/structure/bed/chair/comfy/vehicle/driver/tank/update_icon()
	overlays.Cut()

	..()

	if(buckled_mob)
		overlays += over_image

/obj/effect/landmark/interior/spawn/vehicle_gunner_seat/tank
	name = "gunner's seat spawner"
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	icon_state = "tank_chair"
	color = "blue"

/obj/effect/landmark/interior/spawn/vehicle_gunner_seat/tank/on_load(var/datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/gunner/tank/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.layer = layer
	S.vehicle = I.exterior
	S.dir = dir
	S.update_icon()

	qdel(src)

/obj/structure/bed/chair/comfy/vehicle/gunner/tank
	var/image/over_image = null

/obj/structure/bed/chair/comfy/vehicle/gunner/tank/New()
	over_image = image("icons/obj/vehicles/interiors/tank.dmi", "tank_chair_buckled")
	over_image.layer = ABOVE_MOB_LAYER

	return ..()

/obj/structure/bed/chair/comfy/vehicle/gunner/tank/do_buckle(var/mob/target, var/mob/user)
	. = ..()
	update_icon()

/obj/structure/bed/chair/comfy/vehicle/gunner/tank/update_icon()
	overlays.Cut()

	..()

	if(buckled_mob)
		overlays += over_image