/obj/item/stack/cable_coil/heavyduty
	name = "heavy cable coil"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "wire"

/obj/structure/cable/heavyduty
	icon = 'icons/obj/pipes/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	layer = BELOW_ATMOS_PIPE_LAYER

/obj/structure/cable/heavyduty/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(T.intact_tile)
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		to_chat(usr, SPAN_NOTICE(" These cables are too tough to be cut with those [W.name]."))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		to_chat(usr, SPAN_NOTICE(" You will need heavier cables to connect to these."))
		return
	else
		..()

/obj/structure/cable/heavyduty/cableColor(colorC)
	return
