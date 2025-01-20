//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/secure_data//TODO:SANITY
	name = "Security Records"
	desc = "Used to view and edit personnel's security records"
	icon_state = "security"
	req_access = list(ACCESS_MARINE_BRIG)
	circuit = /obj/item/circuitboard/computer/secure_data
	var/obj/item/card/id/scan = null
	var/obj/item/device/clue_scanner/scanner = null
	var/printing = null

/obj/structure/machinery/computer/secure_data/attackby(obj/item/O as obj, user as mob)

	if(istype(O, /obj/item/device/clue_scanner) && !scanner)
		var/obj/item/device/clue_scanner/S = O
		if(!S.print_list)
			to_chat(user, SPAN_WARNING("There are no prints stored in \the [S]!"))
			return

		if(usr.drop_held_item())
			O.forceMove(src)
			scanner = O
			to_chat(user, "You insert [O].")
			update_static_data(usr)

	. = ..()

/obj/structure/machinery/computer/secure_data/ui_static_data(mob/user)
	. = ..()

	if(!allowed(usr))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	// Pass player data, only for frontend state
	var/mob/living/carbon/human/U = usr
	var/user_data = list("name" = U.get_authentification_name(), "rank" = U.get_assignment())
	.["user_data"] = user_data

	// Pass scanner data
	var/list/prints_data = list()
	if (scanner && scanner.print_list)
		for (var/obj/effect/decal/prints/prints in scanner.print_list)
			var/print_entry = list(
				"name" = prints.criminal_name,
				"squad" = prints.criminal_squad,
				"rank" = prints.criminal_rank,
				"description" = prints.description
			)
			prints_data += list(print_entry)

	var/scanner_status = list(
		"connected" = !!scanner,
		"count" = scanner && scanner.print_list ? length(scanner.print_list) : 0,
		"data" = prints_data,
	)
	.["scanner"] = scanner_status

	// Define criminal statuses and colors
	var/list/criminal_statuses = list(
	"*Arrest*" = list("background" = "#990c28", "font" = "#ffffff"),
	"Incarcerated" = list("background" = "#faa20a", "font" = "#ffffff"),
	"Released" = list("background" = "#2981b3", "font" = "#ffffff"),
	"Suspect" = list("background" = "#686A6C", "font" = "#ffffff"),
	"NJP" = list("background" = "#b60afa", "font" = "#ffffff"),
	"None" = list("background" = "inherit", "font" = "inherit"),
	)

	.["criminal_statuses"] = criminal_statuses

	// Map security records via id
	var/list/records = list()
	var/list/security_map = list()
	for (var/datum/data/record/security in GLOB.data_core.security)
		security_map[security.fields["id"]] = security

	for (var/datum/data/record/general in GLOB.data_core.general)
		var/id = general.fields["id"]
		var/datum/data/record/security = security_map[id]

		var/list/record = list(
			"id" = id,
			"general_name" = general.fields["name"],
			"general_rank" = general.fields["rank"],
			"general_age" = general.fields["age"],
			"general_sex" = general.fields["sex"],
			"general_m_stat" = general.fields["m_stat"],
			"general_p_stat" = general.fields["p_stat"],
			"security_criminal" = security ? security.fields["criminal"] : "",
			"security_comments" = security ? security.fields["comments"] : null,
			"security_incident" = security ? security.fields["incident"] : null
		)
		records += list(record)

	.["records"] = records

/obj/structure/machinery/computer/secure_data/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/secure_data/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		// Open TGUI with records data
		ui = new(user, src, "SecurityRecords", "Security Records")
		ui.open()

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/structure/machinery/computer/secure_data/attack_hand(mob/user as mob)
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

/obj/structure/machinery/computer/secure_data/proc/is_not_allowed(mob/user)
	return user.stat || user.is_mob_restrained() || (!in_range(src, user) && (!isSilicon(user)))

/obj/structure/machinery/computer/secure_data/proc/get_photo(mob/user)
	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_hand()
		return photo.img

