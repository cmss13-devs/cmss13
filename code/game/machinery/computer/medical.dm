//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/// view-only medical record access, for unclassified files. lowest access level.
#define MEDICAL_RECORD_ACCESS_LEVEL_0 0	// assigned to HMs and Nurses.
/// edit access for all unclassified files. view-only for classified files.
#define MEDICAL_RECORD_ACCESS_LEVEL_1 1	// access level given to Doctors, and any Officers at or above 1stLT.
/// full record database edit and viewing access.
#define MEDICAL_RECORD_ACCESS_LEVEL_2 2	// given to the CMO, Synths, and the CO/XO.

/obj/structure/machinery/computer/med_data//TODO:SANITY
	name = "Medical Records"
	desc = "This can be used to check medical records."
	icon_state = "medcomp"
	density = TRUE
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_WY_MEDICAL)
	circuit = /obj/item/circuitboard/computer/med_data
	var/obj/item/card/id/scan = null
	var/last_user_name = ""
	var/last_user_rank = ""
	var/printing = null
	var/access_level = MEDICAL_RECORD_ACCESS_LEVEL_0

/obj/structure/machinery/computer/med_data/attack_remote(user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/computer/med_data/attack_hand(mob/user)
	if(..() || inoperable())
		to_chat(user, SPAN_INFO("It does not appear to be working."))
		return

	if(!allowed(usr))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	if(!is_mainship_level(z))
		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the station!"))
		return

	tgui_interact(user)

	return

/obj/structure/machinery/computer/med_data/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "MedicalRecords", "Medical Records")
		ui.open()

/obj/structure/machinery/computer/med_data/proc/get_database_access_level(obj/item/card/id/id)
	if(!id)
		return MEDICAL_RECORD_ACCESS_LEVEL_0
	if(ACCESS_MARINE_DATABASE_ADMIN in id.access)
		return MEDICAL_RECORD_ACCESS_LEVEL_2
	if(ACCESS_MARINE_DATABASE in id.access)
		return MEDICAL_RECORD_ACCESS_LEVEL_1
	return MEDICAL_RECORD_ACCESS_LEVEL_0

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

		var/datum/weakref/target_ref = general.fields["ref"]
		var/mob/living/carbon/human/target = target_ref.resolve()

		var/obj/item/card/id/id = target.wear_id
		var/paygrade = id ? id.paygrade : "None"

		var/record_classified = FALSE
		// checks if record target is in the chain of command, and needs their record protected
		if(target.job in CHAIN_OF_COMMAND_ROLES)
			record_classified = TRUE

		var/list/record = list(
			"id" = id_number,
			"general_name" = general.fields["name"],
			"general_job" = general.fields["rank"],
			"general_rank" = paygrade,
			"general_age" = general.fields["age"],
			"general_sex" = general.fields["sex"],
			"general_m_stat" = general.fields["m_stat"],
			"general_p_stat" = general.fields["p_stat"],
			"medical_blood_type" = medical.fields["blood_type"],
			"medical_major_disabilities" = medical.fields["major_disability"],
			"medical_major_disabilities_details" = medical.fields["major_disability_details"],
			"medical_minor_disabilities" = medical.fields["minor_disability"],
			"medical_minor_disabilities_details" = medical.fields["minor_disability_details"],
			"medical_allergies" = medical.fields["allergies"],
			"medical_allergies_details" = medical.fields["allergies_details"],
			"medical_diseases" = medical.fields["diseases"],
			"medical_diseases_details" = medical.fields["diseases_details"],
			"medical_comments" = medical ? medical.fields["comments"] : null,
			"record_classified" = record_classified
		)
		records += list(record)

	.["records"] = records
	.["operator"] = operator
	.["database_access_level"] = access_level

	var/icon/photo_icon = new /icon('icons/misc/buildmode.dmi', "buildhelp")
	var/photo_data = icon2html(photo_icon, user.client, sourceonly=TRUE)

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
			var/obj/item/card/id/id = user.wear_id
			access_level = get_database_access_level(id)
			return
		if("log_out")
			operator = null
			access_level = MEDICAL_RECORD_ACCESS_LEVEL_0
			return
		//* Actions for managing records
		if("select_record")
			var/id = params["id"]

			if(!id)
				tgui_alert(user,"Invalid record ID.")
				return

			// Find the corresponding general record
			var/datum/data/record/general_record = find_record("general", id)

			if(!general_record)
				tgui_alert(user,"Record not found.")
				return

			var/icon/photo_icon = new /icon('icons/misc/buildmode.dmi', "buildhelp")
			var/photo_data = icon2html(photo_icon, user.client, sourceonly=TRUE)

			var/photo_front = general_record.fields["photo_front"] ? icon2html(general_record.fields["photo_front"], user.client, sourceonly=TRUE) : photo_data
			var/photo_side = general_record.fields["photo_side"] ? icon2html(general_record.fields["photo_side"], user.client, sourceonly=TRUE) : photo_data

			ui.send_update(list(
				"photo_front" = photo_front,
				"photo_side" = photo_side
			))

			. = TRUE

		if("update_field")
			var/id = params["id"]
			var/field = params["field"]
			var/value = params["value"]

			var/validation_error = validate_field(field, value, user, FALSE)
			if (validation_error)
				to_chat(user, SPAN_WARNING("Console returns error with buzzing sound: [validation_error]"))
				playsound(loc, 'sound/machines/buzz-two.ogg', 15, 1)
				return

			if(!id || !field)
				alert(user, "Invalid record ID or field.")
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
			message_admins("[key_name(user)] changed the record of [name]. Field [original_field] value changed to [value]")

			. = TRUE
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

			var/mob/living/carbon/human/U = usr
			var/new_comment = list(
				"entry" = strip_html(trim(comment)),
				"created_by" = list("name" = U.get_authentification_name(), "rank" = U.get_assignment()),
				"created_at" = created_at,
				"deleted_by" = null,
				"deleted_at" = null
			)

			if (!islist(medical_record.fields["comments"]))
				medical_record.fields["comments"] = list("[comment_id]" = new_comment)
			else
				medical_record.fields["comments"]["[comment_id]"] = new_comment

			to_chat(user, SPAN_NOTICE("Comment added successfully."))
			msg_admin_niche("[key_name_admin(user)] added medical comment.")

			return
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

			var/mob/living/carbon/human/U = user
			comment["deleted_by"] = "[U.get_authentification_name()] ([U.get_assignment()])"
			comment["deleted_at"] = text("[]  []  []", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)

			medical_record.fields["comments"][comment_key] = comment

			to_chat(user, SPAN_NOTICE("Comment deleted successfully."))
			msg_admin_niche("[key_name_admin(user)] deleted medical comment.")

		//* Records maintenance actions
		if ("new_medical_record")
			var/id = params["id"]
			var/name = params["name"]

			if (name && id)
				create_medical_record(name, id)
			return

		if ("new_general_record")
			CreateGeneralRecord()
			to_chat(user, SPAN_NOTICE("You successfully created new general record"))
			msg_admin_niche("[key_name_admin(user)] created new general record.")

		if ("delete_general_record")
			return

			var/id = params["id"]
			var/datum/data/record/general_record = find_record("general", id)

			if (!general_record)
				to_chat(user, SPAN_WARNING("Record not found."))
				return

			var/record_name = general_record.fields["name"]
			if ((istype(general_record, /datum/data/record) && GLOB.data_core.general.Find(general_record)))
				GLOB.data_core.general -= general_record
				msg_admin_niche("[key_name_admin(user)] deleted record of [record_name].")
				qdel(general_record)

		//* Actions for ingame objects interactions
		if ("print_personal_record")
			var/id = params["id"]
			if (!printing)
				printing = TRUE

				// Locate the general record
				var/datum/data/record/general_record = find_record("general", id)

				// Locate the medical record (if applicable)
				var/datum/data/record/medical_record = find_record("medical", id)

				if (!general_record)
					to_chat(user, SPAN_WARNING("Record not found."))
					return
				to_chat(user, SPAN_NOTICE("Printing record."))
				sleep(15)
				playsound(loc, 'sound/machines/print.ogg', 15, 1)

				var/obj/item/paper/personalrecord/P = new /obj/item/paper/personalrecord(loc, general_record, medical_record)
				P.name = text("medical Record ([])", general_record.fields["name"])
				printing = FALSE
		if ("update_photo")
			var/id = params["id"]
			var/photo_profile = params["photo_profile"]
			var/icon/img = get_photo(user)
			if(!img)
				to_chat(user, SPAN_WARNING("You are currently not holding any photo."))
				return

			// Locate the general record
			var/datum/data/record/general_record = find_record("general", id)

			if (!general_record)
				to_chat(user, SPAN_WARNING("Record not found."))
				return

			general_record.fields["photo_[photo_profile]"] = img
			ui.send_update(list(
				"photo_[photo_profile]" = icon2html(img, user.client, sourceonly=TRUE),
			))
			to_chat(user, SPAN_NOTICE("You successfully updated record [photo_profile] photo"))
			msg_admin_niche("[key_name_admin(user)] updated record photo of [general_record.fields["name"]].")

