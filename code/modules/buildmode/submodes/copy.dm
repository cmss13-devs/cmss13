/datum/buildmode_mode/copy
	key = "copy"
	help = "Left Mouse Button on obj/turf/mob = Spawn a Copy of selected target\n\
	Right Mouse Button on obj/mob = Select target to copy"
	var/atom/movable/stored = null

/datum/buildmode_mode/copy/Destroy()
	stored = null
	return ..()

/datum/buildmode_mode/copy/when_clicked(client/admin_copying, params, atom/object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		var/turf/clicked_turf = get_turf(object)
		if(stored)
			var/atom/new_object = DuplicateObject(stored, perfectcopy = TRUE, sameloc = FALSE, newloc = clicked_turf)
			new_object.setDir(BM.build_dir)
			log_admin("Build Mode: [key_name(admin_copying)] copied [stored] to [AREACOORD(object)]")
	else if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(ismovable(object)) // No copying turfs for now.
			to_chat(admin_copying, SPAN_NOTICE("[object] set as template."))
			stored = object
