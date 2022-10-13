#define STATE_DEFAULT 1
#define STATE_EVACUATION 2
#define STATE_EVACUATION_CANCEL	3
#define STATE_DISTRESS 4
#define STATE_DESTROY 5
#define STATE_DEFCONLIST 6

#define STATE_MESSAGELIST 7
#define STATE_VIEWMESSAGE 8
#define STATE_DELMESSAGE 9



#define COMMAND_SHIP_ANNOUNCE		"Command Ship Announcement"

/obj/structure/machinery/computer/almayer_control
	name = "almayer control console"
	desc = "This is used for controlling ship and its related functions."
	icon_state = "comm_alt"
	req_access = list(ACCESS_MARINE_COMMANDER)
	unslashable = TRUE
	unacidable = TRUE

	var/state = STATE_DEFAULT

	var/is_announcement_active = TRUE

	var/cooldown_request = 0
	var/cooldown_destruct = 0
	var/cooldown_central = 0

	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0

/obj/structure/machinery/computer/almayer_control/attack_remote(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/almayer_control/attack_hand(var/mob/user as mob)
	if(..() || !allowed(user) || inoperable())
		return

	if(!istype(loc.loc, /area/almayer/command/cic)) //Has to be in the CIC. Can also be a generic CIC area to communicate, if wanted.
		to_chat(usr, SPAN_WARNING("Unable to establish a connection."))
		return FALSE

	ui_interact(user)

/obj/structure/machinery/computer/almayer_control/ui_interact(mob/user as mob)
	user.set_interaction(src)

	var/dat = "<head><title>Almayer Control Console</title></head><body>"

	if(EvacuationAuthority.evac_status == EVACUATION_STATUS_INITIATING)
		dat += "<B>Evacuation in Progress</B>\n<BR>\nETA: [EvacuationAuthority.get_status_panel_eta()]<BR>"

	switch(state)
		if(STATE_DEFAULT)
			dat += "Alert Level: <A href='?src=\ref[src];operation=changeseclevel'>[get_security_level()]</A><BR>"
			dat += "<BR><A HREF='?src=\ref[src];operation=ship_announce'>[is_announcement_active ? "Make a ship announcement" : "*Unavailable*"]</A>"
			dat += GLOB.admins.len > 0 ? "<BR><A HREF='?src=\ref[src];operation=messageUSCM'>Send a message to USCM</A>" : "<BR>USCM communication offline"
			dat += "<BR><A HREF='?src=\ref[src];operation=award'>Award a medal</A>"
			dat += "<BR><hr>"
			dat += "<BR><hr>"


			dat += "<BR><A HREF='?src=\ref[src];operation=messagelist'>Message list</A>"
			dat += "<BR><A HREF='?src=\ref[src];operation=distress'>Send Distress Beacon</A>"
			dat += "<BR><A HREF='?src=\ref[src];operation=destroy'>Activate Self-Destruct</A>"
			switch(EvacuationAuthority.evac_status)
				if(EVACUATION_STATUS_STANDING_BY)
					dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_start'>Initiate emergency evacuation</A>"
				if(EVACUATION_STATUS_INITIATING)
					dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_cancel'>Cancel emergency evacuation</A>"

		if(STATE_EVACUATION)
			dat += "Are you sure you want to evacuate the [MAIN_SHIP_NAME]? <A HREF='?src=\ref[src];operation=evacuation_start'>Confirm</A>"

		if(STATE_EVACUATION_CANCEL)
			dat += "Are you sure you want to cancel the evacuation of the [MAIN_SHIP_NAME]? <A HREF='?src=\ref[src];operation=evacuation_cancel'>Confirm</A>"

		if(STATE_DISTRESS)
			dat += "Are you sure you want to trigger a distress signal? The signal can be picked up by anyone listening, friendly or not. <A HREF='?src=\ref[src];operation=distress'>Confirm</A>"

		if(STATE_DESTROY)
			dat += "Are you sure you want to trigger the self-destruct? This would mean abandoning ship. <A HREF='?src=\ref[src];operation=destroy'>Confirm</A>"

		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=viewmessage;message-num=[i]'>[messagetitle[i]]</A>"

		if(STATE_VIEWMESSAGE)
			if (currmsg)
				dat += "<B>[messagetitle[currmsg]]</B><BR><BR>[messagetext[currmsg]]"
				dat += "<BR><BR><A HREF='?src=\ref[src];operation=delmessage'>Delete"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_DELMESSAGE)
			if (currmsg)
				dat += "Are you sure you want to delete this message? <A HREF='?src=\ref[src];operation=delmessage2'>OK</A>|<A HREF='?src=\ref[src];operation=viewmessage'>Cancel</A>"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

	dat += "<BR>[(state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A>|" : ""]<A HREF='?src=\ref[user];mach_close=almayer_control'>Close</A>"

	show_browser(user, dat, name, "almayer_control")
	onclose(user, "almayer_control")

