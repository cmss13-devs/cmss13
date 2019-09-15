/*

node1, network1 correspond to input
node2, network2 correspond to output

*/

/obj/structure/machinery/atmospherics/binary/pump
	icon = 'icons/obj/pipes/pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "gas pump"
	desc = "A pump"

	var/on = 0
	use_power = 0

/obj/structure/machinery/atmospherics/binary/pump/on
	icon_state = "map_on"
	on = 1


/obj/structure/machinery/atmospherics/binary/pump/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[on ? "on" : "off"]"

/obj/structure/machinery/atmospherics/binary/pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, turn(dir, -180))
		add_underlay(T, node2, dir)

/obj/structure/machinery/atmospherics/binary/pump/hide(var/i)
	update_underlays()

/obj/structure/machinery/atmospherics/binary/pump/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)

/obj/structure/machinery/atmospherics/binary/pump/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(!iswrench(W))
		return ..()
	if(!(stat & NOPOWER) && on)
		to_chat(user, SPAN_WARNING("You cannot unwrench [src], turn it off first."))
		return 1

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] begins unfastening [src]."),
	SPAN_NOTICE("You begin unfastening [src]."))
	if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] unfastens [src]."),
		SPAN_NOTICE("You unfasten [src]."))
		new /obj/item/pipe(loc, make_from = src)
		qdel(src)
