/obj/structure/pipes/binary
	dir = SOUTH
	valid_directions = list(SOUTH, NORTH)

/obj/structure/pipes/binary/create_valid_directions()
	switch(dir)
		if(NORTH)
			valid_directions = list(NORTH, SOUTH)
		if(SOUTH)
			valid_directions = list(NORTH, SOUTH)
		if(EAST)
			valid_directions = list(EAST, WEST)
		if(WEST)
			valid_directions = list(EAST, WEST)

/obj/structure/pipes/binary/pump
	icon = 'icons/obj/pipes/pump.dmi'
	icon_state = "map_off"
	name = "gas pump"
	desc = "A pump"

/obj/structure/pipes/binary/pump/on
	icon_state = "map_on"

/obj/structure/pipes/binary/pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, turn(dir, -180))
		add_underlay(T, dir)

/obj/structure/pipes/binary/pump/hide(var/invis)
	update_underlays()

/obj/structure/pipes/binary/pump/high_power
	icon = 'icons/obj/pipes/volume_pump.dmi'
	icon_state = "map_off"
	level = 1
	name = "high power gas pump"
	desc = "A pump. Has double the power rating of the standard gas pump."

/obj/structure/pipes/binary/pump/high_power/on
	icon_state = "map_on"


obj/structure/pipes/binary/passive_gate
	icon = 'icons/obj/pipes/passive_gate.dmi'
	icon_state = "map"
	name = "pressure regulator"
	desc = "A one-way air valve that can be used to regulate input or output pressure, and flow rate. Does not require power."

/obj/structure/pipes/binary/passive_gate/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, turn(dir, 180))
		add_underlay(T, dir)

/obj/structure/pipes/binary/passive_gate/hide(var/invis)
	update_underlays()


/obj/structure/pipes/binary/circulator
	name = "circulator/heat exchanger"
	desc = "A gas circulator pump and heat exchanger."
	icon = 'icons/obj/pipes/pipes3.dmi'
	icon_state = "circ-off"
	anchored = 0
	density = 1

/obj/structure/pipes/binary/circulator/New()
	..()
	desc = initial(desc) + "  Its outlet port is to the [dir2text(dir)]."

/obj/structure/pipes/binary/circulator/update_icon()
	if(!anchored)
		icon_state = "circ-p"
	else
		icon_state = "circ-run"

/obj/structure/pipes/binary/circulator/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/wrench))
		anchored = !anchored
		to_chat(user, SPAN_NOTICE(" You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor."))

		if(anchored)
			if(dir & (NORTH|SOUTH))
				valid_directions = list(NORTH, SOUTH)
			else if(dir & (EAST|WEST))
				valid_directions = list(EAST, WEST)
	else
		..()

/obj/structure/pipes/binary/circulator/verb/rotate_clockwise()
	set category = "Object"
	set name = "Rotate Circulator (Clockwise)"
	set src in view(1)

	if (usr.stat || usr.is_mob_restrained() || anchored)
		return

	src.setDir(turn(src.dir, 90))
	desc = initial(desc) + " Its outlet port is to the [dir2text(dir)]."

/obj/structure/pipes/binary/circulator/verb/rotate_anticlockwise()
	set category = "Object"
	set name = "Rotate Circulator (Counterclockwise)"
	set src in view(1)

	if (usr.stat || usr.is_mob_restrained() || anchored)
		return

	src.setDir(turn(src.dir, -90))
	desc = initial(desc) + " Its outlet port is to the [dir2text(dir)]."