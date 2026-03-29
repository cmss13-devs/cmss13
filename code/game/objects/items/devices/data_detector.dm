/obj/item/device/motiondetector/intel
	name = "data detector"
	desc = "A device that detects objects that may be useful for intel gathering. You can switch modes with Alt+Click."
	icon_state = "datadetector"
	item_state = "data_detector"
	blip_type = "data"

/obj/item/device/motiondetector/intel/get_help_text()
	. = "Green indicators on your HUD will show the location of intelligence objects detected by the scanner. Has two modes: slow long-range [SPAN_HELPFUL("(14 tiles)")] and fast short-range [SPAN_HELPFUL("(7 tiles)")]."

/obj/item/device/motiondetector/intel/update_icon()
	if(active)
		icon_state = "[initial(icon_state)]_on_[detector_mode]"
	else
		icon_state = "[initial(icon_state)]"
	for(var/datum/action/item_action as anything in actions)
		item_action.update_button_icon()

/obj/item/device/motiondetector/intel/scan()
	set waitfor = 0
	if(scanning)
		return
	scanning = TRUE
	var/mob/living/carbon/human/human_user
	if(ishuman(loc))
		human_user = loc

	var/detected_sound = FALSE

	for(var/obj/object_being_searched in orange(detector_range, loc))
		var/detected
		if(object_being_searched.is_objective)
			detected = TRUE
		if(!detected && object_being_searched.contents)
			for(var/obj/item/item_in_object in object_being_searched.contents)
				if(item_in_object.is_objective)
					detected = TRUE
					break
		if(human_user && detected)
			show_blip(human_user, object_being_searched)

		if(detected)
			detected_sound = TRUE

		CHECK_TICK

	for(var/mob/mob_checking in orange(detector_range, loc))
		var/detected
		if(loc == null)
			continue
		if(loc.z != mob_checking.z)
			continue
		if(mob_checking == loc)
			continue //device user isn't detected
		if((isxeno(mob_checking) || isyautja(mob_checking)) && mob_checking.stat == DEAD )
			detected = TRUE
		if(!detected && ishuman(mob_checking) && mob_checking.stat == DEAD && length(mob_checking.contents))
			storage_search:
				for(var/obj/item/storage/storage_being_checked in mob_checking.contents_twice())
					for(var/obj/item_on_mob in storage_being_checked.contents)
						if(item_on_mob.is_objective)
							detected = TRUE
							break storage_search
		if(!detected && ishuman(mob_checking) && mob_checking.stat == DEAD && length(mob_checking.contents)) //In case we're not in storage for some ungodly reason
			for(var/obj/item_on_mob in mob_checking.contents)
				if(item_on_mob.is_objective)
					detected = TRUE
					break
		if(human_user && detected)
			show_blip(human_user, mob_checking)
			if(detected)
				detected_sound = TRUE

		CHECK_TICK

	if(detected_sound)
		playsound(loc, 'sound/items/tick.ogg', 60, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 50, 0, 7, 2)
	scanning = FALSE
