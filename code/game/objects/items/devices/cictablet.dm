/obj/item/device/cotablet
	icon = 'icons/obj/items/devices.dmi'
	name = "command tablet"
	desc = "A portable command interface used by top brass, capable of issuing commands over long ranges to their linked computer. Built to withstand a nuclear bomb."
	suffix = "\[3\]"
	icon_state = "Cotablet"
	item_state = "Cotablet"
	unacidable = TRUE
	indestructible = TRUE
	req_access = list(ACCESS_MARINE_COMMANDER)
	var/on = TRUE // 0 for off
	var/cooldown_between_messages = COOLDOWN_COMM_MESSAGE

	var/tablet_name = "Commanding Officer's Tablet"

	var/announcement_title = COMMAND_ANNOUNCE
	var/announcement_faction = FACTION_MARINE
	var/add_pmcs = TRUE

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

	COOLDOWN_DECLARE(announcement_cooldown)
	COOLDOWN_DECLARE(distress_cooldown)

/obj/item/device/cotablet/Initialize()
	tacmap = new(src, minimap_type)
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(disable_pmc))
	return ..()

/obj/item/device/cotablet/proc/disable_pmc()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/device/cotablet/attack_self(mob/user as mob)
	..()

	if(src.allowed(user))
		tgui_interact(user)
	else
		to_chat(user, SPAN_DANGER("Access denied."))

/obj/item/device/cotablet/ui_static_data(mob/user)
	var/list/data = list()

	data["faction"] = announcement_faction
	data["cooldown_message"] = cooldown_between_messages

	return data

/obj/item/device/cotablet/ui_data(mob/user)
	var/list/data = list()

	data["alert_level"] = security_level
	data["evac_status"] = EvacuationAuthority.evac_status
	data["endtime"] = announcement_cooldown
	data["distresstime"] = distress_cooldown
	data["distresstimelock"] = DISTRESS_TIME_LOCK
	data["worldtime"] = world.time

	return data

/obj/item/device/cotablet/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_UPDATE
	if(!on)
		return UI_DISABLED

/obj/item/device/cotablet/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/device/cotablet/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CommandTablet", "Command Tablet")
		ui.open()

/obj/item/device/cotablet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("announce")
			if(!COOLDOWN_FINISHED(src, announcement_cooldown))
				to_chat(usr, SPAN_WARNING("Please wait [COOLDOWN_TIMELEFT(src, announcement_cooldown)/10] second\s before making your next announcement."))
				return FALSE

			var/input = stripped_multiline_input(usr, "Please write a message to announce to the [MAIN_SHIP_NAME]'s crew and all groundside personnel.", "Priority Announcement", "")
			if(!input || !COOLDOWN_FINISHED(src, announcement_cooldown) || !(usr in view(1, src)))
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
			COOLDOWN_START(src, announcement_cooldown, cooldown_between_messages)
			. = TRUE

		if("award")
			if(announcement_faction != FACTION_MARINE)
				return
			print_medal(usr, src)
			. = TRUE

		if("mapview")
			tacmap.tgui_interact(usr)
			. = TRUE

		if("evacuation_start")
			if(announcement_faction != FACTION_MARINE)
				return

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
			. = TRUE

		if("distress")
			if(!SSticker.mode)
				return FALSE //Not a game mode?

			if(security_level == SEC_LEVEL_DELTA)
				to_chat(usr, SPAN_WARNING("The ship is already undergoing self destruct procedures!"))
				return FALSE

			for(var/client/C in GLOB.admins)
				if((R_ADMIN|R_MOD) & C.admin_holder.rights)
					playsound_client(C,'sound/effects/sos-morse-code.ogg',10)
			message_staff("[key_name(usr)] has requested a Distress Beacon! (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccmark=\ref[usr]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress=\ref[usr]'>SEND</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccdeny=\ref[usr]'>DENY</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[usr]'>JMP</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CentcommReply=\ref[usr]'>RPLY</A>)")
			to_chat(usr, SPAN_NOTICE("A distress beacon request has been sent to USCM Central Command."))
			COOLDOWN_START(src, distress_cooldown, COOLDOWN_COMM_REQUEST)
			return TRUE

/obj/item/device/cotablet/pmc
	desc = "A special device used by corporate PMC directors."

	tablet_name = "Site Director's Tablet"

	announcement_title = PMC_COMMAND_ANNOUNCE
	announcement_faction = FACTION_PMC

	minimap_type = MINIMAP_FLAG_PMC