/obj/structure/machinery/computer/almayer_control/Topic(href, href_list)
	if(..())
		return FALSE

	usr.set_interaction(src)

	switch(href_list["operation"])
		if("main")
			state = STATE_DEFAULT

		if("ship_announce")
			if(!is_announcement_active)
				to_chat(usr, SPAN_WARNING("Please allow at least [COOLDOWN_COMM_MESSAGE*0.1] second\s to pass between announcements."))
				return FALSE
			var/input = stripped_multiline_input(usr, "Please write a message to announce to the station crew.", "Priority Announcement", "")
			if(!input || !is_announcement_active || !(usr in view(1,src)))
				return FALSE

			is_announcement_active = FALSE

			var/signed = null
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/id = H.wear_id
				if(istype(id))
					var/paygrade = get_paygrades(id.paygrade, FALSE, H.gender)
					signed = "[paygrade] [id.registered_name]"

			shipwide_ai_announcement(input, COMMAND_SHIP_ANNOUNCE, signature = signed)
			addtimer(CALLBACK(src, .proc/reactivate_announcement, usr), COOLDOWN_COMM_MESSAGE)
			message_staff("[key_name(usr)] has made a shipwide annoucement.")
			log_announcement("[key_name(usr)] has announced the following to the ship: [input]")


		if("evacuation_start")
			if(state == STATE_EVACUATION)
				if(security_level < SEC_LEVEL_RED)
					to_chat(usr, SPAN_WARNING("The ship must be under red alert in order to enact evacuation procedures."))
					return FALSE

				if(EvacuationAuthority.flags_scuttle & FLAGS_EVACUATION_DENY)
					to_chat(usr, SPAN_WARNING("The USCM has placed a lock on deploying the evacuation pods."))
					return FALSE

				if(!EvacuationAuthority.initiate_evacuation())
					to_chat(usr, SPAN_WARNING("You are unable to initiate an evacuation procedure right now!"))
					return FALSE

				log_game("[key_name(usr)] has called for an emergency evacuation.")
				message_staff("[key_name_admin(usr)] has called for an emergency evacuation.")
				return TRUE

			state = STATE_EVACUATION

		if("evacuation_cancel")
			if(state == STATE_EVACUATION_CANCEL)
				if(!EvacuationAuthority.cancel_evacuation())
					to_chat(usr, SPAN_WARNING("You are unable to cancel the evacuation right now!"))
					return FALSE

				spawn(35)//some time between AI announcements for evac cancel and SD cancel.
					if(EvacuationAuthority.evac_status == EVACUATION_STATUS_STANDING_BY)//nothing changed during the wait
						 //if the self_destruct is active we try to cancel it (which includes lowering alert level to red)
						if(!EvacuationAuthority.cancel_self_destruct(1))
							//if SD wasn't active (likely canceled manually in the SD room), then we lower the alert level manually.
							set_security_level(SEC_LEVEL_RED, TRUE) //both SD and evac are inactive, lowering the security level.

				log_game("[key_name(usr)] has canceled the emergency evacuation.")
				message_staff("[key_name_admin(usr)] has canceled the emergency evacuation.")
				return TRUE

			state = STATE_EVACUATION_CANCEL

		if("distress")
			if(state == STATE_DISTRESS)
				//Comment to test
				if(world.time < DISTRESS_TIME_LOCK)
					to_chat(usr, SPAN_WARNING("The distress beacon cannot be launched this early in the operation. Please wait another [time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)] minutes before trying again."))
					return FALSE

				if(!SSticker.mode)
					return FALSE //Not a game mode?

				if(SSticker.mode.force_end_at == 0)
					to_chat(usr, SPAN_WARNING("ARES has denied your request for operational security reasons."))
					return FALSE

				 //Comment block to test
				if(world.time < cooldown_request + COOLDOWN_COMM_REQUEST)
					to_chat(usr, SPAN_WARNING("The distress beacon has recently broadcast a message. Please wait."))
					return FALSE

				if(security_level == SEC_LEVEL_DELTA)
					to_chat(usr, SPAN_WARNING("The ship is already undergoing self-destruct procedures!"))
					return FALSE

				for(var/client/C in GLOB.admins)
					if((R_ADMIN|R_MOD) & C.admin_holder.rights)
						C << 'sound/effects/sos-morse-code.ogg'
				message_staff("[key_name(usr)] has requested a Distress Beacon! (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccmark=\ref[usr]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress=\ref[usr]'>SEND</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccdeny=\ref[usr]'>DENY</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[usr]'>JMP</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CentcommReply=\ref[usr]'>RPLY</A>)")
				to_chat(usr, SPAN_NOTICE("A distress beacon request has been sent to USCM Central Command."))

				cooldown_request = world.time
				return TRUE

			state = STATE_DISTRESS

		if("destroy")
			if(state == STATE_DESTROY)
				//Comment to test
				if(world.time < DISTRESS_TIME_LOCK)
					to_chat(usr, SPAN_WARNING("The self-destruct cannot be activated this early in the operation. Please wait another [time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)] minutes before trying again."))
					return FALSE

				if(!SSticker.mode)
					return FALSE //Not a game mode?

				if(SSticker.mode.force_end_at == 0)
					to_chat(usr, SPAN_WARNING("ARES has denied your request for operational security reasons."))
					return FALSE

				if(world.time < cooldown_destruct + COOLDOWN_COMM_DESTRUCT)
					to_chat(usr, SPAN_WARNING("A self-destruct request has already been sent to high command. Please wait."))
					return FALSE

				if(get_security_level() == "delta")
					to_chat(usr, SPAN_WARNING("The [MAIN_SHIP_NAME]'s self-destruct is already activated."))
					return FALSE

				for(var/client/C in GLOB.admins)
					if((R_ADMIN|R_MOD) & C.admin_holder.rights)
						C << 'sound/effects/sos-morse-code.ogg'
				message_staff("[key_name(usr)] has requested Self-Destruct! (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccmark=\ref[usr]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];destroyship=\ref[usr]'>GRANT</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sddeny=\ref[usr]'>DENY</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[usr]'>JMP</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CentcommReply=\ref[usr]'>RPLY</A>)")
				to_chat(usr, SPAN_NOTICE("A self-destruct request has been sent to USCM Central Command."))
				cooldown_destruct = world.time
				return TRUE

			state = STATE_DESTROY

		if("messagelist")
			currmsg = 0
			state = STATE_MESSAGELIST

		if("viewmessage")
			state = STATE_VIEWMESSAGE
			if (!currmsg)
				if(href_list["message-num"]) 	currmsg = text2num(href_list["message-num"])
				else 							state = STATE_MESSAGELIST

		if("delmessage")
			state = (currmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST

		if("delmessage2")
			if(currmsg)
				var/title = messagetitle[currmsg]
				var/text  = messagetext[currmsg]
				messagetitle.Remove(title)
				messagetext.Remove(text)
				if(currmsg == aicurrmsg) aicurrmsg = 0
				currmsg = 0
			state = STATE_MESSAGELIST

		if("messageUSCM")
			if(world.time < cooldown_central + COOLDOWN_COMM_CENTRAL)
				to_chat(usr, SPAN_WARNING("Arrays recycling.  Please stand by."))
				return FALSE
			var/input = stripped_input(usr, "Please choose a message to transmit to USCM.  Please be aware that this process is very expensive, and abuse will lead to termination.  Transmission does not guarantee a response. There is a small delay before you may send another message. Be clear and concise.", "To abort, send an empty message.", "")
			if(!input || !(usr in view(1,src)) || world.time < cooldown_central + COOLDOWN_COMM_CENTRAL) return FALSE

			high_command_announce(input, usr)
			to_chat(usr, SPAN_NOTICE("Message transmitted."))
			log_announcement("[key_name(usr)] has made an USCM announcement: [input]")
			cooldown_central = world.time

		if("changeseclevel")
			var/list/alert_list = list(num2seclevel(SEC_LEVEL_GREEN), num2seclevel(SEC_LEVEL_BLUE))
			switch(security_level)
				if(SEC_LEVEL_GREEN)
					alert_list -= num2seclevel(SEC_LEVEL_GREEN)
				if(SEC_LEVEL_BLUE)
					alert_list -= num2seclevel(SEC_LEVEL_BLUE)
				if(SEC_LEVEL_DELTA)
					return

			var/level_selected = tgui_input_list(usr, "What alert would you like to set it as?", "Alert Level", alert_list)
			if(!level_selected)
				return

			set_security_level(seclevel2num(level_selected))

			log_game("[key_name(usr)] has changed the security level to [get_security_level()].")
			message_staff("[key_name_admin(usr)] has changed the security level to [get_security_level()].")

		if("award")
			print_medal(usr, src)

	updateUsrDialog()

/obj/structure/machinery/computer/almayer_control/proc/reactivate_announcement(var/mob/user)
	is_announcement_active = TRUE
	updateUsrDialog()


#undef STATE_DEFAULT
#undef STATE_EVACUATION
#undef STATE_EVACUATION_CANCEL
#undef STATE_DISTRESS
#undef STATE_DESTROY
#undef STATE_DEFCONLIST

#undef STATE_MESSAGELIST
#undef STATE_VIEWMESSAGE
#undef STATE_DELMESSAGE