/obj/structure/machinery/computer/secure_data/emp_act(severity)
	. = ..()
	if(inoperable())
		return

	for(var/datum/data/record/R in GLOB.data_core.security)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					msg_admin_niche("The security record name of [R.fields["name"]] was scrambled!")
					R.fields["name"] = "[pick(pick(GLOB.first_names_male), pick(GLOB.first_names_female))] [pick(GLOB.last_names)]"
				if(2)
					R.fields["sex"] = pick("Male", "Female")
					msg_admin_niche("The security record sex of [R.fields["name"]] was scrambled!")
				if(3)
					R.fields["age"] = rand(5, 85)
					msg_admin_niche("The security record age of [R.fields["name"]] was scrambled!")
				if(4)
					R.fields["criminal"] = pick("None", "*Arrest*", "Incarcerated", "Released", "Suspect", "NJP")
					msg_admin_niche("The security record criminal status of [R.fields["name"]] was scrambled!")
				if(5)
					R.fields["p_stat"] = pick("*Unconscious*", "Active", "Physically Unfit")
					msg_admin_niche("The security record physical state of [R.fields["name"]] was scrambled!")
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
					msg_admin_niche("The security record mental state of [R.fields["name"]] was scrambled!")
			continue

		else if(prob(1))
			msg_admin_niche("The security record of [R.fields["name"]] was lost!")
			GLOB.data_core.security -= R
			qdel(R)
			continue

/obj/structure/machinery/computer/secure_data/detective_computer
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "messyfiles"

