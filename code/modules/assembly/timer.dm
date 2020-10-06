/obj/item/device/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	matter = list("metal" = 500, "glass" = 50, "waste" = 10)


	wires = WIRE_PULSE

	secured = 0

	var/timing = 0
	var/time = 4

/obj/item/device/assembly/timer/activate()
	if(!..())	return 0//Cooldown check

	timing = !timing

	update_icon()
	return 0


/obj/item/device/assembly/timer/toggle_secure()
	secured = !secured
	if(secured)
		processing_objects.Add(src)
	else
		timing = 0
		processing_objects.Remove(src)
	update_icon()
	return secured


/obj/item/device/assembly/timer/proc/timer_end()
	if(!secured)	return 0
	pulse(0)
	if(!holder)
		visible_message("[htmlicon(src, hearers(src))] *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	addtimer(CALLBACK(src, .proc/process_cooldown), 1 SECONDS)
	return


/obj/item/device/assembly/timer/process()
	if(timing && (time > 0))
		time--
	if(timing && time <= 0)
		timing = 0
		timer_end()
		time = 10
	return


/obj/item/device/assembly/timer/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "timer_timing"
		attached_overlays += "timer_timing"
	if(holder)
		holder.update_icon()
	return


/obj/item/device/assembly/timer/interact(mob/user as mob)//TODO: Have this use the wires
	if(!secured)
		user.show_message(SPAN_DANGER("The [name] is unsecured!"))
		return 0
	var/second = time % 60
	var/minute = (time - second) / 60
	var/dat = text("<TT>[] []:[]\n<A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT>", (timing ? text("<A href='?src=\ref[];time=0'>Timing</A>", src) : text("<A href='?src=\ref[];time=1'>Not Timing</A>", src)), minute, second, src, src, src, src)
	dat += "<BR><BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<BR><BR><A href='?src=\ref[src];close=1'>Close</A>"
	show_browser(user, dat, "Timing Unit", "timer")
	return


/obj/item/device/assembly/timer/Topic(href, href_list)
	..()
	if(!usr.canmove || usr.stat || usr.is_mob_restrained() || !in_range(loc, usr))
		close_browser(usr, "timer")
		return

	if(href_list["time"])
		timing = text2num(href_list["time"])
		if(!timing)
			time = min(max(round(time), 2), 600)
		update_icon()

	if(href_list["tp"])
		var/tp = text2num(href_list["tp"])
		time += tp
		time = min(max(round(time), 2), 600)

	if(href_list["close"])
		close_browser(usr, "timer")
		return

	if(usr)
		attack_self(usr)

	return
