#define STATE_DEFAULT 1
#define STATE_MESSAGELIST 5
#define STATE_VIEWMESSAGE 6
#define STATE_DELMESSAGE 7
#define STATE_STATUSDISPLAY 8
#define STATE_ALERT_LEVEL 9
#define STATE_CONFIRM_LEVEL 10

#define COOLDOWN_COMM_MESSAGE 30 SECONDS
#define COOLDOWN_COMM_REQUEST 5 MINUTES
#define COOLDOWN_COMM_CENTRAL 30 SECONDS

/obj/item/device/cotablet
	icon = 'icons/obj/items/devices.dmi'
	name = "command tablet"
	desc = "A special device used by the Captain of the ship."
	suffix = "\[3\]"
	icon_state = "Cotablet"
	item_state = "Cotablet"
	req_access = list(ACCESS_MARINE_COMMANDER)
	var/on = 1 // 0 for off
	var/mob/living/carbon/human/current_mapviewer
	var/state = STATE_DEFAULT
	var/cooldown_message = 0

/obj/item/device/cotablet/attack_self(mob/user as mob)
	if(src.allowed(user))
		user.set_interaction(src)
		interact(user)
	else to_chat(user, SPAN_DANGER("Access denied."))

/obj/item/device/cotablet/interact(mob/user as mob)
	if(!on)
		return

	user.set_interaction(src)
	var/dat = "<body>"
	if(EvacuationAuthority.evac_status == EVACUATION_STATUS_INITIATING)
		dat += "<B>Evacuation in Progress</B>\n<BR>\nETA: [EvacuationAuthority.get_status_panel_eta()]<BR>"

	switch(state)
		if(STATE_DEFAULT)
			dat += "<BR><A HREF='?src=\ref[src];operation=announce'>Make an announcement</A>"
			dat += "<BR><A HREF='?src=\ref[src];operation=award'>Award a medal</A>"
			dat += "<BR><hr>"
			switch(EvacuationAuthority.evac_status)
				if(EVACUATION_STATUS_STANDING_BY)
					dat += "<BR><hr>"
					dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_start'>Initiate emergency evacuation</A>"

		if(STATE_EVACUATION)
			dat += "Are you sure you want to evacuate the [MAIN_SHIP_NAME]? <A HREF='?src=\ref[src];operation=evacuation_start'>Confirm</A>"

	dat += "<BR>[(state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A>|" : ""]<A HREF='?src=\ref[user];mach_close=communications'>Close</A> "
	show_browser(user, dat, "Commanding Officer's Tablet", "communications", "size=400x500")
	onclose(user, "communications")
	updateDialog()
	return

/obj/item/device/cotablet/Topic(href, href_list)
	if(..())
		return FALSE
	usr.set_interaction(src)

	switch(href_list["operation"])
		if("main")
			state = STATE_DEFAULT
			interact(usr)

		if("announce")
			if(world.time < cooldown_message + COOLDOWN_COMM_MESSAGE)
				to_chat(usr, SPAN_WARNING("Please wait [(COOLDOWN_COMM_MESSAGE + cooldown_message - world.time)*0.1] second\s before making your next announcement."))
				return FALSE

			var/input = stripped_multiline_input(usr, "Please write a message to announce to the station crew.", "Priority Announcement", "")
			if(!input || world.time < cooldown_message + COOLDOWN_COMM_MESSAGE || !(usr in view(1, src)))
				return FALSE

			input += "<br><br><i>- Sent from USCM Command Tablet</i>"

			marine_announcement(input)
			message_staff("[key_name(usr)] has made a command annoucement.")
			log_announcement("[key_name(usr)] has announced the following: [input]")
			cooldown_message = world.time

		if("award")
			if(usr.job != "Commanding Officer")
				to_chat(usr, SPAN_WARNING("Only the Commanding Officer can award medals."))
				return
			if(give_medal_award(usr.loc))
				visible_message(SPAN_NOTICE("[src] prints a medal."))

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

	updateUsrDialog()
