/obj/structure/machinery/camera
	name = "security camera"
	desc = "It's used to monitor rooms."
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "camera"
	use_power = 2
	idle_power_usage = 5
	active_power_usage = 10
	layer = FLY_LAYER

	var/list/network = list("military")
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1.0
	anchored = 1.0
	var/panel_open = 0 // 0 = Closed / 1 = Open
	var/invuln = null
	var/bugged = 0
	var/obj/item/frame/camera/assembly = null

	// WIRES
	var/wires = 63 // 0b111111
	var/list/IndexToFlag = list()
	var/list/IndexToWireColor = list()
	var/list/WireColorToIndex = list()
	var/list/WireColorToFlag = list()

	//OTHER

	var/view_range = 7
	var/short_range = 2

	var/light_disabled = 0
	var/alarm_on = 0

/obj/structure/machinery/camera/Initialize(mapload, ...)
	. = ..()
	WireColorToFlag = randomCameraWires()
	assembly = new(src)
	assembly.state = 4
	/* // Use this to look for cameras that have the same c_tag.
	for(var/obj/structure/machinery/camera/C in cameranet.cameras)
		var/list/tempnetwork = C.network&src.network
		if(C != src && C.c_tag == src.c_tag && tempnetwork.len)
			world.log << "[src.c_tag] [src.x] [src.y] [src.z] conflicts with [C.c_tag] [C.x] [C.y] [C.z]"
	*/
	if(!src.network || src.network.len < 1)
		if(loc)
			error("[src.name] in [get_area(src)] (x:[src.x] y:[src.y] z:[src.z] has errored. [src.network?"Empty network list":"Null network list"]")
		else
			error("[src.name] in [get_area(src)]has errored. [src.network?"Empty network list":"Null network list"]")
		ASSERT(src.network)
		ASSERT(src.network.len > 0)

	set_pixel_location()

/obj/structure/machinery/camera/set_pixel_location()
	switch(dir)
		if(NORTH)		pixel_y = -18
		if(SOUTH)		pixel_y = 40
		if(EAST)		pixel_x = -27
		if(WEST)		pixel_x = 27

/obj/structure/machinery/camera/emp_act(severity)
	if(!isEmpProof())
		if(prob(100/severity))
			icon_state = "[initial(icon_state)]emp"
			var/list/previous_network = network
			network = list()
			cameranet.removeCamera(src)
			stat |= EMPED
			SetLuminosity(0)
			triggerCameraAlarm()
			spawn(900)
				network = previous_network
				icon_state = initial(icon_state)
				stat &= ~EMPED
				cancelCameraAlarm()
				if(can_use())
					cameranet.addCamera(src)
			kick_viewers()
			..()


/obj/structure/machinery/camera/ex_act(severity)
	if(src.invuln)
		return
	else
		..(severity)
	return

/obj/structure/machinery/camera/proc/setViewRange(var/num = 7)
	src.view_range = num
	cameranet.updateVisibility(src, 0)

/obj/structure/machinery/camera/attack_hand(mob/living/carbon/human/user as mob)

	if(!istype(user))
		return

	if(user.species.can_shred(user))
		visible_message(SPAN_WARNING("\The [user] slashes at [src]!"))
		playsound(src.loc, 'sound/weapons/slash.ogg', 25, 1)
		wires = 0 //wires all cut
		light_disabled = 0
		toggle_cam_status(user, TRUE)

