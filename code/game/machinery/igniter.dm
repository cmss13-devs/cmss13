/obj/structure/machinery/igniter
	name = "igniter"
	desc = "It's useful for igniting flammable items."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "igniter1"
	plane = FLOOR_PLANE
	var/id = null
	var/on = 1.0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/structure/machinery/igniter/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/igniter/attack_hand(mob/user as mob)
	if(..())
		return
	add_fingerprint(user)

	use_power(50)
	src.on = !( src.on )
	src.icon_state = text("igniter[]", src.on)
	return

/obj/structure/machinery/igniter/process()	//ugh why is this even in process()?
//	if (src.on && !(stat & NOPOWER) )
//		var/turf/location = src.loc
//		if (isturf(location))
//			location.hotspot_expose(1000,500,1)
	return 1

/obj/structure/machinery/igniter/Initialize(mapload, ...)
	. = ..()
	icon_state = "igniter[on]"

/obj/structure/machinery/igniter/power_change()
	..()
	if(!( stat & NOPOWER) )
		icon_state = "igniter[src.on]"
	else
		icon_state = "igniter0"

// Wall mounted remote-control igniter.

/obj/structure/machinery/sparker
	name = "Mounted igniter"
	desc = "A wall-mounted ignition device."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "migniter"
	var/id = null
	var/disable = 0
	var/last_spark = 0
	var/base_state = "migniter"
	anchored = 1

/obj/structure/machinery/sparker/power_change()
	..()
	if ( !(stat & NOPOWER) && disable == 0 )

		icon_state = "[base_state]"
//		src.sd_SetLuminosity(2)
	else
		icon_state = "[base_state]-p"
//		src.sd_SetLuminosity(0)

/obj/structure/machinery/sparker/attackby(obj/item/W as obj, mob/user as mob)
	if (HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		add_fingerprint(user)
		src.disable = !src.disable
		if (src.disable)
			user.visible_message(SPAN_DANGER("[user] has disabled the [src]!"), SPAN_DANGER("You disable the connection to the [src]."))
			icon_state = "[base_state]-d"
		if (!src.disable)
			user.visible_message(SPAN_DANGER("[user] has reconnected the [src]!"), SPAN_DANGER("You fix the connection to the [src]."))
			if(src.powered())
				icon_state = "[base_state]"
			else
				icon_state = "[base_state]-p"

/obj/structure/machinery/sparker/attack_remote()
	if (src.anchored)
		return src.ignite()
	else
		return

/obj/structure/machinery/sparker/proc/ignite()
	if (!(powered()))
		return

	if ((src.disable) || (src.last_spark && world.time < src.last_spark + 50))
		return


	flick("[base_state]-spark", src)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(2, 1, src)
	s.start()
	src.last_spark = world.time
	use_power(1000)
//	var/turf/location = src.loc
//	if (isturf(location))
//		location.hotspot_expose(1000,500,1)
	return 1

/obj/structure/machinery/sparker/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	ignite()
	..(severity)

/obj/structure/machinery/ignition_switch/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/ignition_switch/attack_hand(mob/user as mob)
	if(inoperable())
		return
	if(active)
		return

	use_power(5)

	active = 1
	icon_state = "launcheract"

	for(var/obj/structure/machinery/sparker/M in machines)
		if (M.id == src.id)
			INVOKE_ASYNC(M, /obj/structure/machinery/sparker.proc/ignite)

	for(var/obj/structure/machinery/igniter/M in machines)
		if(M.id == src.id)
			use_power(50)
			M.on = !( M.on )
			M.icon_state = text("igniter[]", M.on)

	sleep(50)

	icon_state = "launcherbtt"
	active = 0

	return
