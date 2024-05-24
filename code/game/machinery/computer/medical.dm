

// the type of record
#define MEDICAL 1
#define GENERAL 0

// I hate the printing sound effect.
#define PRINT_COOLDOWN_TIME 2 MINUTES

/obj/structure/machinery/computer/double_id/med_data
	name = "Medical Records"
	desc = "This can be used to check medical records."
	icon_state = "medcomp"
	density = TRUE
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_WY_MEDICAL)
	circuit = /obj/item/circuitboard/computer/med_data
	// general record for a given target user
	var/datum/data/record/target_record_general = null
	// medical record for a given target user
	var/datum/data/record/target_record_medical = null
	// print cooldown
	COOLDOWN_DECLARE(print_cooldown)

/obj/structure/machinery/computer/double_id/med_data/attackby(obj/card, mob/user)
	// we only check the target, never the user.
	if(user_id_card)
		var/obj/item/card/id/id_card = card
		if(!retrieve_target_records(id_card))
			return
	..()

/obj/structure/machinery/computer/double_id/med_data/proc/retrieve_target_records(obj/item/card/id/target_id)
	if(!target_id)
		visible_message("[SPAN_BOLD("[src]")] states, \"CARD FAILURE: Unable to read target ID.\"")
		return FALSE

	target_record_medical = retrieve_record(mob_name = target_id.registered_name, mob_ref = target_id.registered_ref, record_type = RECORD_TYPE_MEDICAL)
	target_record_general = retrieve_record(mob_name = target_id.registered_name, mob_ref = target_id.registered_ref, record_type = RECORD_TYPE_GENERAL)

	if(!target_record_medical || !target_record_general)
		visible_message("[SPAN_BOLD("[src]")] states, \"CARD FAILURE: Unable to retrieve target records.\"")
		return FALSE

	return TRUE

/obj/structure/machinery/computer/double_id/med_data/laptop
	name = "Medical Laptop"
	desc = "Cheap Weyland-Yutani Laptop."
	icon_state = "medlaptop"
	density = FALSE

// TGUI med
// ----------------------------------------------------------------------------------------------------- //
/obj/structure/machinery/computer/double_id/med_data/tgui_interact(mob/user, datum/tgui/ui)

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "MedRec", name)
		ui.open()

/obj/structure/machinery/computer/double_id/med_data/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	playsound(src, pick('sound/machines/computer_typing4.ogg', 'sound/machines/computer_typing5.ogg', 'sound/machines/computer_typing6.ogg'), 5, 1)
	switch(action)
		if("authenticate")
			var/obj/item/id_card = user.get_active_hand()
			if (istype(id_card, /obj/item/card/id))
				if(user.drop_held_item())
					id_card.forceMove(src)
					user_id_card = id_card
			if(authenticate(user, user_id_card))
				return TRUE
			else
				if(!user_id_card)
					return
				if(ishuman(user))
					user_id_card.forceMove(user.loc)
					if(!user.get_active_hand())
						user.put_in_hands(user_id_card)
				else
					user_id_card.forceMove(loc)
				user_id_card = null
		if("logout")
			visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGOUT: Session end confirmed.\"")
			authenticated = FALSE
			if(ishuman(user))
				user_id_card.forceMove(user.loc)
				if(!user.get_active_hand())
					user.put_in_hands(user_id_card)
			else
				user_id_card.forceMove(loc)
			user_id_card = null
			return TRUE
		if("print")
			if(!authenticated || !target_id_card)
				return

			if(!COOLDOWN_FINISHED(src, print_cooldown))
				visible_message("[SPAN_BOLD("[src]")] states, \"PRINT ERROR: system is still on cooldown.\"")
				return
			COOLDOWN_START(src, print_cooldown, PRINT_COOLDOWN_TIME )
			print_paper()

		if("eject")
			if(target_id_card)
				if(ishuman(user))
					target_id_card.forceMove(user.loc)
					if(!user.get_active_hand())
						user.put_in_hands(target_id_card)
				else
					target_id_card.forceMove(loc)
				visible_message("[SPAN_BOLD("[src]")] states, \"CARD EJECT: Data imprinted. Updating database... Success.\"")
				target_record_general = null
				target_record_medical = null
				target_id_card = null
				return TRUE
			else
				var/obj/item/card/id/id_card = user.get_active_hand()
				if (!istype(id_card, /obj/item/card/id))
					return
				if(!retrieve_target_records(id_card))
					ui.close()
					return
				if(user.drop_held_item())
					id_card.forceMove(src)
					target_id_card = id_card
					visible_message("[SPAN_BOLD("[src]")] states, \"CARD FOUND: Preparing ID modification protocol.\"")
					update_static_data(user)
					return TRUE
			return FALSE
		if("updateStatRecord")
			if(params["stat_type"] == MEDICAL)
				target_record_medical.fields[params["stat"]] = params["new_value"]
			else
				target_record_general.fields[params["stat"]] = params["new_value"]
			return TRUE
		if("submitReport")
			if(!target_record_medical.fields[MOB_CAUSE_OF_DEATH])
				visible_message("[SPAN_BOLD("[src]")] states, \"LOG ERROR: You must select a cause of death before submitting a report.\"")
				return
			target_record_medical.fields[MOB_AUTOPSY_SUBMISSION] = TRUE
			return TRUE

