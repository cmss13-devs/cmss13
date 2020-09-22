//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//SortNames variant for cameras that uses their tags rather than names
/proc/sortCameras(var/list/L)
	var/list/Q = new()
	for(var/obj/structure/machinery/camera/CAM in L)
		Q[CAM.c_tag] = CAM
	return sortList(Q)

/obj/structure/machinery/computer/security
	name = "Security Cameras Console"
	desc = "Used to access the various cameras on the station."
	icon_state = "cameras"
	var/obj/structure/machinery/camera/current = null
	var/last_pic = 1.0
	var/list/network = list("military")
	var/mapping = 0//For the overview file, interesting bit of code.
	circuit = /obj/item/circuitboard/computer/security
	var/next_use_time = 0		//sorting cameras list is heavy operation, so added a 2 seconds delay between interactions with console

/obj/structure/machinery/computer/security/attack_remote(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/security/check_eye(mob/user)
	if (user.is_mob_incapacitated() || ((get_dist(user, src) > 1 || !( user.canmove ) || user.blinded) && !isRemoteControlling(user))) //user can't see - not sure why canmove is here.
		user.unset_interaction()
		return
	else if ( !current || !current.can_use() ) //camera doesn't work
		current = null
	user.reset_view(current)


/obj/structure/machinery/computer/security/on_set_interaction(mob/user)
	..()
	if(current && current.can_use())
		user.reset_view(current)


/obj/structure/machinery/computer/security/on_unset_interaction(mob/user)
	..()
	user.reset_view(null)


/obj/structure/machinery/computer/security/attack_hand(mob/user)
	if(z > 6)
		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the station!"))
		return
	if(inoperable())
		return
	if(next_use_time < world.time)
		to_chat(user, SPAN_DANGER("\The [src]'s system is taking it's time to update camera list, please wait."))

	if(!isRemoteControlling(user))
		user.set_interaction(src)

	var/list/camera_list_sorted = sortCameras(cameranet.cameras)		//here we sort cameras, however, due to how procs work, it returns list of camera_name = null

	for(var/obj/structure/machinery/camera/CAM in cameranet.cameras)	//here we add actual cameras to respective C_tag in list
		camera_list_sorted[CAM.c_tag] = CAM

	var/list/camera_list_final = list()
	for(var/C in camera_list_sorted)
		var/obj/structure/machinery/camera/CAM = camera_list_sorted[C]
		if(can_access_camera(CAM))
			camera_list_final += list("[CAM.c_tag][CAM.can_use() ? null : " (Deactivated)"]" = CAM)

	var/t = input(user, "Which camera should you change to?") as null|anything in camera_list_final
	if(!t)
		user.unset_interaction()
		return 0

	var/obj/structure/machinery/camera/C = camera_list_final[t]

	if(C)
		if(!can_access_camera(C))
			return
		switch_to_camera(user, C)
		add_timer(CALLBACK(src, /atom.proc/attack_hand, user), 25)
	return

/obj/structure/machinery/computer/security/proc/can_access_camera(obj/structure/machinery/camera/C)
	if(!istype(C))
		return FALSE
	var/list/shared_networks = network & C.network
	if(shared_networks.len)
		return TRUE
	return FALSE

/obj/structure/machinery/computer/security/proc/switch_to_camera(mob/user, obj/structure/machinery/camera/C)
	//don't need to check if the camera works for AI because the AI jumps to the camera location and doesn't actually look through cameras.
	if(isRemoteControlling(user))
		var/mob/living/silicon/ai/A = user
		A.eyeobj.setLoc(get_turf(C))
		A.client.eye = A.eyeobj
		return 1

	if (!C.can_use() || user.is_mob_incapacitated() || (get_dist(user, src) > 1 || user.interactee != src || user.blinded || !( user.canmove ) && !isRemoteControlling(user)))
		return 0
	current = C
	use_power(50)
	user.reset_view(C)
	return 1

//Camera control: moving.
/obj/structure/machinery/computer/security/proc/jump_on_click(var/mob/user,var/A)
	if(user.interactee != src)
		return
	var/obj/structure/machinery/camera/jump_to
	if(istype(A,/obj/structure/machinery/camera))
		jump_to = A
	else if(ismob(A))
		if(ishuman(A))
			jump_to = locate() in A:head
		else if(isrobot(A))
			jump_to = A:camera
	else if(isobj(A))
		jump_to = locate() in A
	else if(isturf(A))
		var/best_dist = INFINITY
		for(var/obj/structure/machinery/camera/camera in get_area(A))
			if(!camera.can_use())
				continue
			if(!can_access_camera(camera))
				continue
			var/dist = get_dist(camera,A)
			if(dist < best_dist)
				best_dist = dist
				jump_to = camera
	if(isnull(jump_to))
		return
	if(can_access_camera(jump_to))
		switch_to_camera(user,jump_to)

//Camera control: mouse.
/obj/structure/machinery/computer/security/clicked(var/mob/user, var/list/mods)
	if (mods["ctrl"] && mods["middle"])
		if (src == user.interactee)
			jump_on_click(user, src)
		return 1

	..()

/obj/structure/machinery/computer/security/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "telescreen"
	network = list("thunder")
	density = 0
	circuit = null

/obj/structure/machinery/computer/security/telescreen/update_icon()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	return

/obj/structure/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things?"
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "entertainment"
	circuit = null

/obj/structure/machinery/computer/security/wooden_tv
	name = "Security Cameras"
	desc = "An old TV hooked into the stations camera network."
	icon_state = "security_det"
	circuit = null


/obj/structure/machinery/computer/security/mining
	name = "Outpost Cameras"
	desc = "Used to access the various cameras on the outpost."
	icon_state = "miningcameras"
	network = list("MINE")
	circuit = /obj/item/circuitboard/computer/security/mining

/obj/structure/machinery/computer/security/engineering
	name = "Engineering Cameras"
	desc = "Used to monitor fires and breaches."
	icon_state = "engineeringcameras"
	network = list("Engineering","Power Alarms","Atmosphere Alarms","Fire Alarms")
	circuit = /obj/item/circuitboard/computer/security/engineering

/obj/structure/machinery/computer/security/nuclear
	name = "Mission Monitor"
	desc = "Used to access the built-in cameras in helmets."
	icon_state = "syndicam"
	network = list("NUKE")
	circuit = null


/obj/structure/machinery/computer/security/almayer
	density = 0
	icon_state = "security_cam"
	network = list("almayer")

/obj/structure/machinery/computer/security/almayer_network
	network = list("almayer")


/obj/structure/machinery/computer/security/dropship
	name = "abstract dropship camera computer"
	desc = "A computer to monitor cameras linked to the dropship."
	density = 1
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "consoleleft"
	circuit = null
	unslashable = TRUE
	unacidable = TRUE
	exproof = TRUE


/obj/structure/machinery/computer/security/dropship/one
	name = "\improper 'Alamo' camera controls"
	network = list("dropship1","laser targets")

/obj/structure/machinery/computer/security/dropship/two
	name = "\improper 'Normandy' camera controls"
	network = list("dropship2","laser targets")

