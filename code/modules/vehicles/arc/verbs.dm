/obj/vehicle/multitile/arc/proc/toggle_antenna(mob/toggler)
	set name = "Toggle Sensor Antenna"
	set desc = "Raises or lowers the external sensor antenna. While raised, the ARC cannot move."
	set category = "Vehicle"

	var/mob/user = toggler || usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/arc/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(vehicle.health < initial(vehicle.health) * 0.5)
		to_chat(user, SPAN_WARNING("[vehicle]'s hull is too damaged to operate!"))
		return

	var/obj/item/hardpoint/support/arc_antenna/antenna = locate() in vehicle.hardpoints
	if(!antenna)
		to_chat(user, SPAN_WARNING("[vehicle] has no antenna mounted!"))
		return

	if(antenna.deploying)
		return

	if(antenna.health <= 0)
		to_chat(user, SPAN_WARNING("[antenna] is broken!"))
		return

	if(vehicle.antenna_deployed)
		to_chat(user, SPAN_NOTICE("You begin to retract [antenna]..."))
		antenna.deploying = TRUE
		if(!do_after(user, max(vehicle.antenna_toggle_time - antenna.deploy_animation_time, 1 SECONDS), target = vehicle))
			to_chat(user, SPAN_NOTICE("You stop retracting [antenna]."))
			antenna.deploying = FALSE
			return

		antenna.retract_antenna()
		addtimer(CALLBACK(vehicle, PROC_REF(finish_antenna_retract), user), antenna.deploy_animation_time)

	else
		to_chat(user, SPAN_NOTICE("You begin to extend [antenna]..."))
		antenna.deploying = TRUE
		if(!do_after(user, max(vehicle.antenna_toggle_time - antenna.deploy_animation_time, 1 SECONDS), target = vehicle))
			to_chat(user, SPAN_NOTICE("You stop extending [antenna]."))
			antenna.deploying = FALSE
			return

		antenna.deploy_antenna()
		addtimer(CALLBACK(vehicle, PROC_REF(finish_antenna_deploy), user), antenna.deploy_animation_time)

/obj/vehicle/multitile/arc/proc/finish_antenna_retract(mob/user)
	var/obj/item/hardpoint/support/arc_antenna/antenna = locate() in hardpoints
	if(!antenna)
		antenna.deploying = FALSE
		return

	if(user)
		to_chat(user, SPAN_NOTICE("You retract [antenna], enabling the ARC to move again."))
		playsound(user, 'sound/machines/hydraulics_2.ogg', 80, TRUE)
	antenna_deployed = !antenna_deployed
	antenna.deploying = FALSE
	update_icon()
	SEND_SIGNAL(src, COMSIG_ARC_ANTENNA_TOGGLED)

/obj/vehicle/multitile/arc/proc/finish_antenna_deploy(mob/user)
	var/obj/item/hardpoint/support/arc_antenna/antenna = locate() in hardpoints
	if(!antenna)
		antenna.deploying = FALSE
		return

	if(user)
		to_chat(user, SPAN_NOTICE("You extend [antenna], locking the ARC in place."))
		playsound(user, 'sound/machines/hydraulics_2.ogg', 80, TRUE)
	antenna_deployed = !antenna_deployed
	antenna.deploying = FALSE
	update_icon()
	SEND_SIGNAL(src, COMSIG_ARC_ANTENNA_TOGGLED)

/obj/vehicle/multitile/arc/proc/open_arc_controls_guide()
	set name = "Vehicle Controls Guide"
	set desc = "MANDATORY FOR FIRST PLAY AS VEHICLE CREWMAN OR AFTER UPDATES."
	set category = "Vehicle"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/arc/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	var/dat = "<b><i>Common verbs:</i></b><br>\
	1. <b>\"G: Name Vehicle\"</b> - used to add a custom name to the vehicle. Single use. 26 characters maximum.<br> \
	2. <b>\"I: Get Status Info\"</b> - brings up \"Vehicle Status Info\" window with all available information about your vehicle.<br> \
	3. <b>\"G: Toggle Sensor Antenna\"</b> - extend or retract the ARC's sensor antenna. While extended, all unknown lifeforms within a large range can be seen by all on the tacmap, but the ARC cannot move. Additionally enables the automated RE700 cannon.<br> \
	<font color='#cd6500'><b><i>Driver verbs:</i></b></font><br> 1. <b>\"G: Activate Horn\"</b> - activates vehicle horn. Keep in mind, that vehicle horn is very loud and can be heard from afar by both allies and foes.<br> \
	2. <b>\"G: Toggle Door Locks\"</b> - toggles vehicle's access restrictions. Crewman, Brig and Command accesses bypass these restrictions.<br> \
	<font color='#cd6500'><b><i>Driver shortcuts:</i></b></font><br> 1. <b>\"CTRL + Click\"</b> - activates vehicle horn.<br>"

	show_browser(user, dat, "Vehicle Controls Guide", "vehicle_help", width = 900, height = 500)
	onclose(user, "vehicle_help")
	return
