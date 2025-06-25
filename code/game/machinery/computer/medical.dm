//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/// view-only medical record access, for unclassified files. lowest access level.
#define MEDICAL_RECORD_ACCESS_LEVEL_0 0	// assigned to HMs and Nurses.
/// edit access for all unclassified files. view-only for classified files.
#define MEDICAL_RECORD_ACCESS_LEVEL_1 1	// access level given to Doctors, and any Officers at or above 1stLT.
/// full record database edit and viewing access.
#define MEDICAL_RECORD_ACCESS_LEVEL_2 2	// given to the CMO, Synths, and the CO/XO.

/obj/structure/machinery/computer/med_data//TODO:SANITY
	name = "Medical Records Console"
	desc = "This can be used to check medical records."
	icon_state = "medcomp"
	density = TRUE
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_WY_MEDICAL)
	circuit = /obj/item/circuitboard/computer/med_data
	var/obj/item/card/id/scan = null
	/// the target id of a record intended to link with a biometric scan
	var/bio_link_target_record_id
	/// time left for someone to authenticate a biometric scan, before it aborts
	var/biometric_scan_timer
	/// the current users access level for the medical record database. see define definitions for access permissions
	var/access_level = MEDICAL_RECORD_ACCESS_LEVEL_0
	/// the id number of the lastest viewed record. used to manage ui data
	var/currently_selected_record_id

	COOLDOWN_DECLARE(record_printing_cooldown)

/obj/structure/machinery/computer/med_data/attack_remote(mob/user)
	return attack_hand(user)

