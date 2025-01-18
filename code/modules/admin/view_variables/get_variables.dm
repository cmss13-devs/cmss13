/client/proc/vv_get_class(var_name, var_value)
	if(isnull(var_value))
		. = VV_NULL

	else if(isnum(var_value))
		if(var_name in GLOB.bitfields)
			. = VV_BITFIELD
		else
			. = VV_NUM

	else if(istext(var_value))
		if(findtext(var_value, "\n"))
			. = VV_MESSAGE
		else if(findtext(var_value, GLOB.is_color))
			. = VV_COLOR
		else
			. = VV_TEXT

	else if(isicon(var_value))
		. = VV_ICON

	else if(ismob(var_value))
		. = VV_MOB_REFERENCE

	else if(isloc(var_value))
		. = VV_ATOM_REFERENCE

	else if(istype(var_value, /client))
		. = VV_CLIENT

	else if(isweakref(var_value))
		. = VV_WEAKREF

	else if(istype(var_value, /matrix))
		. = VV_MATRIX

	else if(isdatum(var_value))
		. = VV_DATUM_REFERENCE

	else if(ispath(var_value))
		if(ispath(var_value, /atom))
			. = VV_ATOM_TYPE
		else if(ispath(var_value, /datum))
			. = VV_DATUM_TYPE
		else
			. = VV_TYPE

	else if(islist(var_value))
		if(var_name in GLOB.color_vars)
			. = VV_COLOR_MATRIX
		else
			. = VV_LIST

	else if(isfile(var_value))
		. = VV_FILE

	else
		. = VV_NULL

