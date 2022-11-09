// Door open and close constants
/var/const
	CLOSED = 2

#define FIREDOOR_MAX_PRESSURE_DIFF 25 // kPa
#define FIREDOOR_MAX_TEMP 50 // °C
#define FIREDOOR_MIN_TEMP 0

// Bitflags
#define FIREDOOR_ALERT_HOT      1
#define FIREDOOR_ALERT_COLD     2


/obj/structure/machinery/door/firedoor
	name = "\improper Emergency Shutter"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas."
	icon = 'icons/obj/structures/doors/DoorHazard.dmi'
	icon_state = "door_open"
	req_one_access = list(ACCESS_CIVILIAN_ENGINEERING)
	opacity = 0
	density = 0
	layer = FIREDOOR_OPEN_LAYER
	open_layer = FIREDOOR_OPEN_LAYER // Just below doors when open
	closed_layer = FIREDOOR_CLOSED_LAYER // Just above doors when closed
	power_channel = POWER_CHANNEL_ENVIRON
	use_power = 1
	idle_power_usage = 5

	var/blocked = 0
	var/lockdown = 0 // When the door has detected a problem, it locks.
	var/pdiff_alert = 0
	var/pdiff = 0
	var/nextstate = null
	var/net_id
	var/list/areas_added
	var/list/users_to_open = new
	var/next_process_time = 0

	var/list/tile_info[4]
	var/list/dir_alerts[4] // 4 dirs, bitflags

	// MUST be in same order as FIREDOOR_ALERT_*
	var/list/ALERT_STATES=list(
		"hot",
		"cold"
	)

/obj/structure/machinery/door/firedoor/Initialize()
	. = ..()
	for(var/obj/structure/machinery/door/firedoor/F in loc)
		if(F != src)
			QDEL_IN(src, 1)
			return .
	var/area/A = get_area(src)
	ASSERT(istype(A))

	A.all_doors.Add(src)
	areas_added = list(A)

	for(var/direction in cardinal)
		A = get_area(get_step(src,direction))
		if(istype(A) && !(A in areas_added))
			A.all_doors.Add(src)
			areas_added += A

/obj/structure/machinery/door/firedoor/Destroy()
	for(var/area/A in areas_added)
		A.all_doors.Remove(src)
	return ..()


/obj/structure/machinery/door/firedoor/get_examine_text(mob/user)
	. = ..()
	if(get_dist(src, user) > 1 && !isRemoteControlling(user))
		return

	if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
		. += SPAN_WARNING("WARNING: Current pressure differential is [pdiff]kPa! Opening door may result in injury!")

	. += "<b>Sensor readings:</b>"
	for(var/index = 1; index <= tile_info.len; index++)
		var/o = "&nbsp;&nbsp;"
		switch(index)
			if(1)
				o += "NORTH: "
			if(2)
				o += "SOUTH: "
			if(3)
				o += "EAST: "
			if(4)
				o += "WEST: "
		if(tile_info[index] == null)
			o += SPAN_WARNING("DATA UNAVAILABLE")
			. += o
			continue
		var/celsius = convert_k2c(tile_info[index][1])
		var/pressure = tile_info[index][2]
		if(dir_alerts[index] & (FIREDOOR_ALERT_HOT|FIREDOOR_ALERT_COLD))
			o += "<span class='warning'>"
		else
			o += "<span style='color:blue'>"
		o += "[celsius]&deg;C</span> "
		o += "<span style='color:blue'>"
		o += "[pressure]kPa</span></li>"
		. += o

	if(islist(users_to_open) && users_to_open.len)
		var/users_to_open_string = users_to_open[1]
		if(users_to_open.len >= 2)
			for(var/i = 2 to users_to_open.len)
				users_to_open_string += ", [users_to_open[i]]"
		. += "These people have opened \the [src] during an alert: [users_to_open_string]."

/obj/structure/machinery/door/firedoor/Collided(atom/movable/AM)
	if(panel_open || operating)
		return
	if(!density)
		return ..()
	return 0

/obj/structure/machinery/door/firedoor/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.

	if(blocked)
		to_chat(user, SPAN_WARNING("\The [src] is welded solid!"))
		return

	var/alarmed = lockdown
	for(var/area/A in areas_added)		//Checks if there are fire alarms in any areas associated with that firedoor
		if(A.flags_alarm_state & ALARM_WARNING_FIRE || A.air_doors_activated)
			alarmed = 1

	var/answer = alert(user, "Would you like to [density ? "open" : "close"] this [src.name]?[ alarmed && density ? "\nNote that by doing so, you acknowledge any damages from opening this\n[src.name] as being your own fault, and you will be held accountable under the law." : ""]",\
	"\The [src]", "Yes, [density ? "open" : "close"]", "No")
	if(answer == "No")
		return
	if(user.is_mob_incapacitated() || (!user.canmove && !isRemoteControlling(user)) || (get_dist(src, user) > 1  && !isRemoteControlling(user)))
		to_chat(user, "Sorry, you must remain able bodied and close to \the [src] in order to use it.")
		return
	if(density && (inoperable())) //can still close without power
		to_chat(user, "\The [src] is not functioning, you'll have to force it open manually.")
		return

	if(alarmed && density && lockdown && !allowed(user))
		to_chat(user, SPAN_WARNING("Access denied.  Please wait for authorities to arrive, or for the alert to clear."))
		return
	else
		user.visible_message(SPAN_NOTICE("\The [src] [density ? "open" : "close"]s for \the [user]."),\
		"\The [src] [density ? "open" : "close"]s.",\
		"You hear a beep, and a door opening.")

	var/needs_to_close = 0
	if(density)
		if(alarmed)
			// Accountability!
			users_to_open |= user.name
			needs_to_close = 1
		INVOKE_ASYNC(src, .proc/open, TRUE)
	else
		INVOKE_ASYNC(src, .proc/close)

	if(needs_to_close)
		spawn(50)
			alarmed = 0
			for(var/area/A in areas_added)		//Just in case a fire alarm is turned off while the firedoor is going through an autoclose cycle
				if(A.flags_alarm_state & ALARM_WARNING_FIRE || A.air_doors_activated)
					alarmed = 1
			if(alarmed)
				nextstate = CLOSED
				close()