/obj/structure/machinery/computer/med_data/attack_hand(mob/user)
	if(..() || inoperable())
		to_chat(user, SPAN_INFO("It does not appear to be working."))
		return

	if(bio_link_target_record_id && ishumansynth_strict(user))
		user.visible_message(SPAN_NOTICE("You hear a beep as [user]'s hand is scanned to \the [name]."))
		visible_message("[SPAN_BOLD("[src]")] states, \"SCAN ENTRY: ["Scanned, please stay close until operation's end."]\"")
		playsound(user.loc, 'sound/machines/screen_output1.ogg', 25, TRUE)
		link_medical_data(user, bio_link_target_record_id)
		bio_link_target_record_id = FALSE
		return

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	if(!is_mainship_level(z))
		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the station!"))
		return

	tgui_interact(user)

/obj/structure/machinery/computer/med_data/proc/get_database_access_level(obj/item/card/id/id)
	if(!id)
		return MEDICAL_RECORD_ACCESS_LEVEL_0
	if(ACCESS_MARINE_DATABASE_ADMIN in id.access)
		return MEDICAL_RECORD_ACCESS_LEVEL_2
	if(ACCESS_MARINE_DATABASE in id.access)
		return MEDICAL_RECORD_ACCESS_LEVEL_1
	return MEDICAL_RECORD_ACCESS_LEVEL_0

/obj/structure/machinery/computer/med_data/proc/link_medical_data(mob/living/carbon/human/target, general_record_id)

	if(biometric_scan_timer)
		deltimer(biometric_scan_timer)
		biometric_scan_timer = null

	var/assignment  = "Unassigned"	// whichever job is listed on the id of the current user
	if(target.job)
		assignment = target.job

	for (var/datum/data/record/general_record in GLOB.data_core.general)
		if(general_record.fields["id"] != general_record_id)
			continue
		if((general_record.fields["name"] != target.real_name) && (general_record.fields["name"] != "New Record"))
			balloon_alert_to_viewers("ERROR! Medical record bioscan does not match general record ID.")
			playsound(src, 'sound/machines/terminal_error.ogg', 15, FALSE)
			return
		general_record.fields["name"] = target.real_name
		general_record.name = target.real_name
		general_record.fields["real_rank"] = target.job
		general_record.fields["rank"] = assignment
		general_record.fields["age"] = target.age
		general_record.fields["p_stat"] = "Active"
		general_record.fields["m_stat"] = "Stable"
		general_record.fields["sex"] = capitalize(target.gender)
		general_record.fields["ref"] = WEAKREF(target)

		var/datum/data/record/medical_record = new /datum/data/record()
		medical_record.fields["id"] = general_record_id
		medical_record.fields["name"] = target.real_name
		medical_record.name = target.real_name
		medical_record.fields["blood_type"] = target.blood_type
		medical_record.fields["minor_disability"] = "None"
		medical_record.fields["minor_disability_details"] = "No minor disabilities have been declared."
		medical_record.fields["major_disability"] = "None"
		medical_record.fields["major_disability_details"] = "No major disabilities have been diagnosed."
		medical_record.fields["allergies"] = "None"
		medical_record.fields["allergies_details"] = "No allergies have been detected in this patient."
		medical_record.fields["diseases"] = "None"
		medical_record.fields["diseases_details"] = "No diseases have been diagnosed at the moment."
		medical_record.fields["last_scan_time"] = null
		medical_record.fields["last_scan_result"] = "No scan data on record"
		medical_record.fields["autodoc_data"] = list()
		medical_record.fields["ref"] = WEAKREF(target)
		GLOB.data_core.medical += medical_record

		currently_selected_record_id = general_record_id
		update_static_data_for_all_viewers()


/obj/structure/machinery/computer/med_data/proc/print_medical_record(record_id, mob/living/carbon/human/user)

	if(!record_id)
		// for whatever reason, the computer is asking for a record with a null ID
		balloon_alert_to_viewers("Critical systems fault! Unable to process request.")
		to_chat(user, SPAN_NOTICE("Critical systems fault! Unable to process request."))
		playsound(loc, 'sound/machines/terminal_shutdown.ogg', 15, FALSE)
		return

	// Locate the general record
	var/datum/data/record/general_record = find_record("general", record_id)

	// Locate the medical record
	var/datum/data/record/medical_record = find_record("medical", record_id)

	if (!general_record)
		balloon_alert_to_viewers("Unable to process request. Record not found!")
		to_chat(user, SPAN_NOTICE("Unable to process request. Record not found!"))
		playsound(loc, 'sound/machines/terminal_shutdown.ogg', 15, FALSE)
		return

	var/obj/item/paper/medical_record/report = new /obj/item/paper/medical_record(loc, general_record, medical_record)
	report.name = text("Medical Record ([])", general_record.fields["name"])

/obj/structure/machinery/computer/med_data/proc/handle_biometric_scan_timeout(mob/living/carbon/human/user)

	if(biometric_scan_timer)
		deltimer(biometric_scan_timer)
		biometric_scan_timer = null

	bio_link_target_record_id = null
	balloon_alert_to_viewers("Aborting biometric scan! No user detected in time.")
	to_chat(user, SPAN_NOTICE("Aborting biometric scan! No user detected in time."))
	playsound(loc, 'sound/machines/terminal_shutdown.ogg', 15, FALSE)

/obj/structure/machinery/computer/med_data/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "MedicalRecords", "Medical Records")
		ui.autoupdate = FALSE
		ui.open()