/obj/structure/machinery/computer/secure_data/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	//? Leaving below line for debug
	// to_chat(usr, "Received action [action] with params [json_encode(params)]")

	if(!allowed(usr))
		to_chat(usr, SPAN_WARNING("Access denied."))
		return

	switch(action)
		//* Actions for managing records
		if("select_record")
			var/id = params["id"]

			if(!id)
				alert(usr,"Invalid record ID.")
				return

			// Find the corresponding general record
			var/datum/data/record/general_record = find_record("general", id)

			if(!general_record)
				alert(usr,"Record not found.")
				return

			// Send photos to the client
			if(general_record.fields["photo_front"])
				usr << browse_rsc(general_record.fields["photo_front"], "front.png")
			else
				usr << browse_rsc(new /icon('icons/misc/buildmode.dmi', "buildhelp"), "front.png")

			if(general_record.fields["photo_side"])
				usr << browse_rsc(general_record.fields["photo_side"], "side.png")
			else
				// Closest matching thing I've found, feel free to change it!
				usr << browse_rsc(new /icon('icons/misc/buildmode.dmi', "buildhelp"), "side.png")

			. = TRUE

		if("update_field")
			var/id = params["id"]
			var/field = params["field"]
			var/value = params["value"]

			var/validation_error = validate_field(field, value, usr, FALSE)
			if (validation_error)
				to_chat(usr, "Error: [validation_error]")
				return

			if(!id || !field)
				alert(usr, "Invalid record ID or field.")
				return

			var/is_general_field = copytext(field, 1, 9) == "general_"
			var/is_security_field = copytext(field, 1, 10) == "security_"

			if(!is_general_field && !is_security_field)
				alert(usr, "Invalid field prefix.")
				return

			// Remove the prefix to map to the original field name
			var/prefix_length = is_general_field ? 8 : (is_security_field ? 9 : 0)
			var/original_field = copytext(field, prefix_length + 1)

			// Locate the general record
			var/datum/data/record/general_record = find_record("general", id)

			// Locate the security record (if applicable)
			var/datum/data/record/security_record = find_record("security", id)

			// Update the appropriate record
			if(is_general_field && general_record)
				if(original_field in general_record.fields)
					general_record.fields[original_field] = value
				else
					alert(usr, "Field not found in general record.")
					return

			else if(is_security_field && security_record)
				if(original_field in security_record.fields)
					security_record.fields[original_field] = value

					// Update HUD status
					if(original_field == "criminal")
						for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
							H.sec_hud_set_security_status()

				else
					alert(usr, "Field not found in security record.")
					return
			else
				alert(usr, "Record not found or mismatched field type.")
				return


			var/name = general_record.fields["name"]
			update_static_data(usr)
			message_admins("[key_name(usr)] changed the record of [name]. Field [original_field] value changed to [value]")

			. = TRUE
		if ("add_comment")
			var/id = params["id"]
			var/comment = params["comment"]

			if (!id || !comment || length(trim(comment)) == 0)
				to_chat(usr, "Invalid input. Ensure both ID and comment are provided.")
				return

			// Locate the security record
			var/datum/data/record/security_record = find_record("security", id)

			if (!security_record)
				to_chat(usr, "Record not found.")
				return

			var/comment_id = length(security_record.fields["comments"] || list()) + 1
			var/created_at = text("[]  []  []", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)

			var/mob/living/carbon/human/U = usr
			var/new_comment = list(
				"entry" = strip_html(trim(comment)),
				"created_by" = list("name" = U.get_authentification_name(), "rank" = U.get_assignment()),
				"created_at" = created_at,
				"deleted_by" = null,
				"deleted_at" = null
			)

			if (!islist(security_record.fields["comments"]))
				security_record.fields["comments"] = list("[comment_id]" = new_comment)
			else
				security_record.fields["comments"]["[comment_id]"] = new_comment

			to_chat(usr, "Comment added successfully.")
			msg_admin_niche("[key_name_admin(usr)] added security comment.")
			update_static_data(usr)

			return
		if ("delete_comment")
			var/id = params["id"]
			var/comment_key = params["key"]

			if (!id || !comment_key)
				to_chat(usr, "Invalid input. Ensure both ID and comment key are provided.")
				return

			// Locate the security record
			var/datum/data/record/security_record = find_record("security", id)

			if (!security_record)
				to_chat(usr, "Record not found.")
				return

			if (!security_record.fields["comments"] || !security_record.fields["comments"][comment_key])
				to_chat(usr, "Comment not found.")
				return

			var/comment = security_record.fields["comments"][comment_key]
			if (comment["deleted_by"])
				to_chat(usr, "This comment is already deleted.")
				return

			var/mob/living/carbon/human/U = usr
			comment["deleted_by"] = "[U.get_authentification_name()] ([U.get_assignment()])"
			comment["deleted_at"] = text("[]  []  []", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)

			security_record.fields["comments"][comment_key] = comment

			to_chat(usr, "Comment deleted successfully.")
			msg_admin_niche("[key_name_admin(usr)] deleted security comment.")
			update_static_data(usr)

		//* Records maintenance actions
		if ("new_security_record")
			var/id = params["id"]
			var/name = params["name"]

			if (name && id)
				CreateSecurityRecord(name, id)
				update_static_data(usr)
			return

		if ("new_general_record")
			CreateGeneralRecord()
			update_static_data(usr)
			to_chat(usr, "You successfully created new general record")
			msg_admin_niche("[key_name_admin(usr)] created new general record.")

		if ("delete_general_record")
			if(!check_player_paygrade(usr,list(GLOB.uscm_highcom_paygrades))){
				to_chat(usr, "You have no permission to do that")
				return
			}

			var/id = params["id"]
			var/datum/data/record/general_record = find_record("general", id)

			if (!general_record)
				to_chat(usr, "Record not found.")
				return

			var/record_name = general_record.fields["name"]
			if ((istype(general_record, /datum/data/record) && GLOB.data_core.general.Find(general_record)))
				GLOB.data_core.general -= general_record
				msg_admin_niche("[key_name_admin(usr)] deleted record of [record_name].")
				qdel(general_record)
			update_static_data(usr)

		//* Actions for ingame objects interactions
		if("print_fingerprint_report")
			if (!( printing ))
				printing = 1
				if (!scanner || !scanner.print_list)
					to_chat(usr, "No scanner data found.")
					return

				sleep(50)
				playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)

				var/obj/item/paper/fingerprint/P = new /obj/item/paper/fingerprint(src, scanner.print_list)
				P.forceMove(loc)
				var/refkey = ""
				for(var/obj/effect/decal/prints/print in scanner.print_list)
					refkey += print.criminal_name
				P.name = "fingerprint report ([md5(refkey)])"
				printing = null

		if ("clear_fingerprints")
			if (!scanner)
				to_chat(usr, "No scanner found.")
				return

			scanner.update_icon()
			to_chat(usr, "Fingerprints cleared from the scanner.")
			update_static_data(usr)

		if("eject_fingerprint_scanner")
			if (!scanner)
				to_chat(usr, "No scanner found.")
				return

			scanner.update_icon()
			scanner.forceMove(get_turf(src))
			scanner = null
			update_static_data(usr)
		if ("print_personal_record")
			var/id = params["id"]
			if (!( printing ))
				printing = 1

				// Locate the general record
				var/datum/data/record/general_record = find_record("general", id)

				// Locate the security record (if applicable)
				var/datum/data/record/security_record = find_record("security", id)

				if (!general_record)
					to_chat(usr, "Record not found.")
					return

				sleep(50)

				var/obj/item/paper/personalrecord/P = new /obj/item/paper/personalrecord(src, general_record, security_record)
				P.forceMove(loc)
				P.name = text("Security Record ([])", general_record.fields["name"])
				printing = null
		if ("update_photo")
			var/id = params["id"]
			var/photo_profile = params["photo_profile"]
			var/icon/img = get_photo(usr)
			if(!img)
				to_chat(usr, "You are currently not holding any photo")
				return

			// Locate the general record
			var/datum/data/record/general_record = find_record("general", id)

			if (!general_record)
				to_chat(usr, "Record not found.")
				return

			general_record.fields["photo_[photo_profile]"] = img
			usr << browse_rsc(general_record.fields["photo_[photo_profile]"], "[photo_profile].png")
			to_chat(usr, "You successfully updated record [photo_profile] photo")
			msg_admin_niche("[key_name_admin(usr)] updated record photo of [general_record.fields["name"]].")

