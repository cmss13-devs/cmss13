/obj/machinery/atmospherics/trinary/mixer
	icon = 'icons/atmos/mixer.dmi'
	icon_state = "map"
	density = 0
	level = 1

	name = "Gas mixer"


/obj/machinery/atmospherics/trinary/mixer/update_icon(var/safety = 0)
	if(istype(src, /obj/machinery/atmospherics/trinary/mixer/m_mixer))
		icon_state = "m"
	else if(istype(src, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
		icon_state = "t"
	else
		icon_state = ""

	if(!powered())
		icon_state += "off"
	else if(node2 && node3 && node1)
		icon_state += on ? "on" : "off"
	else
		icon_state += "off"
		on = 0

/obj/machinery/atmospherics/trinary/mixer/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return

		if(istype(src, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
			add_underlay(T, node1, turn(dir, -90))
		else
			add_underlay(T, node1, turn(dir, -180))

		if(istype(src, /obj/machinery/atmospherics/trinary/mixer/m_mixer) || istype(src, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
			add_underlay(T, node2, turn(dir, 90))
		else
			add_underlay(T, node2, turn(dir, -90))

		add_underlay(T, node3, dir)

/obj/machinery/atmospherics/trinary/mixer/hide(var/i)
	update_underlays()



/obj/machinery/atmospherics/trinary/mixer/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(!iswrench(W))
		return ..()

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] begins unfastening [src]."),
	SPAN_NOTICE("You begin unfastening [src]."))
	if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] unfastens [src]."),
		SPAN_NOTICE("You unfasten [src]."))
		new /obj/item/pipe(loc, make_from = src)
		qdel(src)


obj/machinery/atmospherics/trinary/mixer/t_mixer
	icon_state = "tmap"

	dir = SOUTH
	initialize_directions = SOUTH|EAST|WEST

	//node 3 is the outlet, nodes 1 & 2 are intakes

obj/machinery/atmospherics/trinary/mixer/t_mixer/New()
	..()
	switch(dir)
		if(NORTH)
			initialize_directions = EAST|NORTH|WEST
		if(SOUTH)
			initialize_directions = SOUTH|WEST|EAST
		if(EAST)
			initialize_directions = EAST|NORTH|SOUTH
		if(WEST)
			initialize_directions = WEST|NORTH|SOUTH

obj/machinery/atmospherics/trinary/mixer/t_mixer/initialize()
	..()
	if(node1 && node2 && node3) return

	var/node1_connect = turn(dir, -90)
	var/node2_connect = turn(dir, 90)
	var/node3_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_connect))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,node2_connect))
		if(target.initialize_directions & get_dir(target,src))
			node2 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,node3_connect))
		if(target.initialize_directions & get_dir(target,src))
			node3 = target
			break

	update_icon()
	update_underlays()

obj/machinery/atmospherics/trinary/mixer/m_mixer
	icon_state = "mmap"

	dir = SOUTH
	initialize_directions = SOUTH|NORTH|EAST

	//node 3 is the outlet, nodes 1 & 2 are intakes

obj/machinery/atmospherics/trinary/mixer/m_mixer/New()
	..()
	switch(dir)
		if(NORTH)
			initialize_directions = WEST|NORTH|SOUTH
		if(SOUTH)
			initialize_directions = SOUTH|EAST|NORTH
		if(EAST)
			initialize_directions = EAST|WEST|NORTH
		if(WEST)
			initialize_directions = WEST|SOUTH|EAST

obj/machinery/atmospherics/trinary/mixer/m_mixer/initialize()
	..()
	if(node1 && node2 && node3) return

	var/node1_connect = turn(dir, -180)
	var/node2_connect = turn(dir, 90)
	var/node3_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_connect))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,node2_connect))
		if(target.initialize_directions & get_dir(target,src))
			node2 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,node3_connect))
		if(target.initialize_directions & get_dir(target,src))
			node3 = target
			break

	update_icon()
	update_underlays()
