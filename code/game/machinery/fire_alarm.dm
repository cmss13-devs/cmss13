


/*
FIRE ALARM
*/
/obj/structure/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "fire0"
	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = POWER_CHANNEL_ENVIRON
	var/last_process = 0
	var/wiresexposed = 0
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone

/obj/structure/machinery/firealarm/Initialize(mapload, dir, building)
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_SECURITY_LEVEL_CHANGED, .proc/sec_changed)

/obj/structure/machinery/firealarm/proc/sec_changed(datum/source, new_sec)
	SIGNAL_HANDLER
	switch(new_sec)
		if(SEC_LEVEL_GREEN)
			icon_state = "fire0"
		if(SEC_LEVEL_BLUE)
			icon_state = "fireblue"
		if(SEC_LEVEL_RED, SEC_LEVEL_DELTA)
			icon_state = "firered"

/obj/structure/machinery/firealarm/update_icon()

	if(wiresexposed)
		switch(buildstage)
			if(2)
				icon_state="fire_b2"
			if(1)
				icon_state="fire_b1"
			if(0)
				icon_state="fire_b0"

		return

	if(stat & BROKEN)
		icon_state = "firex"
	else if(stat & NOPOWER & (security_level != SEC_LEVEL_RED))
		icon_state = "firep"

/obj/structure/machinery/firealarm/fire_act(temperature, volume)
	if(src.detecting)
		if(temperature > T0C+200)
			src.alarm()			// added check of detector status here
	return

/obj/structure/machinery/firealarm/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/firealarm/bullet_act(BLAH)
	return src.alarm()

/obj/structure/machinery/firealarm/emp_act(severity)
	if(prob(50/severity)) alarm()
	..()

/obj/structure/machinery/firealarm/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if (HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && buildstage == 2)
		wiresexposed = !wiresexposed
		update_icon()
		return

	if(wiresexposed)
		switch(buildstage)
			if(2)
				if (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
					src.detecting = !( src.detecting )
					if (src.detecting)
						user.visible_message(SPAN_DANGER("[user] has reconnected [src]'s detecting unit!"), "You have reconnected [src]'s detecting unit.")
					else
						user.visible_message(SPAN_DANGER("[user] has disconnected [src]'s detecting unit!"), "You have disconnected [src]'s detecting unit.")
				else if (HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
					user.visible_message(SPAN_DANGER("[user] has cut the wires inside \the [src]!"), "You have cut the wires inside \the [src].")
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
					buildstage = 1
					update_icon()
			if(1)
				if(istype(W, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/C = W
					if (C.use(5))
						to_chat(user, SPAN_NOTICE("You wire \the [src]."))
						buildstage = 2
						return
					else
						to_chat(user, SPAN_WARNING("You need 5 pieces of cable to do wire \the [src]."))
						return
				else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
					to_chat(user, "You pry out the circuit!")
					playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
					spawn(20)
						var/obj/item/circuitboard/firealarm/circuit = new()
						circuit.forceMove(user.loc)
						buildstage = 0
						update_icon()
			if(0)
				if(istype(W, /obj/item/circuitboard/firealarm))
					to_chat(user, "You insert the circuit!")
					qdel(W)
					buildstage = 1
					update_icon()

				else if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					var/obj/item/frame/fire_alarm/frame = new /obj/item/frame/fire_alarm()
					frame.forceMove(user.loc)
					playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
					qdel(src)
		return

	//src.alarm() // why was this even a thing?
	..()
	return

/obj/structure/machinery/firealarm/power_change()
	..()
	addtimer(CALLBACK(src, .proc/update_icon), rand(0,15))

/obj/structure/machinery/firealarm/attack_hand(mob/user as mob)
	if(user.stat || inoperable())
		return

	if (buildstage != 2)
		return

	user.set_interaction(src)
	var/area/A = src.loc
	var/d1
	var/d2
	if (istype(user, /mob/living/carbon/human) || isRemoteControlling(user))
		A = A.loc

		if (A.flags_alarm_state & ALARM_WARNING_FIRE)
			d1 = text("<A href='?src=\ref[];reset=1'>Reset - Lockdown</A>", src)
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>Alarm - Lockdown</A>", src)
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>Stop Time Lock</A>", src)
		else
			d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Lock</A>", src)
		var/second = round(src.time) % 60
		var/minute = (round(src.time) - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT>[d1]\n<HR>The current alert level is: [get_security_level()]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		show_browser(user, dat, "Fire Alarm", "firealarm")
	else
		A = A.loc
		if (A.flags_alarm_state & ALARM_WARNING_FIRE)
			d1 = text("<A href='?src=\ref[];reset=1'>[]</A>", src, stars("Reset - Lockdown"))
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>[]</A>", src, stars("Alarm - Lockdown"))
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>[]</A>", src, stars("Stop Time Lock"))
		else
			d2 = text("<A href='?src=\ref[];time=1'>[]</A>", src, stars("Initiate Time Lock"))
		var/second = round(src.time) % 60
		var/minute = (round(src.time) - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT>[d1]\n<HR><b>The current alert level is: [stars(get_security_level())]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? text("[]:", minute) : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		show_browser(user, dat, "**Fire Alarm**", "firealarm")
	return

/obj/structure/machinery/firealarm/Topic(href, href_list)
	..()
	if (usr.stat || inoperable())
		return

	if (buildstage != 2)
		return

	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (isRemoteControlling(usr)))
		usr.set_interaction(src)
		if (href_list["reset"])
			src.reset()
		else if (href_list["alarm"])
			src.alarm()
		else if (href_list["time"])
			src.timing = text2num(href_list["time"])
			last_process = world.timeofday
			//START_PROCESSING(SSobj, src)
		else if (href_list["tp"])
			var/tp = text2num(href_list["tp"])
			src.time += tp
			src.time = min(max(round(src.time), 0), 120)

		src.updateUsrDialog()

		src.add_fingerprint(usr)
	else
		close_browser(usr, "firealarm")
		return
	return

/obj/structure/machinery/firealarm/proc/reset()
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.firereset()
	update_icon()
	return

/obj/structure/machinery/firealarm/proc/alarm()
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.firealert()
	update_icon()
	//playsound(src.loc, 'sound/ambience/signal.ogg', 50, 0)
	return

/obj/structure/machinery/firealarm/Initialize(mapload, dir, building)
	. = ..()

	if(dir)
		src.setDir(dir)

	if(building)
		buildstage = 0
		wiresexposed = 1
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0

	if(!is_mainship_level(z))
		if(security_level)
			src.overlays += image('icons/obj/structures/machinery/monitors.dmi', "overlay_[get_security_level()]")
		else
			src.overlays += image('icons/obj/structures/machinery/monitors.dmi', "overlay_green")

	update_icon()
