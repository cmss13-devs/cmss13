/*
FIRE ALARM
*/
/obj/structure/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "fire0"
	var/detecting = 1
	var/working = 1
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = POWER_CHANNEL_ENVIRON
	var/wiresexposed = 0
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone

/obj/structure/machinery/firealarm/Initialize(mapload, dir, building)
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_SECURITY_LEVEL_CHANGED, PROC_REF(sec_changed))

	if(dir)
		setDir(dir)

	if(building)
		buildstage = 0
		wiresexposed = 1
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0

	if(!is_mainship_level(z))
		if(GLOB.security_level)
			overlays += image('icons/obj/structures/machinery/monitors.dmi', "overlay_[get_security_level()]")
		else
			overlays += image('icons/obj/structures/machinery/monitors.dmi', "overlay_green")

	update_icon()

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
				icon_state = "fire_b2"
			if(1)
				icon_state = "fire_b1"
			if(0)
				icon_state = "fire_b0"
		return

	icon_state = "fire0"

	if(stat & BROKEN)
		icon_state = "firex"
	else if(stat & NOPOWER & (GLOB.security_level != SEC_LEVEL_RED))
		icon_state = "firep"

/obj/structure/machinery/firealarm/fire_act(temperature, volume)
	if(src.detecting)
		if(temperature > T0C+200)
			src.alarm() // added check of detector status here
	return

/obj/structure/machinery/firealarm/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/firealarm/bullet_act(BLAH)
	return src.alarm()

/obj/structure/machinery/firealarm/emp_act(severity)
	. = ..()
	if(prob(50/severity))
		alarm()

/obj/structure/machinery/firealarm/attackby(obj/item/held_object as obj, mob/user as mob)
	src.add_fingerprint(user)

	if (HAS_TRAIT(held_object, TRAIT_TOOL_SCREWDRIVER) && buildstage == 2)
		wiresexposed = !wiresexposed
		update_icon()
		return

	if(wiresexposed)
		switch(buildstage)
			if(2)
				if (HAS_TRAIT(held_object, TRAIT_TOOL_MULTITOOL))
					src.detecting = !( src.detecting )
					if (src.detecting)
						user.visible_message(SPAN_DANGER("[user] has reconnected [src]'s detecting unit!"), "You have reconnected [src]'s detecting unit.")
					else
						user.visible_message(SPAN_DANGER("[user] has disconnected [src]'s detecting unit!"), "You have disconnected [src]'s detecting unit.")
				else if (HAS_TRAIT(held_object, TRAIT_TOOL_WIRECUTTERS))
					user.visible_message(SPAN_DANGER("[user] has cut the wires inside \the [src]!"), "You have cut the wires inside \the [src].")
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
					buildstage = 1
					update_icon()
			if(1)
				if(istype(held_object, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/cable = held_object
					if (cable.use(5))
						to_chat(user, SPAN_NOTICE("You wire \the [src]."))
						buildstage = 2
						update_icon()
						return
					else
						to_chat(user, SPAN_WARNING("You need 5 pieces of cable to do wire \the [src]."))
						return
				else if(HAS_TRAIT(held_object, TRAIT_TOOL_CROWBAR))
					to_chat(user, "You pry out the circuit!")
					playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
					spawn(20)
						var/obj/item/circuitboard/firealarm/circuit = new()
						circuit.forceMove(user.loc)
						buildstage = 0
						update_icon()
			if(0)
				if(istype(held_object, /obj/item/circuitboard/firealarm))
					to_chat(user, "You insert the circuit!")
					qdel(held_object)
					buildstage = 1
					update_icon()

				else if(HAS_TRAIT(held_object, TRAIT_TOOL_WRENCH))
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					var/obj/item/frame/fire_alarm/frame = new /obj/item/frame/fire_alarm()
					frame.forceMove(user.loc)
					playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
					qdel(src)
		return

	. = ..()
	return

/obj/structure/machinery/firealarm/attack_hand(mob/user as mob)
	if(user.stat || inoperable())
		return

	if (buildstage != 2 || wiresexposed)
		return

	var/area/area = get_area(src)

	if (area.flags_alarm_state & ALARM_WARNING_FIRE)
		user.visible_message("[user] deactivates [src].", "You deactivate [src].")
		reset()
	else
		user.visible_message("[user] activates [src].", "You activate [src].")
		alarm()

	return

/obj/structure/machinery/firealarm/proc/reset()
	if (!( src.working ))
		return
	var/area/area = get_area(src)

	if (!( istype(area, /area) ))
		return
	area.firereset()
	update_icon()
	return

/obj/structure/machinery/firealarm/proc/alarm()
	if (!( src.working ))
		return
	var/area/area = get_area(src)

	if (!( istype(area, /area) ))
		return
	area.firealert()
	update_icon()
	return
