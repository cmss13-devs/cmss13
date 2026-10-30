/datum/buildmode_mode/varedit
	key = "edit"
	help = "Right Mouse Button on buildmode button = Select var(type) & value\n\
	Left Mouse Button on turf/obj/mob = Set var(type) & value\n\
	Right Mouse Button on turf/obj/mob = Reset var's value"
	// Varedit mode
	var/selected_key = null
	var/selected_value = null

/datum/buildmode_mode/varedit/Destroy()
	selected_key = null
	selected_value = null
	return ..()

/datum/buildmode_mode/varedit/Reset()
	. = ..()
	selected_key = null
	selected_value = null

/datum/buildmode_mode/varedit/change_settings(client/c)
	if(!check_rights(R_DEBUG, FALSE))
		return

	var/list/locked = list("vars", "key", "ckey", "client", "icon")
	selected_key = tgui_input_text(c, "Enter variable name:", "Variable Name", "name")
	if(selected_key in locked)
		to_chat(c, SPAN_WARNING("Editing [selected_key] is not allowed."))
		Reset()
		return
	var/list/types = list(VV_NUM, VV_TEXT, VV_ICON, VV_COLOR, VV_COLOR_MATRIX, VV_ATOM_REFERENCE, VV_DATUM_REFERENCE, VV_MOB_REFERENCE, VV_NULL, VV_INFINITY, VV_WEAKREF, VV_MATRIX)
	if(selected_key in GLOB.bitfields)
		types += VV_BITFIELD
	var/type = tgui_input_list(c, "Select variable type:", "Type", types)
	if(!type)
		return

	var/list/result = c.vv_get_value(type, var_name=selected_key)
	if(!result["class"])
		return
	selected_value = result["value"]
	to_chat(c, SPAN_NOTICE("Stored [selected_key] = [selected_value]"))

/datum/buildmode_mode/varedit/when_clicked(client/c, params, obj/object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(object.vars.Find(selected_key))
			if(!object.vv_edit_var(selected_key, selected_value))
				to_chat(c, SPAN_WARNING("Your edit was rejected by the object."))
				return
			message_admins("[key_name(c)] modified [object.name]'s [selected_key] to [selected_value]")
		else
			to_chat(c, SPAN_DANGER("[initial(object.name)] does not have a var called '[selected_key]'"))

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(object.vars.Find(selected_key))
			var/reset_value = initial(object.vars[selected_key])
			if(!object.vv_edit_var(selected_key, reset_value))
				to_chat(c, SPAN_WARNING("Your edit was rejected by the object."))
				return
			message_admins("[key_name(c)] modified [object.name]'s [selected_key] to [reset_value]")
		else
			to_chat(c, SPAN_DANGER("[initial(object.name)] does not have a var called '[selected_key]'"))