/obj/structure/machinery/computer/med_data/proc/gather_record_data(mob/user, datum/data/record/general)

	if(!general)
		return

	var/id_number = general.fields["id"]
	var/datum/data/record/medical = find_record("medical", id_number)

	var/datum/weakref/target_ref = general.fields["ref"]
	var/mob/living/carbon/human/target
	var/obj/item/card/id/id
	var/record_classified = FALSE

	if(target_ref)
		target = target_ref.resolve()
		if(!target)	// if the target has been gibbed, or no longer physically exists
			return
		id = target.get_idcard()
		// checks if record target is in the chain of command, and needs their record protected
		if(target.job in CHAIN_OF_COMMAND_ROLES)
			record_classified = TRUE

	var/paygrade = id ? id.paygrade : "None"

	var/list/record = list(
		"id" = id_number,
		"general_name" = general.fields["name"],
		"general_job" = general.fields["rank"],
		"general_rank" = paygrade,
		"general_age" = general.fields["age"],
		"general_sex" = general.fields["sex"],
		"general_m_stat" = medical ? general.fields["m_stat"] : null,
		"general_p_stat" = medical ? general.fields["p_stat"] : null,
		"medical_blood_type" = medical ? medical.fields["blood_type"] : null,
		"medical_major_disability" = medical ? medical.fields["major_disability"] : null,
		"medical_major_disability_details" = medical ? medical.fields["major_disability_details"] : null,
		"medical_minor_disability" = medical ? medical.fields["minor_disability"] : null,
		"medical_minor_disability_details" = medical ? medical.fields["minor_disability_details"] : null,
		"medical_allergies" = medical ? medical.fields["allergies"] : null,
		"medical_allergies_details" = medical ? medical.fields["allergies_details"] : null,
		"medical_diseases" = medical ? medical.fields["diseases"] : null,
		"medical_diseases_details" = medical ? medical.fields["diseases_details"] : null,
		"medical_comments" = medical ? medical.fields["comments"] : null,
		"record_classified" = record_classified
	)

	return record

/obj/structure/machinery/computer/med_data/ui_status(mob/user)
	if(inoperable())
		return UI_CLOSE

	if(!ishumansynth_strict(user) || (user.stat == DEAD))
		return UI_CLOSE

	if((user.stat == UNCONSCIOUS) || !allowed(user))
		return UI_DISABLED

	if(get_dist(src, user) <= 2)
		return UI_INTERACTIVE

	// if none of the above were true, something is very wrong
	return UI_CLOSE

/obj/structure/machinery/computer/med_data/ui_data(mob/user)
	. = ..()

	// Map medical records via id
	var/list/records = list()
	var/list/medical_record = list()
	for (var/datum/data/record/medical in GLOB.data_core.medical)
		medical_record[medical.fields["id"]] = medical

	for (var/datum/data/record/general in GLOB.data_core.general)
		var/id_number = general.fields["id"]
		var/datum/data/record/medical = medical_record[id_number]

		// checks if the record is being viewed, and requires more data
		if((id_number == currently_selected_record_id) && currently_selected_record_id)
			records |= list(gather_record_data(user, general))
			// sends photo data seperately from the records system, for ease of use
			var/icon/photo_icon = new /icon('icons/misc/buildmode.dmi', "buildhelp")
			var/photo_data = icon2html(photo_icon, user.client, sourceonly = TRUE)

			var/photo_front = general.fields["photo_front"] ? icon2html(general.fields["photo_front"], user.client, sourceonly = TRUE) : photo_data
			var/photo_side = general.fields["photo_side"] ? icon2html(general.fields["photo_side"], user.client, sourceonly = TRUE) : photo_data

			.["photo_front"] = photo_front
			.["photo_side"] = photo_side
		else
			var/list/record = list(
				"id" = id_number,
				"general_name" = general.fields["name"],
				"general_job" = general.fields["rank"],
				"general_p_stat" = medical ? general.fields["p_stat"] : null
			)
			records |= list(record)

	.["records"] = records

/obj/structure/machinery/computer/med_data/ui_static_data(mob/user)
	. = ..()

	.["operator"] = operator
	.["database_access_level"] = access_level

	var/icon/photo_icon = new /icon('icons/misc/buildmode.dmi', "buildhelp")
	var/photo_data = icon2html(photo_icon, user.client, sourceonly = TRUE)

	// Attach to the UI data
	.["fallback_image"] = photo_data

