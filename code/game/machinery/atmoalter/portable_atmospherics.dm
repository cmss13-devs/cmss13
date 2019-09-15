/obj/structure/machinery/portable_atmospherics
	name = "atmoalter"
	use_power = 0

	var/obj/structure/machinery/atmospherics/portables_connector/connected_port
	var/destroyed = 0


/obj/structure/machinery/portable_atmospherics/initialize()
	. = ..()
	spawn()
		var/obj/structure/machinery/atmospherics/portables_connector/port = locate() in loc
		if(port)
			connect(port)
			update_icon()

/obj/structure/machinery/portable_atmospherics/process()
	if(connected_port)
		update_icon()

/obj/structure/machinery/portable_atmospherics/update_icon()
	return null

/obj/structure/machinery/portable_atmospherics/proc/connect(obj/structure/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src

	anchored = 1 //Prevent movement

	return 1

/obj/structure/machinery/portable_atmospherics/proc/disconnect()
	if(!connected_port)
		return 0

	anchored = 0

	connected_port.connected_device = null
	connected_port = null

	return 1

/obj/structure/machinery/portable_atmospherics/proc/update_connected_network()
	if(!connected_port)
		return


/obj/structure/machinery/portable_atmospherics/attackby(obj/item/W, mob/user)
	var/obj/icon = src
	if (istype(W, /obj/item/tool/wrench))
		if(connected_port)
			disconnect()
			to_chat(user, SPAN_NOTICE(" You disconnect [name] from the port."))
			update_icon()
			return
		else
			var/obj/structure/machinery/atmospherics/portables_connector/possible_port = locate(/obj/structure/machinery/atmospherics/portables_connector/) in loc
			if(possible_port)
				if(connect(possible_port))
					to_chat(user, SPAN_NOTICE(" You connect [name] to the port."))
					update_icon()
					return
				else
					to_chat(user, SPAN_NOTICE(" [name] failed to connect to the port."))
					return
			else
				to_chat(user, SPAN_NOTICE(" Nothing happens."))
				return

	else if ((istype(W, /obj/item/device/analyzer)) && Adjacent(user))
		visible_message(SPAN_DANGER("[user] has used [W] on [htmlicon(icon, viewers(src))]"))
		to_chat(user, SPAN_NOTICE(" Results of analysis of [htmlicon(icon, user)]"))
		to_chat(user, SPAN_NOTICE(" Tank is empty!"))




/obj/structure/machinery/portable_atmospherics/powered
	var/power_rating
	var/power_losses
	var/last_power_draw = 0
	var/obj/item/cell/cell

/obj/structure/machinery/portable_atmospherics/powered/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(cell)
			to_chat(user, "There is already a power cell installed.")
			return

		var/obj/item/cell/C = I

		if(user.drop_inv_item_to_loc(C, src))
			C.add_fingerprint(user)
			cell = C
			user.visible_message(SPAN_NOTICE("[user] opens the panel on [src] and inserts [C]."), SPAN_NOTICE("You open the panel on [src] and insert [C]."))
		return

	if(istype(I, /obj/item/tool/screwdriver))
		if(!cell)
			to_chat(user, SPAN_DANGER("There is no power cell installed."))
			return

		user.visible_message(SPAN_NOTICE("[user] opens the panel on [src] and removes [cell]."), SPAN_NOTICE("You open the panel on [src] and remove [cell]."))
		cell.add_fingerprint(user)
		cell.loc = src.loc
		cell = null
		return

	..()

