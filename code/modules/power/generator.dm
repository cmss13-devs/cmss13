/obj/structure/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon_state = "teg"
	density = 1
	anchored = 0

	use_power = 1
	idle_power_usage = 100 //Watts, I hope.  Just enough to do the computer and display things.

/obj/structure/machinery/power/generator/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/wrench))
		anchored = !anchored
		to_chat(user, SPAN_NOTICE(" You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor."))
		use_power = anchored
	else
		..()

/obj/structure/machinery/power/generator/verb/rotate_clock()
	set category = "Object"
	set name = "Rotate Generator (Clockwise)"
	set src in view(1)

	if (usr.stat || usr.is_mob_restrained()  || anchored)
		return

	src.setDir(turn(src.dir, 90))

/obj/structure/machinery/power/generator/verb/rotate_anticlock()
	set category = "Object"
	set name = "Rotate Generator (Counterclockwise)"
	set src in view(1)

	if (usr.stat || usr.is_mob_restrained()  || anchored)
		return

	src.setDir(turn(src.dir, -90))