/obj/structure/machinery/computer/double_id/med_data/proc/print_paper()
	playsound(loc, 'sound/machines/fax.ogg', 15, 1)
	var/contents = {"<center><h4>Medical Report</h4></center>
								<u>Prepared By:</u> [user_id_card?.registered_name ? user_id_card.registered_name : "Unknown"]<br>
								<u>For:</u> [target_id_card.registered_name ? target_id_card.registered_name : "Unregistered"]<br>
								<hr>
								<center><h4>General Information</h4></center>
								<u>Name:</u> [target_id_card.registered_name ? target_id_card.registered_name : "Unregistered"]<br>
								<u>Sex:</u> [target_record_general?.fields[MOB_SEX]]<br>
								<u>Age:</u> [target_record_general?.fields[MOB_AGE]]<br>
								<u>Blood Type:</u> [target_record_medical?.fields[MOB_BLOOD_TYPE]]<br>
								<hr>
								<center><h4>Medical Notes</h4></center>
								<u>General Notes:</u> [target_record_medical?.fields[MOB_MEDICAL_NOTES]]<br>
								<u>Psychiatric History:</u> [target_record_general?.fields[MOB_MENTAL_STATUS]]<br>
								<u>Disease History:</u> [target_record_medical?.fields[MOB_DISEASES]]<br>
								<u>Disability History:</u> [target_record_medical?.fields[MOB_DISABILITIES]]<br>
								<hr>
								"}

			// autopsy report gets shwacked ontop if it exists and the target stat is dead
	if(target_record_general.fields[MOB_HEALTH_STATUS] == MOB_STAT_HEALTH_DECEASED && target_record_medical.fields[MOB_AUTOPSY_SUBMISSION])
		contents +=  {"<center><h4>Autopsy Report</h4></center>
								<u>Autopsy Notes:</u> [target_record_medical.fields[MOB_AUTOPSY_NOTES]]<br>
								<u>Cause Of Death:</u> [target_record_medical.fields[MOB_CAUSE_OF_DEATH]]<br>
							"}

	var/obj/item/paper/med_report = new (loc)
	med_report.name = "Medical Report"
	med_report.info += contents
	med_report.update_icon()

	visible_message(SPAN_NOTICE("\The [src] prints out a paper."))
	return TRUE

/obj/structure/machinery/computer/double_id/med_data/ui_static_data(mob/user)
	var/list/data = list()
	data["general_record"] = list(
		list(
			value = target_record_general?.fields[MOB_NAME],
			message = "Name: "
			),
		list(
			value = target_record_general?.fields[MOB_AGE],
			message ="Age: "
			),
		list(
			value = target_record_general?.fields[MOB_SEX],
			message ="Sex: "
			),
		list(
			value = target_record_medical?.fields[MOB_BLOOD_TYPE],
			message = "Blood Type: "
			)
		)

	return data

/obj/structure/machinery/computer/double_id/med_data/ui_data(mob/user)
	var/list/data = list()

	data["medical_record"] = list(
		list(
			stat_type = MEDICAL,
			stat = MOB_MEDICAL_NOTES,
			value = target_record_medical?.fields[MOB_MEDICAL_NOTES],
			message = "General Notes: "
			),
			list(
				stat_type = GENERAL,
				stat = MOB_MENTAL_STATUS,
				value = target_record_general?.fields[MOB_MENTAL_STATUS],
				message = "Psychiatric History: "
				),
			list(
				stat_type = MEDICAL,
				stat = MOB_DISEASES,
				value = target_record_medical?.fields[MOB_DISEASES],
				message = "Disease History: "
				),
			list(
				stat_type = MEDICAL,
				stat = MOB_DISABILITIES,
				value = target_record_medical?.fields[MOB_DISABILITIES],
				message = "Disability History: "
				)
		)
	data["death"] = list(
		stat_type = MEDICAL,
		stat = MOB_CAUSE_OF_DEATH,
		value = target_record_medical?.fields[MOB_CAUSE_OF_DEATH],
		message = "Cause Of Death: ")
	data["health"] = list(
		stat_type = GENERAL,
		stat = MOB_HEALTH_STATUS,
		value = target_record_general?.fields[MOB_HEALTH_STATUS],
		message = "Health Status: ")
	data["autopsy"] = list(
		stat_type = MEDICAL,
		stat = MOB_AUTOPSY_NOTES,
		value = target_record_medical?.fields[MOB_AUTOPSY_NOTES],
		message = "Autopsy Notes: ")
	data["existingReport"] = target_record_medical?.fields[MOB_AUTOPSY_SUBMISSION]
	data["authenticated"] = authenticated
	data["has_id"] = !!target_id_card
	data["id_name"] = target_id_card ? target_id_card.name : "-----"

	return data

#undef MEDICAL
#undef GENERAL
