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

	var/tablet_name = "Commanding Officer's Tablet"

	var/announcement_title = COMMAND_ANNOUNCE
	var/announcement_faction = FACTION_MARINE
	var/add_pmcs = TRUE

	var/tacmap_type = TACMAP_DEFAULT
	var/tacmap_base_type = TACMAP_BASE_OCCLUDED
	var/tacmap_additional_parameter = null
	var/minimap_name = "Marine Minimap"

/obj/item/device/cotablet/Initialize()
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, .proc/disable_pmc)
	return ..()

/obj/item/device/cotablet/proc/disable_pmc()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/device/cotablet/attack_self(mob/user as mob)
	..()

	if(src.allowed(user))
		user.set_interaction(src)
		interact(user)
	else
		to_chat(user, SPAN_DANGER("Access denied."))

/obj/item/device/cotablet/interact(mob/user as mob)
	if(!on)
		return

	user.set_interaction(src)
	var/dat = "<body>"
	if(announcement_faction != FACTION_MARINE && EvacuationAuthority.evac_status == EVACUATION_STATUS_INITIATING)
		dat += "<B>Evacuation in Progress</B>\n<BR>\nETA: [EvacuationAuthority.get_status_panel_eta()]<BR>"

	if(announcement_faction == FACTION_MARINE)
		switch(state)
			if(STATE_DEFAULT)
				dat += "<BR><A HREF='?src=\ref[src];operation=announce'>Make an announcement</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=award'>Award a medal</A>"
				dat += "<BR><A HREF='?src=\ref[src];operation=mapview'>Tactical Map</A>"
				dat += "<BR><hr>"
				switch(EvacuationAuthority.evac_status)
					if(EVACUATION_STATUS_STANDING_BY)
						dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_start'>Initiate Emergency Evacuation</A>"

			if(STATE_EVACUATION)
				dat += "Are you sure you want to evacuate the [MAIN_SHIP_NAME]? This cannot be undone from the tablet. <A HREF='?src=\ref[src];operation=evacuation_start'>Confirm</A>"
	else
		dat += "<BR><A HREF='?src=\ref[src];operation=announce'>Make an announcement</A>"
		dat += "<BR><A HREF='?src=\ref[src];operation=mapview'>Tactical Map</A>"

	dat += "<BR>[(state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A>|" : ""]<A HREF='?src=\ref[user];mach_close=communications'>Close</A> "
	show_browser(user, dat, tablet_name, "communications", "size=400x500")
	onclose(user, "communications")
	updateDialog()

/obj/item/device/cotablet/proc/update_mapview(var/close = 0)
	if (close || !current_mapviewer || !Adjacent(current_mapviewer))
		close_browser(current_mapviewer, "marineminimap")
		current_mapviewer = null
		return

	var/icon/O = overlay_tacmap(tacmap_type, tacmap_base_type, tacmap_additional_parameter)
	if(O)
		current_mapviewer << browse_rsc(O, "marine_minimap.png")
		show_browser(current_mapviewer, "<img src=marine_minimap.png>", minimap_name, "marineminimap", "size=[(map_sizes[1]*2)+50]x[(map_sizes[2]*2)+50]", closeref = src)

/obj/item/device/cotablet/Topic(href, href_list)
	if(..())
		return FALSE
	usr.set_interaction(src)

	if (href_list["close"] && current_mapviewer)
		close_browser(current_mapviewer, "marineminimap")
		current_mapviewer = null
		return

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

			var/signed = null
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/id = H.wear_id
				if(istype(id))
					var/paygrade = get_paygrades(id.paygrade, FALSE, H.gender)
					signed = "[paygrade] [id.registered_name]"

			marine_announcement(input, announcement_title, faction_to_display = announcement_faction, add_PMCs = add_pmcs, signature = signed)
			message_staff("[key_name(usr)] has made a command announcement.")
			log_announcement("[key_name(usr)] has announced the following: [input]")
			cooldown_message = world.time

		if("award")
			if(announcement_faction != FACTION_MARINE)
				return
			print_medal(usr, src)

		if("mapview")
			if(current_mapviewer)
				update_mapview(TRUE)
				return
			current_mapviewer = usr
			update_mapview()
			return

		if("evacuation_start")
			if(announcement_faction != FACTION_MARINE)
				return
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

/obj/item/device/cotablet/pmc
	desc = "A special device used by corporate PMC directors."

	tablet_name = "Site Director's Tablet"

	announcement_title = PMC_COMMAND_ANNOUNCE
	announcement_faction = FACTION_PMC

	tacmap_type = TACMAP_FACTION
	tacmap_base_type = TACMAP_BASE_OPEN
	tacmap_additional_parameter = FACTION_PMC
	minimap_name = "PMC Minimap"
