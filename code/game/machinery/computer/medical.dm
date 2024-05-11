// eventually someone will have to make these into global defines and change all the occurrences.

#define AUTOPSY_NOTES "a_stat" // autopsy notes
#define NOTES "notes" // general medical notes
#define MENTAL "m_stat" // psychiatric illnesses
#define DISEASE "cdi"
#define DISABILITY "mi_dis"
#define HEALTH "p_stat" // current health status
#define DEATH "d_stat" // cause of death
#define BLOOD_TYPE "b_type"
#define AUTOPSY_SUBMISSION "aut_sub" // whether or not an autopsy report has been submitted already for a given record

// the type of record
#define MEDICAL 1
#define GENERAL 0

// I hate the printing sound effect.
#define PRINT_COOLDOWN_TIME 2 MINUTES

/obj/structure/machinery/computer/double_id/med_data//TODO:RIP OUT LEGACY CODE.
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

	for(var/datum/data/record/medical_record as anything in GLOB.data_core.medical)
		if(medical_record.fields["name"] == target_id.registered_name)
			target_record_medical = medical_record
			break
	for(var/datum/data/record/general_record as anything in GLOB.data_core.general)
		if(general_record.fields["name"] == target_id.registered_name)
			target_record_general = general_record
			break

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
		ui = new(user, src, "MedMod", name)
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
			playsound(src.loc, 'sound/machines/fax.ogg', 15, 1)
			var/contents = {"<center><h4>Medical Report</h4></center>
								<u>Prepared By:</u> [user_id_card?.registered_name ? user_id_card.registered_name : "Unknown"]<br>
								<u>For:</u> [target_id_card.registered_name ? target_id_card.registered_name : "Unregistered"]<br>
								<hr>
								<center><h4>General Information</h4></center>
								<u>Name:</u> [target_id_card.registered_name ? target_id_card.registered_name : "Unregistered"]<br>
								<u>Sex:</u> [target_record_general?.fields["sex"]]<br>
								<u>Age:</u> [target_record_general?.fields["age"]]<br>
								<u>Blood Type:</u> [target_record_medical?.fields[BLOOD_TYPE]]<br>
								<hr>
								<center><h4>Medical Notes</h4></center>
								<u>General Notes:</u> [target_record_medical?.fields[NOTES]]<br>
								<u>Psychiatric History:</u> [target_record_general?.fields[MENTAL]]<br>
								<u>Disease History:</u> [target_record_medical?.fields[DISEASE]]<br>
								<u>Disability History:</u> [target_record_medical?.fields[DISABILITY]]<br>
								<hr>
								"}

			// autopsy report gets shwacked ontop if it exists and the target stat is dead
			if(target_record_general.fields[HEALTH] == "Deceased" && target_record_medical.fields[AUTOPSY_SUBMISSION])
				contents +=  {"<center><h4>Autopsy Report</h4></center>
								<u>Autopsy Notes:</u> [target_record_medical.fields[AUTOPSY_NOTES]]<br>
								<u>Cause Of Death:</u> [target_record_medical.fields[DEATH]]<br>
							"}

			var/obj/item/paper/med_report = new (loc)
			med_report.name = "Medical Report"
			med_report.info += contents
			med_report.update_icon()

			visible_message(SPAN_NOTICE("\The [src] prints out a paper."))
			return TRUE
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
			if(!target_record_medical.fields[DEATH])
				visible_message("[SPAN_BOLD("[src]")] states, \"LOG ERROR: You must select a cause of death before submitting a report.\"")
				return
			target_record_medical.fields[AUTOPSY_SUBMISSION] = TRUE
			return TRUE

/obj/structure/machinery/computer/double_id/med_data/ui_static_data(mob/user)
	var/list/data = list()
	// general information, it is never modified. Why pass it in so weirdly? because it makes it easy to add and remove stats in the future.
	data["general_record"] = list(
		list(target_record_general?.fields["name"],"Name: "),
		list(target_record_general?.fields["age"],"Age: "),
		list(target_record_general?.fields["sex"],"Sex: "),
		list(target_record_medical?.fields[BLOOD_TYPE],"Blood Type: ")
		)

	return data

/obj/structure/machinery/computer/double_id/med_data/ui_data(mob/user)
	var/list/data = list()

	// medical records, we pass it in as a list so it's better to handle in tgui. Might be ideal to pass in an associated list for clarity?
	data["medical_record"] = list(
		list(MEDICAL, NOTES, target_record_medical?.fields[NOTES],"General Notes: "),
		list(GENERAL, MENTAL, target_record_general?.fields[MENTAL],"Psychiatric History: "),
		list(MEDICAL, DISEASE, target_record_medical?.fields[DISEASE],"Disease History: "),
		list(MEDICAL, DISABILITY, target_record_medical?.fields[DISABILITY],"Disability History: ")
		)
	data["death"] = list(MEDICAL, DEATH, target_record_medical?.fields[DEATH],"Cause Of Death: ")
	data["health"] = list(GENERAL, HEALTH, target_record_general?.fields[HEALTH],"Health Status: ")
	data["autopsy"] = list(MEDICAL, AUTOPSY_NOTES, target_record_medical?.fields[AUTOPSY_NOTES],"Autopsy Notes: ")
	data["existingReport"] = target_record_medical?.fields[AUTOPSY_SUBMISSION]
	data["authenticated"] = authenticated
	data["has_id"] = !!target_id_card
	data["id_name"] = target_id_card ? target_id_card.name : "-----"

	return data

#undef AUTOPSY_NOTES
#undef NOTES
#undef MENTAL
#undef DISEASE
#undef DISABILITY
#undef HEALTH
#undef DEATH
#undef BLOOD_TYPE
#undef AUTOPSY_SUBMISSION
#undef MEDICAL
#undef GENERAL
