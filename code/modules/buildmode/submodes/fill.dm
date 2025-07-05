#define FILL_WARNING_MIN 150

/datum/buildmode_mode/fill
	key = "fill"
	help = "Left Mouse Button on turf/obj/mob = Select corner\n\
	Left Mouse Button + Alt on turf/obj/mob = Delete region\n\
	Right Mouse Button on buildmode button = Select object type"

	use_corner_selection = TRUE
	var/objholder = null

/datum/buildmode_mode/fill/change_settings(client/c)
	var/target_path = input(c, "Enter typepath:" ,"Typepath","/obj/structure/closet")
	objholder = text2path(target_path)
	if(!ispath(objholder))
		objholder = pick_closest_path(target_path)
		if(!objholder)
			alert("No path has been selected.")
			return
		else if(ispath(objholder, /area))
			objholder = null
			alert("Area paths are not supported for this mode, use the area edit mode instead.")
			return
	deselect_region()

/datum/buildmode_mode/fill/when_clicked(client/c, params, obj/object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK) && LAZYACCESS(modifiers, ALT_CLICK))
		if(istype(object, /turf) || istype(object, /obj) || istype(object, /mob))
			objholder = object
			to_chat(c, SPAN_NOTICE("[initial(object.name)] ([object.type]) selected."))
		else
			to_chat(c, SPAN_NOTICE("[initial(object.name)] is not a turf, object, or mob! Please select again."))
	if(isnull(objholder))
		to_chat(c, SPAN_WARNING("Select an object type first."))
		deselect_region()
		return
	..()

#define CONFIRM_NO "No"
#define CONFIRM_YES "Yes"

/datum/buildmode_mode/fill/handle_selected_area(client/c, params)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, ALT_CLICK))
		return
	if(LAZYACCESS(modifiers, LEFT_CLICK)) //rectangular
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			var/list/deletion_area = block(get_turf(cornerA),get_turf(cornerB))
			for(var/turf/T as anything in deletion_area)
				for(var/atom/movable/AM in T)
					qdel(AM)
				T.ScrapeAway(INFINITY, CHANGETURF_DEFER_CHANGE)
			var/selection_size = abs(cornerA.x - cornerB.x) * abs(cornerA.y - cornerB.y)
			if(selection_size > FILL_WARNING_MIN) // Confirm fill if the number of tiles in the selection is greater than FILL_WARNING_MIN
				var/choice = alert("Your selected area is [selection_size] tiles! Continue?", "Large Fill Confirmation", CONFIRM_YES, CONFIRM_NO)
				if(choice != CONFIRM_YES)
					return
			for(var/turf/T as anything in deletion_area)
				if(ispath(objholder,/turf))
					T = T.ChangeTurf(objholder)
					T.setDir(BM.build_dir)
				else
					var/obj/A = new objholder(T)
					A.setDir(BM.build_dir)
			log_admin("Build Mode: [key_name(c)] with path [objholder], filled the region from [AREACOORD(cornerA)] through [AREACOORD(cornerB)]")

#undef FILL_WARNING_MIN
#undef CONFIRM_YES
#undef CONFIRM_NO