/obj/structure/machinery/computer/med_data/proc/validate_field(field, value, mob/user = usr, strict_mode = FALSE)
	var/list/validators = list(
		"general_name" = list(
			"type" = "string",
			"max_length" = 49,
			"required" = TRUE,
			"regex" = regex(@"^[a-zA-Z' ]+$"), // Allow letters, spaces, and single quotes
		),
		"general_rank" = list(
			"type" = "string",
			"required" = TRUE,
			"allowed_values" = GLOB.joblist,
			"permitted_paygrades" = list(GLOB.uscm_highcom_paygrades)
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
		"medical_criminal" = list(
			"type" = "string",
			"required" = TRUE,
			"allowed_values" = list("*Arrest*", "Incarcerated", "Released", "Suspect", "NJP", "None"),
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
		return null

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

	return null

/obj/structure/machinery/computer/med_data/proc/find_record(record_type, id)
	// Determine the list to search based on record_type
	var/list/records = null
	if (record_type == "general")
		records = GLOB.data_core.general
	else if (record_type == "medical")
		records = GLOB.data_core.medical
	else
		return null // Unsupported record type
		// There are actually other types of records as well, but I want to make it foolproof

	// Iterate over the records to find the one matching the ID
	for (var/datum/data/record/record in records)
		if (record.fields["id"] == id)
			return record

	return null

/obj/structure/machinery/computer/med_data/proc/get_photo(mob/user)
	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_hand()
		return photo.img

/obj/structure/machinery/computer/med_data/laptop
	name = "Medical Laptop"
	desc = "Cheap Weyland-Yutani Laptop."
	icon_state = "medlaptop"
	density = FALSE
