GLOBAL_LIST_INIT_TYPED(admin_runtime_decorators, /datum/decorator/manual/admin_runtime, list())

/client/proc/set_autoreplacer()
	set category = "Admin.Events"
	set name = "Set Autoreplacer"

	if(!admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(usr, "Only administrators may use this command.")
		return

	var/types = input(usr, "Enter the type you want to create an autoreplacement for", "Set Autoreplacer") as text|null
	if(!types)
		return

	var/subtypes = FALSE

	switch(alert("Do we want to replace subtypes too?", "Set Autoreplacer", "Yes", "No"))
		if("Yes")
			subtypes = TRUE

	var/field = input(usr, "What field we want to change?", "Set Autoreplacer") as text|null
	if(!field)
		return

	var/value = mod_list_add_ass()

	var/hint_text = subtypes ? "types and subtypes of" : "all"

	switch(alert("Please check: set for [hint_text] `[types]` for field `[field]` set value `[value]`. Correct?", "Set Autoreplacer", "Yes", "No"))
		if("No")
			return

	GLOB.admin_runtime_decorators.Add(SSdecorator.add_decorator(/datum/decorator/manual/admin_runtime, types, subtypes, field, value))

	message_admins("[src] activated new decorator id: [length(GLOB.admin_runtime_decorators)] set for [hint_text] `[types]` for field `[field]` set value `[value]`")

/client/proc/deactivate_autoreplacer()
	set category = "Admin.Events"
	set name = "Deactivate Autoreplacer"

	if(!admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(usr, "Only administrators may use this command.")
		return

	var/num_value = tgui_input_real_number(src, "Enter new number:","Num")

	if(!num_value)
		return

	GLOB.admin_runtime_decorators[num_value].enabled = FALSE

	message_admins("[src] deactivated decorator id: [num_value]")

/client/proc/rerun_decorators()
	set category = "Admin.Events"
	set name = "Rerun Decorators"

	if(!admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(usr, "Only administrators may use this command.")
		return

	switch(alert("ARE YOU SURE? THIS MAY CAUSE A LOT OF LAG!", "Rerun Decorators", "Yes", "No"))
		if("No")
			return

	SSdecorator.force_update()

	message_admins("[src] rerun all decorators.")
