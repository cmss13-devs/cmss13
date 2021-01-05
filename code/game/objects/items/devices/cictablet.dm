#define STATE_DEFAULT 1
#define STATE_MESSAGELIST 5
#define STATE_VIEWMESSAGE 6
#define STATE_DELMESSAGE 7
#define STATE_STATUSDISPLAY 8
#define STATE_ALERT_LEVEL 9
#define STATE_CONFIRM_LEVEL 10

#define COOLDOWN_COMM_MESSAGE SECONDS_30
#define COOLDOWN_COMM_REQUEST MINUTES_5
#define COOLDOWN_COMM_CENTRAL SECONDS_30

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
			dat += "<BR>DEFCON [defcon_controller.current_defcon_level]: [defcon_controller.check_defcon_percentage()]%"
			dat += "<BR>Threat assessment level: [defcon_controller.last_objectives_completion_percentage*100]%"
			dat += "<BR>Remaining DEFCON asset budget: $[defcon_controller.remaining_reward_points * DEFCON_TO_MONEY_MULTIPLIER]."
			dat += "<BR><A href='?src=\ref[src];operation=defcon'>Enable DEFCON assets</A>"
			dat += "<BR><A href='?src=\ref[src];operation=defconlist'>List DEFCON assets</A>"
			switch(EvacuationAuthority.evac_status)
				if(EVACUATION_STATUS_STANDING_BY)
					dat += "<BR><hr>"
					dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_start'>Initiate emergency evacuation</A>"

		if(STATE_DEFCONLIST)
			for(var/str in typesof(/datum/defcon_reward))
				var/datum/defcon_reward/DR = new str
				if(!DR.cost)
					continue
				dat += "DEFCON [DR.minimum_defcon_level] - [DR.name]<BR>"

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
		if("defcon")
			defcon_controller.list_and_purchase_rewards()
			return

		if("defconlist")
			state = STATE_DEFCONLIST
			interact(usr)

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
			addtimer(CALLBACK(GLOBAL_PROC, .proc/message_staff, "[key_name(usr)] has announced the following: [input]"), 20)
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
