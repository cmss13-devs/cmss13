#define COMMAND_SHIP_ANNOUNCE "Command Ship Announcement"

/obj/structure/machinery/computer/almayer_control
	name = "almayer control console"
	desc = "This is used for controlling ship and its related functions."
	icon_state = "comm_alt"
	req_access = list(ACCESS_MARINE_SENIOR)
	unslashable = TRUE
	unacidable = TRUE

	/// requesting a distress beacon
	COOLDOWN_DECLARE(cooldown_request)
	/// requesting evac
	COOLDOWN_DECLARE(cooldown_destruct)
	/// messaging HC (admins)
	COOLDOWN_DECLARE(cooldown_central)
	/// making a ship announcement
	COOLDOWN_DECLARE(cooldown_message)

	var/list/messagetitle = list()
	var/list/messagetext = list()

/obj/structure/machinery/computer/almayer_control/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/almayer_control/attack_hand(mob/user as mob)
	if(..() || inoperable())
		return

	if(!allowed(user))
		to_chat(usr, SPAN_WARNING("Access denied."))
		return FALSE

	if(!istype(loc.loc, /area/almayer/command/cic)) //Has to be in the CIC. Can also be a generic CIC area to communicate, if wanted.
		to_chat(usr, SPAN_WARNING("Unable to establish a connection."))
		return FALSE

	tgui_interact(user)

// tgui boilerplate \\

/obj/structure/machinery/computer/almayer_control/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AlmayerControl", "[name]")
		ui.open()

/obj/structure/machinery/computer/almayer_control/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_CLOSE
	if(!operable())
		return UI_CLOSE

/obj/structure/machinery/computer/almayer_control/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

// tgui data \\

/obj/structure/machinery/computer/almayer_control/ui_static_data(mob/user)
	var/list/data = list()

	data["cooldown_request"] = COOLDOWN_COMM_REQUEST
	data["cooldown_destruct"] = COOLDOWN_COMM_DESTRUCT
	data["cooldown_central"] = COOLDOWN_COMM_CENTRAL
	data["cooldown_message"] = COOLDOWN_COMM_MESSAGE
	data["distresstimelock"] = DISTRESS_TIME_LOCK

	return data

/obj/structure/machinery/computer/almayer_control/ui_data(mob/user)
	var/list/data = list()
	var/list/messages = list()

	data["alert_level"] = GLOB.security_level

	data["time_request"] = cooldown_request
	data["time_destruct"] = cooldown_destruct
	data["time_central"] = cooldown_central
	data["time_message"] = cooldown_message

	data["worldtime"] = world.time

	data["evac_status"] = SShijack.evac_status
	if(SShijack.evac_status == EVACUATION_STATUS_INITIATED)
		data["evac_eta"] = SShijack.get_evac_eta()

	if(!length(messagetitle))
		data["messages"] = null
	else
		for(var/i in 1 to length(messagetitle))
			var/list/messagedata = list(list(
				"title" = messagetitle[i],
				"text" = messagetext[i],
				"number" = i
			))
			messages += messagedata

		data["messages"] = messages

	return data

// end tgui data \\

// tgui interact \\

