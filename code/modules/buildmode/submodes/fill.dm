#define FILL_WARNING_MIN 150

/datum/buildmode_mode/fill
	key = "fill"
	help = "Right Mouse Button on buildmode button = Select object type\n\
	Left Mouse Button on turf/obj/mob = Select corner\n\
	Left Mouse Button + Alt on turf/obj/mob = Select object type\n\
	Left Mouse Button + Ctrl after selection = Delete region instead"

	use_corner_selection = TRUE
	var/objholder = null

/datum/buildmode_mode/fill/change_settings(client/c)
	var/target_path = tgui_input_text(c, "Enter typepath:" ,"Typepath", "/obj/structure/closet")
	objholder = text2path(target_path)
	if(!ispath(objholder))
		objholder = pick_closest_path(target_path)
		if(!objholder)
			tgui_alert(c, "No path has been selected.")
			return
		if(ispath(objholder, /area))
			objholder = null
			tgui_alert(c, "Area paths are not supported for this mode, use the area edit mode instead.")
			return
	deselect_region()

/datum/buildmode_mode/fill/when_clicked(client/c, params, obj/object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK) && LAZYACCESS(modifiers, ALT_CLICK))
		if(istype(object, /turf) || istype(object, /obj) || istype(object, /mob))
			objholder = object.type
			to_chat(c, SPAN_NOTICE("[initial(object.name)] ([object.type]) selected."))
		else
			to_chat(c, SPAN_NOTICE("[initial(object.name)] is not a turf, object, or mob! Please select again."))
	if(isnull(objholder))
		to_chat(c, SPAN_WARNING("Select an object type first."))
		deselect_region()
		return
	..()

/datum/buildmode_mode/fill/handle_selected_area(client/c, params)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, ALT_CLICK))
		return
	if(LAZYACCESS(modifiers, LEFT_CLICK)) //rectangular
		var/selection_size = abs(cornerA.x - cornerB.x) * abs(cornerA.y - cornerB.y)
		if(selection_size > FILL_WARNING_MIN) // Confirm fill if the number of tiles in the selection is greater than FILL_WARNING_MIN
			if(tgui_alert(c, "Your selected area is [selection_size] tiles! Continue?", "Large Fill Confirmation", list("Yes", "No")) != "Yes")
				return
		var/list/affected_area = block(get_turf(cornerA),get_turf(cornerB))
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			for(var/turf/current_turf as anything in affected_area)
				for(var/atom/movable/AM in current_turf)
					qdel(AM)
				current_turf.ScrapeAway(INFINITY, CHANGETURF_DEFER_CHANGE)
			log_admin("Build Mode: [key_name(c)] with path [objholder], deleted the region from [AREACOORD(cornerA)] through [AREACOORD(cornerB)]")
			return
		for(var/turf/current_turf as anything in affected_area)
			if(ispath(objholder, /turf))
				current_turf = current_turf.ChangeTurf(objholder)
				current_turf.setDir(BM.build_dir)
			else
				var/obj/thing = new objholder(current_turf)
				thing.setDir(BM.build_dir)
		log_admin("Build Mode: [key_name(c)] with path [objholder], filled the region from [AREACOORD(cornerA)] through [AREACOORD(cornerB)]")

#undef FILL_WARNING_MIN
