/client/proc/cmd_mass_modify_object_variables(atom/A, var_name)
	set category = "Debug"
	set name = "Mass Edit Variables"
	set desc="(target) Edit all instances of a target item's variables"

	var/method = 0 //0 means strict type detection while 1 means this type and all subtypes (IE: /obj/item with this set to 1 will set it to ALL itms)

	if(!check_rights(R_VAREDIT)) return

	if(A.is_datum_protected())
		to_chat(usr, SPAN_WARNING("This datum is protected. Access Denied"))
		return

	if(!A.can_vv_modify() && !(admin_holder.rights & R_DEBUG))
		to_chat(usr, "You can't modify this object! You require debugging permission")
		return

	if(A && A.type)
		if(typesof(A.type))
			switch(tgui_input_list(usr, "Strict object type detection?", "Object detection", list("Strictly this type","This type and subtypes", "Cancel")))
				if("Strictly this type")
					method = 0
				if("This type and subtypes")
					method = 1
				if("Cancel")
					return
				if(null)
					return

	src.massmodify_variables(A, var_name, method)



/client/proc/massmodify_variables(atom/O, var_name = "", method = 0)
	if(!check_rights(R_VAREDIT)) return

	var/list/locked = list("vars", "key", "ckey", "client", "icon")

	if(!O.can_vv_modify() && !(admin_holder.rights & R_DEBUG))
		to_chat(usr, "You can't modify this object! You require debugging permission")
		return

	var/list/names = list()
	for (var/V in O.vars)
		names += V

	names = sortList(names)

	var/variable = ""

	if(!var_name)
		variable = tgui_input_list(usr, "Which var?","Var", names)
	else
		variable = var_name

	if(!variable) return
	var/var_value = O.vars[variable]
	var/dir

	if(variable == "holder" || (variable in locked))
		if(!check_rights(R_DEBUG)) return

	if(isnull(var_value))
		to_chat(usr, "Unable to determine variable type.")

	else if(isnum(var_value))
		to_chat(usr, "Variable appears to be <b>NUM</b>.")

		dir = 1

	else if(istext(var_value))
		to_chat(usr, "Variable appears to be <b>TEXT</b>.")


	else if(isloc(var_value))
		to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")


	else if(isicon(var_value))
		to_chat(usr, "Variable appears to be <b>ICON</b>.")
		var_value = "\icon[var_value]"


	else if(istype(var_value,/matrix))
		to_chat(usr, "Variable appears to be <b>MATRIX</b>.")


	else if(istype(var_value,/atom) || istype(var_value,/datum))
		to_chat(usr, "Variable appears to be <b>TYPE</b>.")

	else if(istype(var_value,/list))
		to_chat(usr, "Variable appears to be <b>LIST</b>.")

	else if(istype(var_value,/client))
		to_chat(usr, "Variable appears to be <b>CLIENT</b>.")

	else
		to_chat(usr, "Variable appears to be <b>FILE</b>.")

	to_chat(usr, "Variable contains: [var_value]")
	if(dir)
		switch(var_value)
			if(1)
				dir = "NORTH"
			if(2)
				dir = "SOUTH"
			if(4)
				dir = "EAST"
			if(8)
				dir = "WEST"
			if(5)
				dir = "NORTHEAST"
			if(6)
				dir = "SOUTHEAST"
			if(9)
				dir = "NORTHWEST"
			if(10)
				dir = "SOUTHWEST"
			else
				dir = null
		if(dir)
			to_chat(usr, "If a direction, direction is: [dir]")

	var/list/possible_classes = list("text","num","type","icon","file")
	if(LAZYLEN(stored_matrices))
		possible_classes += "matrix"
	possible_classes += "edit referenced object"
	possible_classes += "restore to default"
	var/class = tgui_input_list(usr, "What kind of variable?","Variable Type", possible_classes)

	if(!class)
		return

	var/original_name

	if (!istype(O, /atom))
		original_name = "\ref[O] ([O])"
	else
		original_name = O:name

	var/rejected = 0
	var/accepted = 0

	switch(class)

		if("restore to default")
			to_chat(src, "Finding items...")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "Changing [length(items)] items...")
			for(var/datum/thing as anything in items)
				if(!thing)
					continue

				if (thing.vv_edit_var(variable, initial(thing.vars[variable])))
					accepted++
				else
					rejected++
				CHECK_TICK

		if("edit referenced object")
			return .(O.vars[variable])

		if("text")
			var/new_value = input("Enter new text:", "Text", O.vars[variable]) as text|null
			if(isnull(new_value))
				return

			if(!O.vv_edit_var(variable, new_value))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return


			to_chat(src, "Finding items...")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "Changing [length(items)] items...")
			for(var/datum/thing as anything in items)
				if(!thing)
					continue

				if (thing.vv_edit_var(variable, new_value))
					accepted++
				else
					rejected++
				CHECK_TICK

		if("num")
			var/new_value = tgui_input_real_number(usr, "Enter new number:","Num",O.vars[variable])
			if(isnull(new_value))
				return

			if(!O.vv_edit_var(variable, new_value))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

			to_chat(src, "Finding items...")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "Changing [length(items)] items...")

			for(var/datum/thing as anything in items)
				if(!thing)
					continue

				if(thing.vv_edit_var(variable, new_value))
					accepted++
				else
					rejected++
				CHECK_TICK


		if("type")
			var/new_value = tgui_input_list(usr, "Enter type:", "Type", typesof(/obj, /mob, /area, /turf))
			if(isnull(new_value))
				return

			if(!O.vv_edit_var(variable, new_value))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

			to_chat(src, "Finding items...")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "Changing [length(items)] items...")

			for(var/datum/thing as anything in items)
				if(!thing)
					continue

				if(thing.vv_edit_var(variable, new_value))
					accepted++
				else
					rejected++
				CHECK_TICK

		if("file")
			var/new_value = input("Pick file:","File",O.vars[variable]) as null|file
			if(isnull(new_value))
				return

			if(!O.vv_edit_var(variable, new_value))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

			to_chat(src, "Finding items...")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "Changing [length(items)] items...")

			for(var/datum/thing as anything in items)
				if(!thing)
					continue

				if(thing.vv_edit_var(variable, new_value))
					accepted++
				else
					rejected++
				CHECK_TICK

		if("icon")
			var/new_value = input("Pick icon:","Icon",O.vars[variable]) as null|icon
			if(isnull(new_value))
				return

			if(!O.vv_edit_var(variable, new_value))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

			to_chat(src, "Finding items...")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "Changing [length(items)] items...")

			for(var/datum/thing as anything in items)
				if(!thing)
					continue

				if(thing.vv_edit_var(variable, new_value))
					accepted++
				else
					rejected++
				CHECK_TICK

		if("matrix")
			if(!LAZYLEN(stored_matrices))
				to_chat(usr, "You don't have any matrices stored!")
				return

			var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (stored_matrices + "Cancel"))
			if(!matrix_name || (matrix_name == "Cancel"))
				return

			var/matrix/matrix_gotten = LAZYACCESS(stored_matrices, matrix_name)
			if(!matrix_gotten)
				return

			if(!O.vv_edit_var(variable, matrix_gotten))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

			to_chat(src, "Finding items...")
			var/list/items = get_all_of_type(O.type, method)
			to_chat(src, "Changing [length(items)] items...")

			for(var/datum/thing as anything in items)
				if(!thing)
					continue

				if(thing.vv_edit_var(variable, matrix_gotten))
					accepted++
				else
					rejected++
				CHECK_TICK

			message_staff("[key_name_admin(src)] mass modified [original_name]'s [variable] to their matrix \"[matrix_name]\" with columns ([matrix_gotten.a], [matrix_gotten.b], [matrix_gotten.c]), ([matrix_gotten.d], [matrix_gotten.e], [matrix_gotten.f])", 1)

	var/count = rejected + accepted
	if(!count)
		to_chat(src, "No objects found.")
		return
	if(!accepted)
		to_chat(src, "Every object rejected your edit.")
		return
	if(rejected)
		to_chat(src, "[rejected] out of [count] objects rejected your edit.")

	// Matrix edits make their own custom log
	if(class != "matrix")
		message_staff("[key_name_admin(src)] mass modified [original_name]'s [variable] to [O.vars[variable]]", 1)
