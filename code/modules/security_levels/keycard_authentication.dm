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
	power_channel = POWER_CHANNEL_ENVIRON

/obj/structure/machinery/keycard_auth/attack_remote(mob/user as mob)
	to_chat(user, "The station AI is not to interact with these devices.")
	return

/obj/structure/machinery/keycard_auth/attackby(obj/item/W as obj, mob/user as mob)
	if(inoperable())
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
		dat += "<li><A href='?src=\ref[src];triggerevent=Red alert'>Red alert</A></li>"
		if(!config.ert_admin_call_only)
			dat += "<li><A href='?src=\ref[src];triggerevent=Emergency Response Team'>Emergency Response Team</A></li>"

		dat += "<li><A href='?src=\ref[src];triggerevent=Remove Emergency Maintenance Access'>Remove Emergency Maintenance Access</A></li>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Add Emergency Maintenance Access'>Add Emergency Maintenance Access</A></li>"
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
	for(var/obj/structure/machinery/keycard_auth/KA in machines)
		if(KA == src || KA.channel != channel) continue
		KA.reset()
		INVOKE_ASYNC(KA, /obj/structure/machinery/keycard_auth.proc/receive_request, src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_staff("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]", 1)
	reset()

/obj/structure/machinery/keycard_auth/proc/receive_request(var/obj/structure/machinery/keycard_auth/source)
	if(inoperable())
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
		if("Remove Emergency Maintenance Access")
			make_maint_all_access()
		if("Add Emergency Maintenance Access")
			revoke_maint_all_access()

/obj/structure/machinery/keycard_auth/proc/is_ert_blocked()
	if(config.ert_admin_call_only) return 1
	return ticker.mode && ticker.mode.ert_disabled

var/global/maint_all_access = 1

/proc/make_maint_all_access()
	maint_all_access = 1
	ai_announcement("The maintenance access requirement has been removed on all airlocks.")

/proc/revoke_maint_all_access()
	maint_all_access = 0
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
	window_desc = "This device is used to override the CORSAT automated lockdown. It requires both of the authentication disks, which can be found in the offices of various heads of deparments around the station."
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
	for(var/obj/structure/machinery/keycard_auth/lockdown/KA in machines)
		if(KA == src || KA.channel != channel)
			continue
		KA.reset()
		INVOKE_ASYNC(KA, .proc/receive_request, src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_staff("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]", 1)
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

/obj/structure/machinery/keycard_auth/lockdown/proc/timed_countdown(var/timeleft = 0)
	if(!timeleft)
		for(var/obj/structure/machinery/door/poddoor/M in machines)
			if(M.id == podlock_id && M.density)
				INVOKE_ASYNC(M, /obj/structure/machinery/door.proc/open)
		return

	if(istype(ticker.mode, /datum/game_mode/colonialmarines))
		var/datum/game_mode/colonialmarines/gCM = ticker.mode
		if(gCM.round_status_flags & ROUNDSTATUS_PODDOORS_OPEN)
			visible_message(SPAN_NOTICE("[src] states: LOCKDOWN ALREADY LIFTED"))
			return
		gCM.round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN // So we don't spam the message twice
	
	var/text_timeleft = "[timeleft * 0.01] minutes"
	var/next_interval = MINUTES_1
	if(timeleft <= MINUTES_1)
		next_interval = SECONDS_55
		text_timeleft = "[timeleft] minute"
	if(timeleft <= SECONDS_5)
		next_interval = timeleft
		text_timeleft = "[timeleft] seconds"
	var/input = "Station shutter locks lifting in [text_timeleft] per manual override."
	var/title = announce_title
	marine_announcement(input, title, 'sound/AI/commandreport.ogg')
	for(var/mob/M in GLOB.player_list)
		if(isXeno(M))
			sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
			to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
			to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in [text_timeleft]."))
	var/new_timeleft = timeleft - next_interval
	addtimer(CALLBACK(src, /obj/structure/machinery/keycard_auth/lockdown/proc/timed_countdown, new_timeleft), next_interval)

/obj/structure/machinery/keycard_auth/lockdown/trigger_event()
	set waitfor = 0
	switch(event)
		if("Lift Lockdown")
			if(istype(ticker.mode, /datum/game_mode/colonialmarines))
				var/datum/game_mode/colonialmarines/gCM = ticker.mode
				if(gCM.round_status_flags & ROUNDSTATUS_PODDOORS_OPEN)
					visible_message(SPAN_NOTICE("[src] states: LOCKDOWN ALREADY LIFTED"))
					return
				gCM.round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN // So we don't spam the message twice
			timed_countdown(MINUTES_3)
