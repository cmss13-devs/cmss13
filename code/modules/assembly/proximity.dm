/obj/item/device/assembly/prox_sensor
	name = "proximity sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	icon_state = "prox"
	matter = list("metal" = 800, "glass" = 200, "waste" = 50)


	wires = WIRE_PULSE

	secured = 0

	var/scanning = 0
	var/timing = FALSE
	var/time = 10
	var/range = 2
	var/iff_signal = FACTION_MARINE

	var/delay = 1 //number of seconds between sensing and pulsing
	var/delaying = FALSE

/obj/item/device/assembly/prox_sensor/activate()
	if(!..())
		return FALSE//Cooldown check
	timing = !timing
	update_icon()
	return FALSE


/obj/item/device/assembly/prox_sensor/toggle_secure()
	secured = !secured
	if(secured)
		processing_objects.Add(src)
	else
		scanning = 0
		timing = 0
		processing_objects.Remove(src)
	update_icon()
	return secured


/obj/item/device/assembly/prox_sensor/HasProximity(atom/movable/AM)
	if((!holder && !secured) || !scanning || cooldown>0 || delaying)
		return
	if(has_moved_recently(AM))
		sense()


/obj/item/device/assembly/prox_sensor/proc/has_moved_recently(atom/movable/AM)
	if(world.time-AM.l_move_time <= 20)
		return TRUE
	return FALSE


/obj/item/device/assembly/prox_sensor/proc/sense()
	var/turf/mainloc = get_turf(src)
	mainloc.visible_message(SPAN_DANGER("You hear a proximity sensor beep!"), SPAN_DANGER("You hear a proximity sensor beep!"))
	playsound(mainloc, 'sound/machines/twobeep.ogg', 50, 1)

	delaying = TRUE
	addtimer(CALLBACK(src, .proc/pulse, 0), delay*10)

	cooldown = 2
	addtimer(CALLBACK(src, .proc/process_cooldown),10)
	return


/obj/item/device/assembly/prox_sensor/pulse()
	delaying = FALSE
	..()


/obj/item/device/assembly/prox_sensor/process()
	if(scanning)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/M in range(range,mainloc))
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.get_target_lock(iff_signal))
					continue
			HasProximity(M)

	if(timing && (time >= 0))
		time--
	if(timing && time <= 0)
		timing = 0
		toggle_scan()
		time = 10
	return


/obj/item/device/assembly/prox_sensor/proc/toggle_scan()
	if(!secured)	return 0
	scanning = !scanning
	update_icon()
	return


/obj/item/device/assembly/prox_sensor/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "prox_timing"
		attached_overlays += "prox_timing"
	if(scanning)
		overlays += "prox_scanning"
		attached_overlays += "prox_scanning"
	if(holder)
		holder.update_icon()
	return


/obj/item/device/assembly/prox_sensor/interact(mob/user as mob)//TODO: Change this to the wires thingy
	if(!secured)
		user.show_message(SPAN_DANGER("The [name] is unsecured!"))
		return 0
	var/second = time % 60
	var/minute = (time - second) / 60
	var/dat = text("<TT>[] []:[]\n<A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT>", (timing ? text("<A href='?src=\ref[];time=0'>Arming</A>", src) : text("<A href='?src=\ref[];time=1'>Not Arming</A>", src)), minute, second, src, src, src, src)
	dat += text("<BR>Range: <A href='?src=\ref[];range=-1'>-</A> [] <A href='?src=\ref[];range=1'>+</A>", src, range, src)
	dat += text("<BR>Delay: <A href='?src=\ref[];delay=-1'>-</A> [] <A href='?src=\ref[];delay=1'>+</A>", src, delay, src)
	dat += "<BR><A href='?src=\ref[src];scanning=1'>[scanning?"Armed":"Unarmed"]</A> (Movement sensor active when armed!)"
	dat += "<BR><BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<BR><BR><A href='?src=\ref[src];close=1'>Close</A>"
	show_browser(user, dat, "Proximity Sensor", "prox")
	return


/obj/item/device/assembly/prox_sensor/Topic(href, href_list)
	..()
	if(!usr.canmove || usr.stat || usr.is_mob_restrained() || !in_range(loc, usr))
		close_browser(usr, "prox")
		return

	if(href_list["scanning"])
		toggle_scan()

	if(href_list["time"])
		timing = text2num(href_list["time"])
		if(!timing)
			time = min(max(round(time), 3), 600)
		update_icon()

	if(href_list["tp"])
		var/tp = text2num(href_list["tp"])
		time += tp
		time = min(max(round(time), 3), 600)

	if(href_list["range"])
		var/r = text2num(href_list["range"])
		range += r
		range = min(max(range, 1), 5)

	if(href_list["delay"])
		var/d = text2num(href_list["delay"])
		delay += d
		delay = min(max(delay, 1), 10)

	if(href_list["close"])
		close_browser(usr, "prox")
		return

	if(usr)
		attack_self(usr)


	return