/obj/structure/machinery/computer/almayer_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	switch(action)
		if("award")
			open_medal_panel(user, src)
			. = TRUE

		// evac stuff start \\

		if("evacuation_start")
			if(GLOB.security_level < SEC_LEVEL_RED)
				to_chat(user, SPAN_WARNING("The ship must be under red alert in order to enact evacuation procedures."))
				return FALSE

			if(SShijack.evac_admin_denied)
				to_chat(user, SPAN_WARNING("The USCM has placed a lock on deploying the evacuation pods."))
				return FALSE

			if(!SShijack.initiate_evacuation())
				to_chat(user, SPAN_WARNING("You are unable to initiate an evacuation procedure right now!"))
				return FALSE

			log_game("[key_name(user)] has called for an emergency evacuation.")
			message_admins("[key_name_admin(user)] has called for an emergency evacuation.")
			log_ares_security("Initiate Evacuation", "Called for an emergency evacuation.", user)
			. = TRUE

		if("evacuation_cancel")
			var/mob/living/carbon/human/human_user = user
			var/obj/item/card/id/idcard = human_user.get_active_hand()
			var/bio_fail = FALSE
			if(!istype(idcard))
				idcard = human_user.get_idcard()
			if(!istype(idcard))
				bio_fail = TRUE
			else if(!idcard.check_biometrics(human_user))
				bio_fail = TRUE
			if(bio_fail)
				to_chat(human_user, SPAN_WARNING("Biometrics failure! You require an authenticated ID card to perform this action!"))
				return FALSE

			if(!SShijack.cancel_evacuation())
				to_chat(user, SPAN_WARNING("You are unable to cancel the evacuation right now!"))
				return FALSE

			log_game("[key_name(user)] has canceled the emergency evacuation.")
			message_admins("[key_name_admin(user)] has canceled the emergency evacuation.")
			log_ares_security("Cancel Evacuation", "Cancelled the emergency evacuation.", user)
			. = TRUE

		// evac stuff end \\

		if("change_sec_level")
			var/list/alert_list = list(num2seclevel(SEC_LEVEL_GREEN), num2seclevel(SEC_LEVEL_BLUE))
			switch(GLOB.security_level)
				if(SEC_LEVEL_GREEN)
					alert_list -= num2seclevel(SEC_LEVEL_GREEN)
				if(SEC_LEVEL_BLUE)
					alert_list -= num2seclevel(SEC_LEVEL_BLUE)
				if(SEC_LEVEL_DELTA)
					return

			var/level_selected = tgui_input_list(user, "What alert would you like to set it as?", "Alert Level", alert_list)
			if(!level_selected)
				return

			set_security_level(seclevel2num(level_selected), log = ARES_LOG_NONE)
			log_game("[key_name(user)] has changed the security level to [get_security_level()].")
			message_admins("[key_name_admin(user)] has changed the security level to [get_security_level()].")
			log_ares_security("Manual Security Update", "Changed the security level to [get_security_level()].", user)
			. = TRUE

		if("messageUSCM")
			if(!COOLDOWN_FINISHED(src, cooldown_central))
				to_chat(user, SPAN_WARNING("Arrays are re-cycling.  Please stand by."))
				return FALSE
			var/input = stripped_input(user, "Please choose a message to transmit to USCM.  Please be aware that this process is very expensive, and abuse will lead to termination.  Transmission does not guarantee a response. There is a small delay before you may send another message. Be clear and concise.", "To abort, send an empty message.", "")
			if(!input || !(user in dview(1, src)) || !COOLDOWN_FINISHED(src, cooldown_central))
				return FALSE

			high_command_announce(input, user)
			to_chat(user, SPAN_NOTICE("Message transmitted."))
			log_announcement("[key_name(user)] has made an USCM announcement: [input]")
			COOLDOWN_START(src, cooldown_central, COOLDOWN_COMM_CENTRAL)
			. = TRUE

		if("ship_announce")
			var/mob/living/carbon/human/human_user = user
			var/obj/item/card/id/idcard = human_user.get_active_hand()
			var/bio_fail = FALSE
			if(!istype(idcard))
				idcard = human_user.get_idcard()
			if(!idcard)
				bio_fail = TRUE
			else if(!idcard.check_biometrics(human_user))
				bio_fail = TRUE
			if(bio_fail)
				to_chat(human_user, SPAN_WARNING("Biometrics failure! You require an authenticated ID card to perform this action!"))
				return FALSE

			if(!COOLDOWN_FINISHED(src, cooldown_message))
				to_chat(user, SPAN_WARNING("Please allow at least [COOLDOWN_TIMELEFT(src, cooldown_message)/10] second\s to pass between announcements."))
				return FALSE
			var/input = stripped_multiline_input(user, "Please write a message to announce to the station crew.", "Priority Announcement", "")
			if(!input || !COOLDOWN_FINISHED(src, cooldown_message) || !(user in dview(1, src)))
				return FALSE

			var/signed = null
			var/paygrade = get_paygrades(idcard.paygrade, FALSE, human_user.gender)
			signed = "[paygrade] [idcard.registered_name]"

			COOLDOWN_START(src, cooldown_message, COOLDOWN_COMM_MESSAGE)
			shipwide_ai_announcement(input, COMMAND_SHIP_ANNOUNCE, signature = signed)
			message_admins("[key_name(user)] has made a shipwide annoucement.")
			log_announcement("[key_name(user)] has announced the following to the ship: [input]")
			. = TRUE

		if("distress")
			if(world.time < DISTRESS_TIME_LOCK)
				to_chat(user, SPAN_WARNING("The distress beacon cannot be launched this early in the operation. Please wait another [time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)] minutes before trying again."))
				return FALSE

			if(!SSticker.mode)
				return FALSE //Not a game mode?

			if(SSticker.mode.force_end_at == 0)
				to_chat(user, SPAN_WARNING("ARES has denied your request for operational security reasons."))
				return FALSE

			if(!COOLDOWN_FINISHED(src, cooldown_request))
				to_chat(user, SPAN_WARNING("The distress beacon has recently broadcast a message. Please wait."))
				return FALSE

			if(GLOB.security_level == SEC_LEVEL_DELTA)
				to_chat(user, SPAN_WARNING("The ship is already undergoing self-destruct procedures!"))
				return FALSE

			for(var/client/admin_client as anything in GLOB.admins)
				if((R_ADMIN|R_MOD) & admin_client.admin_holder.rights)
					admin_client << 'sound/effects/sos-morse-code.ogg'
			SSticker.mode.request_ert(user)
			to_chat(user, SPAN_NOTICE("A distress beacon request has been sent to USCM Central Command."))

			COOLDOWN_START(src, cooldown_request, COOLDOWN_COMM_REQUEST)
			. = TRUE

	// sd \\

		if("destroy")
			if(world.time < DISTRESS_TIME_LOCK)
				to_chat(user, SPAN_WARNING("The self-destruct cannot be activated this early in the operation. Please wait another [time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)] minutes before trying again."))
				return FALSE

			if(!SSticker.mode)
				return FALSE //Not a game mode?

			if(SSticker.mode.force_end_at == 0)
				to_chat(user, SPAN_WARNING("ARES has denied your request for operational security reasons."))
				return FALSE

			if(!COOLDOWN_FINISHED(src, cooldown_destruct))
				to_chat(user, SPAN_WARNING("A self-destruct request has already been sent to high command. Please wait."))
				return FALSE

			if(get_security_level() == "delta")
				to_chat(user, SPAN_WARNING("The [MAIN_SHIP_NAME]'s self-destruct is already activated."))
				return FALSE

			for(var/client/admin_client as anything in GLOB.admins)
				if((R_ADMIN|R_MOD) & admin_client.admin_holder.rights)
					admin_client << 'sound/effects/sos-morse-code.ogg'
			message_admins("[key_name(user)] has requested Self-Destruct! [CC_MARK(user)] (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];destroyship=\ref[user]'>GRANT</A>) (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sddeny=\ref[user]'>DENY</A>) [ADMIN_JMP_USER(user)] [CC_REPLY(user)]")
			to_chat(user, SPAN_NOTICE("A self-destruct request has been sent to USCM Central Command."))
			COOLDOWN_START(src, cooldown_destruct, COOLDOWN_COMM_DESTRUCT)
			. = TRUE

		if("delmessage")
			var/number_of_message = params["number"]
			if(!number_of_message)
				return FALSE
			var/title = messagetitle[number_of_message]
			var/text  = messagetext[number_of_message]
			messagetitle.Remove(title)
			messagetext.Remove(text)
			. = TRUE


// end tgui interact \\

// end tgui \\