/obj/structure/machinery/door/firedoor/attackby(obj/item/C as obj, mob/user as mob)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.
	if(iswelder(C))
		var/obj/item/tool/weldingtool/W = C
		if(W.remove_fuel(0, user))
			blocked = !blocked
			user.visible_message(SPAN_DANGER("\The [user] [blocked ? "welds" : "unwelds"] \the [src] with \a [W]."),\
			"You [blocked ? "weld" : "unweld"] \the [src] with \the [W].",\
			"You hear something being welded.")
			update_icon()
			return

	else if(C.pry_capable)
		if(operating)
			return

		if(blocked)
			user.visible_message(SPAN_DANGER("\The [user] pries at \the [src] with \a [C], but \the [src] is welded in place!"),\
			"You try to pry \the [src] [density ? "open" : "closed"], but it is welded in place!",\
			"You hear someone struggle and metal straining.")
			return

		user.visible_message(SPAN_DANGER("\The [user] starts to force \the [src] [density ? "open" : "closed"] with \a [C]!"),\
				SPAN_NOTICE("You start forcing \the [src] [density ? "open" : "closed"] with \the [C]!"),\
				"You hear metal strain.")
		var/old_density = density
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			if(blocked || density != old_density) return
			user.visible_message(SPAN_DANGER("\The [user] forces \the [blocked ? "welded " : "" ][name] [density ? "open" : "closed"] with \a [C]!"),\
				SPAN_NOTICE("You force \the [blocked ? "welded " : ""][name] [density ? "open" : "closed"] with \the [C]!"),\
				"You hear metal strain and groan, and a door [density ? "opening" : "closing"].")
			spawn(0)
				if(density)
					open(TRUE)
				else
					close()
		return TRUE //no afterattack call
	else
		if(blocked)
			to_chat(user, SPAN_DANGER("\The [src] is welded solid!"))
			return
	if(istype(C, /obj/item/weapon/zombie_claws))
		if(operating)
			return
		user.visible_message(SPAN_DANGER("\The zombie starts to force \the [src] [density ? "open" : "closed"] with it's claws!!!"),\
				"You start forcing \the [src] [density ? "open" : "closed"] with your claws!",\
				"You hear metal strain.")
		if(do_after(user, 150, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			user.visible_message(SPAN_DANGER("\The [user] forces \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \a [C]!"),\
			"You force \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \the [C]!",\
			"You hear metal strain and groan, and a door [density ? "opening" : "closing"].")
			if(density)
				INVOKE_ASYNC(src, .proc/open, TRUE)
			else
				INVOKE_ASYNC(src, .proc/close)
			return

/obj/structure/machinery/door/firedoor/try_to_activate_door(mob/user)
	return

/obj/structure/machinery/door/firedoor/proc/latetoggle()
	if(operating || !nextstate)
		return
	switch(nextstate)
		if(OPEN)
			nextstate = null
			open()
		if(CLOSED)
			nextstate = null
			close()
	return

/obj/structure/machinery/door/firedoor/close()
	latetoggle()
	return ..()

/obj/structure/machinery/door/firedoor/open(var/forced = FALSE)
	if(!forced)
		if(inoperable())
			return //needs power to open unless it was forced
		else
			use_power(360)
	latetoggle()
	return ..()

/obj/structure/machinery/door/firedoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("door_opening", src)
		if("closing")
			flick("door_closing", src)
	playsound(loc, 'sound/machines/emergency_shutter.ogg', 25)
	return


/obj/structure/machinery/door/firedoor/update_icon()
	overlays.Cut()
	if(density)
		icon_state = "door_closed"
		if(blocked)
			overlays += "welded"
		if(pdiff_alert)
			overlays += "palert"
		if(dir_alerts)
			for(var/d=1;d<=4;d++)
				var/cdir = cardinal[d]
				for(var/i=1;i<=ALERT_STATES.len;i++)
					if(dir_alerts[d] & (1<<(i-1)))
						overlays += new/icon(icon,"alert_[ALERT_STATES[i]]", dir=cdir)
	else
		icon_state = "door_open"
		if(blocked)
			overlays += "welded_open"
	return


/obj/structure/machinery/door/firedoor/border_only


//ALMAYER FIRE DOOR

/obj/structure/machinery/door/firedoor/border_only/almayer
	name = "\improper Emergency Shutter"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas."
	icon = 'icons/obj/structures/doors/purinadoor.dmi'
	openspeed = 4


/obj/structure/machinery/door/firedoor/multi_tile
	icon = 'icons/obj/structures/doors/DoorHazard2x1.dmi'
	width = 2

/obj/structure/machinery/door/firedoor/border_only/almayer/antag
	req_one_access = list(ACCESS_ILLEGAL_PIRATE)
