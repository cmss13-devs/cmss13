/obj/structure/machinery/meter
	name = "meter"
	desc = "It measures something."
	icon = 'icons/obj/structures/machinery/meter.dmi'
	icon_state = "meterX"
	var/obj/structure/pipes/standard/target = null
	anchored = 1.0
	power_channel = ENVIRON
	use_power = 0

/obj/structure/machinery/meter/New()
	..()
	src.target = locate(/obj/structure/pipes/standard/) in loc
	return 1

/obj/structure/machinery/meter/Dispose()
	target = null
	. = ..()

/obj/structure/machinery/meter/Initialize()
	. = ..()
	if (!target)
		src.target = locate(/obj/structure/pipes/standard/) in loc

/obj/structure/machinery/meter/examine(mob/user)
	var/t = "A gas flow meter. "

	if(get_dist(user, src) > 3 && !(isAI(user) || istype(user, /mob/dead)))
		t += SPAN_NOTICE("<B>You are too far away to read it.</B>")

	else if(stat & (NOPOWER|BROKEN))
		t += SPAN_DANGER("<B>The display is off.</B>")

	else if(target)
		if(target.return_pressure())
			t += "The pressure gauge reads [round(target.return_pressure(), 0.01)] kPa; [round(target.return_temperature(),0.01)]K ([round(target.return_temperature()-T0C,0.01)]&deg;C)"
		else
			t += "The sensor error light is blinking."
	else
		t += "The connect error light is blinking."

	to_chat(user, t)

/obj/structure/machinery/meter/clicked(var/mob/user)
	..()

	if(isAI(user)) // ghosts can call ..() for examine
		examine(user)
		return 1

/obj/structure/machinery/meter/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (!istype(W, /obj/item/tool/wrench))
		return ..()
	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] begins to unfasten [src]."),
	SPAN_NOTICE("You begin to unfasten [src]."))
	if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] unfastens [src]."),
		SPAN_NOTICE("You unfasten [src]."))
		new /obj/item/pipe_meter(loc)
		qdel(src)

// TURF METER - REPORTS A TILE'S AIR CONTENTS

/obj/structure/machinery/meter/turf/New()
	..()
	src.target = loc
	return 1


/obj/structure/machinery/meter/turf/Initialize()
	. = ..()
	if (!target)
		src.target = loc

/obj/structure/machinery/meter/turf/attackby(var/obj/item/W as obj, var/mob/user as mob)
	return
