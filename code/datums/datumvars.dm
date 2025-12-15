
// reference: /client/proc/modify_variables(var/atom/O, var/param_var_name = null, var/autodetect_class = 0)

/datum/proc/can_vv_get(var_name)
	if(var_name == NAMEOF(src, vars))
		return FALSE
	return TRUE

/datum/proc/can_vv_modify()
	return TRUE

/client/can_vv_modify()
	return FALSE

/datum/proc/can_vv_mark()
	return TRUE

/// Called whenever a var is edited to edit the var, returning FALSE will reject the edit.
/datum/proc/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, vars))
		return FALSE
	vars[var_name] = var_value
	datum_flags |= DF_VAR_EDITED
	return TRUE

/datum/proc/vv_get_var(var_name)
	switch(var_name)
		if (NAMEOF(src, vars))
			return debug_variable(var_name, list(), 0, src)
	return debug_variable(var_name, vars[var_name], 0, src)

//please call . = ..() first and append to the result, that way parent items are always at the top and child items are further down
//add separaters by doing . += "---"
/datum/proc/vv_get_dropdown()
	. = list()
	VV_DROPDOWN_OPTION(VV_HK_CALLPROC, "Call Proc")
	VV_DROPDOWN_OPTION(VV_HK_MARK, "Mark Object")
	VV_DROPDOWN_OPTION(VV_HK_TAG, "Tag Datum")
	VV_DROPDOWN_OPTION(VV_HK_DELETE, "Delete")
	VV_DROPDOWN_OPTION(VV_HK_EXPOSE, "Show VV To Player")
	VV_DROPDOWN_OPTION(VV_HK_ADDCOMPONENT, "Add Component/Element")
	VV_DROPDOWN_OPTION(VV_HK_REMOVECOMPONENT, "Remove Component/Element")
	VV_DROPDOWN_OPTION(VV_HK_MASS_REMOVECOMPONENT, "Mass Remove Component/Element")
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_TRAITS, "Modify Traits")

//This proc is only called if everything topic-wise is verified. The only verifications that should happen here is things like permission checks!
//href_list is a reference, modifying it in these procs WILL change the rest of the proc in topic.dm of admin/view_variables!
//This proc is for "high level" actions like admin heal/set species/etc/etc. The low level debugging things should go in admin/view_variables/topic_basic.dm incase this runtimes.
/datum/proc/vv_do_topic(list/href_list)
	if(!usr || !usr.client || !usr.client.admin_holder || !check_rights(NONE))
		return FALSE //This is VV, not to be called by anything else.
	if(SEND_SIGNAL(src, COMSIG_VV_TOPIC, usr, href_list) & COMPONENT_VV_HANDLED)
		return FALSE
	if(href_list[VV_HK_MODIFY_TRAITS])
		usr.client.admin_holder.modify_traits(src)
	if(href_list[VV_HK_EXPLODE])
		if(!check_rights(R_DEBUG))
			return

		var/atom/A = locate(href_list[VV_HK_EXPLODE])
		if(!isobj(A) && !ismob(A) && !isturf(A))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		cell_explosion(A, 150, 100, , create_cause_data("divine intervention"))
		message_admins("[key_name(src, TRUE)] has exploded [A]!")
	if(href_list[VV_HK_EMPULSE])
		if(!check_rights(R_DEBUG))
			return

		var/atom/A = locate(href_list[VV_HK_EMPULSE])
		if(!isobj(A) && !ismob(A) && !isturf(A))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		usr.client.cmd_admin_emp(A)
	return TRUE

/datum/proc/vv_get_header()
	. = list()
	if(("name" in vars) && !isatom(src))
		. += "<b>[vars["name"]]</b><br>"

/client/proc/is_safe_variable(name)
	if(name == "step_x" || name == "step_y" || name == "bound_x" || name == "bound_y" || name == "bound_height" || name == "bound_width" || name == "bounds")
		return FALSE
	return TRUE
