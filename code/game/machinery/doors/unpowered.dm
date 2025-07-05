/obj/structure/machinery/door/unpowered
	autoclose = 0
	var/locked = 0

/obj/structure/machinery/door/unpowered/Collided(atom/movable/AM)
	if(src.locked)
		return
	..()
	return

/obj/structure/machinery/door/unpowered/attackby(obj/item/I as obj, mob/user as mob)
	if(src.locked)
		return
	. = ..()
	return

/obj/structure/machinery/door/unpowered/shuttle
	icon = 'icons/turf/shuttle.dmi'
	name = "door"
	icon_state = "door1"
	opacity = TRUE
	density = TRUE

