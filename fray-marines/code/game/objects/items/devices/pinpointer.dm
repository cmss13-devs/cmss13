/obj/item/device/pinpointer
	name = "pinpointer"
	icon_state = "pinoff"
	flags_atom = FPRINT | CONDUCT
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_TINY
	item_state = "electronic"
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	matter = list("metal" = 500)
	var/active
	var/atom/movable/target
	var/list/tracked_list

/obj/item/device/pinpointer/attack_self()
	. = ..()

	if(!active)
		activate(usr)
	else
		deactivate(usr)

/obj/item/device/pinpointer/proc/set_target(mob/user)
	if(!length(tracked_list))
		to_chat(user, SPAN_WARNING("No traceable signals found!"))
		return
	target = tgui_input_list(user, "Select the item you wish to track.", "Pinpointer", tracked_list)
	if(QDELETED(target))
		return
	var/turf/pinpointer_loc = get_turf(src)
	if(target.z != pinpointer_loc.z)
		to_chat(user, SPAN_WARNING("Chosen target signal too weak. Choose another."))
		target = null
		return

/obj/item/device/pinpointer/proc/workdisk()
	if(!active) return
	if(!target)
		target = pick(tracked_list)
		if(!target)
			icon_state = "pinonnull"
			return
	setDir(get_dir(src,target))
	switch(get_dist(src,target))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
	spawn(5) .()

/obj/item/device/pinpointer/get_examine_text(mob/user)
	. = ..()
	for(var/obj/structure/machinery/nuclearbomb/bomb in GLOB.machines)
		if(bomb.timing)
			. += "Extreme danger.  Arming signal detected.   Time remaining: [bomb.timeleft]"

/obj/item/device/pinpointer/proc/activate(mob/user)
	set_target(user)
	if(!target)
		return
	active = TRUE
	START_PROCESSING(SSobj, src)
	to_chat(user, "<span class='notice'>You activate the pinpointer</span>")


/obj/item/device/pinpointer/proc/deactivate(mob/user)
	active = FALSE
	target = null
	STOP_PROCESSING(SSobj, src)
	icon_state = "pinoff"
	to_chat(user, "<span class='notice'>You deactivate the pinpointer</span>")


/obj/item/device/pinpointer/process()
	if(!target)
		icon_state = "pinonnull"
		active = FALSE
		return

	setDir(get_dir(src, target))
	switch(get_dist(src, target))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"


/obj/item/device/pinpointer/nuke
	name = "Nuke Pinpointer"
	desc = "A pinpointer designed to detect the encrypted emissions of nuclear devices"

/obj/item/device/pinpointer/nuke/Initialize()
	. = ..()
	tracked_list += GLOB.nuke_disk_generators
	tracked_list += GLOB.nuke_list

/obj/item/device/pinpointer/nuke/examine(mob/user)
	. = ..()
	for(var/i in GLOB.nuke_list)
		var/obj/structure/machinery/nuclearbomb/bomb = i
		if(bomb.timing)
			continue
		to_chat(user, "Extreme danger.  Arming signal detected.   Time remaining: [bomb.timeleft]")

/obj/item/device/pinpointer/advpinpointer
	name = "Advanced Pinpointer"
	desc = "A larger version of the normal pinpointer, this unit features a helpful quantum entanglement detection system to locate various objects that do not broadcast a locator signal."
	var/mode = 0  // Mode 0 locates disk, mode 1 locates coordinates.
	var/turf/location = null

/obj/item/device/pinpointer/advpinpointer/attack_self()
	..()
	if(!active)
		active = 1
		if(mode == 0)
			workdisk()
		if(mode == 1)
			worklocation()
		if(mode == 2)
			workobj()
		to_chat(usr, SPAN_NOTICE(" You activate the pinpointer"))
	else
		active = 0
		icon_state = "pinoff"
		to_chat(usr, SPAN_NOTICE(" You deactivate the pinpointer"))

/obj/item/device/pinpointer/advpinpointer/proc/worklocation()
	if(!active)
		return
	if(!location)
		icon_state = "pinonnull"
		return
	setDir(get_dir(src,location))
	switch(get_dist(src,location))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
	spawn(5) .()

/obj/item/device/pinpointer/advpinpointer/proc/workobj()
	if(!active)
		return
	if(!target)
		icon_state = "pinonnull"
		return
	setDir(get_dir(src,target))
	switch(get_dist(src,target))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
	spawn(5) .()

/obj/item/device/pinpointer/advpinpointer/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Pinpointer Mode"
	set src in view(1)

	active = 0
	icon_state = "pinoff"
	target = null
	location = null

	switch(alert("Please select the mode you want to put the pinpointer in.", "Pinpointer Mode Select", "Location", "Disk Recovery", "Other Signature"))
		if("Location")
			mode = 1

			var/locationx = tgui_input_real_number(usr, "Please input the x coordinate to search for.", "Location?")
			if(!locationx || !(usr in view(1,src)))
				return
			var/locationy = tgui_input_real_number(usr, "Please input the y coordinate to search for.", "Location?")
			if(!locationy || !(usr in view(1,src)))
				return

			var/turf/Z = get_turf(src)

			location = locate(locationx,locationy,Z.z)

			to_chat(usr, "You set the pinpointer to locate [locationx],[locationy]")


			return attack_self()

		if("Disk Recovery")
			mode = 0
			return attack_self()
