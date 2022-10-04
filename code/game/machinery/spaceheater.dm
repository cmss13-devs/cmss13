/obj/structure/machinery/space_heater
	name = "space heater"
	desc = "It's an electric space heater. It heats the room through radiation with electricity."
	icon = 'icons/obj/structures/machinery/atmos.dmi'
	icon_state = "sheater0"
	anchored = FALSE
	density = 0
	var/obj/item/cell/cell
	var/on = 0
	var/open = 0
	var/set_temperature = T0C + 70	//K
	var/heating_power = 40000

	flags_atom = FPRINT

/obj/structure/machinery/space_heater/Initialize()
	. = ..()
	cell = new (src)
	cell.charge += 500
	update_icon()

/obj/structure/machinery/space_heater/update_icon()
	overlays.Cut()
	icon_state = "sheater[on]"
	if(open)
		overlays  += "sheater-open"

/obj/structure/machinery/space_heater/get_examine_text(mob/user)
	. = ..()
	. += "The heater is [on ? "on" : "off"] and the hatch is [open ? "open" : "closed"]."
	if(open)
		. += "The power cell is [cell ? "installed" : "missing"]."
	else
		. += "The charge meter reads [cell ? round(cell.percent(),1) : 0]%"


/obj/structure/machinery/space_heater/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/structure/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				var/obj/item/cell/C = usr.get_active_hand()
				if(istype(C))
					if(user.drop_inv_item_to_loc(C, src))
						cell = C
						C.add_fingerprint(usr)

						user.visible_message(SPAN_NOTICE("[user] inserts a power cell into [src]."), SPAN_NOTICE("You insert the power cell into [src]."))
		else
			to_chat(user, "The hatch must be open to insert a power cell.")
			return
	else if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		open = !open
		user.visible_message(SPAN_NOTICE("[user] [open ? "opens" : "closes"] the hatch on the [src]."), SPAN_NOTICE("You [open ? "open" : "close"] the hatch on the [src]."))
		update_icon()
		if(!open && user.interactee == src)
			close_browser(user, "spaceheater")
			user.unset_interaction()
	else
		..()
	return

/obj/structure/machinery/space_heater/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	interact(user)

/obj/structure/machinery/space_heater/interact(mob/user as mob)

	if(open)

		var/dat
		dat = "Power cell: "
		if(cell)
			dat += "<A href='byond://?src=\ref[src];op=cellremove'>Installed</A><BR>"
		else
			dat += "<A href='byond://?src=\ref[src];op=cellinstall'>Removed</A><BR>"

		dat += "Power Level: [cell ? round(cell.percent(),1) : 0]%<BR><BR>"

		dat += "Set Temperature: "

		dat += "<A href='?src=\ref[src];op=temp;val=-5'>-</A>"

		dat += " [set_temperature]K ([set_temperature-T0C]&deg;C)"
		dat += "<A href='?src=\ref[src];op=temp;val=5'>+</A><BR>"

		user.set_interaction(src)
		show_browser(user, dat, "Space Heater Control Panel", "spaceheater")
	else
		on = !on
		if(on)
			start_processing()
		else
			stop_processing()
		user.visible_message(SPAN_NOTICE("[user] switches [on ? "on" : "off"] the [src]."),SPAN_NOTICE("You switch [on ? "on" : "off"] the [src]."))
		update_icon()
	return


/obj/structure/machinery/space_heater/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (isRemoteControlling(usr)))
		usr.set_interaction(src)

		switch(href_list["op"])

			if("temp")
				var/value = text2num(href_list["val"])

				// limit to 0-90 degC
				set_temperature = dd_range(T0C, T0C + 90, set_temperature + value)

			if("cellremove")
				if(open && cell && !usr.get_active_hand())
					usr.visible_message(SPAN_NOTICE("[usr] removes \the [cell] from \the [src]."), SPAN_NOTICE("You remove \the [cell] from \the [src]."))
					cell.updateicon()
					usr.put_in_hands(cell)
					cell.add_fingerprint(usr)
					cell = null


			if("cellinstall")
				if(open && !cell)
					var/obj/item/cell/C = usr.get_active_hand()
					if(istype(C))
						if(usr.drop_held_item())
							cell = C
							C.forceMove(src)
							C.add_fingerprint(usr)

							usr.visible_message(SPAN_NOTICE("[usr] inserts \the [C] into \the [src]."), SPAN_NOTICE("You insert \the [C] into \the [src]."))

		updateDialog()
	else
		close_browser(usr, "spaceheater")
		usr.unset_interaction()
	return



/obj/structure/machinery/space_heater/process()
	if(on)
		if(isturf(loc) && cell && cell.charge)
			for(var/mob/living/carbon/human/H in range(2, src))
				if(H.bodytemperature < T20C)
					H.bodytemperature += min(round(T20C - H.bodytemperature)*0.7, 25)
					H.recalculate_move_delay = TRUE


			cell.use(50*CELLRATE)

		else
			on = 0
			stop_processing()
			update_icon()

/obj/structure/machinery/space_heater/radiator
	name = "radiator"
	desc = "It's a radiator. It heats the room through convection with hot water."
	icon_state = "radiator"
	anchored = TRUE

/obj/structure/machinery/space_heater/radiator/update_icon()
	return

/obj/structure/machinery/space_heater/radiator/red
	name = "radiator"
	desc = "It's a radiator. It heats the room through convection with hot water. This one has a red handle."
	icon_state = "radiator-r"

