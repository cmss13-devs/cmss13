//TODO: Put this under a common parent type with freezers to cut down on the copypasta

/obj/machinery/atmospherics/unary/heater
	name = "gas heating system"
	desc = "Heats gas when connected to a pipe network"
	icon = 'icons/obj/machines/cryogenics.dmi'
	icon_state = "heater_0"
	density = 1

	anchored = 1.0

	var/on = 0
	use_power = 0

	var/heating = 0		//mainly for icon updates
	var/opened = 0		//for deconstruction

/obj/machinery/atmospherics/unary/heater/New()
	..()
	initialize_directions = dir

	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/unary_atmos/heater(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/capacitor(src)
	component_parts += new /obj/item/stock_parts/capacitor(src)


/obj/machinery/atmospherics/unary/heater/initialize()
	if(node) return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			node = target
			break

	update_icon()


/obj/machinery/atmospherics/unary/heater/update_icon()
	if(src.node)
		if(src.on && src.heating)
			icon_state = "heater_1"
		else
			icon_state = "heater"
	else
		icon_state = "heater_0"
	return


/obj/machinery/atmospherics/unary/heater/attack_ai(mob/user as mob)
	src.ui_interact(user)

/obj/machinery/atmospherics/unary/heater/attack_hand(mob/user as mob)
	src.ui_interact(user)

//dismantling code. copied from autolathe
/obj/machinery/atmospherics/unary/heater/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/tool/screwdriver))
		opened = !opened
		to_chat(user, "You [opened ? "open" : "close"] the maintenance hatch of [src].")
		return

	if (opened && istype(O, /obj/item/tool/crowbar))
		dismantle()
		return

	..()

/obj/machinery/atmospherics/unary/heater/examine(mob/user)
	..()
	if(opened)
		to_chat(user, "The maintenance hatch is open.")