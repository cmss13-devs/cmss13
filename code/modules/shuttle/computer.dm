/obj/structure/machinery/computer/shuttle
	name = "shuttle console"
	desc = "A shuttle control computer."
	icon_state = "syndishuttle"
	req_access = list( )
// interaction_flags = INTERACT_MACHINE_TGUI
	var/shuttleId
	var/possible_destinations = ""
	var/admin_controlled


/obj/structure/machinery/computer/shuttle/tgui_interact(mob/user)
	. = ..()
	var/list/options = valid_destinations()
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	var/dat = "Status: [M ? M.getStatusText() : "*Missing*"]<br><br>"
	if(M)
		var/destination_found
		for(var/obj/docking_port/stationary/S in SSshuttle.stationary)
			if(!options.Find(S.id))
				continue
			if(!M.check_dock(S, silent=TRUE))
				continue
			destination_found = TRUE
			dat += "<A href='?src=[REF(src)];move=[S.id]'>Send to [S.name]</A><br>"
		if(!destination_found)
			dat += "<B>Shuttle Locked</B><br>"
			if(admin_controlled)
				dat += "Authorized personnel only<br>"
				dat += "<A href='?src=[REF(src)];request=1]'>Request Authorization</A><br>"

	var/datum/browser/popup = new(user, "computer", "<div align='center'>[M ? M.name : "shuttle"]</div>", 300, 200)
	popup.set_content("<center>[dat]</center>")
	popup.open()

/obj/structure/machinery/computer/shuttle/proc/valid_destinations()
	return params2list(possible_destinations)

/obj/structure/machinery/computer/shuttle/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(!isXenoQueen(usr) && !allowed(usr))
		to_chat(usr, "<span class='danger'>Access denied.</span>")
		return TRUE

	if(href_list["move"])
		var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
// if(!(M.shuttle_flags & GAMEMODE_IMMUNE) && world.time < SSticker.round_start_time + SSticker.mode.deploy_time_lock)
// to_chat(usr, "<span class='warning'>The engines are still refueling.</span>")
// return TRUE
		if(!M.can_move_topic(usr))
			return TRUE
		if(!(href_list["move"] in valid_destinations()))
			log_admin("[key_name(usr)] may be attempting a href dock exploit on [src] with target location \"[href_list["move"]]\"")
// message_admins("[ADMIN_TPMONTY(usr)] may be attempting a href dock exploit on [src] with target location \"[href_list["move"]]\"")
			return TRUE
		var/previous_status = M.mode
		log_game("[key_name(usr)] has sent the shuttle [M] to [href_list["move"]]")
		switch(SSshuttle.moveShuttle(shuttleId, href_list["move"], 1))
			if(0)
				if(previous_status != SHUTTLE_IDLE)
					visible_message("<span class='notice'>Destination updated, recalculating route.</span>")
				else
					visible_message("<span class='notice'>Shuttle departing. Please stand away from the doors.</span>")
			if(1)
				to_chat(usr, "<span class='warning'>Invalid shuttle requested.</span>")
				return TRUE
			else
				to_chat(usr, "<span class='notice'>Unable to comply.</span>")
				return TRUE

/obj/structure/machinery/computer/shuttle/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	if(port && (shuttleId == initial(shuttleId) || override))
		shuttleId = port.id

/obj/structure/machinery/computer/shuttle/lifeboat
	name = "lifeboat console"
	desc = "A lifeboat control computer."
	icon_state = "terminal"
	req_access = list()
	breakable = FALSE

/obj/structure/machinery/computer/shuttle/lifeboat/attack_hand(mob/user)
	. = ..()
	var/obj/docking_port/mobile/lifeboat/lifeboat = SSshuttle.getShuttle(shuttleId)
	if(lifeboat.status == LIFEBOAT_LOCKED)
		to_chat(user, SPAN_WARNING("\The [src] flickers with error messages."))
	else if(lifeboat.status == LIFEBOAT_INACTIVE)
		to_chat(user, SPAN_NOTICE("\The [src]'s screen says \"Awaiting evacuation order\"."))
	else if(lifeboat.status == LIFEBOAT_ACTIVE)
		switch(lifeboat.mode)
			if(SHUTTLE_IDLE)
				to_chat(user, SPAN_NOTICE("\The [src]'s screen says \"Awaiting confirmation of the evacuation order\"."))
			if(SHUTTLE_IGNITING)
				to_chat(user, SPAN_NOTICE("\The [src]'s screen says \"Engines firing\"."))
			if(SHUTTLE_CALL)
				to_chat(user, SPAN_NOTICE("\The [src] has flight information scrolling across the screen. The autopilot is working correctly."))

/obj/structure/machinery/computer/shuttle/lifeboat/attack_alien(mob/living/carbon/Xenomorph/xeno)
	if(xeno.caste && xeno.caste.is_intelligent)
		var/obj/docking_port/mobile/lifeboat/lifeboat = SSshuttle.getShuttle(shuttleId)
		if(lifeboat.status == LIFEBOAT_LOCKED)
			to_chat(xeno, SPAN_WARNING("We already wrested away control of this metal bird."))
			return XENO_NO_DELAY_ACTION

		xeno_attack_delay(xeno)
		if(do_after(usr, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			if(lifeboat.status != LIFEBOAT_LOCKED)
				lifeboat.status = LIFEBOAT_LOCKED
				lifeboat.available = FALSE
				lifeboat.set_mode(SHUTTLE_IDLE)
				xeno_message(SPAN_XENOANNOUNCE("We have wrested away control of one of the metal birds! They shall not escape!"), 3, xeno.hivenumber)
		return XENO_NO_DELAY_ACTION
	else
		return ..()