/client/proc/vv_get_value(class, default_class, current_value, list/restricted_classes, list/extra_classes, list/classes, var_name)
	. = list("class" = class, "value" = null)
	if(!class)
		if(!classes)
			classes = list (
				VV_NUM,
				VV_TEXT,
				VV_MESSAGE,
				VV_ICON,
				VV_COLOR,
				VV_COLOR_MATRIX,
				VV_ATOM_REFERENCE,
				VV_DATUM_REFERENCE,
				VV_MOB_REFERENCE,
				VV_CLIENT,
				VV_ATOM_TYPE,
				VV_DATUM_TYPE,
				VV_TYPE,
				VV_FILE,
				VV_NEW_ATOM,
				VV_NEW_DATUM,
				VV_NEW_TYPE,
				VV_NEW_LIST,
				VV_NULL,
				VV_INFINITY,
				VV_RESTORE_DEFAULT,
				VV_TEXT_LOCATE,
				VV_PROCCALL_RETVAL,
				VV_WEAKREF,
				VV_MATRIX,
				)

		var/markstring
		if(!(VV_MARKED_DATUM in restricted_classes))
			markstring = "[VV_MARKED_DATUM] (CURRENT: [(istype(admin_holder) && istype(admin_holder.marked_datum))? admin_holder.marked_datum.type : "NULL"])"
			classes += markstring

		var/list/tagstrings = new
		if(!(VV_TAGGED_DATUM in restricted_classes) && admin_holder && LAZYLEN(admin_holder.tagged_datums))
			var/i = 0
			for(var/datum/iter_tagged_datum as anything in admin_holder.tagged_datums)
				i++
				var/new_tagstring = "[VV_TAGGED_DATUM] #[i]: [iter_tagged_datum.type])"
				tagstrings[new_tagstring] = iter_tagged_datum
				classes += new_tagstring

		if(restricted_classes)
			classes -= restricted_classes

		if(extra_classes)
			classes += extra_classes

		.["class"] = tgui_input_list(src, "What kind of data?", "Variable Type", classes)
		if(admin_holder && admin_holder.marked_datum && .["class"] == markstring)
			.["class"] = VV_MARKED_DATUM

		if(admin_holder && tagstrings[.["class"]])
			var/datum/chosen_datum = tagstrings[.["class"]]
			.["value"] = chosen_datum
			.["class"] = VV_TAGGED_DATUM


	switch(.["class"])
		if(VV_TEXT)
			.["value"] = tgui_input_text(usr, "Enter new text:", "Text", current_value, encode = FALSE, trim = FALSE)
			if(.["value"] == null)
				.["class"] = null
				return
		if(VV_MESSAGE)
			.["value"] = tgui_input_text(usr, "Enter new text:", "Text", current_value, encode = FALSE, trim = FALSE)
			if(.["value"] == null)
				.["class"] = null
				return


		if(VV_NUM)
			.["value"] = tgui_input_real_number(usr, "Enter new number:", "Num", current_value)
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_BITFIELD)
			.["value"] = input_bitfield(usr, "Editing bitfield: [var_name]", var_name, current_value)
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_ATOM_TYPE)
			.["value"] = pick_closest_path(FALSE)
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_DATUM_TYPE)
			.["value"] = pick_closest_path(FALSE, get_fancy_list_of_datum_types())
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_TYPE)
			var/type = current_value
			var/error = ""
			do
				type = tgui_input_text(usr, "Enter type:[error]", "Type", type)
				if(!type)
					break
				type = text2path(type)
				error = "\nType not found, Please try again"
			while(!type)
			if(!type)
				.["class"] = null
				return
			.["value"] = type

		if(VV_ATOM_REFERENCE)
			var/type = pick_closest_path(FALSE)
			var/subtypes = vv_subtype_prompt(type)
			if(subtypes == null)
				.["class"] = null
				return
			var/list/things = vv_reference_list(type, subtypes)
			var/value = tgui_input_list(usr, "Select reference:", "Reference", things)
			if(!value)
				.["class"] = null
				return
			.["value"] = things[value]

		if(VV_DATUM_REFERENCE)
			var/type = pick_closest_path(FALSE, get_fancy_list_of_datum_types())
			var/subtypes = vv_subtype_prompt(type)
			if(subtypes == null)
				.["class"] = null
				return
			var/list/things = vv_reference_list(type, subtypes)
			var/value = tgui_input_list(usr, "Select reference:", "Reference", things)
			if(!value)
				.["class"] = null
				return
			.["value"] = things[value]

		if(VV_MOB_REFERENCE)
			var/type = pick_closest_path(FALSE, make_types_fancy(typesof(/mob)))
			var/subtypes = vv_subtype_prompt(type)
			if(subtypes == null)
				.["class"] = null
				return
			var/list/things = vv_reference_list(type, subtypes)
			var/value = tgui_input_list(usr, "Select reference:", "Reference", things)
			if(!value)
				.["class"] = null
				return
			.["value"] = things[value]

		if(VV_WEAKREF)
			var/type = pick_closest_path(FALSE, get_fancy_list_of_datum_types())
			var/subtypes = vv_subtype_prompt(type)
			if(subtypes == null)
				.["class"] = null
				return
			var/list/things = vv_reference_list(type, subtypes)
			var/value = tgui_input_list(usr, "Select reference:", "Reference", things)
			if(!value)
				.["class"] = null
				return
			.["value"] = WEAKREF(things[value])

		if(VV_CLIENT)
			.["value"] = tgui_input_list(usr, "Select reference:", "Reference", GLOB.clients)
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_FILE)
			.["value"] = input("Pick file:", "File") as null|file
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_ICON)
			.["value"] = input("Pick icon:", "Icon") as null|icon
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_MARKED_DATUM)
			.["value"] = admin_holder.marked_datum
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_TAGGED_DATUM)
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_PROCCALL_RETVAL)
			var/list/get_retval = list()
			callproc_blocking(get_retval)
			.["value"] = get_retval[1] //should have been set in proccall!
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_NEW_ATOM)
			var/type = pick_closest_path(FALSE)
			if(!type)
				.["class"] = null
				return
			.["type"] = type
			var/atom/newguy = new type()
			newguy.datum_flags |= DF_VAR_EDITED
			.["value"] = newguy

		if(VV_NEW_DATUM)
			var/type = pick_closest_path(FALSE, get_fancy_list_of_datum_types())
			if(!type)
				.["class"] = null
				return
			.["type"] = type
			var/datum/newguy = new type()
			newguy.datum_flags |= DF_VAR_EDITED
			.["value"] = newguy

		if(VV_NEW_TYPE)
			var/type = current_value
			var/error = ""
			do
				type = tgui_input_text("Enter type:[error]", "Type", type)
				if(!type)
					break
				type = text2path(type)
				error = "\nType not found, Please try again"
			while(!type)
			if(!type)
				.["class"] = null
				return
			.["type"] = type
			var/datum/newguy = new type()
			if(istype(newguy))
				newguy.datum_flags |= DF_VAR_EDITED
			.["value"] = newguy

		if(VV_NEW_LIST)
			.["value"] = list()
			.["type"] = /list

		if(VV_TEXT_LOCATE)
			var/datum/D
			do
				var/ref = tgui_input_text("Enter reference:", "Reference")
				if(!ref)
					break
				D = locate(ref)
				if(!D)
					tgui_alert(usr,"Invalid ref!")
					continue
				if(!D.can_vv_mark())
					tgui_alert(usr,"Datum can not be marked!")
					continue
			while(!D)
			.["type"] = D.type
			.["value"] = D

		if(VV_COLOR)
			.["value"] = input("Enter new color:", "Color", current_value) as color|null
			if(.["value"] == null)
				.["class"] = null
				return

		if(VV_COLOR_MATRIX)
			.["value"] = open_color_matrix_editor()
			if(.["value"] == color_matrix_identity()) //identity is equivalent to null
				.["class"] = null

		if(VV_INFINITY)
			.["value"] = INFINITY

		if(VV_MATRIX)
			if(!stored_matrices)
				.["class"] = null
				to_chat(usr, SPAN_NOTICE("No matrices!"))
				return

			var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (stored_matrices + "Cancel"))
			if(!matrix_name || matrix_name == "Cancel")
				.["class"] = null
				return

			var/matrix/M = LAZYACCESS(stored_matrices, matrix_name)
			if(!M)
				.["class"] = null
				return

			.["value"] = M

