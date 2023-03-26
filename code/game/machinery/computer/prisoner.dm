//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/prisoner
	name = "Prisoner Management"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "explosive"
	density = TRUE
	req_access = list(ACCESS_MARINE_BRIG)
	circuit = /obj/item/circuitboard/computer/prisoner
	var/id = 0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed
	processing = TRUE


/obj/structure/machinery/computer/prisoner/attack_remote(mob/user as mob)
	return src.attack_hand(user)


/obj/structure/machinery/computer/prisoner/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_interaction(src)
	var/dat
	dat += "<B>Prisoner Implant Manager System</B><BR>"
	if(screen == 0)
		dat += "<HR><A href='?src=\ref[src];lock=1'>Unlock Console</A>"
	else if(screen == 1)
		dat += "<HR>Chemical Implants<BR>"
		var/turf/Tr = null
		for(var/i in GLOB.chem_implant_list)
			var/obj/item/implant/chem/chem = i
			Tr = get_turf(chem)
			if((Tr) && (Tr.z != src.z)) continue//Out of range
			if(!chem.implanted) continue
			dat += "[chem.imp_in.name]|Remaining Units: [chem.reagents.total_volume]|Inject: "
			dat += "<A href='?src=\ref[src];inject1=\ref[chem]'>(<font color=red>(1)</font>)</A>"
			dat += "<A href='?src=\ref[src];inject5=\ref[chem]'>(<font color=red>(5)</font>)</A>"
			dat += "<A href='?src=\ref[src];inject10=\ref[chem]'>(<font color=red>(10)</font>)</A><BR>"
			dat += "********************************<BR>"
		dat += "<HR>Tracking Implants<BR>"
		for(var/i in GLOB.tracking_implant_list)
			var/obj/item/implant/tracking/tracker = i
			Tr = get_turf(tracker)
			if((Tr) && (Tr.z != src.z)) continue//Out of range
			if(!tracker.implanted) continue
			var/loc_display = "Unknown"
			var/mob/living/carbon/current_carbon = tracker.imp_in
			if(is_ground_level(current_carbon.z) && !istype(current_carbon.loc, /turf/open/space))
				var/turf/mob_loc = get_turf(current_carbon)
				loc_display = mob_loc.loc
			dat += "ID: [tracker.id]|Location: [loc_display]<BR>"
			dat += "<A href='?src=\ref[src];[HrefToken(forceGlobal = TRUE)];warn=\ref[tracker]'>(<font color=red><i>Message Holder</i></font>)</A> |<BR>"
			dat += "********************************<BR>"
		dat += "<HR><A href='?src=\ref[src];lock=1'>Lock Console</A>"

	show_browser(user, dat, name, "computer")
	onclose(user, "computer")
	return


/obj/structure/machinery/computer/prisoner/process()
	if(!..())
		src.updateDialog()
	return


/obj/structure/machinery/computer/prisoner/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (isRemoteControlling(usr)))
		usr.set_interaction(src)

		if(href_list["inject1"])
			var/obj/item/implant/implant = locate(href_list["inject1"])
			if(implant) implant.activate(1)

		else if(href_list["inject5"])
			var/obj/item/implant/implant = locate(href_list["inject5"])
			if(implant) implant.activate(5)

		else if(href_list["inject10"])
			var/obj/item/implant/implant = locate(href_list["inject10"])
			if(implant) implant.activate(10)

		else if(href_list["lock"])
			if(src.allowed(usr))
				screen = !screen
			else
				to_chat(usr, "Unauthorized Access.")

		else if(href_list["warn"])
			var/warning = strip_html(input(usr,"Message:","Enter your message here!",""))
			if(!warning) return
			var/obj/item/implant/implant = locate(href_list["warn"])
			if((implant)&&(implant.imp_in))
				var/mob/living/carbon/current_mob = implant.imp_in
				to_chat(current_mob, SPAN_XENOWARNING(" You hear a voice in your head saying: '[warning]'"))

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return
