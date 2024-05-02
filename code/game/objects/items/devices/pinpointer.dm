/*relocated to fray-marines same dir
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
	var/obj/item/disk/nuclear/the_disk = null
	var/active = 0


/obj/item/device/pinpointer/attack_self()
	..()

	if(!active)
		active = 1
		workdisk()
		to_chat(usr, SPAN_NOTICE(" You activate the pinpointer"))
	else
		active = 0
		icon_state = "pinoff"
		to_chat(usr, SPAN_NOTICE(" You deactivate the pinpointer"))

/obj/item/device/pinpointer/proc/workdisk()
	if(!active) return
	if(!the_disk)
		the_disk = locate()
		if(!the_disk)
			icon_state = "pinonnull"
			return
	setDir(Get_Compass_Dir(src,the_disk))
	switch(get_dist(src,the_disk))
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


/obj/item/device/pinpointer/advpinpointer
	name = "Advanced Pinpointer"
	desc = "A larger version of the normal pinpointer, this unit features a helpful quantum entanglement detection system to locate various objects that do not broadcast a locator signal."
	var/mode = 0  // Mode 0 locates disk, mode 1 locates coordinates.
	var/turf/location = null
	var/obj/target = null

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
	setDir(Get_Compass_Dir(src,location))
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
	setDir(Get_Compass_Dir(src,target))
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
	target=null
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
*/
