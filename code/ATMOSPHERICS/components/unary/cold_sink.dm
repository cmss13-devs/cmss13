//TODO: Put this under a common parent type with heaters to cut down on the copypasta
#define FREEZER_PERF_MULT 2.5

/obj/machinery/atmospherics/unary/freezer
	name = "gas cooling system"
	desc = "Cools gas when connected to pipe network"
	icon = 'icons/obj/machines/cryogenics.dmi'
	icon_state = "freezer_0"
	density = 1

	anchored = TRUE

	var/on = 0
	use_power = 0

	var/cooling = 0
	var/opened = 0	//for deconstruction

/obj/machinery/atmospherics/unary/freezer/New()
	..()
	initialize_directions = dir

	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/unary_atmos/cooler(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/capacitor(src)
	component_parts += new /obj/item/stock_parts/capacitor(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)

	start_processing()

/obj/machinery/atmospherics/unary/freezer/initialize()
	if(node) return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			node = target
			break

	update_icon()


/obj/machinery/atmospherics/unary/freezer/update_icon()
	if(src.node)
		if(src.on && cooling)
			icon_state = "freezer_1"
		else
			icon_state = "freezer"
	else
		icon_state = "freezer_0"
	return

/obj/machinery/atmospherics/unary/freezer/attack_ai(mob/user as mob)
	src.ui_interact(user)

/obj/machinery/atmospherics/unary/freezer/attack_hand(mob/user as mob)
	src.ui_interact(user)


//upgrading parts
/obj/machinery/atmospherics/unary/freezer/RefreshParts()
	..()
	var/cap_rating = 0
	var/cap_count = 0
	var/manip_rating = 0
	var/manip_count = 0
	var/bin_rating = 0
	var/bin_count = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/capacitor))
			cap_rating += P.rating
			cap_count++
		if(istype(P, /obj/item/stock_parts/manipulator))
			manip_rating += P.rating
			manip_count++
		if(istype(P, /obj/item/stock_parts/matter_bin))
			bin_rating += P.rating
			bin_count++
	cap_rating /= cap_count
	bin_rating /= bin_count
	manip_rating /= manip_count


//dismantling code. copied from autolathe
/obj/machinery/atmospherics/unary/freezer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/tool/screwdriver))
		opened = !opened
		to_chat(user, "You [opened ? "open" : "close"] the maintenance hatch of [src].")
		return

	if (opened && istype(O, /obj/item/tool/crowbar))
		dismantle()
		return

	..()

/obj/machinery/atmospherics/unary/freezer/examine(mob/user)
	..()
	if(opened)
		to_chat(user, "The maintenance hatch is open.")