/obj/structure/machinery/computer/drone_control
	name = "Maintenance Drone Control"
	desc = "Used to monitor the station's drone population and the assembler that services them."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "power"
	req_one_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING)
	circuit = /obj/item/circuitboard/computer/drone_control

	//Used when pinging drones.
	var/drone_call_area = "Engineering"
	//Used to enable or disable drone fabrication.
	var/obj/structure/machinery/drone_fabricator/dronefab

/obj/structure/machinery/computer/drone_control/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/computer/drone_control/attack_hand(mob/user as mob)
	if(..())
		return

	if(!allowed(user))
		to_chat(user, SPAN_DANGER("Access denied."))
		return

	user.set_interaction(src)
	var/dat
	dat += "<B>Maintenance Units</B><BR>"

	for(var/mob/living/silicon/robot/drone/D in GLOB.mob_list)
		dat += "<BR>[D.real_name] ([D.stat == 2 ? "<font color='red'>INACTIVE" : "<font color='green'>ACTIVE"]</FONT>)"
		dat += "<font dize = 9><BR>Cell charge: [D.cell.charge]/[D.cell.maxcharge]."
		dat += "<BR>Currently located in: [get_area(D)]."
		dat += "<BR><A href='?src=\ref[src];resync=\ref[D]'>Resync</A>|<A href='?src=\ref[src];shutdown=\ref[D]'>Shutdown</A></font>"

	dat += "<BR><BR><B>Request drone presence in area:</B> <A href='?src=\ref[src];setarea=1'>[drone_call_area]</A> (<A href='?src=\ref[src];ping=1'>Send ping</A>)"

	dat += "<BR><BR><B>Drone fabricator</B>: "
	dat += "[dronefab ? "<A href='?src=\ref[src];toggle_fab=1'>[(dronefab.produce_drones && !(dronefab.stat & NOPOWER)) ? "ACTIVE" : "INACTIVE"]</A>" : "<font color='red'><b>FABRICATOR NOT DETECTED.</b></font> (<A href='?src=\ref[src];search_fab=1'>search</a>)"]"
	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return


/obj/structure/machinery/computer/drone_control/Topic(href, href_list)
	if(..())
		return

	if(!allowed(usr))
		to_chat(usr, SPAN_DANGER("Access denied."))
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (isRemoteControlling(usr)))
		usr.set_interaction(src)

	if (href_list["setarea"])

		//Probably should consider using another list, but this one will do.
		var/t_area = tgui_input_list(usr, "Select the area to ping.", "Set Target Area", null, tagger_locations)

		if(!t_area)
			return

		drone_call_area = t_area
		to_chat(usr, SPAN_NOTICE(" You set the area selector to [drone_call_area]."))

	else if (href_list["ping"])

		to_chat(usr, SPAN_NOTICE(" You issue a maintenance request for all active drones, highlighting [drone_call_area]."))
		for(var/mob/living/silicon/robot/drone/D in GLOB.mob_list)
			if(D.client && D.stat == 0)
				to_chat(D, "-- Maintenance drone presence requested in: [drone_call_area].")

	else if (href_list["shutdown"])

		var/mob/living/silicon/robot/drone/D = locate(href_list["shutdown"])

		if(D.stat != 2)
			to_chat(usr, SPAN_DANGER("You issue a kill command for the unfortunate drone."))
			message_admins("[key_name_admin(usr)] issued kill order for drone [key_name_admin(D)] from control console.")
			log_game("[key_name(usr)] issued kill order for [key_name(src)] from control console.")
			D.shut_down()

	else if (href_list["search_fab"])
		if(dronefab)
			return

		for(var/obj/structure/machinery/drone_fabricator/fab in oview(3,src))

			if(fab.stat & NOPOWER)
				continue

			dronefab = fab
			to_chat(usr, SPAN_NOTICE(" Drone fabricator located."))
			return

		to_chat(usr, SPAN_DANGER("Unable to locate drone fabricator."))

	else if (href_list["toggle_fab"])

		if(!dronefab)
			return

		if(get_dist(src,dronefab) > 3)
			dronefab = null
			to_chat(usr, SPAN_DANGER("Unable to locate drone fabricator."))
			return

		dronefab.produce_drones = !dronefab.produce_drones
		to_chat(usr, SPAN_NOTICE(" You [dronefab.produce_drones ? "enable" : "disable"] drone production in the nearby fabricator."))

	src.updateUsrDialog()
