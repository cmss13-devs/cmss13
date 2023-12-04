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
	var/busy = FALSE //Busy when waiting for authentication or an event request has been sent from this device.
	var/obj/structure/machinery/keycard_auth/event_source
	var/mob/event_triggered_by
	var/mob/event_confirmed_by
	var/channel = "almayer" // Which channel are we on? Needs to be set for these to properly work.
	//1 = select event
	//2 = authenticate
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = POWER_CHANNEL_ENVIRON
	COOLDOWN_DECLARE(distress_cooldown)

/obj/structure/machinery/keycard_auth/attack_remote(mob/user as mob)
	to_chat(user, "The station AI is not to interact with these devices.")
	return

/obj/structure/machinery/keycard_auth/attackby(obj/item/W as obj, mob/user as mob)
	if(inoperable())
		to_chat(user, "This device is not powered.")
		return
	if(istype(W,/obj/item/card/id))
		var/obj/item/card/id/ID = W
		if(ACCESS_MARINE_COMMAND in ID.access)
			if(active == 1)
				//This is not the device that made the initial request. It is the device confirming the request.
				if(event_source)
					event_source.confirmed = 1
					event_source.event_confirmed_by = usr
			else if(screen == 2)
				event_triggered_by = usr
				broadcast_request() //This is the device making the initial event request. It needs to broadcast to other devices
			playsound(src, 'sound/machines/switch.ogg', 25, 1)
/obj/structure/machinery/keycard_auth/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "auth_off"

