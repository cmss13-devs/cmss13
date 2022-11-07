/obj/structure/machinery/computer/pmc_transfer
	name = "PMC Transfer Processing Terminal"
	desc = "A terminal for"
	icon_state = "id"
	circuit = /obj/item/circuitboard/computer/card
	/// Ref to mob who's trying to sign up
	var/mob/living/carbon/human/person_to_modify
	/// If we're at the amror
	var/verified = FALSE
	/// How many more PFCs can be made into PMCs this shift
	var/static/pmc_transfers_left = 4
	/// What access is required on the user's ID
	var/access_required = ACCESS_WY_CORPORATE
	/// Ref to the inserted ID
	var/obj/item/card/id/inserted_id


/obj/structure/machinery/computer/pmc_transfer/Destroy()
	person_to_modify = null
	if(inserted_id)
		QDEL_NULL(inserted_id)
	return ..()

/obj/structure/machinery/computer/pmc_transfer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PmcTransfer", name)
		ui.open()

/obj/structure/machinery/computer/pmc_transfer/ui_act(action, params)
	. = ..()
	if(.)
		return

	// Please stay close, marine
	if(person_to_modify && !(person_to_modify.Adjacent(src)))
		person_to_modify = null

	playsound(src, pick('sound/machines/computer_typing4.ogg', 'sound/machines/computer_typing5.ogg', 'sound/machines/computer_typing6.ogg'), 5, 1)
	switch(action)
		if("ejectID")
			if(!inserted_id)
				return FALSE
			remove_id(usr)
			return TRUE

		if("clickVerification")
			if(pmc_transfers_left <= 0)
				return FALSE

			verified = !verified
			var/obj/item/card/id/ID = person_to_modify.wear_id
			ID.set_assignment("Weyland-Yutani PMC")
			GLOB.data_core.manifest_remove(WEAKREF(person_to_modify), person_to_modify.name)
			pmc_transfers_left -= 1
			return TRUE

		if("selectArmor")
			if(!verified)
				return FALSE

			switch(params["selected_armor"])
				if("light")
					new /obj/item/clothing/suit/storage/marine/light(get_turf(src))
				if("medium")
					new /obj/item/clothing/suit/storage/marine/light(get_turf(src))
				if("heavy")
					new /obj/item/clothing/suit/storage/marine/light(get_turf(src))

			new /obj/item/device/encryptionkey/WY(get_turf(src))
			verified = FALSE
			return TRUE

/obj/structure/machinery/computer/pmc_transfer/ui_data(mob/user)
	if(person_to_modify && !(person_to_modify.Adjacent(src)))
		person_to_modify = null

	var/list/data = list()

	data["human"] = person_to_modify ? person_to_modify.name : null
	data["verification"] = verified
	data["possible_verifications"] = pmc_transfers_left
	data["inserted_id"] = !!inserted_id
	data["id_has_access"] = (access_required in inserted_id?.access)
	data["id_name"] = inserted_id ? inserted_id.registered_name : ""

	return data

/obj/structure/machinery/computer/pmc_transfer/attackby(obj/O, mob/user)
	add_fingerprint(user)

	if(!ishuman(user))
		return ..()

	if(istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		if(ismob(G.grabbed_thing))
			if(inoperable())
				to_chat(usr, SPAN_NOTICE("You place [G.grabbed_thing]'s hand on scanner but \the [src] remains silent."))
				return
			if(iscarbon(G.grabbed_thing))
				add_modifying_person(G.grabbed_thing)

	else if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/idcard = O
		if(!inserted_id)
			user.drop_inv_item_to_loc(idcard, src)
			inserted_id = idcard
			to_chat(user, SPAN_NOTICE("You put [inserted_id] into [src]."))
			playsound(src, 'sound/machines/pda_button1.ogg', 15, TRUE)

/obj/structure/machinery/computer/pmc_transfer/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in view(1)

	if(!usr || usr.stat || usr.lying)
		return

	if(ishuman(usr) && inserted_id)
		remove_id(usr)
		return
	to_chat(usr, "There is nothing to remove from \the [src].")

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

/obj/structure/machinery/computer/pmc_transfer/proc/add_modifying_person(mob/living/carbon/to_modify)
	var/is_xeno = isXeno(to_modify)
	to_modify.visible_message(SPAN_NOTICE("You hear a beep as [to_modify]'s [is_xeno ? "limb" : "hand"] is scanned to \the [name]."))
	visible_message("<span class='bold'>[src]</span> states, \"SCAN ENTRY: [is_xeno ? "Unknown lifeform detected! Forbidden operation!" : "Scanned, please stay close until operation's end."]\"")
	playsound(to_modify, 'sound/machines/screen_output1.ogg', 25, 1)
	if(!ishuman(to_modify))
		return FALSE
	var/mob/living/carbon/human/human_to_modify = to_modify
	if(SSticker?.mode?.flags_round_type & MODE_DS_LANDED)
		visible_message("<span class='bold'>[src]</span> states, \"DESIGNATION ERROR: Due to USCM regulations, the transfer of personnel once an operation has started is not permitted.\"")
		return FALSE
	if(human_to_modify.job != JOB_SQUAD_MARINE)
		visible_message("<span class='bold'>[src]</span> states, \"DESIGNATION ERROR: Target must be a rifleman to continue.\"")
		return FALSE
	var/obj/item/card/id/ID = human_to_modify.wear_id
	if(!istype(ID)) //not wearing an ID
		visible_message("<span class='bold'>[src]</span> states, \"ACCESS ERROR: Target not wearing identification.\"")
		return FALSE
	if(ID.registered_ref != WEAKREF(to_modify))
		visible_message("<span class='bold'>[src]</span> states, \"ACCESS ERROR: Target not wearing correct identification.\"")
		return FALSE
	person_to_modify = to_modify
	return TRUE

/obj/structure/machinery/computer/pmc_transfer/proc/remove_id(mob/remover)
	to_chat(usr, "You remove \the [inserted_id] from \the [src].")
	playsound(src, 'sound/machines/terminal_eject.ogg', 15, TRUE)
	inserted_id.forceMove(get_turf(src))
	if(!usr.get_active_hand() && ishuman(usr))
		usr.put_in_hands(inserted_id)
	inserted_id = null
	verified = FALSE
