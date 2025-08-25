/datum/buildmode_mode/advanced
	key = "advanced"
	help = "Right Mouse Button on buildmode button = Set object type\n\
	Left Mouse Button + alt on turf/obj = Copy object type\n\
	Left Mouse Button + alt + shift on turf/obj = Copy object type and variables\n\
	Left Mouse Button on turf/obj = Place objects\n\
	Left Mouse Button + shift on turf/obj = Place object/turf with copied variables\n\
	Right Mouse Button = Delete objects\n\
	Use the button in the upper left corner to\n\
	change the direction of built objects."
	var/objholder = null
	var/atom/selected_object = /obj/structure/closet
	var/list/copied_vars = list()

	var/list/ignore_vars = list("old_turf", "loc", "ckey", "key", "vars", "verbs", \
		"locs", "contents", "vis_locs", "vis_contents", "client", "linked_pylons", \
		"x", "y", "z", "disposed")
	// Might be better to move to a whitelist system instead. If there are too many runtimes/issues,
	// turn this into a whitelist system and whitelist vars like icon_state, overlays and ids

	var/list/ignore_types = list(/atom)

	var/list/must_include = list("icon_state", "dir")

/datum/buildmode_mode/advanced/change_settings(client/c)
	var/target_path = input(c, "Enter typepath:", "Typepath", "/obj/structure/closet")
	objholder = text2path(target_path)
	if(!ispath(objholder))
		objholder = pick_closest_path(target_path)
		if(!objholder)
			alert("No path was selected")
			return
		else if(ispath(objholder, /area))
			objholder = null
			alert("That path is not allowed.")
			return

/datum/buildmode_mode/advanced/when_clicked(client/c, params, obj/object)
	var/list/modifiers = params2list(params)
	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)
	var/alt_click = LAZYACCESS(modifiers, ALT_CLICK)
	var/shift_click = LAZYACCESS(modifiers, SHIFT_CLICK)

	if(left_click && alt_click)
		if(istype(object, /turf) || istype(object, /obj) || istype(object, /mob))
			objholder = object.type
			if(shift_click)
				copied_vars = filter_vars(object)
			to_chat(c, SPAN_NOTICE("[initial(object.name)] ([object.type]) selected."))
		else
			to_chat(c, SPAN_NOTICE("[initial(object.name)] is not a turf, object, or mob! Please select again."))
	else if(left_click)
		if(ispath(objholder, /turf))
			var/turf/T = get_turf(object)
			log_admin("Build Mode: [key_name(c)] modified [T] in [AREACOORD(object)] to [objholder]")
			T.ChangeTurf(objholder)
			if(shift_click)
				apply_copied_vars_shallow(T)
		else if(!isnull(objholder))
			var/obj/A = new objholder (get_turf(object))
			A.setDir(BM.build_dir)
			if(shift_click)
				addtimer(CALLBACK(src, PROC_REF(apply_copied_vars_shallow), A), 1)
			log_admin("Build Mode: [key_name(c)] modified [A]'s [COORD(A)] dir to [BM.build_dir]")
		else
			to_chat(c, SPAN_WARNING("Select object type first."))
	else if(right_click)
		if(isobj(object))
			log_admin("Build Mode: [key_name(c)] deleted [object] at [AREACOORD(object)]")
			qdel(object)

/datum/buildmode_mode/advanced/proc/apply_copied_vars_shallow(atom/A)
	if(ismob(A))
		return

	for(var/variable in copied_vars)
		var/temp_value = copied_vars[variable]

		if(isdatum(temp_value)) // Don't bother with copying datums
			continue

		if(islist(temp_value))
			temp_value = copyListList(temp_value)

		A.vars[variable] = temp_value

/datum/buildmode_mode/advanced/proc/filter_vars(atom/A)
	var/list/filtered_vars = list()

	for(var/variable in A.vars)
		if(!(variable in must_include))
			if(variable in ignore_vars)
				continue
			if(A.vars[variable] == initial(A.vars[variable]))
				continue

			for(var/type in ignore_types)
				if(istype(A.vars[variable], type))
					continue

		filtered_vars += list("[variable]" = A.vars[variable])

	return(filtered_vars)