/obj/structure/machinery/keycard_auth/attack_hand(mob/user as mob)
	if(user.stat || inoperable())
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
		if(GLOB.security_level < SEC_LEVEL_RED)
			dat += "<li><A href='?src=\ref[src];triggerevent=Red alert'>Red alert</A></li>"
		if(!SSticker.mode.ert_dispatched)
			dat += "<li><A href='?src=\ref[src];triggerevent=Distress Beacon'>Distress Beacon</A></li>"

		dat += "<li><A href='?src=\ref[src];triggerevent=Disable Maintenance Access'>Disable Maintenance Access</A></li>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Enable Maintenance Access'>Enable Maintenance Access</A></li>"
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
	if(usr.stat || inoperable())
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
	for(var/obj/structure/machinery/keycard_auth/KA in GLOB.machines)
		if(KA == src || KA.channel != channel) continue
		KA.reset()
		INVOKE_ASYNC(KA, TYPE_PROC_REF(/obj/structure/machinery/keycard_auth, receive_request), src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_admins("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]", 1)
	reset()

/obj/structure/machinery/keycard_auth/proc/receive_request(obj/structure/machinery/keycard_auth/source)
	if(inoperable())
		return
	event_source = source
	busy = TRUE
	active = 1
	icon_state = "auth_on"

	sleep(confirm_delay)

	event_source = null
	icon_state = "auth_off"
	active = 0
	busy = FALSE

/obj/structure/machinery/keycard_auth/proc/trigger_event()
	switch(event)
		if("Red alert")
			set_security_level(SEC_LEVEL_RED)
		if("Enable Maintenance Access")
			make_maint_all_access()
		if("Disable Maintenance Access")
			revoke_maint_all_access()
		if("Distress Beacon")
			call_ert()

/obj/structure/machinery/keycard_auth/proc/call_ert()
	if(world.time < DISTRESS_TIME_LOCK)
		to_chat(usr, SPAN_WARNING("The distress beacon cannot be launched this early in the operation. Please wait another [time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)] minutes before trying again."))
		return

	if(!COOLDOWN_FINISHED(src, distress_cooldown))
		to_chat(usr, SPAN_WARNING("The distress beacon has recently broadcast a message. Please wait."))
		return

	if(SSticker.mode.ert_dispatched)
		to_chat(usr, SPAN_WARNING("A distress beacon has already launched successfully!"))
		return

	if(GLOB.security_level == SEC_LEVEL_DELTA)
		to_chat(usr, SPAN_WARNING("The ship is already undergoing self-destruct procedures!"))
		return

	if(GLOB.security_level < SEC_LEVEL_RED)
		to_chat(usr, SPAN_WARNING("The ship security level is not high enough to call a distress beacon!"))
		return

	for(var/client/client in GLOB.admins)
		if((R_ADMIN|R_MOD) & client.admin_holder.rights)
			playsound_client(client,'sound/effects/sos-morse-code.ogg')
	if(SSticker.mode.is_in_endgame)
		SSticker.mode.authorized_request_ert(usr)
		to_chat(usr, SPAN_WARNING("Priority distress beacon launched successfully!"))
	else
		SSticker.mode.request_ert(usr)
		to_chat(usr, SPAN_NOTICE("Distress beacon request sent to ARES systems."))
	playsound(src, 'sound/machines/terminal_success.ogg', 25, 1)
	COOLDOWN_START(src, distress_cooldown, COOLDOWN_COMM_REQUEST)

GLOBAL_VAR_INIT(maint_all_access, TRUE)

/proc/make_maint_all_access()
	GLOB.maint_all_access = TRUE
	ai_announcement("The maintenance access requirement has been removed on all airlocks.")

/proc/revoke_maint_all_access()
	GLOB.maint_all_access = FALSE
	ai_announcement("The maintenance access requirement has been added on all airlocks.")

// Keycard reader at the CORSAT locks
/obj/structure/machinery/keycard_auth/lockdown
	name = "automated lockdown override"
	desc = "This device is used override the security lockdown."
	channel = "map_lockdown"
	var/window_desc = "This device is used to override the security lockdown. It requires both of the authentication disks."
	var/announce_title = "Station Security Authority automated announcement"
	var/card_type
	var/podlock_id = "map_lockdown"
	var/obj/item/card/data/stored_id
	confirm_delay = 30

/obj/structure/machinery/keycard_auth/lockdown/corsat
	name = "CORSAT automated biohazard override"
	card_type = /obj/item/card/data/corsat
	announce_title = "CORSAT Security Authority automated announcement"
	window_desc = "This device is used to override the CORSAT automated lockdown. It requires both of the authentication disks, which can be found in the offices of various heads of departments around the station."
	desc = "This device is used override the CORSAT automatic biohazard lockdown."

/obj/structure/machinery/keycard_auth/lockdown/prison
	card_type = /obj/item/card/data/prison
	window_desc = "This device is used to override the security lockdown. It requires both of the authentication disks, which can be found in the security offices of various cell blocks around the station."

/obj/structure/machinery/keycard_auth/lockdown/attackby(obj/item/W as obj, mob/user as mob)
	if(inoperable())
		to_chat(user, "This device is not powered.")
		return
	if(!istype(W, card_type))
		return

	var/obj/item/card/data/cID = W
	stored_id = cID

	/// We are the SECOND keycard device used (our event_source has already been set)

	if(active && event_source && istype(event_source, /obj/structure/machinery/keycard_auth/lockdown))
		var/obj/structure/machinery/keycard_auth/lockdown/ES = event_source
		if(ES.stored_id != stored_id)
			// Tell the first console that we're good to go.
			event_source.confirmed = 1
			event_source.event_confirmed_by = usr
		else
			visible_message(SPAN_NOTICE("[src] states: ONLY ONE UNIQUE CODE DISK DETECTED"))

	else if(screen == 2)
		event_triggered_by = usr
		broadcast_request() //This is the device making the initial event request. It needs to broadcast to other devices

/obj/structure/machinery/keycard_auth/lockdown/broadcast_request()
	icon_state = "auth_on"
	for(var/obj/structure/machinery/keycard_auth/lockdown/KA in GLOB.machines)
		if(KA == src || KA.channel != channel)
			continue
		KA.reset()
		INVOKE_ASYNC(KA, PROC_REF(receive_request), src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_admins("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]", 1)
	reset()

/obj/structure/machinery/keycard_auth/lockdown/attack_hand(mob/user as mob)
	if(user.stat || inoperable())
		to_chat(user, "This device is not powered.")
		return
	if(busy)
		to_chat(user, "This device is busy.")
		return

	user.set_interaction(src)

	var/dat = window_desc
	dat += "<br><hr><br>"

	if(screen == 1)
		dat += "Select an event to trigger:<ul>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Lift Biohazard Lockdown'>Lift Lockdown</A></li>"
		dat += "</ul>"
		show_browser(user, dat, name, "keycard_auth", "size=500x300")
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='?src=\ref[src];reset=1'>Back</A>"
		show_browser(user, dat, name, "keycard_auth", "size=500x300")
	return

/obj/structure/machinery/keycard_auth/lockdown/proc/timed_countdown(timeleft = 0)
	if(!timeleft)
		for(var/obj/structure/machinery/door/poddoor/M in GLOB.machines)
			if(M.id == podlock_id && M.density)
				INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/structure/machinery/door, open))
		return

	if(istype(SSticker.mode, /datum/game_mode/colonialmarines))
		var/datum/game_mode/colonialmarines/gCM = SSticker.mode
		if(gCM.round_status_flags & ROUNDSTATUS_PODDOORS_OPEN)
			visible_message(SPAN_NOTICE("[src] states: LOCKDOWN ALREADY LIFTED"))
			return
		gCM.round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN // So we don't spam the message twice

	var/text_timeleft = "[timeleft * 0.01] minutes"
	var/next_interval = 1 MINUTES
	if(timeleft <= 1 MINUTES)
		next_interval = 55 SECONDS
		text_timeleft = "[timeleft] minute"
	if(timeleft <= 5 SECONDS)
		next_interval = timeleft
		text_timeleft = "[timeleft] seconds"
	var/input = "Station shutter locks lifting in [text_timeleft] per manual override."
	var/title = announce_title
	marine_announcement(input, title, 'sound/AI/commandreport.ogg')
	for(var/mob/M in GLOB.player_list)
		if(isxeno(M))
			sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
			to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
			to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in [text_timeleft]."))
	var/new_timeleft = timeleft - next_interval
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/keycard_auth/lockdown, timed_countdown), new_timeleft), next_interval)

/obj/structure/machinery/keycard_auth/lockdown/trigger_event()
	set waitfor = 0
	switch(event)
		if("Lift Lockdown")
			if(istype(SSticker.mode, /datum/game_mode/colonialmarines))
				var/datum/game_mode/colonialmarines/gCM = SSticker.mode
				if(gCM.round_status_flags & ROUNDSTATUS_PODDOORS_OPEN)
					visible_message(SPAN_NOTICE("[src] states: LOCKDOWN ALREADY LIFTED"))
					return
				gCM.round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN // So we don't spam the message twice
			timed_countdown(3 MINUTES)