/obj/structure/machinery/camera/attackby(W as obj, mob/living/user as mob)

	// DECONSTRUCTION
	if(isscrewdriver(W))
		//to_chat(user, SPAN_NOTICE("You start to [panel_open ? ")close" : "open"] the camera's panel.")
		//if(toggle_panel(user)) // No delay because no one likes screwdrivers trying to be hip and have a duration cooldown
		panel_open = !panel_open
		user.visible_message(SPAN_WARNING("[user] screws the camera's panel [panel_open ? "open" : "closed"]!"),
		SPAN_NOTICE("You screw the camera's panel [panel_open ? "open" : "closed"]."))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)

	else if((iswirecutter(W) || ismultitool(W)) && panel_open)
		interact(user)

	else if(iswelder(W) && canDeconstruct())
		if(weld(W, user))
			if(assembly)
				assembly.loc = src.loc
				assembly.state = 1
			qdel(src)


	// OTHER
	else if ((istype(W, /obj/item/paper)) && isliving(user))
		var/mob/living/U = user
		var/obj/item/paper/X = null

		var/itemname = ""
		var/info = ""
		if(istype(W, /obj/item/paper))
			X = W
			itemname = X.name
			info = X.info
		to_chat(U, "You hold \a [itemname] up to the camera ...")
		for(var/mob/living/silicon/ai/O in living_mob_list)
			if(!O.client) continue
			if(U.name == "Unknown") to_chat(O, "<b>[U]</b> holds \a [itemname] up to one of your cameras ...")
			else to_chat(O, "<b><a href='byond://?src=\ref[O];track2=\ref[O];track=\ref[U]'>[U]</a></b> holds \a [itemname] up to one of your cameras ...")
			show_browser(O, info, itemname, itemname)
		for(var/mob/O in player_list)
			if (istype(O.interactee, /obj/structure/machinery/computer/security))
				var/obj/structure/machinery/computer/security/S = O.interactee
				if (S.current == src)
					to_chat(O, "[U] holds \a [itemname] up to one of the cameras ...")
					show_browser(O, info, itemname, itemname)
	else if (istype(W, /obj/item/device/camera_bug))
		if (!src.can_use())
			to_chat(user, SPAN_NOTICE(" Camera non-functional"))
			return
		if (src.bugged)
			to_chat(user, SPAN_NOTICE(" Camera bug removed."))
			src.bugged = 0
		else
			to_chat(user, SPAN_NOTICE(" Camera bugged."))
			src.bugged = 1
	else
		..()
	return

/obj/structure/machinery/camera/proc/toggle_cam_status(mob/user, silent)
	status = !status
	add_hiddenprint(user)
	if(!silent)
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
		if(status)
			visible_message(SPAN_WARNING("[user] has reactivated [src]!"))
		else
			visible_message(SPAN_WARNING("[user] has deactivated [src]!"))
	if(status)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]1"
	// now disconnect anyone using the camera
	//Apparently, this will disconnect anyone even if the camera was re-activated.
	//I guess that doesn't matter since they can't use it anyway?
	kick_viewers()

//This might be redundant, because of check_eye()
/obj/structure/machinery/camera/proc/kick_viewers()
	for(var/mob/O in player_list)
		if (istype(O.interactee, /obj/structure/machinery/computer/security))
			var/obj/structure/machinery/computer/security/S = O.interactee
			if (S.current == src)
				O.unset_interaction()
				O.reset_view(null)
				to_chat(O, "The screen bursts into static.")

/obj/structure/machinery/camera/proc/triggerCameraAlarm()
	alarm_on = 1
	for(var/mob/living/silicon/S in mob_list)
		S.triggerAlarm("Camera", get_area(src), list(src), src)


/obj/structure/machinery/camera/proc/cancelCameraAlarm()
	alarm_on = 0
	for(var/mob/living/silicon/S in mob_list)
		S.cancelAlarm("Camera", get_area(src), src)

/obj/structure/machinery/camera/proc/can_use()
	if(!status)
		return 0
	if(stat & EMPED)
		return 0
	return 1

/obj/structure/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(src)
	if(isXRay())
		see = range(view_range, pos)
	else
		see = hear(view_range, pos)
	return see

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/closed/wall/T = null
	for(var/i = 1, i <= 8; i += i)
		T = get_ranged_target_turf(src, i, 1)
		if(istype(T))
			//If someone knows a better way to do this, let me know. -Giacom
			switch(i)
				if(NORTH)
					src.dir = SOUTH
				if(SOUTH)
					src.dir = NORTH
				if(WEST)
					src.dir = EAST
				if(EAST)
					src.dir = WEST
			break

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(var/mob/M)
	for(var/obj/structure/machinery/camera/C in oview(4, M))
		if(C.can_use())	// check if camera disabled
			return C
			break
	return null

/proc/near_range_camera(var/mob/M)

	for(var/obj/structure/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C
			break

	return null

/obj/structure/machinery/camera/proc/weld(var/obj/item/tool/weldingtool/WT, var/mob/user)

	if(user.action_busy)
		return 0
	if(!WT.isOn())
		return 0

	//Do after stuff here
	user.visible_message(SPAN_NOTICE("[user] starts to weld [src]."),
	SPAN_NOTICE("You start to weld [src]."))
	playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
	WT.eyecheck(user)
	if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		if(!WT.isOn())
			return 0
		playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] welds [src]."),
		SPAN_NOTICE("You weld [src]."))
		return 1
	return 0
