/obj/structure/pipes/unary/freezer
	name = "gas cooling system"
	desc = "Cools gas when connected to pipe network"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "freezer_0"
	density = 1
	anchored = TRUE

	var/opened = 0	//for deconstruction

/obj/structure/pipes/unary/freezer/create_valid_directions()
	valid_directions = list(dir)

/obj/structure/pipes/unary/freezer/update_icon()
	if(length(connected_to))
		icon_state = "freezer"
	else
		icon_state = "freezer_0"

/obj/structure/pipes/unary/freezer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/tool/screwdriver))
		opened = !opened
		to_chat(user, "You [opened ? "open" : "close"] the maintenance hatch of [src].")
		return

	..()

/obj/structure/pipes/unary/freezer/examine(mob/user)
	..()
	if(opened)
		to_chat(user, "The maintenance hatch is open.")


/obj/structure/pipes/unary/heat_exchanger
	name = "heat exchanger"
	desc = "Exchanges heat between two input gases. Setup for fast heat transfer"
	icon = 'icons/obj/pipes/heat_exchanger.dmi'
	icon_state = "intact"
	density = 1

/obj/structure/pipes/unary/heat_exchanger/update_icon()
	if(length(connected_to))
		icon_state = "intact"
	else
		icon_state = "exposed"


/obj/structure/pipes/unary/heater
	name = "gas heating system"
	desc = "Heats gas when connected to a pipe network"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "heater_0"
	density = 1
	anchored = 1.0
	var/opened = 0		//for deconstruction

/obj/structure/pipes/unary/heater/create_valid_directions()
	valid_directions = list(dir)


/obj/structure/pipes/unary/heater/update_icon()
	if(length(connected_to))
		icon_state = "heater"
	else
		icon_state = "heater_0"

//dismantling code. copied from autolathe
/obj/structure/pipes/unary/heater/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/tool/screwdriver))
		opened = !opened
		to_chat(user, "You [opened ? "open" : "close"] the maintenance hatch of [src].")
		return

	..()

/obj/structure/pipes/unary/heater/examine(mob/user)
	..()
	if(opened)
		to_chat(user, "The maintenance hatch is open.")


/obj/structure/pipes/unary/outlet_injector
	icon = 'icons/obj/pipes/injector.dmi'
	icon_state = "map_injector"
	layer = OBJ_LAYER
	name = "air injector"
	desc = "Passively injects air into its surroundings. Has a valve attached to it that can control flow rate."

/obj/structure/pipes/unary/outlet_injector/update_icon()
	if(connected_to)
		icon_state = "on"
	else
		icon_state = "off"

/obj/structure/pipes/unary/outlet_injector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, dir)

/obj/structure/pipes/unary/outlet_injector/hide(var/invis)
	update_underlays()


/obj/structure/pipes/unary/oxygen_generator
	icon = 'icons/obj/pipes/oxygen_generator.dmi'
	icon_state = "intact_off"
	density = 1
	name = "Oxygen Generator"
	desc = ""
	dir = SOUTH
	valid_directions = list(SOUTH)

/obj/structure/pipes/unary/oxygen_generator/update_icon()
	if(connected_to)
		icon_state = "intact_on"
	else
		icon_state = "exposed_off"