/obj/structure/machinery/computer/med_data/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/user = ui.user
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	playsound(src, get_sfx("terminal_button"), 25, FALSE)

	switch(action)
		if("log_in")
			operator = user
			var/obj/item/card/id/id = user.get_idcard()
			access_level = get_database_access_level(id)
			update_static_data(user, ui)
			return
		if("log_out")
			operator = null
			access_level = MEDICAL_RECORD_ACCESS_LEVEL_0
			update_static_data(user, ui)
			return
		//* Actions for managing records
		if("select_record")
			var/id = params["id"]

			if(!id)
				tgui_alert(user, "Invalid record ID.")
				return

			// Find the corresponding general record
			var/datum/data/record/general_record = find_record("general", id)

			if(!general_record)
				tgui_alert(user,"Record not found.")
				return

			currently_selected_record_id = id

			return TRUE

		if("update_field")
			var/id = params["id"]
			var/field = params["field"]
			var/value = params["value"]

			var/validation_error = validate_field(field, value, user, FALSE)
			if (validation_error)
				to_chat(user, SPAN_WARNING("Console returns error with buzzing sound: [validation_error]"))
				playsound(loc, 'sound/machines/buzz-two.ogg', 15, TRUE)
				return

			if(!id || !field)
				tgui_alert(user, "Invalid record ID or field.")
				return

			var/is_general_field = copytext(field, 1, 9) == "general_"
			var/is_medical_field = copytext(field, 1, 9) == "medical_"

			if(!is_general_field && !is_medical_field)
				tgui_alert(user, "Invalid field prefix.")
				return

			// Remove the prefix to map to the original field name
			var/original_field = copytext(field, 9)

			// Locate the general record
			var/datum/data/record/general_record = find_record("general", id)

			// Locate the medical record (if applicable)
			var/datum/data/record/medical_record = find_record("medical", id)

			// Update the appropriate record
			if(is_general_field && general_record && (original_field in general_record.fields))
				general_record.fields[original_field] = value

			else if(is_medical_field && medical_record && (original_field in medical_record.fields))
				medical_record.fields[original_field] = value

			else
				tgui_alert(user, "Record or associated field not found.")
				return

			var/name = general_record.fields["name"]
			// record modifications to be ported to ARES logs in future
			msg_admin_niche("[key_name(user)] changed the record of [name] at [get_location_in_text(user)]. Field [original_field] value changed to [value] [ADMIN_JMP(loc)]")

			return TRUE

		if ("add_comment")
			var/id = params["id"]
			var/comment = params["comment"]

			if (!id || !comment || length(trim(comment)) == 0)
				to_chat(user, SPAN_WARNING("Invalid input. Ensure both ID and comment are provided."))
				return

			// Locate the medical record
			var/datum/data/record/medical_record = find_record("medical", id)

			if (!medical_record)
				to_chat(user, SPAN_WARNING("Record not found."))
				return

			var/comment_id = length(medical_record.fields["comments"] || list()) + 1
			var/created_at = text("[]  []  []", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)

			var/new_comment = list(
				"entry" = strip_html(trim(comment)),
				"created_by" = list("name" = user.get_authentification_name(), "rank" = user.get_assignment()),
				"created_at" = created_at,
				"deleted_by" = null,
				"deleted_at" = null
			)

			if (!islist(medical_record.fields["comments"]))
				medical_record.fields["comments"] = list("[comment_id]" = new_comment)
			else
				medical_record.fields["comments"]["[comment_id]"] = new_comment

			to_chat(user, SPAN_NOTICE("Comment added successfully."))
			msg_admin_niche("[key_name_admin(user)] added medical comment for [medical_record.fields["name"]] at [get_location_in_text(user)] [ADMIN_JMP(loc)]")

			return TRUE

		if ("delete_comment")
			var/id = params["id"]
			var/comment_key = params["key"]

			if (!id || !comment_key)
				to_chat(user, SPAN_WARNING("Invalid input. Ensure both ID and comment key are provided."))
				return

			// Locate the medical record
			var/datum/data/record/medical_record = find_record("medical", id)

			if (!medical_record)
				to_chat(user, SPAN_WARNING("Record not found."))
				return

			if (!medical_record.fields["comments"] || !medical_record.fields["comments"][comment_key])
				to_chat(user, SPAN_WARNING("Comment not found."))
				return

			var/comment = medical_record.fields["comments"][comment_key]
			if (comment["deleted_by"])
				to_chat(user, SPAN_WARNING("This comment is already deleted."))
				return

			comment["deleted_by"] = "[user.get_authentification_name()] ([user.get_assignment()])"
			comment["deleted_at"] = text("[]  []  []", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)

			medical_record.fields["comments"][comment_key] = comment

			to_chat(user, SPAN_NOTICE("Comment deleted successfully."))
			msg_admin_niche("[key_name_admin(user)] deleted comment [comment_key] on [medical_record.fields["name"]]'s medical record at [get_location_in_text(user)] [ADMIN_JMP(loc)]")

			return TRUE

		//* Records maintenance actions
		if ("new_medical_record")
			if(access_level != MEDICAL_RECORD_ACCESS_LEVEL_2)
				to_chat(user, SPAN_WARNING("Insufficient access credentials!"))
				return

			var/id = params["id"]
			var/name = params["name"]

			if (name && id)
				balloon_alert_to_viewers("Place a hand on the biometric reader to create a new medical record.")
				to_chat(user, SPAN_WARNING("Place a hand on the biometric reader to create a new medical record."))
				playsound(src, 'sound/machines/ping.ogg', 15, FALSE)
				bio_link_target_record_id = id
				biometric_scan_timer = addtimer(CALLBACK(src, PROC_REF(handle_biometric_scan_timeout), user), 10 SECONDS, TIMER_STOPPABLE)

			return

		if ("new_general_record")

			if(access_level != MEDICAL_RECORD_ACCESS_LEVEL_2)
				to_chat(user, SPAN_WARNING("Insufficient access credentials!"))
				return

			CreateGeneralRecord()
			to_chat(user, SPAN_NOTICE("You successfully created a new general record."))
			msg_admin_niche("[key_name_admin(user)] created new general record at [get_location_in_text(user)] [ADMIN_JMP(loc)].")
			update_static_data_for_all_viewers()

			return TRUE

		if ("delete_medical_record")
			if(access_level != MEDICAL_RECORD_ACCESS_LEVEL_2)
				to_chat(user, SPAN_WARNING("Insufficient access credentials!"))
				return

			var/id = params["id"]
			var/datum/data/record/medical_record = find_record("medical", id)
			var/datum/data/record/general_record = find_record("medical", id)

			if (!medical_record || !general_record)
				to_chat(user, SPAN_WARNING("Record not found."))
				return

			var/record_name = general_record.fields["name"]
			if ((istype(medical_record, /datum/data/record) && GLOB.data_core.medical.Find(medical_record)))
				GLOB.data_core.medical -= medical_record
				msg_admin_niche("[key_name_admin(user)] deleted the medical record of [record_name] at [get_location_in_text(user)] [ADMIN_JMP(loc)].")
				qdel(medical_record)

				tgui_interact(user, ui)

			return

		//* Actions for ingame objects interactions
		if ("print_medical_record")
			var/target_record_id = params["id"]
			if (!COOLDOWN_FINISHED(src, record_printing_cooldown))
				to_chat(user, SPAN_WARNING("Woah there buddy! Let the printer catch its breath before ordering the next document."))
				return

			COOLDOWN_START(src, record_printing_cooldown, 7 SECONDS)

			balloon_alert_to_viewers("Printing record!")
			to_chat(user, SPAN_NOTICE("Printing record!"))
			playsound(loc, 'sound/machines/fax.ogg', 15, TRUE)

			addtimer(CALLBACK(src, PROC_REF(print_medical_record), target_record_id, user), 3 SECONDS)
			return

		if ("update_photo")
			var/id = params["id"]
			var/photo_profile = params["photo_profile"]
			var/icon/image = get_photo(user)
			if(!image)
				to_chat(user, SPAN_WARNING("You are currently not holding any photo."))
				return

			// Locate the general record
			var/datum/data/record/general_record = find_record("general", id)

			if (!general_record)
				to_chat(user, SPAN_WARNING("Record not found."))
				return

			general_record.fields["photo_[photo_profile]"] = image
			ui.send_update(list(
				"photo_[photo_profile]" = icon2html(image, user.client, sourceonly = TRUE),
			))

			to_chat(user, SPAN_NOTICE("You successfully updated record [photo_profile] photo"))
			msg_admin_niche("[key_name_admin(user)] updated the record photo of [general_record.fields["name"]] at [get_location_in_text(user)] [ADMIN_JMP(loc)]")

			return TRUE

