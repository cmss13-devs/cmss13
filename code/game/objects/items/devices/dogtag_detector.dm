/obj/item/device/motiondetector/dogtag
	name = "dogtag detector"
	desc = "A device that detects fallen marine's dogtags."
	icon_state = "dogtagdetector"
	item_state = "dogtag_detector"
	blip_type = "dogtag"
	w_class = SIZE_SMALL

/obj/item/device/motiondetector/dogtag/get_help_text()
	. = "Red indicators on your HUD will show the location of dogtags detected by the scanner. Has two modes: slow long-range [SPAN_HELPFUL("(14 tiles)")] and fast short-range [SPAN_HELPFUL("(7 tiles)")]."

/obj/item/device/motiondetector/dogtag/update_icon()
	if (active)
		icon_state = "[initial(icon_state)]_on_[detector_mode]"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/device/motiondetector/dogtag/scan()
	set waitfor = 0
	if(scanning)
		return
	scanning = TRUE
	var/mob/living/carbon/human/human_user
	if(ishuman(loc))
		human_user = loc

	var/detected_sound = FALSE

	for(var/mob/living/carbon/human/sourcemob in orange(detector_range, loc))
		var/detected
		if(loc == null || sourcemob == null)
			continue
		if(loc.z != sourcemob.z)
			continue
		if(sourcemob == loc)
			continue //device user isn't detected
		if(ishuman(sourcemob) && sourcemob.undefibbable && length(sourcemob.contents) && sourcemob.faction == FACTION_MARINE)
			for(var/obj/I in sourcemob.contents_twice())
				if(istype(I, /obj/item/card/id/dogtag))
					detected = TRUE
		if(human_user && detected)
			show_blip(human_user, sourcemob)
			if(detected)
				detected_sound = TRUE

		CHECK_TICK

	if(detected_sound)
		playsound(loc, 'sound/items/tick.ogg', 60, 0, 7, 2)
	else
		playsound(loc, 'sound/items/detector.ogg', 50, 0, 7, 2)
	scanning = FALSE