/obj/structure/machinery/computer/secure_data/proc/validate_field(field, value, mob/user = null, strict_mode = FALSE)
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
		"security_criminal" = list(
			"type" = "string",
			"required" = TRUE,
			"allowed_values" = list("*Arrest*", "Incarcerated", "Released", "Suspect", "NJP", "None"),
		),
		"security_comments" = list(
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

	// Check for paygrade
	if (rules["permitted_paygrades"] && !check_player_paygrade(usr, rules["permitted_paygrades"])){
		return "Not enough permissions to edit [field]"
	}

	// Check allowed_values
	if (rules["allowed_values"] && !(value in rules["allowed_values"]))
		return "[value] is not a valid value for [field]."

	return null


/obj/structure/machinery/computer/secure_data/proc/check_player_paygrade(mob/user, list/permitted_paygrades)
	if (ishuman(user))
		var/mob/living/carbon/human/human = user
		var/obj/item/card/id/id_card = human.get_idcard()

		if (id_card)
			for(var/paygrade in permitted_paygrades)
				if(id_card.paygrade in paygrade)
					return TRUE

	return FALSE

/obj/structure/machinery/computer/secure_data/proc/find_record(record_type, id)
	// Determine the list to search based on record_type
	var/list/records = null
	if (record_type == "general")
		records = GLOB.data_core.general
	else if (record_type == "security")
		records = GLOB.data_core.security
	else
		return null // Unsupported record type
		// There are actually other types of records as well, but I want to make it foolproof

	// Iterate over the records to find the one matching the ID
	for (var/datum/data/record/record in records)
		if (record.fields["id"] == id)
			return record

	return null
