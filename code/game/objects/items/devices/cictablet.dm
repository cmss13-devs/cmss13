/obj/item/device/cotablet
	icon = 'icons/obj/items/devices.dmi'
	name = "command tablet"
	desc = "A portable command interface used by top brass, capable of issuing commands over long ranges to their linked computer. Built to withstand a nuclear bomb."
	suffix = "\[3\]"
	icon_state = "Cotablet"
	item_state = "Cotablet"
	unacidable = TRUE
	indestructible = TRUE
	req_access = list(ACCESS_MARINE_SENIOR)
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
	if(announcement_faction == FACTION_MARINE)
		tacmap = new /datum/tacmap/drawing(src, minimap_type)
	else
		tacmap = new(src, minimap_type) // Non-drawing version
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(disable_pmc))
	return ..()

/obj/item/device/cotablet/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/obj/item/device/cotablet/proc/disable_pmc()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/device/cotablet/attack_self(mob/living/carbon/human/user as mob)
	..()

	if(src.allowed(user) && user.wear_id?.check_biometrics(user))
		tgui_interact(user)
	else
		to_chat(user, SPAN_DANGER("Access denied."))

/obj/item/device/cotablet/ui_static_data(mob/user)
	var/list/data = list()

	data["faction"] = announcement_faction
	data["cooldown_message"] = cooldown_between_messages
	data["distresstimelock"] = DISTRESS_TIME_LOCK

	return data

/obj/item/device/cotablet/ui_data(mob/user)
	var/list/data = list()

	data["alert_level"] = GLOB.security_level
	data["evac_status"] = SShijack.evac_status
	data["endtime"] = announcement_cooldown
	data["distresstime"] = distress_cooldown
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
	var/mob/user = ui.user
	switch(action)
		if("announce")
			if(user.client.prefs.muted & MUTE_IC)
				to_chat(user, SPAN_DANGER("You cannot send Announcements (muted)."))
				return

			if(!COOLDOWN_FINISHED(src, announcement_cooldown))
				to_chat(user, SPAN_WARNING("Please wait [COOLDOWN_TIMELEFT(src, announcement_cooldown)/10] second\s before making your next announcement."))
				return FALSE

			var/input = stripped_multiline_input(user, "Please write a message to announce to the [MAIN_SHIP_NAME]'s crew and all groundside personnel.", "Priority Announcement", "")
			if(!input || !COOLDOWN_FINISHED(src, announcement_cooldown) || !(user in view(1, src)))
				return FALSE

			var/signed = null
			if(ishuman(user))
				var/mob/living/carbon/human/human_user = user
				var/obj/item/card/id/id = human_user.wear_id
				if(istype(id))
					var/paygrade = get_paygrades(id.paygrade, FALSE, human_user.gender)
					signed = "[paygrade] [id.registered_name]"

			marine_announcement(input, announcement_title, faction_to_display = announcement_faction, add_PMCs = add_pmcs, signature = signed)
			message_admins("[key_name(user)] has made a command announcement.")
			log_announcement("[key_name(user)] has announced the following: [input]")
			COOLDOWN_START(src, announcement_cooldown, cooldown_between_messages)
			. = TRUE

		if("award")
			if(announcement_faction != FACTION_MARINE)
				return
			open_medal_panel(user, src)
			. = TRUE

		if("mapview")
			tacmap.tgui_interact(user)
			. = TRUE

		if("evacuation_start")
			if(announcement_faction != FACTION_MARINE)
				return

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

		if("distress")
			if(!SSticker.mode)
				return FALSE //Not a game mode?

			if(GLOB.security_level == SEC_LEVEL_DELTA)
				to_chat(user, SPAN_WARNING("The ship is already undergoing self destruct procedures!"))
				return FALSE

			for(var/client/C in GLOB.admins)
				if((R_ADMIN|R_MOD) & C.admin_holder.rights)
					playsound_client(C,'sound/effects/sos-morse-code.ogg',10)
			SSticker.mode.request_ert(user)
			to_chat(user, SPAN_NOTICE("A distress beacon request has been sent to USCM Central Command."))
			COOLDOWN_START(src, distress_cooldown, COOLDOWN_COMM_REQUEST)
			return TRUE

/obj/item/device/cotablet/pmc
	desc = "A special device used by corporate PMC directors."

	tablet_name = "Site Director's Tablet"

	announcement_title = PMC_COMMAND_ANNOUNCE
	announcement_faction = FACTION_PMC

	minimap_type = MINIMAP_FLAG_PMC
