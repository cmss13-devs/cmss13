/obj/structure/machinery/keycard_auth
	name = "Keycard Authentication Device"
	desc = "This device is used to trigger station functions, which require more than one ID card to authenticate."
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "auth_off"
	unacidable = TRUE
	var/active = 0 //This gets set to 1 on all devices except the one where the initial request was made.
	var/event = ""
	var/screen = 1
	var/confirmed = 0 //This variable is set by the device that confirms the request.
	var/confirm_delay = 20 //(2 seconds)
	var/busy = 0 //Busy when waiting for authentication or an event request has been sent from this device.
	var/obj/structure/machinery/keycard_auth/event_source
	var/mob/event_triggered_by
	var/mob/event_confirmed_by
	var/channel = "almayer" // Which channel are we on? Needs to be set for these to properly work.
	//1 = select event
	//2 = authenticate
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/structure/machinery/keycard_auth/attack_ai(mob/user as mob)
	to_chat(user, "The station AI is not to interact with these devices.")
	return

/obj/structure/machinery/keycard_auth/attackby(obj/item/W as obj, mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(istype(W,/obj/item/card/id))
		var/obj/item/card/id/ID = W
		if(ACCESS_MARINE_BRIDGE in ID.access)
			if(active == 1)
				//This is not the device that made the initial request. It is the device confirming the request.
				if(event_source)
					event_source.confirmed = 1
					event_source.event_confirmed_by = usr
			else if(screen == 2)
				event_triggered_by = usr
				broadcast_request() //This is the device making the initial event request. It needs to broadcast to other devices

/obj/structure/machinery/keycard_auth/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "auth_off"

/obj/structure/machinery/keycard_auth/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(busy)
		to_chat(user, "This device is busy.")
		return

	user.set_interaction(src)

	var/dat = "<h1>Keycard Authentication Device</h1>"

	dat += "This device is used to trigger some high security events. It requires the simultaneous swipe of two high-level ID cards."
	dat += "<br><hr><br>"

	if(screen == 1)
		dat += "Select an event to trigger:<ul>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Red alert'>Red alert</A></li>"
		if(!config.ert_admin_call_only)
			dat += "<li><A href='?src=\ref[src];triggerevent=Emergency Response Team'>Emergency Response Team</A></li>"

		dat += "<li><A href='?src=\ref[src];triggerevent=Grant Emergency Maintenance Access'>Grant Emergency Maintenance Access</A></li>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Revoke Emergency Maintenance Access'>Revoke Emergency Maintenance Access</A></li>"
		dat += "</ul>"
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='?src=\ref[src];reset=1'>Back</A>"
	show_browser(user, dat, name, "keycard_auth")
	return


/obj/structure/machinery/keycard_auth/Topic(href, href_list)
	..()
	if(busy)
		to_chat(usr, "This device is busy.")
		return
	if(usr.stat || stat & (BROKEN|NOPOWER))
		to_chat(usr, "This device is without power.")
		return
	if(href_list["triggerevent"])
		event = href_list["triggerevent"]
		screen = 2
	if(href_list["reset"])
		reset()

	updateUsrDialog()
	add_fingerprint(usr)
	return

/obj/structure/machinery/keycard_auth/proc/reset()
	active = 0
	event = ""
	screen = 1
	confirmed = 0
	event_source = null
	icon_state = "auth_off"
	event_triggered_by = null
	event_confirmed_by = null

/obj/structure/machinery/keycard_auth/proc/broadcast_request()
	icon_state = "auth_on"
	for(var/obj/structure/machinery/keycard_auth/KA in machines)
		if(KA == src || KA.channel != channel) continue
		KA.reset()
		INVOKE_ASYNC(KA, /obj/structure/machinery/keycard_auth.proc/receive_request, src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_admins("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]", 1)
	reset()

/obj/structure/machinery/keycard_auth/proc/receive_request(var/obj/structure/machinery/keycard_auth/source)
	if(stat & (BROKEN|NOPOWER))
		return
	event_source = source
	busy = 1
	active = 1
	icon_state = "auth_on"

	sleep(confirm_delay)

	event_source = null
	icon_state = "auth_off"
	active = 0
	busy = 0

/obj/structure/machinery/keycard_auth/proc/trigger_event()
	switch(event)
		if("Red alert")
			set_security_level(SEC_LEVEL_RED)
		if("Grant Emergency Maintenance Access")
			make_maint_all_access()
		if("Revoke Emergency Maintenance Access")
			revoke_maint_all_access()
		if("Emergency Response Team")
			if(is_ert_blocked())
				to_chat(usr, SPAN_DANGER("All emergency response teams are dispatched and can not be called at this time."))
				return

			trigger_armed_response_team(1)

/obj/structure/machinery/keycard_auth/proc/is_ert_blocked()
	if(config.ert_admin_call_only) return 1
	return ticker.mode && ticker.mode.ert_disabled

var/global/maint_all_access = 0

/proc/make_maint_all_access()
	maint_all_access = 1
	ai_announcement("The maintenance access requirement has been revoked on all airlocks.")

/proc/revoke_maint_all_access()
	maint_all_access = 0
	ai_announcement("The maintenance access requirement has been readded on all airlocks.")

// Keycard reader at the CORSAT locks
/obj/structure/machinery/keycard_auth/corsat
	name = "CORSAT Automated Biohazard override"
	desc = "This device is used override the CORSAT automatic biohazard lockdown."
	channel = "corsat"
	var/obj/item/card/data/corsat/stored_id
	confirm_delay = 30

/obj/structure/machinery/keycard_auth/corsat/attackby(obj/item/W as obj, mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(!istype(W,/obj/item/card/data/corsat))
		return
	
	var/obj/item/card/data/corsat/cID = W
	stored_id = cID

	/// We are the SECOND keycard device used (our event_source has already been set)
	
	if(active && event_source && istype(event_source, /obj/structure/machinery/keycard_auth/corsat))
		var/obj/structure/machinery/keycard_auth/corsat/ES = event_source
		if(ES.stored_id != stored_id)
			// Tell the first console that we're good to go.
			event_source.confirmed = 1
			event_source.event_confirmed_by = usr
		else
			visible_message(SPAN_NOTICE("[src] states: ONLY ONE UNIQUE CODE DISK DETECTED"))

	else if(screen == 2)
		event_triggered_by = usr
		broadcast_request() //This is the device making the initial event request. It needs to broadcast to other devices

/obj/structure/machinery/keycard_auth/corsat/broadcast_request()
	icon_state = "auth_on"
	for(var/obj/structure/machinery/keycard_auth/corsat/KA in machines)
		if(KA == src || KA.channel != channel)
			continue
		KA.reset()
		INVOKE_ASYNC(KA, .proc/receive_request, src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_admins("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]", 1)
	reset()

/obj/structure/machinery/keycard_auth/corsat/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(busy)
		to_chat(user, "This device is busy.")
		return

	user.set_interaction(src)

	var/dat = "This device is used to override the CORSAT automated lockdown. It requires both of the authentication disks, which can be found in the offices of various heads of deparments around the station."
	dat += "<br><hr><br>"

	if(screen == 1)
		dat += "Select an event to trigger:<ul>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Lift Biohazard Lockdown'>Lift Biohazard Lockdown</A></li>"
		dat += "</ul>"
		show_browser(user, dat, "CORSAT Automated Biohazard Lockdown Override", "keycard_auth", "size=500x300")
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='?src=\ref[src];reset=1'>Back</A>"
		show_browser(user, dat, "CORSAT Automated Biohazard Lockdown Override", "keycard_auth", "size=500x300")
	return

/obj/structure/machinery/keycard_auth/corsat/trigger_event()
	set waitfor = 0
	switch(event)
		if("Lift Biohazard Lockdown")
			if(istype(ticker.mode, /datum/game_mode/colonialmarines))
				var/datum/game_mode/colonialmarines/gCM = ticker.mode
				if(gCM.round_status_flags & ROUNDSTATUS_PODDOORS_OPEN)
					visible_message(SPAN_NOTICE("[src] states: BIOHAZARD LOCKDOWN ALREADY LIFTED"))
					return
				gCM.round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN // So we don't spam the message twice
				
			var/input = "Biohazard locks lifting in 3 minutes per manual override."
			var/title = "CORSAT Security Authority automated announcement"
			marine_announcement(input, title, 'sound/AI/commandreport.ogg')
			for(var/mob/M in player_list)
				if(isXeno(M))
					sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
					to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
					to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in 3 minutes."))
			
			sleep(600)	

			if(istype(ticker.mode, /datum/game_mode/colonialmarines))
				var/datum/game_mode/colonialmarines/gCM = ticker.mode
				if(gCM.round_status_flags & ROUNDSTATUS_PODDOORS_OPEN)
					return

			input = "Biohazard locks lifting in 2 minutes per manual override."
			marine_announcement(input, title, 'sound/AI/commandreport.ogg')
			for(var/mob/M in player_list)
				if(isXeno(M))
					sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
					to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
					to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in 2 minutes."))

			sleep(600)

			if(istype(ticker.mode, /datum/game_mode/colonialmarines))
				var/datum/game_mode/colonialmarines/gCM = ticker.mode
				if(gCM.round_status_flags & ROUNDSTATUS_PODDOORS_OPEN)
					return

			input = "Biohazard locks lifting in 1 minute per manual override."
			marine_announcement(input, title, 'sound/AI/commandreport.ogg')
			for(var/mob/M in player_list)
				if(isXeno(M))
					sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
					to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
					to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in 1 minute."))

			sleep(550)

			if(istype(ticker.mode, /datum/game_mode/colonialmarines))
				var/datum/game_mode/colonialmarines/gCM = ticker.mode
				if(gCM.round_status_flags & ROUNDSTATUS_PODDOORS_OPEN)
					return

			input = "Biohazard locks lifting in 5 seconds per manual override."
			marine_announcement(input, title, 'sound/AI/commandreport.ogg')
			for(var/mob/M in player_list)
				if(isXeno(M))
					sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
					to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
					to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in 5 seconds."))

			sleep(50)
			
			var/podlock_id = "corsat_lockdown"
			for(var/obj/structure/machinery/door/poddoor/M in machines)
				if(M.id == podlock_id && M.density)
					INVOKE_ASYNC(M, /obj/structure/machinery/door.proc/open)
