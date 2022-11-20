/obj/structure/machinery/computer/pmc_transfer
	name = "PMC Transfer Processing Terminal"
	desc = "A terminal for recruiting PMCs from the ranks of the USCM."
	icon_state = "wy_transfer"
	circuit = /obj/item/circuitboard/computer/pmc_transfer
	req_access = list(ACCESS_WY_CORPORATE)
	/// Ref to mob who's trying to sign up
	var/mob/living/carbon/human/person_to_modify
	/// If we're at the stage where we've recruited a guy, but they haven't gotten armor yet
	var/verified = FALSE
	/// How many more PFCs/Survivors can be made into PMCs this shift
	var/static/pmc_transfers_left = 4
	/// If the UI is at a loading bar
	var/is_loading = FALSE


/obj/structure/machinery/computer/pmc_transfer/Destroy()
	person_to_modify = null
	return ..()

/obj/structure/machinery/computer/pmc_transfer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PmcTransfer", name)
		ui.open()

/obj/structure/machinery/computer/pmc_transfer/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_DISABLED

/obj/structure/machinery/computer/pmc_transfer/ui_act(action, params)
	. = ..()
	if(.)
		return

	// Please stay close, marine
	if(person_to_modify && !(person_to_modify.Adjacent(src)))
		person_to_modify = null
		is_loading = FALSE

	playsound(src, pick('sound/machines/computer_typing4.ogg', 'sound/machines/computer_typing5.ogg', 'sound/machines/computer_typing6.ogg'), 5, 1)
	switch(action)
		if("startLoading")
			if(verified || is_loading || (pmc_transfers_left <= 0))
				return FALSE

			is_loading = TRUE
			addtimer(CALLBACK(src, .proc/transfer_person, usr), 5 SECONDS)
			tgui_interact(usr)
			return TRUE

		if("selectArmor")
			if(!verified)
				return FALSE

			// All the equipment here is just a reskin of marine equipment, no different stat wise
			var/obj/item/storage/briefcase/pmc_recruit/armor_case = new(get_turf(src))

			switch(params["selected_armor"])
				if("Light Armor")
					new /obj/item/clothing/suit/storage/marine/light/pmc_recruit(armor_case)
				if("Medium Armor")
					new /obj/item/clothing/suit/storage/marine/pmc_recruit(armor_case)
				if("Heavy Armor")
					new /obj/item/clothing/suit/storage/marine/heavy/pmc_recruit(armor_case)

			switch(params["selected_head"])
				if("Helmet")
					new	/obj/item/clothing/head/helmet/marine/pmc_recruit(armor_case)
				if("Beret")
					new /obj/item/clothing/head/helmet/marine/veteran/PMC/recruit/beret(armor_case)
				if("Tactical Cap")
					new /obj/item/clothing/head/helmet/marine/veteran/PMC/recruit(armor_case)

			visible_message("[SPAN_BOLD(src)] states, \"Equipment vended. For any questions, please ask the Weyland-Yutani Corporate Liason.\"")
			verified = FALSE
			person_to_modify = null
			return TRUE

/obj/structure/machinery/computer/pmc_transfer/ui_data(mob/user)
	if(person_to_modify && !person_to_modify.Adjacent(src))
		person_to_modify = null
		is_loading = FALSE

	var/list/data = list()

	data["human"] = person_to_modify ? person_to_modify.name : null
	data["verification"] = verified
	data["possible_verifications"] = pmc_transfers_left
	data["is_loading"] = is_loading

	return data

/obj/structure/machinery/computer/pmc_transfer/attackby(obj/O, mob/user)
	add_fingerprint(user)

	if(!ishuman(user))
		return ..()

	if(istype(O, /obj/item/grab))
		var/obj/item/grab/grab_obj = O
		if(ismob(grab_obj.grabbed_thing))
			if(inoperable())
				to_chat(usr, SPAN_NOTICE("You place [grab_obj.grabbed_thing]'s hand on scanner but \the [src] remains silent."))
				return
			if(iscarbon(grab_obj.grabbed_thing))
				add_modifying_person(grab_obj.grabbed_thing)

/obj/structure/machinery/computer/pmc_transfer/attack_remote(mob/user)
	return attack_hand(user)

/obj/structure/machinery/computer/pmc_transfer/bullet_act()
	return FALSE

/obj/structure/machinery/computer/pmc_transfer/attack_hand(mob/user)
	if(..())
		return
	if(user)
		add_fingerprint(user)
	if(inoperable())
		return
	user.set_interaction(src)
	if(allowed(user))
		tgui_interact(user)
		return
	if(iscarbon(user))
		add_modifying_person(user)

/// Attempt to hand scan a person for PMC transfer, returns TRUE if it succeeds, FALSE if fails.
/obj/structure/machinery/computer/pmc_transfer/proc/add_modifying_person(mob/living/carbon/to_modify)
	to_modify.visible_message(SPAN_NOTICE("You hear a beep as [to_modify]'s hand is scanned to \the [name]."))
	playsound(to_modify, 'sound/machines/screen_output1.ogg', 25, 1)
	if(!ishuman(to_modify))
		return FALSE
	var/mob/living/carbon/human/human_to_modify = to_modify
	if((human_to_modify.job != JOB_SQUAD_MARINE) && (human_to_modify.job != JOB_SURVIVOR))
		visible_message("[SPAN_BOLD(src)] states, \"DESIGNATION ERROR: Target must be a rifleman or non-USCM personnel to continue.\"")
		return FALSE
	var/obj/item/card/id/ID = human_to_modify.wear_id
	if(!istype(ID)) //not wearing an ID
		visible_message("[SPAN_BOLD(src)] states, \"ACCESS ERROR: Target not wearing identification.\"")
		return FALSE
	if(ID.registered_ref != WEAKREF(to_modify))
		visible_message("[SPAN_BOLD(src)] states, \"ACCESS ERROR: Target not wearing correct identification.\"")
		return FALSE
	visible_message("[SPAN_BOLD(src)] states, \"SCAN ENTRY: Scanned, please stay close until operation's end.\"")
	person_to_modify = to_modify
	return TRUE

/// Transfer a person to the PMC corps, changing their ID and removing them from the manifest
/obj/structure/machinery/computer/pmc_transfer/proc/transfer_person(mob/user)
	if(!is_loading)
		visible_message("[SPAN_BOLD(src)] states, \"ERROR: Subject must continue applying hand to sensor.\"")
		return
	verified = TRUE
	is_loading = FALSE
	var/obj/item/card/id/ID = person_to_modify.wear_id
	ID.set_assignment("Weyland-Yutani PMC Recruit")
	ID.faction = FACTION_PMC_RECRUIT
	person_to_modify.job = JOB_PMC_RECRUIT
	person_to_modify.faction = FACTION_PMC_RECRUIT
	GLOB.data_core.manifest_remove(WEAKREF(person_to_modify), person_to_modify.name)
	pmc_transfers_left -= 1
	visible_message("[SPAN_BOLD(src)] states, \"Recruitment finalized, [person_to_modify]'s employment has been transferred to the Weyland-Yutani corporation. IFF addition recommended.\"")
	playsound(user, 'sound/machines/screen_output1.ogg', 25, 1)
	ui_interact(user)
