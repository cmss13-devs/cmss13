/* Teleportation devices.
 * Contains:
 *		Locator
 *		Hand-tele
 */

/*
 * Locator
 */
/obj/item/device/locator
	name = "locator"
	desc = "Used to track those with locater implants."
	icon_state = "locator"
	var/temp = null
	var/frequency = 1451
	var/broadcasting = null
	var/listening = 1.0
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL
	item_state = "electronic"
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	matter = list("metal" = 400)


/obj/item/device/locator/attack_self(mob/user)
	..()
	user.set_interaction(src)
	var/dat
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = {"
		Frequency:
		<A href='byond://?src=\ref[src];freq=-10'>-</A>
		<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(frequency)]
		<A href='byond://?src=\ref[src];freq=2'>+</A>
		<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

		<A href='?src=\ref[src];refresh=1'>Refresh</A>
		"}
	show_browser(user, dat, "Persistent Signal Locator", "radio")
	onclose(user, "radio")
	return

/obj/item/device/locator/Topic(href, href_list)
	..()
	if (usr.stat || usr.is_mob_restrained())
		return
	var/turf/current_location = get_turf(usr)//What turf is the user on?
	if(!current_location || is_admin_level(current_location.z))//If turf was not found or they're on z level 2.
		to_chat(usr, "The [src] is malfunctioning.")
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_interaction(src)
		if (href_list["refresh"])
			src.temp = "<B>Persistent Signal Locator</B><HR>"
			var/turf/sr = get_turf(src)

			if (sr)
				src.temp += "<B>Located Beacons:</B><BR>"

				for(var/i in GLOB.radio_beacon_list)
					var/obj/item/device/radio/beacon/W = i
					if (W.frequency == src.frequency)
						var/turf/tr = get_turf(W)
						if (tr.z == sr.z && tr)
							var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									if (direct < 20)
										direct = "weak"
									else
										direct = "very weak"
							src.temp += "[W.code]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>Extranneous Signals:</B><BR>"
				for (var/i in GLOB.tracking_implant_list)
					var/obj/item/implant/tracking/W = i
					if (!W.implanted || !(istype(W.loc,/obj/limb) || ismob(W.loc)))
						continue
					else
						var/mob/M = W.loc
						if (M.stat == 2)
							if (M.timeofdeath + 6000 < world.time)
								continue

					var/turf/tr = get_turf(W)
					if (tr.z == sr.z && tr)
						var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
						if (direct < 20)
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									direct = "weak"
							src.temp += "[W.id]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>You are at \[[sr.x],[sr.y],[sr.z]\]</B> in orbital coordinates.<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A><BR>"
			else
				src.temp += "<B><FONT color='red'>Processing Error:</FONT></B> Unable to locate orbital position.<BR>"
		else
			if (href_list["freq"])
				src.frequency += text2num(href_list["freq"])
				src.frequency = sanitize_frequency(src.frequency)
			else
				if (href_list["temp"])
					src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M as anything in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	return


/*
 * Hand-tele
 */
/obj/item/device/hand_tele
	name = "hand tele"
	desc = "A portable item using blue-space technology."
	icon_state = "hand_tele"
	item_state = "electronic"
	throwforce = 5
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	matter = list("metal" = 10000)


/obj/item/device/hand_tele/attack_self(mob/user)
	..()

	var/turf/current_location = get_turf(user)//What turf is the user on?
	if(!current_location || is_admin_level(current_location.z))//If turf was not found or they're on z level 2
		to_chat(user, SPAN_NOTICE("\The [src] is malfunctioning."))
		return
	var/list/L = list(  )
	for(var/obj/structure/machinery/teleport/hub/R in machines)
		var/obj/structure/machinery/computer/teleporter/com = locate(/obj/structure/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
		if (istype(com, /obj/structure/machinery/computer/teleporter) && com.locked && !com.one_time_use)
			if(R.icon_state == "tele1")
				L["[com.id] (Active)"] = com.locked
			else
				L["[com.id] (Inactive)"] = com.locked
	var/list/turfs = list(	)
	for(var/turf/T in orange(10))
		if(T.x>world.maxx-8 || T.x<8)	continue	//putting them at the edge is dumb
		if(T.y>world.maxy-8 || T.y<8)	continue
		turfs += T
	if(turfs.len)
		L["None (Dangerous)"] = pick(turfs)
	var/t1 = tgui_input_list(user, "Please select a teleporter to lock in on.", "Hand Teleporter", L)
	if ((user.get_active_hand() != src || user.stat || user.is_mob_restrained()))
		return
	var/count = 0	//num of portals from this teleport in the world
	for(var/i in GLOB.portal_list)
		var/obj/effect/portal/PO = i
		if(PO.creator == src)
			count++
	if(count >= 3)
		user.show_message(SPAN_NOTICE("\The [src] is recharging!"))
		return
	var/T = L[t1]
	for(var/mob/O in hearers(user, null))
		O.show_message(SPAN_NOTICE("Locked In."), 2)
	var/obj/effect/portal/P = new /obj/effect/portal( get_turf(src) )
	P.target = T
	P.creator = src
	src.add_fingerprint(user)
	return

