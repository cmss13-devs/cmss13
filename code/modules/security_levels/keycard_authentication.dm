/obj/structure/machinery/keycard_auth
	name = "Keycard Authentication Device"
	desc = "This device is used to trigger station functions, which require multiple swipes of an ID card to authenticate."
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
	// so that folks dont constantly spam their ID, and play an 'id rejected' noise over and over
	COOLDOWN_DECLARE(id_scan_cooldown)

/obj/structure/machinery/keycard_auth/attack_remote(mob/user as mob)
	to_chat(user, "The station AI is not to interact with these devices.")
	return

/obj/structure/machinery/keycard_auth/attackby(obj/item/W as obj, mob/user as mob)
	if(inoperable())
		to_chat(user, "This device is not powered.")
		return
	if(istype(W,/obj/item/card/id))
		var/obj/item/card/id/ID = W
		if((ACCESS_MARINE_COMMAND in ID.access) && (COOLDOWN_FINISHED(src, id_scan_cooldown)))
			if(active == 1)
				//This is not the device that made the initial request. It is the device confirming the request.
				if(event_source)
					event_source.confirmed = 1
					event_source.event_confirmed_by = user
			else if(screen == 2)
				event_triggered_by = usr
				if((event == "toggle_ob_safety") && !(ACCESS_MARINE_SENIOR in ID.access))	// need to be senior CIC staff to toggle ob safety
					balloon_alert_to_viewers("Error! Insufficient clearence!")
					playsound(loc, 'sound/items/defib_failed.ogg')
					COOLDOWN_START(src, id_scan_cooldown, 1 SECONDS)
					return
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
		dat += "<li><A href='byond://?src=\ref[src];triggerevent=Red alert'>Red alert</A></li>"
		if(!CONFIG_GET(flag/ert_admin_call_only))
			dat += "<li><A href='byond://?src=\ref[src];triggerevent=Emergency Response Team'>Emergency Response Team</A></li>"

		dat += "<li><A href='byond://?src=\ref[src];triggerevent=toggle_ob_safety'>Toggle OB Cannon Safety</A></li>"
		dat += "<li><A href='byond://?src=\ref[src];triggerevent=enable_maint_sec'>Enable Maintenance Security</A></li>"
		dat += "<li><A href='byond://?src=\ref[src];triggerevent=disable_maint_sec'>Disable Maintenance Security</A></li>"
		dat += "</ul>"
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='byond://?src=\ref[src];reset=1'>Back</A>"
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
		if(KA == src || KA.channel != channel)
			continue
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
		if("disable_maint_sec")
			make_maint_all_access()
		if("enable_maint_sec")
			revoke_maint_all_access()
		if("toggle_ob_safety")
			toggle_ob_cannon_safety()

/obj/structure/machinery/keycard_auth/proc/is_ert_blocked()
	if(CONFIG_GET(flag/ert_admin_call_only))
		return 1
	return SSticker.mode && SSticker.mode.ert_disabled

GLOBAL_VAR_INIT(maint_all_access, TRUE)

/proc/make_maint_all_access()
	GLOB.maint_all_access = TRUE
	ai_announcement("The maintenance access requirement has been removed on all airlocks.")

/proc/revoke_maint_all_access()
	GLOB.maint_all_access = FALSE
	ai_announcement("The maintenance access requirement has been added on all airlocks.")

GLOBAL_VAR_INIT(ob_cannon_safety, FALSE)

/proc/toggle_ob_cannon_safety()
	GLOB.ob_cannon_safety = !GLOB.ob_cannon_safety
	for(var/obj/structure/machinery/computer/overwatch/overwatch in GLOB.active_overwatch_consoles)
		overwatch.toggle_ob_cannon_safety()


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
		dat += "<li><A href='byond://?src=\ref[src];triggerevent=Lift Biohazard Lockdown'>Lift Lockdown</A></li>"
		dat += "</ul>"
		show_browser(user, dat, name, "keycard_auth", width = 500, height = 300)
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='byond://?src=\ref[src];reset=1'>Back</A>"
		show_browser(user, dat, name, "keycard_auth", width = 500, height = 300)
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