/proc/get_fancy_list_of_atom_types()
	var/static/list/pre_generated_list
	if (!pre_generated_list) //init
		pre_generated_list = make_types_fancy(typesof(/atom))
	return pre_generated_list

/proc/get_fancy_list_of_datum_types()
	var/static/list/pre_generated_list
	if(!pre_generated_list) //init
		pre_generated_list = make_types_fancy(sortList(typesof(/datum) - typesof(/atom)))
	return pre_generated_list

/proc/pick_closest_path(value, list/matches = get_fancy_list_of_atom_types())
	if(value == FALSE) //nothing should be calling us with a number, so this is safe
		value = tgui_input_text(usr, "Enter type to find (blank for all, cancel to cancel)", "Search for type")
		if(isnull(value))
			return
	value = trim(value)
	if(!isnull(value) && value != "")
		matches = filter_fancy_list(matches, value)

	if(!length(matches))
		return

	var/chosen
	if(length(matches) == 1)
		chosen = matches[1]
	else
		chosen = tgui_input_list(usr, "Select a type", "Pick Type", matches)
		if(!chosen)
			return
	chosen = matches[chosen]
	return chosen

/proc/filter_fancy_list(list/L, filter as text)
	var/list/matches = new
	var/end_len = -1
	var/list/endcheck = splittext(filter, "!")
	if(length(endcheck) > 1)
		filter = endcheck[1]
		end_len = length_char(filter)

	for(var/key in L)
		var/value = L[key]
		if(findtext("[key]", filter, -end_len) || findtext("[value]", filter, -end_len))
			matches[key] = value
	return matches
