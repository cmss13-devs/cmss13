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

#define TYPE_TEXT "text"
#define TYPE_NUMBER "number"
#define TYPE_MOB_REFERENCE "mob reference"
#define TYPE_OBJ_REFERENCE "object reference"
#define TYPE_TURF_REFERENCE "turf reference"

/datum/buildmode_mode/varedit/change_settings(client/c)
	if(!check_rights(R_DEBUG, FALSE))
		return

	var/list/locked = list("vars", "key", "ckey", "client", "icon")
	selected_key = tgui_input_text(c, "Enter variable name:", "Variable Name", "name")
	if(selected_key in locked)
		to_chat(c, SPAN_WARNING("Editing [selected_key] is not allowed."))
		return
	var/type = tgui_input_list(c, "Select variable type:", "Type", list(TYPE_TEXT, TYPE_NUMBER, TYPE_MOB_REFERENCE, TYPE_OBJ_REFERENCE, TYPE_TURF_REFERENCE))

	if(!type)
		return

	switch(type)
		if(TYPE_TEXT)
			selected_value = input(usr,"Enter variable value:" ,"Value", "value") as text
		if(TYPE_NUMBER)
			selected_value = input(usr,"Enter variable value:" ,"Value", 0) as num
		if(TYPE_MOB_REFERENCE)
			selected_value = input(usr,"Enter variable value:" ,"Value") as mob in GLOB.mob_list
		if(TYPE_OBJ_REFERENCE)
			selected_value = input(usr,"Enter variable value:" ,"Value") as obj in world
		if(TYPE_TURF_REFERENCE)
			selected_value = input(usr,"Enter variable value:" ,"Value") as turf in GLOB.turfs

#undef TYPE_TEXT
#undef TYPE_NUMBER
#undef TYPE_MOB_REFERENCE
#undef TYPE_OBJ_REFERENCE
#undef TYPE_TURF_REFERENCE

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