/obj/structure/machinery/computer/med_data/proc/validate_field(field, value, mob/user = usr, strict_mode = FALSE)
	var/list/validators = list(
		"general_name" = list(
			"type" = "string",
			"max_length" = 49,
			"required" = TRUE,
			"regex" = regex(@"^[a-zA-Z' ]+$"), // Allow letters, spaces, and single quotes
		),
		"general_age" = list(
			"type" = "number",
			"required" = TRUE,
			"min_value" = 18,
			"max_value" = 100,
		),
		"general_sex" = list(
			"type" = "string",
			"required" = TRUE,
			"allowed_values" = list("Male", "Female"),
		),
		"medical_major_disability" = list(
			"type" = "string",
			"max_length" = 50,
		),
		"medical_minor_disability" = list(
			"type" = "string",
			"max_length" = 50,
		),
		"medical_diseases" = list(
			"type" = "string",
			"max_length" = 50,
		),
		"medical_allergies" = list(
			"type" = "string",
			"max_length" = 50,
		),
		"medical_comments" = list(
			"type" = "string",
			"max_length" = 500,
			"required" = TRUE,
		)
	)

	var/list/rules = validators[field]
	// Handle strict mode: if the field is undefined, fail immediately
	if (strict_mode && !rules)
		return "[field] is not a recognized property."

	// If not in strict mode and the field is undefined, allow it through without checks
	if (!rules)
		return

	// Check required
	if (rules["required"] && isnull(value))
		return "[field] is required."

	// Check type
	if (rules["type"] == "string" && !istext(value))
		return "[field] must be a string."

	// Check max_length
	if (rules["type"] == "string" && rules["max_length"] && length(value) > rules["max_length"])
		return "[field] exceeds maximum length of [rules["max_length"]]."

	// Validate value range for numbers
	if (rules["type"] == "number")
		var/regex/regex_number = regex(@"^[-+]?[0-9]*(\.[0-9]+)?$")
		if (!regex_number.Find(value))
			return "Field [field] must be a valid number."

		var/min_value = rules["min_value"]
		var/max_value = rules["max_value"]
		var/num_value = text2num(value)
		if (rules["min_value"] && num_value  < min_value)
			return "Field [field] must not be less than [min_value]."
		if (rules["max_value"] && num_value  > max_value)
			return "Field [field] must not exceed [max_value]."

	// Check regex
	var/regex/regex = rules["regex"]
	if (rules["regex"] && !regex.Find(value))
		return "[field] contains invalid characters."

	// Check allowed_values
	if (rules["allowed_values"] && !(value in rules["allowed_values"]))
		return "[value] is not a valid value for [field]."

	return

/obj/structure/machinery/computer/med_data/proc/find_record(record_type, id)
	// Determine the list to search based on record_type
	var/list/records = null
	if (record_type == "general")
		records = GLOB.data_core.general
	else if (record_type == "medical")
		records = GLOB.data_core.medical
	else
		return // Unsupported record type
		// There are actually other types of records as well, but I want to make it foolproof

	// Iterate over the records to find the one matching the ID
	for (var/datum/data/record/record in records)
		if (record.fields["id"] == id)
			return record

/obj/structure/machinery/computer/med_data/proc/get_photo(mob/user)
	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_hand()
		return photo.img

/obj/structure/machinery/computer/med_data/laptop
	name = "Medical Laptop"
	desc = "Cheap Weyland-Yutani Laptop."
	icon_state = "medlaptop"
	density = FALSE
