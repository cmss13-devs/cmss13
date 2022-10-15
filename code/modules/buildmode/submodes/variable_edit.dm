/datum/buildmode_mode/varedit
	key = "edit"
	// Varedit mode
	var/selected_key = null
	var/selected_value = null

/datum/buildmode_mode/varedit/Destroy()
	selected_key = null
	selected_value = null
	return ..()

/datum/buildmode_mode/varedit/show_help(client/c)
	to_chat(c, SPAN_NOTICE("***********************************************************"))
	to_chat(c, SPAN_NOTICE("Right Mouse Button on buildmode button = Select var(type) & value"))
	to_chat(c, SPAN_NOTICE("Left Mouse Button on turf/obj/mob      = Set var(type) & value"))
	to_chat(c, SPAN_NOTICE("Right Mouse Button on turf/obj/mob     = Reset var's value"))
	to_chat(c, SPAN_NOTICE("***********************************************************"))

/datum/buildmode_mode/varedit/Reset()
	. = ..()
	selected_key = null
	selected_value = null

/datum/buildmode_mode/varedit/change_settings(client/c)
	var/list/locked = list("vars", "key", "ckey", "client", "icon")

	selected_key = input(usr,"Enter variable name:" ,"Name", "name")
	if(selected_key in locked && !check_rights(R_DEBUG,0))
		return TRUE
	var/type = tgui_input_list(usr,"Select variable type:" ,"Type", list("text","number","mob-reference","obj-reference","turf-reference"))

	if(!type)
		return TRUE

	switch(type)
		if("text")
			selected_value = input(usr,"Enter variable value:" ,"Value", "value") as text
		if("number")
			selected_value = input(usr,"Enter variable value:" ,"Value", 0) as num
		if("mob-reference")
			selected_value = input(usr,"Enter variable value:" ,"Value") as mob in GLOB.mob_list
		if("obj-reference")
			selected_value = input(usr,"Enter variable value:" ,"Value") as obj in GLOB.object_list
		if("turf-reference")
			selected_value = input(usr,"Enter variable value:" ,"Value") as turf in turfs


/datum/buildmode_mode/varedit/when_clicked(client/c, params, obj/object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(object.vars.Find(selected_key))
			message_staff("[key_name(usr)] modified [object.name]'s [selected_key] to [selected_value]")
			object.vars[selected_key] = selected_value
		else
			to_chat(usr, SPAN_DANGER("[initial(object.name)] does not have a var called '[selected_key]'"))
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(object.vars.Find(selected_key))
			var/reset_value = initial(object.vars[selected_key])
			message_staff("[key_name(usr)] modified [object.name]'s [selected_key] to [reset_value]")
			object.vars[selected_key] = reset_value
		else
			to_chat(usr, SPAN_DANGER("[initial(object.name)] does not have a var called '[selected_key]'"))


